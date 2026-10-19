[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.ToLocaleDateString**

# Instant.ToLocaleDateString

Returns the date as the machine's locale writes it, for display only.

## Syntax

```freebasic
Instant.ToLocaleDateString
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
'' WHATEVER THE MACHINE'S LOCALE SAYS, so the exact text cannot be
'' asserted and must not be written to a file. ToIsoString is the one
'' that round-trips.
print len( d.ToLocaleDateString( ) ) > 0         '' -1 (true)
print len( d.ToLocaleDateString( lsLong ) ) > 0  '' -1 (true)
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
