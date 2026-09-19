[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Str**

# LogEvent.Str

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Str( k, v as ustring )
```

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Info( ).Str( "file", "data.csv" ).Str( "mode", "read" ).Msg( "opened" )

'' Every field method returns BYREF to the same event, which is what
'' makes the chain work -- and the event lives on the CALLER'S STACK,
'' which is what makes it thread-safe with no thread-local storage
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the tiko-lang repository.
