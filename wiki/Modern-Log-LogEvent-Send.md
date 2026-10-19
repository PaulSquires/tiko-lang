[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Send**

# LogEvent.Send

Sends the record without a message, for a record that is only fields.

## Syntax

```freebasic
Send( )
```

## Notes

- commits

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

'' Send( ) commits WITHOUT a message, for a record that is entirely
'' fields
lg.Info( ).AddText( "event", "heartbeat" ).AddInt( "seq", 1 ).Send( )

'' Msg( m ) is Send( ) with the message set first
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
