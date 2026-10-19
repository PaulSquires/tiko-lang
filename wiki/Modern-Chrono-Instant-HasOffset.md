[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.HasOffset**

# Instant.HasOffset

Returns true if the date-time carries a UTC offset.

## Syntax

```freebasic
Instant.HasOffset
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
'' Constructed from civil fields, so there is no offset: this is a wall
'' clock reading that does not yet name a moment
print d.HasOffset            '' false

print d.WithOffset( 0 ).HasOffset        '' true
print d.WithOffset( 0 ).IsUtc            '' true
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
