[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **WithName**

# WithName

Returns a child logger with its own component name and the parent's sinks.

## Syntax

```freebasic
WithName( n ) as LoggerType
```

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )
lg.Name = "app"

'' A child logger with its own name, so one subsystem's lines can be
'' told apart at the sink. The child carries the parent's sinks.
dim net_ as Logger = lg.WithName( "net" )
net_.Info( "listening" )

print net_.Name              '' net
print lg.Name                '' app -- the parent is untouched
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
