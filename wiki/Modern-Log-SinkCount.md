[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **SinkCount**

# SinkCount

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
SinkCount( ) as long
```

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

dim con as ConsoleSink
dim lg as Logger

print lg.SinkCount( )        '' 0 -- a fresh Logger has no sinks

lg.AddSink( @con )
print lg.SinkCount( )        '' 1

'' Logging with no sinks attached is still valid: the record is built
'' and then goes nowhere
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the tiko-lang repository.
