[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **WithTimeout**

# WithTimeout

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Goroutines and Channels](Category-Goroutines-and-Channels), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

cancels itself when the deadline passes

## Syntax

```freebasic
WithTimeout( parent, ms )
```

## Notes

- cancels itself when the deadline passes

## Examples

```freebasic
#include once "fb/sync.bi"
using FB

dim root as Context
dim ctx as CancelContext = WithTimeout( root, 50 )

print ctx.IsCancelled( )     '' false

sleep 150, 1
print ctx.IsCancelled( )     '' true
print ctx.Err( )             '' deadline exceeded -- NOT "cancelled"

'' The timeout is a goroutine parked with a deadline, so it costs one
'' pool worker for the duration. Cancelling early unparks it, so it does
'' not outlive the context.
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels) ✨  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Context  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
