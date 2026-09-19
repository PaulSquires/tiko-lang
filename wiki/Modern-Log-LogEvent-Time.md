[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Time**

# LogEvent.Time

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Time( k, v as Instant )
```

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

#include once "fb/chrono.bi"

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

'' Instant has no Now( ) -- the clock lives in SystemClock; an Instant
'' is built from a count, here a Unix timestamp
dim as Instant at = Instant.FromUnixSeconds( 1767225600 )
lg.Info( ).Time( "at", at ).Msg( "stamped" )
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the tiko-lang repository.
