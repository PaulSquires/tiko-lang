[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Close**

# LogEvent.Close

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Close( )
```

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

dim con as ConsoleSink

dim r as LogRecord
r.level = LOG_INFO
r.message = "before close"
con.Write( r )

con.Close( )                 '' releases whatever the sink holds

'' Part of the abstract Sink interface -- Write, Flush, Close and
'' DroppedCount -- so every sink can be shut down the same way
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the tiko-lang repository.
