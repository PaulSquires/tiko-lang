[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.MonthUName**

# Instant.MonthUName

## Syntax

```freebasic
Instant.MonthUName
```

## Examples

```freebasic
#import "std/chrono"
using FB

'' The same invariant English name as MonthName, as a USTRING
dim as ustring s = DateTime.MonthUName( 8 )

print s                      '' August
print DateTime.MonthUName( 8, true )    '' Aug
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
