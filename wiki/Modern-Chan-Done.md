[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **Done**

# Done

## Syntax

```freebasic
Done( )
```

## Examples

```freebasic
#import "std/tasks"
using tasks

dim wg as WaitGroup
wg.Add( 2 )

wg.Done( )                   '' one unit of work finished
print wg.Count( )            '' 1

wg.Done( )
print wg.Count( )            '' 0 -- Wait( ) returns once the count reaches zero

'' In a worker this belongs in a DEFER, so an early exit still counts:
''     defer wg->Done( )
'' Calling Done( ) more times than Add( ) raises -- the count must not
'' go negative, because that would let Wait( ) return early forever.
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Select  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
