[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **IsNil**

# IsNil

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Goroutines and Channels](Category-Goroutines-and-Channels), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Whether this is a default-constructed channel, which blocks forever.

## Syntax

```freebasic
IsNil( ) as boolean
```

## Notes

- A **nil channel blocks forever** on `Send` and `Receive`. That is Go's rule, and it looks like a defect until `select` arrives -- where assigning a nil channel is how a case is disabled.
- This exists so a program can assert its own initialisation, because *"my program hangs"* is the symptom of forgetting it.
- `Close` on a nil channel raises.

## Examples

```freebasic
#include once "fb/channel.bi"
using FB

dim ch as Channel( of long )
print ch.IsNil( )            '' true -- default-constructed

'' Assert initialisation before anything blocks on it, because the
'' symptom of forgetting is a hang with no message
if ch.IsNil( ) then print "not initialised"

ch = Channel( of long )( 4 )
print ch.IsNil( )            '' false
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels) ✨  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members  
**Source:** `docs/goroutines/goroutines.txt` in the tiko-lang repository.
