[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Msg**

# LogEvent.Msg

Sets the message and sends the record; a record that is never sent logs nothing.

## Syntax

```freebasic
Msg( m )
```

## Notes

- sets the message and commits

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

'' Msg( ) sets the message AND COMMITS. It is the end of the chain.
lg.Info( ).AddText( "user", "ada" ).Msg( "login ok" )

'' AN EVENT THAT IS NEVER COMMITTED EMITS NOTHING. The destructor does
'' not auto-send: a forgotten Msg( ) shows up as a missing line, which
'' is noticed, rather than as a line appearing from nowhere.
lg.Info( ).AddText( "user", "grace" )      '' never sent
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
