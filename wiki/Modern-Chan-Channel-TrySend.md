[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **TrySend**

# TrySend

Sends a value if it can be sent immediately; never blocks.

## Syntax

```freebasic
TrySend( byref v as T ) as boolean
```

## Notes

- FALSE means "not now": the buffer is full, or no receiver is waiting on a rendezvous channel. It does **not** mean closed -- like `Send`, this **raises** on a closed channel.
- The value is only consumed when the call succeeds.
- Use it for a drop-on-overload path, where blocking would be worse than losing the item.

## Examples

```freebasic
#include once "fb/channel.bi"
using FB

dim ch as Channel( of long ) = Channel( of long )( 1 )

dim as long a = 1, b = 2
print ch.TrySend( a )        '' true
print ch.TrySend( b )        '' false -- the buffer is full, and it did
                             '' NOT wait

'' A drop-on-overload producer, which a blocking Send cannot express
if ch.TrySend( b ) = false then print "dropped"
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
