[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **Add**

# Add

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Goroutines and Channels](Category-Goroutines-and-Channels), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Add( delta = 1 )
```

## Examples

```freebasic
#include once "fb/sync.bi"
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

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels) ✨  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Waitgroup  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
