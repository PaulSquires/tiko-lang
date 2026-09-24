[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Msg**

# LogEvent.Msg

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

sets the message and commits

## Syntax

```freebasic
Msg( m )
```

## Notes

- sets the message and commits

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

'' Msg( ) sets the message AND COMMITS. It is the end of the chain.
lg.Info( ).Str( "user", "ada" ).Msg( "login ok" )

'' AN EVENT THAT IS NEVER COMMITTED EMITS NOTHING. The destructor does
'' not auto-send: a forgotten Msg( ) shows up as a missing line, which
'' is noticed, rather than as a line appearing from nowhere.
lg.Info( ).Str( "user", "grace" )      '' never sent
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
