[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **IsClosed**

# IsClosed

Whether the channel has been closed.

## Syntax

```freebasic
IsClosed( ) as boolean
```

## Notes

- It is what tells a FALSE from `TryReceive` apart: "nothing right now" versus "nothing ever again".
- TRUE while buffered values remain -- closed and drained are different states, and `Receive` keeps yielding until both hold.
- A snapshot. Do not branch on it to decide whether a `Send` will succeed; check the result of the send.

## Examples

```freebasic
#import "std/tasks"
using tasks

dim ch as Channel( of int32 ) = Channel( of int32 )( 4 )
print ch.IsClosed( )         '' false

dim as int32 v = 1
ch.Send( v )
ch.Close( )

'' TRUE even though a value is still buffered: closed and drained are
'' two different things
print ch.IsClosed( )         '' true
print ch.Count( )            '' 1
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members
