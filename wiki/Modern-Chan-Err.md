[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **Err**

# Err

## Syntax

```freebasic
Err( )
```

## Examples

```freebasic
#import "std/tasks"
using tasks

dim root as Context

'' Empty while the context is still live -- the same rule Go follows,
'' so a non-empty Err( ) means "finished, and this is why"
print "[" & root.Err( ) & "]"          '' []

dim c1 as CancelContext = WithCancel( root )
c1.Cancel( )
print c1.Err( )                        '' cancelled

dim c2 as CancelContext = WithTimeout( root, 20 )
sleep 100, 1
print c2.Err( )                        '' deadline exceeded

'' The two are distinguishable on purpose: a deadline is a failure to
'' finish in time, a cancel is someone deciding to stop
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Context  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
