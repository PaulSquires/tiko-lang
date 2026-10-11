[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.LocalDate**

# LocalDate.LocalDate

Invalid

## Syntax

```freebasic
LocalDate( )
LocalDate( y, mo, d )
```

## Notes

- Invalid

## Examples

```freebasic
#import "std/chrono"
using chrono

'' A calendar date with no time and no zone. One LONG day number,
'' counted from 0001-01-01 in the proleptic Gregorian calendar.
dim as LocalDate d = LocalDate( 2026, 8, 13 )

print d.Year & "-" & d.Month & "-" & d.Day     '' 2026-8-13
print d.ToIsoString( )                          '' 2026-08-13

'' A date that does not exist is Invalid, not an error
print LocalDate( 2025, 2, 30 ).IsValid          '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
