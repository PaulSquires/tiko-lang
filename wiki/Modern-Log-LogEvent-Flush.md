[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Flush**

# LogEvent.Flush

## Syntax

```freebasic
Flush( )
```

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Info( "buffered" )

'' Logger.Flush( ) calls this on every attached sink; a sink can also be
'' flushed on its own
con.Flush( )
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
