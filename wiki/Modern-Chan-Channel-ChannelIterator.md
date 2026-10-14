[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **ChannelIterator**

# ChannelIterator

The iterator `for each` uses to drain a channel.

## Syntax

```freebasic
ChannelIterator( of T )
```

## Notes

- The iterator protocol -- `IsValid`, `Value`, `MoveNext` -- which is what `for each` is rewritten into. Ordinary code names the type only when the loop has to stop early, resume, or interleave with another.
- Iteration **consumes**: each step receives a value, and the loop ends when the channel is closed and drained.
- It **blocks** between values, so `for each` over a channel nobody closes never ends.
- Requires `-mt`.

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
