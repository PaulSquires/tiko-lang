[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.UInt**

# LogEvent.UInt

## Syntax

```freebasic
UInt( k, v as uint64 )
```

## Examples

```freebasic
#import "std/logs"
using FB

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

'' Unsigned, so a value above LongInt's range keeps its magnitude
'' instead of appearing as a negative number
lg.Info( ).UInt( "bytes", 18446744073709551615ull ).Msg( "counted" )
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
