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
#include once "fb/channel.bi"
using FB

dim ch as Channel( of long ) = Channel( of long )( 4 )

for i as long = 1 to 3
    dim as long v = i
    ch.Send( v )
next
ch.Close( )                  '' no more values will be sent

'' The consumer loop ends by itself: closed AND drained answers false
dim as long v
while ch.Receive( v )
    print v                  '' 1 / 2 / 3
wend
print "drained"
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
