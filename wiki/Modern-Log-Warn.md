[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **Warn**

# Warn

Logs a message at the warn level, or returns a record to add fields to.

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
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Warn( "a message, logged immediately" )

'' Or build a record with fields, committed by Msg( )
lg.Warn( ).AddText( "user", "ada" ).AddInt( "attempt", 2 ).Msg( "with fields" )

'' Nothing is emitted by an event that is never committed
lg.Warn( ).AddText( "user", "grace" )
print "done"
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
