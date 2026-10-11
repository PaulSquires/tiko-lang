[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Dbl**

# LogEvent.Dbl

## Syntax

```freebasic
Dbl( k, v as float64 )
```

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Info( ).Dbl( "elapsed_s", 1.25 ).Dbl( "ratio", 0.1 + 0.2 ).Msg( "done" )
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
