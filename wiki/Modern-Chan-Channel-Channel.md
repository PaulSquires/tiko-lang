[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **Channel**

# Channel

A typed, thread-safe queue: Go's `hchan`, transliterated.

## Syntax

```freebasic
Channel( of T )( [ capacity ] )
```

## Notes

- A **capacity of 0 is a RENDEZVOUS**, not a zero-length buffer. `Send` blocks until a receiver takes the value, and the value is handed over **directly** rather than through the buffer -- which makes the rendezvous an ordering point as well as a handoff.
- **Copies SHARE.** A Channel is a refcounted handle to a channel, not a channel. Handing a copy to each of four workers gives four handles on one queue, which is what makes fan-out work. Deliberately unlike `containers.Array`, whose copy is deep.
- A **default-constructed channel is NIL**, and a nil channel blocks forever on `Send` and `Receive`. That is Go's rule, and `IsNil` exists so a program can assert its own initialisation -- "my program hangs" is the symptom of forgetting it.
- The destructor does **not** Close. Closing means "no more values will be sent", and a scope that merely stopped holding a reference has not said that.
- Requires `-mt`; the header refuses to compile without it.

## Examples

```freebasic
#import "std/tasks"
using tasks

dim ch as Channel( of int32 ) = Channel( of int32 )( 4 )

print ch.Capacity( )         '' 4
print ch.IsNil( )            '' false -- constructed, not default

dim as int32 v = 42
ch.TrySend( v )
print ch.Count( )            '' 1

dim as int32 got
ch.TryReceive( got )
print got                    '' 42

'' A DEFAULT-CONSTRUCTED channel is nil, and blocks forever if used
dim nilch as Channel( of int32 )
print nilch.IsNil( )         '' true
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
