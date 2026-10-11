[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **Send**

# Send

Sends a value, blocking until it is taken or buffered.

## Syntax

```freebasic
Send( byref v as T ) as boolean
```

## Notes

- **RAISES on a closed channel** -- it does not return FALSE. Sending after a close is a structural bug: two parties disagree about who owns the producer role, and reporting it as an ordinary FALSE would let that disagreement continue silently.
- On a buffered channel it blocks only while the buffer is full; on a **rendezvous** channel (capacity 0) it blocks until a receiver arrives.
- On a **nil** channel it blocks forever. That is deliberate, and is what makes assigning a nil channel disable a `select` case.
- `TrySend` is the non-blocking form and `SendFor` the bounded one.

## Examples

```freebasic
#import "std/tasks"
using tasks

dim ch as Channel( of int32 ) = Channel( of int32 )( 2 )

dim as int32 a = 1, b = 2
print ch.Send( a )           '' true
print ch.Send( b )           '' true -- still room in the buffer
print ch.Count( )            '' 2

'' Sending on a CLOSED channel RAISES -- illegal function call, not a
'' FALSE -- so a producer that cannot know must ask first:
dim as int32 got
ch.TryReceive( got )
ch.Close( )
if ch.IsClosed( ) = false then
    dim as int32 c = 3
    ch.Send( c )
end if
print "not sent"
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
