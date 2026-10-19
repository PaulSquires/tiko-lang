[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.MaxValue**

# LocalDate.MaxValue

Returns the latest date, 9999-12-31.

## Syntax

```freebasic
LocalDate.MaxValue
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as LocalDate d = LocalDate.MaxValue( )

print d.ToIsoString( )       '' 9999-12-31
print d.AddDays( 1 ).IsValid            '' false -- arithmetic NEVER wraps
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
