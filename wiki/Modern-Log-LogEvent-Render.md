[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.Render**

# LogEvent.Render

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

APPENDS, and does not clear

## Syntax

```freebasic
Render( r, byref outbuf as ustring )
```

## Notes

- APPENDS, and does not clear

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

'' Render is the Renderer side: it turns a LogRecord into text and
'' appends it to a buffer, without doing any I/O itself. That split is
'' what lets one sink write what another renders.
dim tr as TextRenderer
dim out_ as ustring

dim r as LogRecord
r.level = LOG_INFO
r.message = "hello"

tr.Render( r, out_ )
print len( out_ ) > 0        '' -1 (true) -- the line was rendered

'' JsonRenderer is phase 2; TextRenderer is the only one here
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
