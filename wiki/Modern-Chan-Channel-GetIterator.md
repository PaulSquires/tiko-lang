[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **GetIterator**

# GetIterator

The iterator `for each` uses to drain a channel.

## Syntax

```freebasic
GetIterator( ) as ChannelIterator( of T )
```

## Notes

- Iteration **consumes**: each step receives a value, and the loop ends when the channel is closed and drained -- the same condition that ends `while ch.Receive( v )`.
- It blocks between values, so a `for each` over a channel that nobody closes never ends.
- The iterator protocol -- `IsValid`, `Value`, `MoveNext` -- as used by every other iterable type here.

## Examples

```freebasic
#import "std/tasks"
using tasks

dim ch as Channel( of int32 ) = Channel( of int32 )( 4 )

for i as int32 = 1 to 3
    dim as int32 v = i
    ch.Send( v )
next
ch.Close( )                  '' or the loop below would never end

for each v in ch
    print v                  '' 1 / 2 / 3
next
print "drained"
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members
