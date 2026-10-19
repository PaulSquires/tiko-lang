[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.FileTime**

# DateTime.FileTime

Returns the date-time as a Windows FILETIME: 100 ns ticks since 1601-01-01.

## Syntax

```freebasic
DateTime.FileTime
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
'' Windows FILETIME: 100 ns ticks since 1601-01-01 UTC
print d.WithOffset( 0 ).FileTime > 0             '' -1 (true)

print DateTime.FromFileTime( d.WithOffset( 0 ).FileTime ).Day        '' 13
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
