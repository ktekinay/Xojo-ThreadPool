# ThreadPool

A thread management system for Xojo.

## About

With Xojo's introduction of preemptive threads, user will have to think about issues that had never before been a concern. For example, while cooperative threads can set the property's value without fear, preemptive threads must be mindful of "race" conditions where two threads can attempt to change the property at the same instant leading to incorrect results or even a hard crash.

`ThreadPool` mitigates these issues by creating a consistent environment where a thread will work on a single data point and post its result. It handles all thread management so all the user has to do is implement its events. A user must still be mindful and careful when setting common properties, but this becomes much simpler.

## Installation

Open the "ThreadPool Harness" project, copy `M_ThreadPool` and paste it into your project.

## Usage

### General

Implement the `Process` event. This tells `ThreadPool` how to handle a single instance of your `data`.

Set the `QueueLimit` property to limit how much data can be added to `ThreadPool` at one time. If your dataset is relatively small, e.g., a list of numbers, you can set this to `0` for "unlimited". Otherwise, set it to something reasonable to keep from overwhelming memory. For example, if you are working on a 2 TB file in 500 k chunks, you probably don't want to load the entire file into memory. Unless you override it, `QueueLimit` will be set to `System.CoreCount * 2`.

Set the `MaximumJobs` property to determine how many threads can be launched at once. Typically, there is no point in launching more threads than the number of cores so the default value of `0` will mean `System.CoreCount - 1`.

Note that, depending on your code and how you feed data to `ThreadPool`, it may never launch the maximum number of threads. For example, if average processing takes 1 ms but it takes 3 ms to get the next data point, `ThreadPool` may only need to launch one thread regardless of value in `MaximumJobs`.

### Feeding Data

`ThreadPool` will start processing as soon as you add data to it via `Add` or `TryAdd`.

One strategy is to loop through your data calling `Add`. In a GUI app, this will lock up the interface until all the data has been fed unless your loop is itself within a thread (see below).

Another is to create a function that loops through your data using `TryAdd`. This will return `false` if the queue is unable to accept more data because you have hit the `QueueLimit`. You can call this function to start processing and implement the `QueueAvailable` event to continue feeding `ThreadPool` as space on the queue becomes available.

In either case, once your data is complete, call `Finish` to let `ThreadPool` know that no more data is coming. You can also call `Wait`, which implies `Finish`, to await completion of all processing.

If you use `Finish`, the `Finished` event will be raised once processing is complete.

You may choose to let `ThreadPool` continue running so you can feed data over time. In that case, the `QueueDrained` event will let you know when the current set of data has been exhausted.

If you choose to feed `ThreadPool` through a thread, the feeder thread must be of the same `Type` (`Thread.Types`) as the `ThreadPool`. Unless you change it, `ThreadPool.Type` defaults to `Thread.Types.Preemptive`.


### Returning Processed Data

The safest way to return data is by calling `AddUserInterfaceUpdate` and implementing the `UserInterfaceUpdate` event. These work the same way as in the `Thread` class.

You may also choose to update some shared property or array. If so, you _must_ protect that property through a `Semaphore` or `CriticalSection`. Remember to set the locking class's `Type` to match `ThreadPool.Type`.

Note that you may update an array without a `Semaphore` or `CriticalSection` if you are certain your preemptive threads are writing to different indexes. You may do that by initially sizing the array, then sending a unique index to `ThreadPool` as part of its data. For example, `tp.Add index : myData` or `tp.Add new Dictionary("index" : index, "data1" : data1, "data2" : data2)`.

The same holds true for a `MemoryBlock`.

### Stopping

If you want to prematurely stop processing, you may call `Stop` which will, in effect, cancel all further processing.

Note: Before destroying a `ThreadPool`, you must call `Stop` before it goes out of scope if there is a chance it is still running. It is safe to call `Stop` even if a `ThreadPool` is idle.

### ThreadSafeVariantArray

The included `ThreadSafeVariantArray` is meant to support `ThreadPool` but may be used in your own projects. You must instantiate it using `new`, but then access it as if it were a traditional `Variant` array.

Example:

```
var arr as new ThreadSafeVariantArray

arr.Add 1
arr.Add 2

arr.ResizeTo 9

arr( 3 ) = false

MessageBox arr.Count.ToString

arr.Sort AddressOf someSortDelegate

arr.RemoveAt 8

arr.RemoveAll

MessageBox arr.IndexOf( 1 ).ToString
```

# Examples

One or more examples will show how to implement `ThreadPool` in your own projects. These are not designed to do anything necessarily useful, merely to show techniques.

**Note**: Running the examples in the IDE will be significantly slower than in a compiled app.

# Dos and Don'ts

- **Do** use `Semaphore` and `CriticalSection` generously to control flow of data that two threads might be manipulating.
- **Don't** assume any order and remember that a condition can change even as you are checking it. For example, `if this and that then` may evaluate `this` and `that` as true even as some other Thread changes `this` to false before `that` is even checked.
- **Do** use an individual `Database` instance for each Thread. Sharing a `Database` among Threads is a no good, very bad, idea. If you are using an in-memory `SQLiteDatabase` and cannot have more than one instance, protect access to it using `Semaphore` or `CriticalSection`.
- **Don't** share a `RegEx` or any class that maintains state among Threads. Let each Thread create its own or pass in an instance as part of your data.
- **Do** test heavily. Even the simplest code can lead to odd edge cases that you will only find with extensive testing.
- **Do** expect hard crashes during development. It is the nature of preemptive threads where things can happen simultaneously.
- **Don't** share resources where it's not required. For example, if you are updating a `Picture` in Threads that you are displaying in a `Canvas` in real-time, create a copy of the `Picture` and send back information that can be used to update the original.
- **Do** mind memory usage by using the `QueueLimit` property. For example, assuming `MaximumJobs` is 10 (a maximum of 10 Threads at a time), you can manipulate the contents of a file by setting `QueueLimit` to 100 and reading the file in 1 MB chunks. This will ensure that you only load about 110 MB into memory (100 MB in the queue and 10 MB assigned to the Threads) even if the file is far larger.
- **Do** set `QueueLimit` to some multiple of `MaximumJobs` or `System.CoreCount`. The idea is to keep sufficient data on hand so the Threads can keep processing. (Setting it to 0, the default, means "no limit".)

# Who Did This?!?

This project was created by and is maintained by Kem Tekinay (ktekinay@mactechnologies dot com).

# Comments and Contributions

All contributions to this project will be gratefully considered. Fork this repo to your own, then submit your changes via a Pull Request.

All comments are also welcome.

# Release Notes

**1.1** (July 31, 2025)

  - Replaced `Semaphore` with `CriticalSection` and always set `Type` to "Preemptive".

**1.0** (Aug. 1, 2024)

  - Initial release.
