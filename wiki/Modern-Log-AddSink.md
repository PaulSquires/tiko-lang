[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **AddSink**

# AddSink

the LOGGER DOES NOT OWN THE SINK

## Syntax

```freebasic
AddSink( s as Sink ptr )
```

## Notes

- the LOGGER DOES NOT OWN THE SINK

## Examples

```freebasic
#import "std/logs"
using logs

'' THE LOGGER DOES NOT OWN THE SINK -- it stores a pointer, so the sink
'' must outlive the logger. Declaring both in the same scope, sink first,
'' is the shape that guarantees it.
dim con as ConsoleSink
dim lg as Logger

lg.AddSink( @con )
print lg.SinkCount( )        '' 1

lg.Info( "goes to the console" )
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
