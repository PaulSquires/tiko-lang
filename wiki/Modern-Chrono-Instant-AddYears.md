[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.AddYears**

# Instant.AddYears

Returns the date-time moved by whole years; 29 February becomes the 28th if needed.

## Syntax

```freebasic
Instant.AddYears( n )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print d.AddYears( 4 ).Year           '' 2030

'' 29 February clamps to the 28th in a non-leap year
dim as DateTime leap = DateTime( 2024, 2, 29, 0, 0, 0, 0 )
print leap.AddYears( 1 ).ToIsoString( )          '' 2025-02-28T00:00:00
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
