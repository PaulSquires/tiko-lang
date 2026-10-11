[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.WeekdayUName**

# Instant.WeekdayUName

## Syntax

```freebasic
Instant.WeekdayUName
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as ustring s = DateTime.WeekdayUName( 4 )

print s                      '' Thursday
print DateTime.WeekdayUName( 7, true )  '' Sun
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
