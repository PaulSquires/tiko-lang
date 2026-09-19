[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.ConsoleSink**

# LogEvent.ConsoleSink

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

stderr, own TextRenderer

## Syntax

```freebasic
ConsoleSink( )
ConsoleSink( target )
ConsoleSink( target, r as Renderer ptr )
```

## Notes

- stderr, own TextRenderer
- CT_STDERR or CT_STDOUT
- your renderer, not owned

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

'' Writes to stderr, with its own TextRenderer. Detects whether the
'' handle is a terminal, so colour is not emitted into a redirected file.
dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Info( "to stderr" )

'' It is the only sink in phase 1: FileSink and rotation are phase 3,
'' AsyncSink phase 6
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the tiko-lang repository.
