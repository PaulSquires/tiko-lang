[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Flush**

# LogEvent.Flush

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Flush( )
```

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Info( "buffered" )

'' Logger.Flush( ) calls this on every attached sink; a sink can also be
'' flushed on its own
con.Flush( )
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the tiko-lang repository.
