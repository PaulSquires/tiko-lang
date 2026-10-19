[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.ToIsoString**

# Instant.ToIsoString

Returns the date-time as ISO 8601 text, with Z or the offset when it has one.

## Syntax

```freebasic
Instant.ToIsoString
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print d.ToIsoString( )       '' 2026-08-13T14:30:05.1230000

'' The offset is printed when there is one, and Z when it is zero
print d.WithOffset( 0 ).ToIsoString( )       '' 2026-08-13T14:30:05.1230000Z
print d.WithOffset( 90 ).ToIsoString( )      '' 2026-08-13T14:30:05.1230000+01:30
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
