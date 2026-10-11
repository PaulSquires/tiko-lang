[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Time**

# LogEvent.Time

## Syntax

```freebasic
Time( k, v as Instant )
```

## Examples

```freebasic
#import "std/chrono"
#import "std/logs"
using logs, chrono


dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

'' Instant has no Now( ) -- the clock lives in SystemClock; an Instant
'' is built from a count, here a Unix timestamp
dim as Instant at = Instant.FromUnixSeconds( 1767225600 )
lg.Info( ).Time( "at", at ).Msg( "stamped" )
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
