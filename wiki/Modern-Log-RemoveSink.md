[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **RemoveSink**

# RemoveSink

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
RemoveSink( s )
```

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

dim con as ConsoleSink
dim lg as Logger

lg.AddSink( @con )
print lg.SinkCount( )        '' 1

lg.RemoveSink( @con )        '' matched by pointer identity
print lg.SinkCount( )        '' 0

'' Removing one that was never added is a no-op, not an error
lg.RemoveSink( @con )
print lg.SinkCount( )        '' 0
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
