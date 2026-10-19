[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **Sink.DroppedCount**

# Sink.DroppedCount

Returns how many records a sink could not write; the count never resets.

## Syntax

```freebasic
DroppedCount( ) as uint64
```

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Info( "one record" )

'' How many records this sink threw away. A ConsoleSink writes
'' synchronously and drops nothing, so it is always 0; the counter
'' matters for AsyncSink, whose queue can overflow.
print con.DroppedCount( )    '' 0
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
