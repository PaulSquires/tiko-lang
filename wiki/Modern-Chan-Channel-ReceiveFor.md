[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **ReceiveFor**

# ReceiveFor

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Goroutines and Channels](Category-Goroutines-and-Channels), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Receives a value, giving up after `ms` milliseconds.

## Syntax

```freebasic
ReceiveFor( byref out as T, byval ms as ulong ) as boolean
```

## Notes

- FALSE means the timeout expired **or** the channel is closed and drained.
- The output is left alone on a timeout.
- The receive-side counterpart of `SendFor`, and the shape a worker uses so it can check for cancellation between attempts.

## Examples

```freebasic
#include once "fb/channel.bi"
using FB

dim ch as Channel( of long ) = Channel( of long )( 1 )

dim as long got
print ch.ReceiveFor( got, 50 )       '' false -- nothing arrived in 50 ms

dim as long v = 7
ch.Send( v )
print ch.ReceiveFor( got, 100 )      '' true
print got                            '' 7
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels) ✨  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members  
**Source:** `docs/goroutines/goroutines.txt` in the tiko-lang repository.
