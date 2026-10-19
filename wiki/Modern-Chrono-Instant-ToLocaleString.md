[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **ToLocaleString**

# ToLocaleString

Returns the date and time as the machine's locale writes them, for display only.

## Syntax

```freebasic
ToLocaleString( byval style as int32 = lsShort ) as string
```

## Notes

- **Whatever the machine's locale says**, so the exact text cannot be asserted and must never be written to a file. `ToIsoString` is the one that round-trips.
- `lsShort` and `lsLong` are the two styles; which is which is the OS's decision, not this library's.
- `ToLocaleDateString` and `ToLocaleTimeString` are the halves.

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 0 )

'' Locale dependent, so assert shape rather than content
print len( d.ToLocaleString( ) ) > 0          '' -1 (true)
print len( d.ToLocaleString( lsLong ) ) > 0   '' -1 (true)

'' The one that does NOT vary
print d.ToIsoString( )       '' 2026-08-13T14:30:05
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** Members
