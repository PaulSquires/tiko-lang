[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **Flush**

# Flush

Flushes every sink attached to the logger.

## Syntax

```freebasic
Flush( )
```

## Notes

- reaches every attached sink

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Info( "written" )
lg.Flush( )                  '' reaches EVERY attached sink

'' Worth calling before the process exits and before anything that might
'' abort: a buffered sink otherwise loses its tail
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
