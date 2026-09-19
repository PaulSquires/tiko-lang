[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LevelToSyslog**

# LevelToSyslog

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Logging](Category-Logging), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LevelToSyslog( lv ) as long
```

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

'' The RFC 5424 severity number, for a sink that speaks syslog rather
'' than these names. Note the scales run OPPOSITE ways: higher severity
'' is a BIGGER LogLevel and a SMALLER syslog number.
print LevelToSyslog( LOG_FATAL )     '' 2
print LevelToSyslog( LOG_ERROR )     '' 3
print LevelToSyslog( LOG_WARN )      '' 4
print LevelToSyslog( LOG_INFO )      '' 6
print LevelToSyslog( LOG_DEBUG )     '' 7
```

---

**Library:** [Logging](Category-Logging) ✨  
**Category:** [Logging](Category-Logging)  
**Documented under:** Levels  
**Source:** `docs/logging/logging.txt` in the tiko-lang repository.
