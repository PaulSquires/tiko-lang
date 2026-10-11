[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **SinkCount**

# SinkCount

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
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
