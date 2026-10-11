[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Str**

# LogEvent.Str

## Syntax

```freebasic
Str( k, v as ustring )
```

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Info( ).Str( "file", "data.csv" ).Str( "mode", "read" ).Msg( "opened" )

'' Every field method returns BYREF to the same event, which is what
'' makes the chain work -- and the event lives on the CALLER'S STACK,
'' which is what makes it thread-safe with no thread-local storage
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
