[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **MinLevel**

# MinLevel

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

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
#include once "fb/logging.bi"
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

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the tiko-lang repository.
