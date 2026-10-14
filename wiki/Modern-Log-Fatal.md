[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **Fatal**

# Fatal

Logs at FATAL level, either directly or by starting a field chain.

## Syntax

```freebasic
Fatal( ) as LogEvent
Fatal( byref m as ustring )
```

## Notes

- The most severe level -- and it DOES NOT TERMINATE ANYTHING.
- Two forms: the one taking a message logs immediately, and the no-argument one returns a **LogEvent** to hang fields on, committed by `.Msg( )` or `.Send( )`.
- An event that is never committed **emits nothing** -- the destructor does not auto-send, so a forgotten `.Msg( )` shows up as a missing line rather than a line from nowhere.
- Suppressed entirely when the logger's `MinLevel` is above LOG_FATAL, and `Enabled( )` is how to skip building an expensive message.
- `LOG_FATAL` is a **severity, not an action**: a library that logs it has not decided to end your process.

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Fatal( "a message, logged immediately" )

'' Or build a record with fields, committed by Msg( )
lg.Fatal( ).Str( "user", "ada" ).Int_( "attempt", 2 ).Msg( "with fields" )

'' Nothing is emitted by an event that is never committed
lg.Fatal( ).Str( "user", "grace" )
print "done"
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
