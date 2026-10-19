[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **Log**

# Log

Logs a message at a level you pass, or returns a record to add fields to.

## Syntax

```freebasic
Log( lv ) as LogEvent
Log( lv, m )
```

## Notes

- and the same six taking a message

## Examples

```freebasic
#import "std/logs"
using logs

'' THERE IS NO PROCESS-WIDE DEFAULT LOGGER in phase 1. A `dim shared`
'' in a .bi included by two modules gives two of them, so a singleton
'' needs storage in the runtime and this module deliberately adds no C.
'' Use an explicit Logger.
dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

'' Log( ) takes the level as an argument; the six named methods are the
'' same call with the level baked in
lg.Log( LOG_INFO, "starting" )
lg.Info( "started" )

'' Each also has a no-argument form returning a LogEvent to add fields to
lg.Log( LOG_WARN ).AddText( "disk", "C:" ).Msg( "almost full" )
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
