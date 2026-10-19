[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **Debug**

# Debug

Logs a message at the debug level, or returns a record to add fields to.

## Syntax

```freebasic
Debug( ) as LogEvent
Debug( byref m as ustring )
```

## Notes

- Detail for diagnosing a problem, off in production.
- Two forms: the one taking a message logs immediately, and the no-argument one returns a **LogEvent** to hang fields on, committed by `.Msg( )` or `.Send( )`.
- An event that is never committed **emits nothing** -- the destructor does not auto-send, so a forgotten `.Msg( )` shows up as a missing line rather than a line from nowhere.
- Suppressed entirely when the logger's `MinLevel` is above LOG_DEBUG, and `Enabled( )` is how to skip building an expensive message.

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Debug( "a message, logged immediately" )

'' Or build a record with fields, committed by Msg( )
lg.Debug( ).AddText( "user", "ada" ).AddInt( "attempt", 2 ).Msg( "with fields" )

'' Nothing is emitted by an event that is never committed
lg.Debug( ).AddText( "user", "grace" )
print "done"
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
