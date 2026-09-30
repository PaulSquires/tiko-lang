[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **Capacity**

# Capacity

The buffer size the channel was constructed with.

## Syntax

```freebasic
Capacity( ) as long
```

## Notes

- **0 is a rendezvous**, not an error and not a one-element buffer: the sender waits for a receiver and the value is handed over directly.
- Fixed at construction; a channel cannot be resized.
- `Count` is how much is in it now.

## Examples

```freebasic
#include once "fb/channel.bi"
using FB

dim buffered as Channel( of long ) = Channel( of long )( 16 )
print buffered.Capacity( )   '' 16

'' 0 is a RENDEZVOUS: Send waits for a receiver and hands the value
'' over directly, which makes it an ordering point as well as a handoff
dim rendezvous as Channel( of long ) = Channel( of long )( 0 )
print rendezvous.Capacity( ) '' 0
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
