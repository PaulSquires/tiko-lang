[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Write**

# LogEvent.Write

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Write( r )
```

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

'' Write is the Sink side, not the LogEvent side: every Sink implements
'' Write / Flush / Close / DroppedCount, and the Logger calls Write once
'' per record per sink.
dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Info( "routed to Write( )" )

'' Calling it directly is legal, and is what a custom sink overrides
dim r as LogRecord
r.level = LOG_INFO
r.message = "written directly"
con.Write( r )
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the tiko-lang repository.
