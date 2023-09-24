---
title: "Csharp Concurrency a note to myself"
date: 2023-09-22T10:37:05+03:30
tags: ["csharp", "concurrency"]
draft: true
---

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

When you add the "async" keyword to a method, the compiler creates a state machine in the background, which takes care of concurrency and frees you from worrying about handling threads. However, making a state machine can be expensive, as the compiler generates a lot of code behind the scenes. Therefore, it's essential to avoid creating unnecessary state machines.

Here are some best practices to keep in mind:

- Only use "async" in a method when you have an "await" in the method body.
- Don't use "await" if you don't need a value returned from a call to an asynchronous method. Just return the "Task" to upstream.
- If you need to use "async," but you don't need to use "await" to get a required value and want to return out of the method, use "[Task.FromResult](https://stackoverflow.com/questions/19568280/what-is-the-use-for-task-fromresulttresult-in-c-sharp)".
- If you don't want to return any value from the method, use "[Task.CompletedTask](https://stackoverflow.com/questions/30493036/what-is-the-point-of-net-4-6s-task-completedtask)".
- [Avoid using "async void" methods](https://learn.microsoft.com/en-us/archive/msdn-magazine/2013/march/async-await-best-practices-in-asynchronous-programming#avoid-async-void).

### Thread Synchronization

Most of the time you
