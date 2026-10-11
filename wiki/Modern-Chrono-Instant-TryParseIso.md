[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.TryParseIso**

# Instant.TryParseIso

## Syntax

```freebasic
Instant.TryParseIso
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d

if DateTime.TryParseIso( "2026-08-13T14:30:05", d ) then print d.Year

'' FALSE on a bad string, and the output is CLOBBERED to Invalid rather
'' than left as it was
print DateTime.TryParseIso( "13/08/2026", d )        '' false
print d.IsValid                                      '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
