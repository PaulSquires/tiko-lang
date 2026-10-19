[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.ToLocaleDateUString**

# DateTime.ToLocaleDateUString

Returns the date in the machine's locale format as a ustring, for display only.

## Syntax

```freebasic
DateTime.ToLocaleDateUString
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
'' The ustring form of ToLocaleDateString -- and equally locale
'' dependent, so it is for display only
dim as ustring s = d.ToLocaleDateUString( )
print len( s ) > 0           '' -1 (true)
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
