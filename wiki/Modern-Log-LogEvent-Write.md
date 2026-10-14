[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Write**

# LogEvent.Write

## Syntax

```freebasic
Write( r )
```

## Examples

```freebasic
#import "std/logs"
using logs

'' Write is the Sink side, not the LogEvent side: every Sink implements
'' Write / Flush / Close / DroppedCount, and the Logger calls Write once
'' per record per sink.
dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Info( "routed to Write( )" )

'' Calling it directly is legal, and is what a custom sink overrides
dim r as LogRecord
r.level = LOG_INFO
r.message = "written directly"
con.Write( r )
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
