[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Ptr_**

# LogEvent.Ptr_

## Syntax

```freebasic
Ptr_( k, v as any ptr )
```

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

dim as int32 target = 42

'' Spelled Ptr_ WITH A TRAILING UNDERSCORE, because PTR is a FreeBASIC
'' keyword -- the same reason as Int_
lg.Info( ).Ptr_( "addr", @target ).Msg( "tracking" )
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
