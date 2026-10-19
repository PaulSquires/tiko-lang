[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.AddValue**

# LogEvent.AddValue

Adds a named field from a value you built yourself, of any supported kind.

## Syntax

```freebasic
AddValue( k, v as LogValue )
```

## Notes

- any tag, built by hand

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

'' The escape hatch: any tag, built by hand. LogValue has a constructor
'' per supported type, so this is what the typed methods call underneath.
dim v as LogValue = LogValue( 42ll )
lg.Info( ).AddValue( "answer", v ).Msg( "computed" )
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
