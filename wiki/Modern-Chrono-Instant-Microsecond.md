[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.Microsecond**

# Instant.Microsecond

Returns the microseconds within the second, the milliseconds included.

## Syntax

```freebasic
Instant.Microsecond
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print d.Microsecond          '' 123000

'' Within the SECOND, so it INCLUDES the milliseconds -- it is not the
'' 0-999 remainder after them. Take `Microsecond mod 1000` for that.
print d.Microsecond mod 1000     '' 0
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
