[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.AddUInt**

# LogEvent.AddUInt

## Syntax

```freebasic
AddUInt( k, v as uint64 )
```

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

'' Unsigned, so a value above LongInt's range keeps its magnitude
'' instead of appearing as a negative number
lg.Info( ).AddUInt( "bytes", 18446744073709551615ull ).Msg( "counted" )
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
