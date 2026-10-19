[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.AddSpan**

# LogEvent.AddSpan

Adds a named field holding a length of time, such as how long a step took.

## Syntax

```freebasic
AddSpan( k, v as TimeSpan )
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
lg.Info( ).AddSpan( "took", took ).Msg( "finished" )
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
