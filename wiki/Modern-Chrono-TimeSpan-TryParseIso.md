[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.TryParseIso**

# TimeSpan.TryParseIso

## Syntax

```freebasic
TimeSpan.TryParseIso( s, result )
```

## Examples

```freebasic
#import "std/chrono"
using FB

dim as TimeSpan t

if TimeSpan.TryParseIso( "PT90M", t ) then print t.TotalHours       '' 1.5

'' FALSE on a bad string -- and the output is CLOBBERED. TryParseIso
'' assigns Invalid to it before parsing and only overwrites that on
'' success, so the previous value does NOT survive a failed parse.
print TimeSpan.TryParseIso( "1 hour", t )              '' false
print t.IsValid                                        '' false
print t.TotalHours                                     '' a huge nonsense
                                                       '' number: read
                                                       '' IsValid, not this
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
