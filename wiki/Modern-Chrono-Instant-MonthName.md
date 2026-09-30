[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.MonthName**

# Instant.MonthName

## Syntax

```freebasic
Instant.MonthName( mo [, abbrev] )
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print DateTime.MonthName( 8 )           '' August
print DateTime.MonthName( 8, true )     '' Aug -- abbreviated

'' INVARIANT ENGLISH, never the OS locale, so it is safe to write to a
'' file and read back. ToLocaleDateString is the locale-aware one.
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
