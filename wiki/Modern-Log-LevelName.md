[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LevelName**

# LevelName

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LevelName( lv ) as ustring
```

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

print LevelName( LOG_TRACE )     '' TRACE
print LevelName( LOG_INFO )      '' INFO
print LevelName( LOG_FATAL )     '' FATAL

'' LOG_FATAL DOES NOT TERMINATE ANYTHING -- it is a severity, not an
'' action. A library that logs it has not decided to end your process.
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Levels  
**Source:** `docs/logging/logging.txt` in the tiko-lang repository.
