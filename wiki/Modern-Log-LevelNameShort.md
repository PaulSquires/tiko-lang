[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LevelNameShort**

# LevelNameShort

## Syntax

```freebasic
LevelNameShort( lv ) as ustring
```

## Examples

```freebasic
#include once "fb/logging.bi"
using FB

print LevelNameShort( LOG_TRACE )    '' TRC
print LevelNameShort( LOG_INFO )     '' INF
print LevelNameShort( LOG_FATAL )    '' FTL

'' Three characters for every level, so a log column lines up without
'' padding -- which LevelName, running from TRACE to WARN, does not
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Levels  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
