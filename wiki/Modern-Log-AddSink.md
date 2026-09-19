[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **AddSink**

# AddSink

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

the LOGGER DOES NOT OWN THE SINK

## Syntax

```freebasic
AddSink( s as Sink ptr )
```

## Notes

- the LOGGER DOES NOT OWN THE SINK

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

'' THE LOGGER DOES NOT OWN THE SINK -- it stores a pointer, so the sink
'' must outlive the logger. Declaring both in the same scope, sink first,
'' is the shape that guarantees it.
dim con as ConsoleSink
dim lg as Logger

lg.AddSink( @con )
print lg.SinkCount( )        '' 1

lg.Info( "goes to the console" )
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the tiko-lang repository.
