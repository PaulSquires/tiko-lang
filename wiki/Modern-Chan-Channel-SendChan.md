[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **SendChan**

# SendChan

Holds a send-only view of a channel, for a procedure that only produces.

## Syntax

```freebasic
SendChan( of T )
```

## Notes

- A **direction**, enforced at compile time: a producer given one of these cannot accidentally receive from the channel it is meant to fill.
- It shares the same underlying channel -- it is a view, not a copy, and closing through it closes the channel.
- `RecvChan` is the other half. Handing each side the view it needs is how a pipeline documents its own direction.
- Requires `-mt`.

## Examples

```freebasic
#import "std/tasks"
using tasks

dim ch as Channel( of int32 ) = Channel( of int32 )( 4 )

'' The producer's half: it can send and close, and cannot receive
dim s as SendChan( of int32 ) = ch
dim as int32 v = 42
print s.Send( v )            '' true

'' The same channel underneath
dim as int32 got
print ch.TryReceive( got )   '' true
print got                    '' 42
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members
