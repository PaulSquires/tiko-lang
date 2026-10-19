[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.FromSerial**

# Instant.FromSerial

Creates a date-time from a date serial, the days since 1899-12-30.

## Syntax

```freebasic
Instant.FromSerial( float64 )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

'' The OLE/BASIC serial date: days since 1899-12-30, fractional
dim as DateTime d = DateTime.FromSerial( 46247.6042 )

print d.Year & "-" & d.Month           '' 2026-8
print DateTime.FromSerial( 0 ).ToIsoString( )      '' 1899-12-30T00:00:00

'' The pair to the Serial property, for talking to Excel, ADO and
'' anything else built on the same convention
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
