[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.FromFileTime**

# DateTime.FromFileTime

Creates a UTC date-time from a Windows FILETIME.

## Syntax

```freebasic
DateTime.FromFileTime( int64 )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

'' A Windows FILETIME: 100 ns ticks since 1601-01-01 UTC
dim as DateTime d = DateTime.FromFileTime( 133689600000000000ll )

print d.Year                 '' 2024
print DateTime.FromFileTime( 0 ).ToIsoString( )     '' 1601-01-01T00:00:00Z

'' The same 100 ns tick this library uses, with a different epoch -- so
'' the conversion is an offset, not a rescale
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
