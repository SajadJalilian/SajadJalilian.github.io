---
title: "C# Concurrency: a note to myself."
date: 2023-09-22T10:37:05+03:30
tags: ["csharp", "concurrency"]
---

In this article, I will briefly discuss the most important things to know about concurrency in C#.

## Concurrency vs. Parallelism

> A system is said to be concurrent if it can support two or more actions in progress at the same time. A system is said to be parallel if it can support two or more actions executing simultaneously.

The Art of Concurrency book

To make breakfast, one person can boil eggs, make tea, and toast the bread at the same time. However, he/she cannot drive to the grocery store and come back simultaneously. In order to make breakfast and buy groceries in parallel, you need at least two people.

A computer with a single CPU and a single thread can perform multiple tasks by quickly switching between them. However, in order to work on multiple jobs simultaneously, multiple threads are required. Each thread is like a separate worker, allowing the CPU to allocate resources and process data more efficiently. By utilizing multiple threads, a computer can perform jobs in parallel, resulting in faster and more efficient processing.

## C# Concurrency

To achieve concurrency in C# you should know about operating system and threads and C# Asynchronous Pattern.

### Multithreading

I don't want to explain how to work with **Threads** in this article, Because we don't deal with threads in day to day code in modern C#. Most of the time we use latest C# asynchronous pattern which is TAP.

I suggest an excellent series of articles in [csharptutorial.net](https://www.csharptutorial.net/).

- [C# Thread](https://www.csharptutorial.net/csharp-concurrency/csharp-thread/)
- [C# Background Thread](https://www.csharptutorial.net/csharp-concurrency/csharp-background-thread/)
- [C# Threadpool](https://www.csharptutorial.net/csharp-concurrency/csharp-threadpool/)

### Asynchronous Patterns

C# introduced 3 asynchronous patterns in it's life time. A First in C# 1.0 there was the Asynchronous Programming Model pattern, otherwise known as the **APM** pattern.

C# 2.0 introduced that Event-based Asynchronous Pattern, or **EAP**.

After ten years finally in C# 5.0, we got latest and greats of them, the **[Task asynchronous programming model](https://learn.microsoft.com/en-us/dotnet/csharp/asynchronous-programming/task-asynchronous-programming-model)** or **TAP**.

Each pattern simplifies asynchronous programming compared to the previous methods. For those interested in the details, I recommend reading this comprehensive article from the .NET blog; it's worth your time. [How Async/Await Really Works in C#](https://devblogs.microsoft.com/dotnet/how-async-await-really-works/).

TAP consists of the following key components:

- The *Task* class – represents an asynchronous operation.
- The *async* / *await* keywords – define asynchronous methods and wait for the completion of asynchronous operations.
- Task-based API – a set of classes that work seamlessly with the Task class and async/await keywords.

#### What you should know about TAP?

- [What is TASK](https://www.csharptutorial.net/csharp-concurrency/csharp-task/)
- [TASK ContinueWith](https://www.csharptutorial.net/csharp-concurrency/csharp-continuewith/)
- [Handling Exceptions in C# Task](https://www.csharptutorial.net/csharp-concurrency/csharp-task-handle-exception/)
- [How to use async/await](https://www.csharptutorial.net/csharp-concurrency/csharp-async-await/)
- [Canceling a Task with CancellationTokenSource](https://www.csharptutorial.net/csharp-concurrency/csharp-cancellationtokensource/)
- [TASK WhenAny](https://www.csharptutorial.net/csharp-concurrency/csharp-whenany/)
- [TASK WhenAll](https://www.csharptutorial.net/csharp-concurrency/csharp-whenall/)

#### State machine

When you add the "async" keyword to a method, the compiler creates a [state](https://refactoring.guru/design-patterns/state) machine in the background, which takes care of concurrency and frees you from worrying about handling threads. However, making a state machine can be expensive, as the compiler generates a lot of code behind the scenes. Therefore, it's essential to avoid creating unnecessary state machines.

Here are some best practices to keep in mind:

- Only use "async" in a method when you have an "await" in the method body.
- Don't use "await" if you don't need a value returned from a call to an asynchronous method. Just return the "Task" to upstream.
- If you need to use "async," but you don't need to use "await" to get a required value and want to return out of the method, use "[Task.FromResult](https://stackoverflow.com/questions/19568280/what-is-the-use-for-task-fromresulttresult-in-c-sharp)".
- If you don't want to return any value from the method, use "[Task.CompletedTask](https://stackoverflow.com/questions/30493036/what-is-the-point-of-net-4-6s-task-completedtask)".
- [Avoid using "async void" methods](https://learn.microsoft.com/en-us/archive/msdn-magazine/2013/march/async-await-best-practices-in-asynchronous-programming#avoid-async-void).

### Thread Synchronization

Thread synchronization in C# refers to the coordination and control of multiple threads to ensure their safe and orderly execution in a multi-threaded environment. It helps prevent race conditions, data corruption, and other concurrency-related issues that can occur when multiple threads access shared resources concurrently.

#### Lock

In C#, the [lock](https://www.csharptutorial.net/csharp-concurrency/csharp-lock/) keyword is used to ensure mutual exclusion or thread synchronization in a multi-threaded environment. When multiple threads are accessing a shared resource concurrently, using the lock keyword helps prevent race conditions and ensures that only one thread can access the critical section at a time.

The lock keyword is used in conjunction with a synchronization object, typically an instance of object. When a thread encounters a lock statement, it attempts to acquire the lock on the specified object. If the lock is already held by another thread, the current thread will wait until the lock is released before proceeding.

#### Deadlock

A [deadlock](https://www.csharptutorial.net/csharp-concurrency/csharp-continuewith/) is a situation where two or more threads are unable to proceed because each is waiting for a resource that is held by another thread in the deadlock group. This results in a circular dependency, causing all threads involved to be blocked indefinitely.

#### InterLocked

The [Interlocked](https://www.csharptutorial.net/csharp-concurrency/c-interlocked/) class provides atomic operations for variables that are shared among multiple threads. It offers thread-safe and atomic operations without the need for explicit locking mechanisms, such as lock or Monitor.

#### ReaderWriterLockSlim

The [ReaderWriterLockSlim](https://www.csharptutorial.net/csharp-concurrency/csharp-readerwriterlockslim/) class provides a synchronization mechanism that allows multiple threads to read a shared resource simultaneously while ensuring exclusive access when writing. It is designed to optimize concurrent read access while maintaining thread safety.

The ReaderWriterLockSlim class is a more efficient alternative to the older ReaderWriterLock class. It reduces the overhead associated with acquiring and releasing locks by using lightweight synchronization primitives.

#### SemaphoreSlim

The [SemaphoreSlim](https://www.csharptutorial.net/csharp-concurrency/csharp-semaphoreslim/) class provides a synchronization primitive that allows controlling access to a limited number of resources among multiple threads. It is a lightweight alternative to the Semaphore class and is useful in scenarios where you need to limit concurrent access to a shared resource.

### Thread Signaling

Thread signaling in C# refers to the mechanism of communication and coordination between multiple threads to ensure synchronized execution or to notify each other about specific events or conditions.

In multi-threaded scenarios, it is often necessary for threads to wait for certain conditions before proceeding or for one thread to notify another thread about a particular event. This is where thread signaling comes into play.

#### AutoResetEvent

The [AutoResetEvent](https://www.csharptutorial.net/csharp-concurrency/csharp-autoresetevent/) class is a synchronization primitive that allows threads to wait until a signal is received and then automatically resets itself. It is a thread signaling mechanism used for one-to-one thread coordination.

#### ManualResetEventSlim

The [ManualResetEventSlim](https://www.csharptutorial.net/csharp-concurrency/csharp-manualreseteventslim/) class is a lightweight synchronization primitive that provides thread signaling functionality similar to ManualResetEvent. It allows threads to wait until a signal is received and remains in the signaled state until manually reset.

#### CountdownEvent

The [CountdownEvent](https://www.csharptutorial.net/csharp-concurrency/csharp-countdownevent/) class is a synchronization primitive that allows one or more threads to wait until a specified number of signals or operations have completed. It provides a way to synchronize the execution of multiple threads and coordinate their completion.
