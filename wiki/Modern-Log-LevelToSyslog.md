[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LevelToSyslog**

# LevelToSyslog

Returns the syslog severity number for a level.

## Syntax

```freebasic
LevelToSyslog( lv ) as int32
```

## Examples

```freebasic
#import "std/logs"
using logs

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

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Levels
