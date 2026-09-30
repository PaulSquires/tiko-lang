[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **TryReceive**

# TryReceive

Receives a value if one is available immediately; never blocks.

## Syntax

```freebasic
TryReceive( byref out as T ) as boolean
```

## Notes

- FALSE means "nothing right now", **and also** means closed-and-drained. `IsClosed` distinguishes them.
- The output is left alone when it answers FALSE.
- Use it to poll a channel from a loop that has other work to do.

## Examples

```freebasic
#include once "fb/channel.bi"
using FB

dim ch as Channel( of long ) = Channel( of long )( 4 )

dim as long got
print ch.TryReceive( got )   '' false -- empty, and it did not wait

dim as long v = 7
ch.Send( v )
print ch.TryReceive( got )   '' true
print got                    '' 7

'' FALSE covers both "empty" and "closed and drained"
ch.Close( )
print ch.TryReceive( got )   '' false
print ch.IsClosed( )         '' true -- which tells the two apart
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
