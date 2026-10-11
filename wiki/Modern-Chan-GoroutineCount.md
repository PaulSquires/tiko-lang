[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **GoroutineCount**

# GoroutineCount

How many goroutines currently exist.

## Syntax

```freebasic
GoroutineCount( ) as int32
```

## Notes

- A **diagnostic**, and a snapshot: it is stale the moment it returns.
- Useful for asserting in a test that a fan-out actually finished, and for spotting a leak where goroutines accumulate.
- Not a scheduling control -- there is no way to cap it from here.

## Examples

```freebasic
#import "std/tasks"
using tasks

print GoroutineCount( ) >= 0     '' -1 (true)

'' Worth asserting at the end of a test: a count that keeps climbing
'' between runs is a goroutine leak
dim as int32 before = GoroutineCount( )
print before >= 0                '' -1 (true)
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
