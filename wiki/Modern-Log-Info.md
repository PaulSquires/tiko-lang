[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **Info**

# Info

Logs at INFO level, either directly or by starting a field chain.

## Syntax

```freebasic
Info( ) as LogEvent
Info( byref m as ustring )
```

## Notes

- The ordinary running commentary of a healthy program.
- Two forms: the one taking a message logs immediately, and the no-argument one returns a **LogEvent** to hang fields on, committed by `.Msg( )` or `.Send( )`.
- An event that is never committed **emits nothing** -- the destructor does not auto-send, so a forgotten `.Msg( )` shows up as a missing line rather than a line from nowhere.
- Suppressed entirely when the logger's `MinLevel` is above LOG_INFO, and `Enabled( )` is how to skip building an expensive message.

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Info( "a message, logged immediately" )

'' Or build a record with fields, committed by Msg( )
lg.Info( ).Str( "user", "ada" ).Int_( "attempt", 2 ).Msg( "with fields" )

'' Nothing is emitted by an event that is never committed
lg.Info( ).Str( "user", "grace" )
print "done"
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
