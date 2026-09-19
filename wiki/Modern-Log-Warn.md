[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **Warn**

# Warn

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Logs at WARN level, either directly or by starting a field chain.

## Syntax

```freebasic
Warn( ) as LogEvent
Warn( byref m as ustring )
```

## Notes

- Something unexpected that the program handled.
- Two forms: the one taking a message logs immediately, and the no-argument one returns a **LogEvent** to hang fields on, committed by `.Msg( )` or `.Send( )`.
- An event that is never committed **emits nothing** -- the destructor does not auto-send, so a forgotten `.Msg( )` shows up as a missing line rather than a line from nowhere.
- Suppressed entirely when the logger's `MinLevel` is above LOG_WARN, and `Enabled( )` is how to skip building an expensive message.

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Warn( "a message, logged immediately" )

'' Or build a record with fields, committed by Msg( )
lg.Warn( ).Str( "user", "ada" ).Int_( "attempt", 2 ).Msg( "with fields" )

'' Nothing is emitted by an event that is never committed
lg.Warn( ).Str( "user", "grace" )
print "done"
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the tiko-lang repository.
