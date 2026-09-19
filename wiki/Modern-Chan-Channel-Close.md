[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **Close**

# Close

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Goroutines and Channels](Category-Goroutines-and-Channels), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Declares that no more values will be sent.

## Syntax

```freebasic
Close( )
```

## Notes

- It is **not** a destructor and not a free: it is a broadcast. Every blocked receiver wakes, and every later `Receive` drains the buffer and then answers FALSE.
- **Closing twice raises**, and so does any send after it. Closing is a statement of fact that only the sending side may make, and making it twice -- or sending afterwards -- means two parties disagree about who owns the producer role.
- The channel's destructor does **not** close, because a scope that stopped holding a reference has not said that no more values are coming.
- Buffered values survive: a closed channel is drained before it reports closure.

## Examples

```freebasic
#include once "fb/channel.bi"
using FB

dim ch as Channel( of long ) = Channel( of long )( 4 )

dim as long v = 1
ch.Send( v )
ch.Close( )

print ch.IsClosed( )         '' true

'' The buffered value is still delivered -- closing does not discard
dim as long got
print ch.Receive( got )      '' true
print got                    '' 1
print ch.Receive( got )      '' false -- now it is drained
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels) ✨  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members  
**Source:** `docs/goroutines/goroutines.txt` in the tiko-lang repository.
