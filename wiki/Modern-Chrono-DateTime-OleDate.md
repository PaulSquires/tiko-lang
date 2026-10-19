[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.OleDate**

# DateTime.OleDate

Returns the date-time as an OLE automation date, the number Excel and ADO use.

## Syntax

```freebasic
DateTime.OleDate
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print int( d.OleDate )       '' 46247

'' The same number as Serial, under the name the OLE automation and ADO
'' world uses
print DateTime.FromOleDate( d.OleDate ).Day      '' 13
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
