[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **Flush**

# Flush

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

reaches every attached sink

## Syntax

```freebasic
Flush( )
```

## Notes

- reaches every attached sink

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Info( "written" )
lg.Flush( )                  '' reaches EVERY attached sink

'' Worth calling before the process exits and before anything that might
'' abort: a buffered sink otherwise loses its tail
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the tiko-lang repository.
