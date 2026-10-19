[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **SinkCount**

# SinkCount

Returns how many sinks are attached to the logger.

## Syntax

```freebasic
SinkCount( ) as int32
```

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger

print lg.SinkCount( )        '' 0 -- a fresh Logger has no sinks

lg.AddSink( @con )
print lg.SinkCount( )        '' 1

'' Logging with no sinks attached is still valid: the record is built
'' and then goes nowhere
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
