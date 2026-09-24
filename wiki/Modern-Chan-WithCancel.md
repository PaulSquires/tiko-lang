[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **WithCancel**

# WithCancel

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Goroutines and Channels](Category-Goroutines-and-Channels), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

a cancellable child

## Syntax

```freebasic
WithCancel( parent )
```

## Notes

- a cancellable child

## Examples

```freebasic
#include once "fb/sync.bi"
using FB

dim root as Context
dim ctx as CancelContext = WithCancel( root )

print ctx.IsCancelled( )     '' false

ctx.Cancel( )                '' the caller decides when
print ctx.IsCancelled( )     '' true
print ctx.Err( )             '' cancelled

'' Cancelling a parent cancels its children too, so one Cancel( ) at the
'' top shuts down a whole tree of workers
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels) ✨  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Context  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
