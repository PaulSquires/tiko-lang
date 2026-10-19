[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.IsValid**

# Instant.IsValid

Returns true if the date-time is a real, in-range value; the only safe test.

## Syntax

```freebasic
Instant.IsValid
```

## Examples

```freebasic
#import "std/chrono"
using chrono

print DateTime( 2026, 8, 13 ).IsValid     '' true
print DateTime( 2025, 2, 30 ).IsValid     '' false -- no such date
print DateTime( 2026, 8, 13, 25, 0, 0, 0 ).IsValid       '' false

'' Out-of-range construction yields Invalid rather than raising
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
