[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Site**

# LogEvent.Site

what the phase-5 macros will fill in

## Syntax

```freebasic
Site( file, line, func )
```

## Notes

- what the phase-5 macros will fill in

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

'' File, line and function. Phase 5's macro layer will fill these in
'' automatically; until then they are passed by hand.
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
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
