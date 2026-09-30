[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **MinLevel**

# MinLevel

The lowest level this logger will emit.

## Syntax

```freebasic
MinLevel as LogLevel        '' get and set
```

## Notes

- A **property**, so it reads and assigns like a field.
- Records below it are dropped before any sink sees them, so raising it costs nothing at the sinks.
- `LOG_OFF` silences the logger completely.
- A child from `WithName` or `WithField` starts from its parent's value.

## Examples

```freebasic
#import "std/logs"
using FB

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

print lg.MinLevel = LOG_TRACE    '' -1 (true) -- the default

lg.MinLevel = LOG_WARN
lg.Info( "dropped -- below MinLevel" )
lg.Warn( "emitted" )

'' LOG_OFF silences it entirely
lg.MinLevel = LOG_OFF
lg.Error( "not emitted either" )
print "done"
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
