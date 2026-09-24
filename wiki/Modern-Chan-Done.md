[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **Done**

# Done

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Goroutines and Channels](Category-Goroutines-and-Channels), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Done( )
```

## Examples

```freebasic
#include once "fb/sync.bi"
using FB

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

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels) ✨  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Select  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
