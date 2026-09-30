[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **ReceiveFor**

# ReceiveFor

Receives a value, giving up after `ms` milliseconds.

## Syntax

```freebasic
ReceiveFor( byref out as T, byval ms as uint32 ) as boolean
```

## Notes

- FALSE means the timeout expired **or** the channel is closed and drained.
- The output is left alone on a timeout.
- The receive-side counterpart of `SendFor`, and the shape a worker uses so it can check for cancellation between attempts.

## Examples

```freebasic
#import "std/tasks"
using FB

dim ch as Channel( of int32 ) = Channel( of int32 )( 1 )

dim as int32 got
print ch.ReceiveFor( got, 50 )       '' false -- nothing arrived in 50 ms

dim as int32 v = 7
ch.Send( v )
print ch.ReceiveFor( got, 100 )      '' true
print got                            '' 7
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
