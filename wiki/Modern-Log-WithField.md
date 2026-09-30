[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **WithField**

# WithField

## Syntax

```freebasic
WithField( k, v as LogValue ) as Logger_
```

## Examples

```freebasic
#import "std/logs"
using FB

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

'' A child carrying one field on EVERY record it makes -- per-request or
'' per-connection context attached once instead of at each call site
dim req as Logger = lg.WithField( "reqid", LogValue( "abc123" ) )

req.Info( "received" )
req.Info( "answered" )       '' both lines carry reqid=abc123
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
