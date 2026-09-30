[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Bool**

# LogEvent.Bool

## Syntax

```freebasic
Bool( k, v as boolean )
```

## Examples

```freebasic
#import "std/logs"
using FB

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Info( ).Bool( "cached", true ).Bool( "stale", false ).Msg( "served" )
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
