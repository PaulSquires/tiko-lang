[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.ToIsoUString**

# TimeSpan.ToIsoUString

## Syntax

```freebasic
TimeSpan.ToIsoUString
```

## Examples

```freebasic
#import "std/chrono"
using chrono

'' The same text as ToIsoString, as a USTRING -- for a call site that
'' is already working in ustring and would otherwise convert
dim as ustring s = TimeSpan( 2, 0, 0 ).ToIsoUString( )

print s                      '' PT2H
print len( s )               '' 4

'' TryParseIso and ParseIso are both overloaded on ustring too, so the
'' round trip stays in one string type
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
