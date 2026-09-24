[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Int_**

# LogEvent.Int_

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Int_( k, v as longint )
```

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

'' Spelled Int_ WITH A TRAILING UNDERSCORE, because INT is a FreeBASIC
'' keyword. Ptr_ is the same story.
lg.Info( ).Int_( "rows", 1200 ).Int_( "skipped", -3 ).Msg( "loaded" )
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
