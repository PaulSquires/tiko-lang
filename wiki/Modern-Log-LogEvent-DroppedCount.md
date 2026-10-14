[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.DroppedCount**

# LogEvent.DroppedCount

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
'' exists for phase 6's AsyncSink, whose queue can overflow.
print con.DroppedCount( )    '' 0
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
