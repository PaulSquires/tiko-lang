[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **Sink.Close**

# Sink.Close

Closes a sink and releases what it holds; every kind of sink closes the same way.

## Syntax

```freebasic
Close( )
```

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink

dim r as LogRecord
r.level = LOG_INFO
r.message = "before close"
con.Write( r )

con.Close( )                 '' releases whatever the sink holds

'' Part of the abstract Sink interface -- Write, Flush, Close and
'' DroppedCount -- so every sink can be shut down the same way
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
