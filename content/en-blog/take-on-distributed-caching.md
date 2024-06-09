---
title: "Take on Distributed Caching"
date: 2022-07-07T19:13:49+03:30
tags: ["csharp", "cache"]
type: "en"
---
## Should I use Distributed Caching?

## Don’t

The best strategy to use distributed cache is not to use it!

It’s hard to do and adds complexity to your system; as all of us know, complexity is the source of all evils in software development.

So please don’t use it.

First, you can focus on optimizing your application, database, connection, network, or even hardware. And use In-Memory Cache instead.

## Use In-Memory Caching

But you have to consider using a cache to speed things up at some point. So it would be best if you first consider using whatever internal in-memory cache your back-end framework introduces, use database caching, etc.

Believe it or not, every tool you use has its caching providers internally, and you can leverage them.

Most of the time, you can make your app significantly faster by doing just these things and avoiding adding complexity to your system.

## Distributed Caching Strategies

Again another BUT!

But at some point, when your user base grows, you need to think about caching more seriously. This means you want to add a dedicated caching server or even more complex distributed caching to your system.

## Understand your workload

To do caching correctly, you need to understand your application responsibilities and requirements.

To choose caching pattern, you need to know your workload. For example, your application may be write-heavy, read-heavy, real-time, etc.

## Cache Aside

This is the most common caching strategy, in this approach the cache works along with the database trying to reduce the hits on it as much as possible. The data is lazy loaded in the cache.

When the user sends a request for particular data. The system first looks for it in the cache. If present it’s simply returned from it. If not, the data is fetched from the database, the cache is updated, and is returned to the user.

This kind of strategy works best with read-heavy workloads. The kind of data that is not frequently updated is user profile data in a portal — his name, account number, etc.

The data in this strategy is written directly to the database. This means things between the cache and the database could get inconsistent.

To avoid this data on the cache has a TTL Time to Live. After that stipulated period the data is invalidated from the cache.

## Read-Through

This strategy is pretty similar to the cache Aside strategy with subtle differences in the Cache Aside strategy the system has to fetch information from the database if it is not found in the cache but in the Read-through strategy, the cache always stays consistent with the database. The cache library takes the onus of maintaining consistency with the back-end;

The information in this strategy too, is lazy loaded in the cache, only when the user requests it.

So, for the first time when information is requested it results in a cache miss, the back-end has to update the cache while returning the response to the user.

Though the developers can pre-load the cache with the information which is expected to be requested most by the users.

## Write-Through

In this strategy, every piece of information written to the database goes through the cache. When the data is written to the DB, the cache is updated with it.

This maintains high consistency between the cache and the database though it adds a little latency during the write operations as data is to be updated in the cache. This works well for write-heavy workloads like online massive multiplayer games.

This strategy is used with other caching strategies to achieve optimized performance.

## Write-Back

It helps optimize costs significantly.

In the Write-back caching strategy, the data is directly written to the cache instead of the database. And the cache, after some delay as per the business logic, writes data to the database.

If there are quite a heavy number of writes in the application. Developers can reduce the frequency of database writes to cut down the load & the associated costs.

A risk in this approach is if the cache fails before the DB is updated, the data might get lost. Again this strategy is used with other caching strategies to make the most out of these.

## How to Cache

It’s pretty straightforward; depending on your catching strategy while writing to or reading from the database, you can create a unique key and a cache in Redis.

Example of using cache in service:

``` csharp
public async Task<int> CountByFilterAsync(ContentFilter filter)
{
    // Get cache
    var cacheKey = _prefixKey + "-CountByFilterAsync-" + filter;
    if (CacheHelper.IsEnabled(_cacheRepositoryOptions))
    {
        var cached = await _redisCacheEngine.GetAsync<int>(cacheKey);
        if (cached != null && cached != 0) return cached;
    }
    var query = _queryableDbSet;
    query = query.ApplyFilter(filter);
    var count = await query.CountAsync();
    // Set cache
    if (CacheHelper.IsEnabled(_cacheRepositoryOptions))
        await _redisCacheEngine.SetAsync(cacheKey, count, _ttlFromMinutes);
    return count;
}

```

It depends on your design to choose where to implement cache, my favorite approach is leveraging the [CQRS pipeline,](https://codewithmukesh.com/blog/caching-with-mediatr-in-aspnet-core/) to set Cache in Query requests and invalidate the Cache in Command requests.

You can use [**CachedRepository Pattern**](https://stackoverflow.com/questions/3442102/repository-pattern-caching).

Another good practice is using Event-Sourcing to raise an event after Commands and handle events asynchronous in another part of the application to invalidate the cache.

## Nondeterministic Problem

Definition:

> _Nondeterministic functions result in different outputs each time they are called with a fixed set of input values. For example,_ `_GETDATE()_` _function, results in the current date and time value, always a different value._

When you have a deterministic item whose data is always the same, you can get it from the database, put it in the cache and forget about it; after updating it in the database, you can invalidate or update the cache.

Things get complicated when you have nondeterministic data, for example, a list of contents. You get the first page of content and cache it, but maybe some contents get deleted or updated, or some other contents get added to the database; you can’t ever be sure.

The best approach I am aware of is using `time to live` to cache this kind of data. Then, you can start from the shortest `TTL` you can afford and increase it after understanding your user behavior, etc.

## Redis and StackExchange.Redis

You can try to search for keys with specific prefixes and invalidate them, But the time complicity for this search is O(n); in general, it’s not a good idea; But Redis is extremely fast.

as Redis docs say:

> _While the time complexity for this operation is O(N), the constant times are fairly low. For example, Redis running on an entry-level laptop can scan a 1 million key database in 40 milliseconds._

## Invalidation

To invalidate all keys with the pattern with `StackExchange.Redis` you should first get all keys with the [Keys method](https://stackexchange.github.io/StackExchange.Redis/KeysValues). It uses [SCAN under the hood](https://redis.io/commands/scan)

> _Since_ `_SCAN_` _commands allow for incremental iteration, returning only a small number of elements per call, they can be used in production without the downside of commands like_ `_KEYS_` _or_ `_SMEMBERS_` _that may block the server for a long time (even several seconds) when called against big collections of keys or elements._

You must iterate over all keys, with help of the cursor, and get all keys that match the pattern. Again iterate over matched keys and delete them one by one.

If you care about performance, you can use the `set`. The idea is to put all keys associated with the pattern in `set` and delete them `set` to clear everything out.

## The problem with aggressive invalidation

Invalidating all keys that match the pattern is not very efficient, for example, if you update one content, in this approach we delete all keys which associate with the content entity. as I mentioned above my preferred way for invalidation is the usage of `TTL` on nondeterministic data. With this approach we eliminate all the trouble of finding associated keys and invalidating them; unused query keys will expire after a short time. We just need to calibrate TTL to find the best one for each endpoint.

## Conclusion

Be careful about caching. You can use a combination of these patterns to find a solution working for you.

> _There are only two hard things in Computer Science: cache invalidation and naming things. — Phil Karlton_
