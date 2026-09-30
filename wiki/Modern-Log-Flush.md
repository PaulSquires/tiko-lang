[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **Flush**

# Flush

reaches every attached sink

## Syntax

```freebasic
Flush( )
```

## Notes

- reaches every attached sink

## Examples

```freebasic
#import "std/logs"
using FB

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
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
