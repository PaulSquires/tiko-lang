[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **Context**

# Context

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Goroutines and Channels](Category-Goroutines-and-Channels), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

the background context; never cancelled

## Syntax

```freebasic
Context( )
```

## Notes

- the background context; never cancelled

## Examples

```freebasic
#include once "fb/sync.bi"
using FB

'' The background context: never cancelled, and the root every other
'' context descends from
dim ctx as Context

print ctx.IsCancelled( )     '' false
print "[" & ctx.Err( ) & "]" '' [] -- empty while it is still live

'' NOTHING IS EVER KILLED. Cancellation is a request a goroutine
'' notices, or does not. TerminateThread would skip destructors and
'' DEFER blocks and leak every mutex the thread held -- in a language
'' with DEFER, forced termination misses exactly the cleanup that was
'' written to be unmissable.
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels) ✨  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Context  
**Source:** `docs/goroutines/goroutines.txt` in the tiko-lang repository.
