[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.AddInt**

# LogEvent.AddInt

Adds a named integer field, which stays a number in JSON output.

## Syntax

```freebasic
AddInt( k, v as int64 )
```

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Info( ).AddInt( "rows", 1200 ).AddInt( "skipped", -3 ).Msg( "loaded" )
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
