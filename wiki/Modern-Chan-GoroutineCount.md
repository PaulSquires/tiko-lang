[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **GoroutineCount**

# GoroutineCount

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Goroutines and Channels](Category-Goroutines-and-Channels), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

How many goroutines currently exist.

## Syntax

```freebasic
GoroutineCount( ) as long
```

## Notes

- A **diagnostic**, and a snapshot: it is stale the moment it returns.
- Useful for asserting in a test that a fan-out actually finished, and for spotting a leak where goroutines accumulate.
- Not a scheduling control -- there is no way to cap it from here.

## Examples

```freebasic
#include once "fb/sync.bi"
using FB

print GoroutineCount( ) >= 0     '' -1 (true)

'' Worth asserting at the end of a test: a count that keeps climbing
'' between runs is a goroutine leak
dim as long before = GoroutineCount( )
print before >= 0                '' -1 (true)
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels) ✨  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members  
**Source:** `docs/goroutines/goroutines.txt` in the tiko-lang repository.
