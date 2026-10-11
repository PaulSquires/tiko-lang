[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.MinValue**

# LocalDate.MinValue

## Syntax

```freebasic
LocalDate.MinValue
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as LocalDate d = LocalDate.MinValue( )

print d.ToIsoString( )       '' 0001-01-01
print d.DayNumber            '' 0

'' Subtracting a day from it overflows, and overflow yields Invalid
'' rather than wrapping
print d.AddDays( -1 ).IsValid           '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
