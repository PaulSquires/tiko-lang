[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.ToLocaleTimeUString**

# DateTime.ToLocaleTimeUString

Returns the time in the machine's locale format as a ustring, for display only.

## Syntax

```freebasic
DateTime.ToLocaleTimeUString
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
dim as ustring s = d.ToLocaleTimeUString( )

print len( s ) > 0           '' -1 (true)
print len( d.ToLocaleTimeUString( lsLong ) ) > 0     '' -1 (true)
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
