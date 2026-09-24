[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Send**

# LogEvent.Send

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

commits

## Syntax

```freebasic
Send( )
```

## Notes

- commits

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

'' Send( ) commits WITHOUT a message, for a record that is entirely
'' fields
lg.Info( ).Str( "event", "heartbeat" ).Int_( "seq", 1 ).Send( )

'' Msg( m ) is Send( ) with the message set first
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
