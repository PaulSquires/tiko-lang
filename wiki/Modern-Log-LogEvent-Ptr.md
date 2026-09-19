[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Ptr_**

# LogEvent.Ptr_

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Ptr_( k, v as any ptr )
```

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

dim as long target = 42

'' Spelled Ptr_ WITH A TRAILING UNDERSCORE, because PTR is a FreeBASIC
'' keyword -- the same reason as Int_
lg.Info( ).Ptr_( "addr", @target ).Msg( "tracking" )
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the tiko-lang repository.
