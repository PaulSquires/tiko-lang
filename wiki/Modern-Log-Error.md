[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **Error**

# Error

Logs at ERROR level, either directly or by starting a field chain.

## Syntax

```freebasic
Error( ) as LogEvent
Error( byref m as ustring )
```

## Notes

- Something the program could not do.
- Two forms: the one taking a message logs immediately, and the no-argument one returns a **LogEvent** to hang fields on, committed by `.Msg( )` or `.Send( )`.
- An event that is never committed **emits nothing** -- the destructor does not auto-send, so a forgotten `.Msg( )` shows up as a missing line rather than a line from nowhere.
- Suppressed entirely when the logger's `MinLevel` is above LOG_ERROR, and `Enabled( )` is how to skip building an expensive message.

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Error( "a message, logged immediately" )

'' Or build a record with fields, committed by Msg( )
lg.Error( ).AddText( "user", "ada" ).AddInt( "attempt", 2 ).Msg( "with fields" )

'' Nothing is emitted by an event that is never committed
lg.Error( ).AddText( "user", "grace" )
print "done"
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
