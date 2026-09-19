[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **Emit**

# Emit

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

a finished record, to the sinks

## Syntax

```freebasic
Emit( r as LogRecord )
```

## Notes

- a finished record, to the sinks

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

'' Emit hands a FINISHED record to every sink. It is what .Msg( ) and
'' .Send( ) call underneath, and it is the only place a Logger does I/O.
lg.Info( ).Str( "stage", "startup" ).Msg( "ready" )

'' A record can also be built and emitted directly
dim r as LogRecord
r.level = LOG_INFO
r.message = "emitted by hand"
lg.Emit( r )
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the tiko-lang repository.
