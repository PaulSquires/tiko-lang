[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **WithField**

# WithField

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
WithField( k, v as LogValue ) as Logger_
```

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

'' A child carrying one field on EVERY record it makes -- per-request or
'' per-connection context attached once instead of at each call site
dim req as Logger = lg.WithField( "reqid", LogValue( "abc123" ) )

req.Info( "received" )
req.Info( "answered" )       '' both lines carry reqid=abc123
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
