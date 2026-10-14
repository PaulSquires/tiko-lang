[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.IsValid**

# LocalDate.IsValid

## Syntax

```freebasic
LocalDate.IsValid
```

## Examples

```freebasic
#import "std/chrono"
using chrono

print LocalDate( 2026, 8, 13 ).IsValid      '' true
print LocalDate( 2025, 2, 30 ).IsValid      '' false -- no such date
print LocalDate( 2024, 2, 29 ).IsValid      '' true -- 2024 is a leap year

'' The only correct test: an Invalid value never compares equal to
'' anything, itself included
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
