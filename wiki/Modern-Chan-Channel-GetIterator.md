[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **GetIterator**

# GetIterator

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Goroutines and Channels](Category-Goroutines-and-Channels), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The iterator `for each` uses to drain a channel.

## Syntax

```freebasic
GetIterator( ) as ChannelIterator( of T )
```

## Notes

- Iteration **consumes**: each step receives a value, and the loop ends when the channel is closed and drained -- the same condition that ends `while ch.Receive( v )`.
- It blocks between values, so a `for each` over a channel that nobody closes never ends.
- The RFC-0002 protocol -- `IsValid`, `Value`, `MoveNext` -- as used by every other iterable type here.

## Examples

```freebasic
#include once "fb/channel.bi"
using FB

dim ch as Channel( of long ) = Channel( of long )( 4 )

for i as long = 1 to 3
    dim as long v = i
    ch.Send( v )
next
ch.Close( )                  '' or the loop below would never end

for each v in ch
    print v                  '' 1 / 2 / 3
next
print "drained"
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels) ✨  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members  
**Source:** `docs/goroutines/goroutines.txt` in the tiko-lang repository.
