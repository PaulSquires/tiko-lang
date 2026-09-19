[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **IsClosed**

# IsClosed

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Goroutines and Channels](Category-Goroutines-and-Channels), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Whether the channel has been closed.

## Syntax

```freebasic
IsClosed( ) as boolean
```

## Notes

- It is what tells a FALSE from `TryReceive` apart: "nothing right now" versus "nothing ever again".
- TRUE while buffered values remain -- closed and drained are different states, and `Receive` keeps yielding until both hold.
- A snapshot. Do not branch on it to decide whether a `Send` will succeed; check the result of the send.

## Examples

```freebasic
#include once "fb/channel.bi"
using FB

dim ch as Channel( of long ) = Channel( of long )( 4 )
print ch.IsClosed( )         '' false

dim as long v = 1
ch.Send( v )
ch.Close( )

'' TRUE even though a value is still buffered: closed and drained are
'' two different things
print ch.IsClosed( )         '' true
print ch.Count( )            '' 1
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels) ✨  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members  
**Source:** `docs/goroutines/goroutines.txt` in the tiko-lang repository.
