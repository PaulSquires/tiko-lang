[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.AddPtr**

# LogEvent.AddPtr

Adds a named pointer field, such as the address of an object.

## Syntax

```freebasic
AddPtr( k, v as any ptr )
```

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

dim as int32 target = 42

lg.Info( ).AddPtr( "addr", @target ).Msg( "tracking" )
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
