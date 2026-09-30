[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.MaxValue**

# LocalDate.MaxValue

## Syntax

```freebasic
LocalDate.MaxValue
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as LocalDate d = LocalDate.MaxValue( )

print d.ToIsoString( )       '' 9999-12-31
print d.AddDays( 1 ).IsValid            '' false -- arithmetic NEVER wraps
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
