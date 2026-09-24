[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LevelFromName**

# LevelFromName

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LevelFromName( s, byref out ) as boolean
```

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

'' Note the shape: the level comes back through an OUT PARAMETER and
'' the return value says whether the name was recognised. That is what
'' lets an unknown name be rejected rather than silently defaulted.
dim as LogLevel lv

if LevelFromName( "info", lv ) then print LevelName( lv )     '' INFO
if LevelFromName( "WARN", lv ) then print LevelName( lv )     '' WARN

print LevelFromName( "shouting", lv )      '' false -- lv is left alone

'' The inverse of LevelName, for reading a level from a config file
'' or an environment variable
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Levels  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
