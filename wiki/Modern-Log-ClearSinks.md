[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **ClearSinks**

# ClearSinks

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
ClearSinks( )
```

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

dim a as ConsoleSink
dim b as ConsoleSink
dim lg as Logger

lg.AddSink( @a )
lg.AddSink( @b )
print lg.SinkCount( )        '' 2

lg.ClearSinks( )
print lg.SinkCount( )        '' 0

'' Detaches every sink. It does NOT destroy them -- the logger never
'' owned them, so their lifetime is still the caller's business.
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the tiko-lang repository.
