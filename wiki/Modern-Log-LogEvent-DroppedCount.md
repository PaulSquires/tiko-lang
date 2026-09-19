[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.DroppedCount**

# LogEvent.DroppedCount

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
DroppedCount( ) as ulongint
```

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Info( "one record" )

'' How many records this sink threw away. A ConsoleSink writes
'' synchronously and drops nothing, so it is always 0; the counter
'' exists for phase 6's AsyncSink, whose queue can overflow.
print con.DroppedCount( )    '' 0
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the tiko-lang repository.
