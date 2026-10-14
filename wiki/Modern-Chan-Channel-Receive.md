[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **Receive**

# Receive

Receives a value, blocking until one arrives.

## Syntax

```freebasic
Receive( byref out as T ) as boolean
```

## Notes

- Returns **FALSE when the channel is closed AND drained**, which is what makes `while ch.Receive( v )` the whole consumer loop -- it ends by itself.
- A closed channel still yields every value already buffered; only when those run out does it answer FALSE.
- On a **nil** channel it blocks forever.
- `TryReceive` is the non-blocking form and `ReceiveFor` the bounded one.

## Examples

```freebasic
#import "std/tasks"
using tasks

dim ch as Channel( of int32 ) = Channel( of int32 )( 4 )

for i as int32 = 1 to 3
    dim as int32 v = i
    ch.Send( v )
next
ch.Close( )                  '' no more values will be sent

'' The consumer loop ends by itself: closed AND drained answers false
dim as int32 v
while ch.Receive( v )
    print v                  '' 1 / 2 / 3
wend
print "drained"
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members
