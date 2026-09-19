[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **SendFor**

# SendFor

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Goroutines and Channels](Category-Goroutines-and-Channels), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Sends a value, giving up after `ms` milliseconds.

## Syntax

```freebasic
SendFor( byref v as T, byval ms as ulong ) as boolean
```

## Notes

- FALSE means the timeout expired. Like `Send` and `TrySend`, it **raises** on a closed channel rather than reporting one.
- The bounded middle ground between `Send`, which waits forever, and `TrySend`, which does not wait at all.
- Every blocking operation in this design takes a timeout, so a cancellable goroutine can be written to wake and check its Context.

## Examples

```freebasic
#include once "fb/channel.bi"
using FB

dim ch as Channel( of long ) = Channel( of long )( 1 )

dim as long a = 1
print ch.SendFor( a, 100 )   '' true -- room in the buffer

dim as long b = 2
print ch.SendFor( b, 50 )    '' false -- full, and it waited 50 ms

'' This is how a cancellable producer is written: wake regularly and
'' check whether the Context has been cancelled
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels) ✨  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members  
**Source:** `docs/goroutines/goroutines.txt` in the tiko-lang repository.
