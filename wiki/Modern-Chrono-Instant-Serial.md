[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.Serial**

# Instant.Serial

Returns the date-time as a date serial: days since 1899-12-30, with a fraction.

## Syntax

```freebasic
Instant.Serial
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
'' The OLE/BASIC serial: days since 1899-12-30, fractional
print int( d.Serial )        '' 46247

print DateTime.FromSerial( d.Serial ).Day        '' 13 -- round trips
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
