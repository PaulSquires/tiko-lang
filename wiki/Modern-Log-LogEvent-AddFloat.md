[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.AddFloat**

# LogEvent.AddFloat

Adds a named floating-point field.

## Syntax

```freebasic
AddFloat( k, v as float64 )
```

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Info( ).AddFloat( "elapsed_s", 1.25 ).AddFloat( "ratio", 0.1 + 0.2 ).Msg( "done" )
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
