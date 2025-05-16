---
title: "Take on Distributed Caching"
date: 2022-07-07T19:13:49+03:30
tags: ["csharp", "cache"]
type: "en"
---

# Should I Use Distributed Caching?

## Don’t

The best strategy for distributed caching is often not to use it!

It’s challenging to implement and adds complexity to your system. As we all know, complexity is the root of most problems in software development.

So, avoid it if possible.

Before considering distributed caching, focus on optimizing your application, database, connection, network, or even hardware. Use in-memory caching instead.

## Use In-Memory Caching

At some point, you’ll need to consider caching to improve performance. Start by leveraging the internal in-memory caching mechanisms provided by your back-end framework, database caching, etc.

Believe it or not, most tools have built-in caching providers you can utilize.

In many cases, these simple optimizations can significantly improve your application's performance without the added complexity of distributed caching.

## Distributed Caching Strategies

### When to Use Distributed Caching

However, as your user base grows, you might need to take caching more seriously. This could mean adding a dedicated caching server or implementing a more complex distributed caching system.

## Understand Your Workload

To implement caching effectively, you must thoroughly understand your application’s responsibilities and requirements.

Choosing the right caching pattern depends on your workload. For example, is your application write-heavy, read-heavy, or real-time?

## Common Caching Strategies

### Cache Aside

This is the most common caching strategy. Here, the cache works alongside the database to reduce database hits. Data is lazy loaded into the cache.

When a user requests specific data, the system first checks the cache. If the data is present, it’s returned directly. If not, the system fetches the data from the database, updates the cache, and returns the data to the user.

This strategy works well with read-heavy workloads, such as user profile data (e.g., name, account number) that isn’t frequently updated.

However, this approach can lead to inconsistencies between the cache and the database. To mitigate this, cached data is assigned a `TTL` (Time to Live), after which it’s invalidated.

### Read-Through

This strategy is similar to Cache Aside but with one key difference: in Read-Through, the cache always stays consistent with the database. The cache library ensures consistency with the back-end.

Like Cache Aside, data is lazy loaded into the cache when first requested. Developers can also pre-load the cache with frequently requested data to reduce cache misses.

### Write-Through

In this strategy, all data written to the database goes through the cache. When data is written to the database, the cache is updated simultaneously.

This ensures a high level of consistency between the cache and the database but adds some latency during write operations. This strategy is well-suited for write-heavy workloads, such as online multiplayer games.

### Write-Back

Write-Back caching optimizes costs by writing data directly to the cache instead of the database. After a delay (based on business logic), the cache writes the data to the database.

This approach is ideal for applications with heavy write operations, as it reduces the frequency of database writes and associated costs.

However, if the cache fails before the database is updated, data loss can occur. This strategy is often combined with other caching strategies for optimal performance.

## How to Implement Caching

Implementing caching depends on your chosen strategy. For example, when working with a database, you can create a unique key and cache data in Redis.

Here’s an example of caching in a service:

```csharp
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

### Best Practices

- Use the [CQRS pipeline](https://codewithmukesh.com/blog/caching-with-mediatr-in-aspnet-core/) to set cache for Query requests and invalidate it for Command requests.
- Implement the [Cached Repository Pattern](https://stackoverflow.com/questions/3442102/repository-pattern-caching).
- Use Event Sourcing to raise events after Commands and asynchronously handle them to invalidate the cache.

## Nondeterministic Problem

### Definition

> _Nondeterministic functions produce different outputs each time they’re called with the same input values (e.g., the `_GETDATE()` function)._

For deterministic data that doesn’t change frequently, you can cache it and update or invalidate it when the database is updated.

For nondeterministic data (e.g., a list of contents), caching becomes more complex. For instance, if you cache the first page of content, it might no longer be accurate as data is added, updated, or deleted in the database.

The best approach for nondeterministic data is to use a `TTL`. Start with the shortest TTL you can afford and adjust it based on user behavior and requirements.

## Redis and StackExchange.Redis

Redis allows you to search for keys with specific prefixes and invalidate them. However, this operation has a time complexity of O(n), which might not be ideal for large datasets. Fortunately, Redis is extremely fast.

As Redis docs state:

> _While the time complexity for this operation is O(N), the constant times are fairly low. For example, Redis running on an entry-level laptop can scan a 1 million key database in 40 milliseconds._

### Key Invalidation

With `StackExchange.Redis`, you can invalidate keys by using the [Keys method](https://stackexchange.github.io/StackExchange.Redis/KeysValues), which uses [SCAN under the hood](https://redis.io/commands/scan).

> _The_ `_SCAN_` _command allows incremental iteration, returning only a small number of elements per call. This makes it usable in production without the downsides of blocking commands like_ `_KEYS_` _or_ `_SMEMBERS_`.

You must iterate over all keys using a cursor, match the desired pattern, and delete the matched keys one by one.

### Optimizing Performance

To improve performance, store all associated keys in a `set` and clear the `set` to invalidate everything at once.

## The Problem with Aggressive Invalidation

Invalidating all keys matching a pattern can be inefficient. For example, updating one piece of content might result in deleting all keys associated with the content entity.

Instead, use `TTL` for nondeterministic data to avoid these issues. With this approach, unused query keys automatically expire after a short time, eliminating the need to find and invalidate associated keys manually. Calibrate the TTL for each endpoint to achieve optimal results.

## Conclusion

Be cautious when implementing caching. Use a combination of these strategies to find a solution that works for your specific needs.

> _There are only two hard things in Computer Science: cache invalidation and naming things. — Phil Karlton_
