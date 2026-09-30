[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **Count**

# Count

How many values are currently buffered.

## Syntax

```freebasic
Count( ) as long
```

## Notes

- A **snapshot**, and stale the moment it returns if another thread is running -- never branch on it to decide whether a send or receive will block. Use `TrySend`/`TryReceive`, which cannot race.
- Always 0 on a rendezvous channel (capacity 0): a value handed over directly is never buffered.
- Not to be confused with `WaitGroup.Count`, which counts outstanding work rather than queued values.

## Examples

```freebasic
#include once "fb/channel.bi"
using FB

dim ch as Channel( of long ) = Channel( of long )( 4 )
print ch.Count( )            '' 0

dim as long v = 1
ch.Send( v )
print ch.Count( )            '' 1

'' A rendezvous channel never buffers, so its Count stays 0
dim r as Channel( of long ) = Channel( of long )( 0 )
print r.Capacity( )          '' 0
print r.Count( )             '' 0
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
