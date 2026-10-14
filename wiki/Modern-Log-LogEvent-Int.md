[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Int_**

# LogEvent.Int_

## Syntax

```freebasic
Int_( k, v as int64 )
```

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

'' Spelled Int_ WITH A TRAILING UNDERSCORE, because INT is a FreeBASIC
'' keyword. Ptr_ is the same story.
lg.Info( ).Int_( "rows", 1200 ).Int_( "skipped", -3 ).Msg( "loaded" )
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
