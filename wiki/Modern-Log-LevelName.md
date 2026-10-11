[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LevelName**

# LevelName

## Syntax

```freebasic
LevelName( lv ) as ustring
```

## Examples

```freebasic
#import "std/logs"
using logs

print LevelName( LOG_TRACE )     '' TRACE
print LevelName( LOG_INFO )      '' INFO
print LevelName( LOG_FATAL )     '' FATAL

'' LOG_FATAL DOES NOT TERMINATE ANYTHING -- it is a severity, not an
'' action. A library that logs it has not decided to end your process.
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Levels  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
