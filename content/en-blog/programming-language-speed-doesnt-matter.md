---
title: "Programming Language Speed Doesn't Matter"
date: 2025-07-26
tags: ["backend","software","programming"]
type: "en"
---
When developing a web application, don't prioritize the speed of the programming language you use. The primary bottlenecks are typically network calls, followed by database calls.
Consider an ASP.NET application where we measure a simple HTTP GET request that includes one database call and one network call to an external service.
Database call latency is approximately 1,000 times slower than CPU operations, while a network call is about five times slower than a database call.
Is Python or Ruby 100 times slower than C# or Go? For web applications, this difference is negligible.

Note: This discussion applies specifically to web applications. Games, CPU-intensive applications, desktop, or mobile applications are subject to different performance considerations.

![Plane](cpu-db-network-latency-comparison.png)
