[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **WithName**

# WithName

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
WithName( n ) as Logger_
```

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

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

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the tiko-lang repository.
