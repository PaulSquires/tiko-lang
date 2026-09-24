[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Span**

# LogEvent.Span

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Span( k, v as TimeSpan )
```

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

#include once "fb/chrono.bi"

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

dim as TimeSpan took = TimeSpan.FromMilliseconds( 1500 )
lg.Info( ).Span( "took", took ).Msg( "finished" )
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
