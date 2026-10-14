[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LevelFromName**

# LevelFromName

## Syntax

```freebasic
LevelFromName( s, byref out ) as boolean
```

## Examples

```freebasic
#import "std/logs"
using logs

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

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Levels
