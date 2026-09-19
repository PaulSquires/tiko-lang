[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.UInt**

# LogEvent.UInt

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
UInt( k, v as ulongint )
```

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

'' Unsigned, so a value above LongInt's range keeps its magnitude
'' instead of appearing as a negative number
lg.Info( ).UInt( "bytes", 18446744073709551615ull ).Msg( "counted" )
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the tiko-lang repository.
