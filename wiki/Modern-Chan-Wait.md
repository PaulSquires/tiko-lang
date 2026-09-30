[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **Wait**

# Wait

## Syntax

```freebasic
Wait( )
```

## Examples

```freebasic
#import "std/tasks"
using FB

dim wg as WaitGroup

'' With nothing outstanding, Wait( ) returns immediately
print wg.Count( )            '' 0
wg.Wait( )
print "returned"

'' The real shape, with the Add before the spawn:
''     for i as long = 1 to 8
''         wg.Add( )
''         spawn Worker( i, @wg )     '' Worker does `defer wg->Done( )`
''     next
''     wg.Wait( )                     '' blocks until all eight are done
''
'' Wait( ) parks the calling thread rather than spinning, so waiting
'' costs no CPU.
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Waitgroup  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
