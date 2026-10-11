[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **RecvChan**

# RecvChan

A receive-only view of a channel.

## Syntax

```freebasic
RecvChan( of T )
```

## Notes

- The other half of `SendChan`: a consumer given one of these cannot send, and cannot close a channel it does not own the producing end of.
- A view of the same channel, not a copy.
- Closing is the **sender's** statement to make, which is exactly what this type prevents a consumer from doing.
- Requires `-mt`.

## Examples

```freebasic
#import "std/tasks"
using tasks

dim ch as Channel( of int32 ) = Channel( of int32 )( 4 )
dim as int32 v = 42
ch.Send( v )
ch.Close( )

'' The consumer's half: it can receive and cannot send or close
dim r as RecvChan( of int32 ) = ch
dim as int32 got
print r.Receive( got )       '' true
print got                    '' 42
print r.Receive( got )       '' false -- closed and drained
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
