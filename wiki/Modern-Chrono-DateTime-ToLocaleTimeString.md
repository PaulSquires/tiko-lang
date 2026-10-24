[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.ToLocaleTimeString**

# DateTime.ToLocaleTimeString

Returns the time of day as the machine's locale writes it, for display only.

## Syntax

```freebasic
ToLocaleTimeString( byval style as int32 = lsShort ) as ustring
```

## Notes

- Locale dependent, like every `ToLocale*` member: for display only, never for storage.
- The time half of `ToLocaleString`; `ToLocaleDateString` is the date half.
- A ustring, so a non-ASCII locale's text prints and displays intact.

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 0 )

print len( d.ToLocaleTimeString( ) ) > 0      '' -1 (true)
print len( d.ToLocaleTimeString( lsLong ) ) > 0        '' -1 (true)
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** Members
