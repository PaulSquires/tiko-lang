[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **ClearSinks**

# ClearSinks

Detaches every sink, without destroying any of them.

## Syntax

```freebasic
ClearSinks( )
```

## Examples

```freebasic
#import "std/logs"
using logs

dim a as ConsoleSink
dim b as ConsoleSink
dim lg as Logger

lg.AddSink( @a )
lg.AddSink( @b )
print lg.SinkCount( )        '' 2

lg.ClearSinks( )
print lg.SinkCount( )        '' 0

'' Detaches every sink. It does NOT destroy them -- the logger never
'' owned them, so their lifetime is still the caller's business.
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
