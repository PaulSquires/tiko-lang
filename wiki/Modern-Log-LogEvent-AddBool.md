[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.AddBool**

# LogEvent.AddBool

Adds a named true or false field.

## Syntax

```freebasic
AddBool( k, v as boolean )
```

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Info( ).AddBool( "cached", true ).AddBool( "stale", false ).Msg( "served" )
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
