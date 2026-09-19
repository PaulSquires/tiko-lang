[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **IsCancelled**

# IsCancelled

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Goroutines and Channels](Category-Goroutines-and-Channels), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
IsCancelled( )
```

## Examples

```freebasic
#include once "fb/sync.bi"
using FB

dim root as Context
dim ctx as CancelContext = WithCancel( root )

print ctx.IsCancelled( )     '' false
ctx.Cancel( )
print ctx.IsCancelled( )     '' true

'' A poll, for a loop that can check between units of work:
''     do while not ctx.IsCancelled( )
''         ... one chunk ...
''     loop
''
'' To BLOCK until cancellation instead, select on Done( ) -- a closed
'' channel is permanently ready, so that case fires at once and forever.
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels) ✨  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Context  
**Source:** `docs/goroutines/goroutines.txt` in the tiko-lang repository.
