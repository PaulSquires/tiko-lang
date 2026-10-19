[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.ToString**

# Instant.ToString

Returns ISO 8601 text, or the date-time laid out by a pattern such as "yyyy-MM-dd".

## Syntax

```freebasic
Instant.ToString
Instant.ToString( pattern )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print d.ToString( )          '' 2026-08-13T14:30:05.1230000

'' The no-argument form is ToIsoString. The one-argument form takes a
'' PATTERN and returns a ustring.
print d.ToString( "yyyy-MM-dd" )         '' 2026-08-13
print d.ToString( "HH:mm:ss" )           '' 14:30:05
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
