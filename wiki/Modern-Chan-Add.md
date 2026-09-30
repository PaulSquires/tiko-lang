[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **Add**

# Add

## Syntax

```freebasic
Add( delta = 1 )
```

## Examples

```freebasic
#import "std/tasks"
using FB

'' A WaitGroup counts outstanding work. Add BEFORE spawning, never
'' inside the goroutine -- otherwise Wait( ) can see zero and return
'' before the worker has even started.
dim wg as WaitGroup

wg.Add( )                    '' delta defaults to 1
print wg.Count( )            '' 1

wg.Add( 3 )                  '' or several at once
print wg.Count( )            '' 4

wg.Done( ) : wg.Done( ) : wg.Done( ) : wg.Done( )
print wg.Count( )            '' 0
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Waitgroup  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
