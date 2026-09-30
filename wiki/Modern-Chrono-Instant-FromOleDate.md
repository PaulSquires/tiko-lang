[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.FromOleDate**

# Instant.FromOleDate

## Syntax

```freebasic
Instant.FromOleDate( float64 )
```

## Examples

```freebasic
#import "std/chrono"
using FB

'' The OLE automation date, the same serial Excel and ADO use
dim as DateTime d = DateTime.FromOleDate( 46247.0 )

print d.ToIsoString( )       '' 2026-08-13T00:00:00
print DateTime.FromOleDate( 0 ).ToIsoString( )      '' 1899-12-30T00:00:00
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
