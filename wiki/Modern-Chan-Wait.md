[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **Wait**

# Wait

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Goroutines and Channels](Category-Goroutines-and-Channels), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Wait( )
```

## Examples

```freebasic
#include once "fb/sync.bi"
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

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels) ✨  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Waitgroup  
**Source:** `docs/goroutines/goroutines.txt` in the tiko-lang repository.
