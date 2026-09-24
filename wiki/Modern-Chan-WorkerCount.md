[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **WorkerCount**

# WorkerCount

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Goroutines and Channels](Category-Goroutines-and-Channels), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

How many OS threads the scheduler is running goroutines on.

## Syntax

```freebasic
WorkerCount( ) as long
```

## Notes

- Distinct from `GoroutineCount`: many goroutines share few workers.
- The pool grows when a goroutine blocks, so this can rise under load and is not a constant.
- A diagnostic, like `GoroutineCount` -- reading it does not change scheduling.

## Examples

```freebasic
#include once "fb/sync.bi"
using FB

print WorkerCount( ) >= 1        '' -1 (true) -- at least one

'' Many goroutines share few workers, so these two numbers answer
'' different questions
print GoroutineCount( ) >= 0     '' -1 (true)
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels) ✨  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
