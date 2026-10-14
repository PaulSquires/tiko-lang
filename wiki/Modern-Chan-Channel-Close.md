[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **Close**

# Close

Declares that no more values will be sent.

## Syntax

```freebasic
Close( )
```

## Notes

- It is **not** a destructor and not a free: it is a broadcast. Every blocked receiver wakes, and every later `Receive` drains the buffer and then answers FALSE.
- **Closing twice raises**, and so does any send after it. Closing is a statement of fact that only the sending side may make, and making it twice -- or sending afterwards -- means two parties disagree about who owns the producer role.
- The channel's destructor does **not** close, because a scope that stopped holding a reference has not said that no more values are coming.
- Buffered values survive: a closed channel is drained before it reports closure.

## Examples

```freebasic
#import "std/tasks"
using tasks

dim ch as Channel( of int32 ) = Channel( of int32 )( 4 )

dim as int32 v = 1
ch.Send( v )
ch.Close( )

print ch.IsClosed( )         '' true

'' The buffered value is still delivered -- closing does not discard
dim as int32 got
print ch.Receive( got )      '' true
print got                    '' 1
print ch.Receive( got )      '' false -- now it is drained
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members
