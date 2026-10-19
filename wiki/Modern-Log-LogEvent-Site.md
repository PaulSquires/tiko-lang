[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Site**

# LogEvent.Site

Records the file, line and procedure the record came from.

## Syntax

```freebasic
Site( file, line, func )
```

## Notes

- what the LogInfo-style macros fill in

## Examples

```freebasic
#import "std/logs"
using logs

'' File, line and function. The LogInfo-style macros fill these in
'' automatically on the default logger; with your own Logger they are
'' passed by hand.
''
'' TextRenderer.showsite DEFAULTS TO FALSE, so a Site( ) call on the
'' default sink is captured and then not printed. Turn it on and hand
'' the renderer to the sink:
dim tr as TextRenderer
tr.showsite = true

dim con as ConsoleSink = ConsoleSink( CT_STDERR, @tr )
dim lg as Logger
lg.AddSink( @con )

lg.Error( ).Site( __FILE__, __LINE__, __FUNCTION__ ).Msg( "unreachable" )
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
