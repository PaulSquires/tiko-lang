[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Span**

# LogEvent.Span

## Syntax

```freebasic
Span( k, v as TimeSpan )
```

## Examples

```freebasic
#import "std/chrono"
#import "std/logs"
using logs, chrono


dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

dim as TimeSpan took = TimeSpan.FromMilliseconds( 1500 )
lg.Info( ).Span( "took", took ).Msg( "finished" )
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
