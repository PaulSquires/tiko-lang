[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **SendFor**

# SendFor

Sends a value, giving up after `ms` milliseconds.

## Syntax

```freebasic
SendFor( byref v as T, byval ms as uint32 ) as boolean
```

## Notes

- FALSE means the timeout expired. Like `Send` and `TrySend`, it **raises** on a closed channel rather than reporting one.
- The bounded middle ground between `Send`, which waits forever, and `TrySend`, which does not wait at all.
- Every blocking operation in this design takes a timeout, so a cancellable goroutine can be written to wake and check its Context.

## Examples

```freebasic
#import "std/tasks"
using tasks

dim ch as Channel( of int32 ) = Channel( of int32 )( 1 )

dim as int32 a = 1
print ch.SendFor( a, 100 )   '' true -- room in the buffer

dim as int32 b = 2
print ch.SendFor( b, 50 )    '' false -- full, and it waited 50 ms

'' This is how a cancellable producer is written: wake regularly and
'' check whether the Context has been cancelled
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members
