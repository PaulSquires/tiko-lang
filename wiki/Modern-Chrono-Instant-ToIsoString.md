[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.ToIsoString**

# Instant.ToIsoString

## Syntax

```freebasic
Instant.ToIsoString
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

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
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
