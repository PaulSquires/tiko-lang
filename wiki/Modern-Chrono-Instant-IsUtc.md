[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.IsUtc**

# Instant.IsUtc

## Syntax

```freebasic
Instant.IsUtc
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print d.IsUtc                '' false -- no offset at all

print d.WithOffset( 0 ).IsUtc            '' true -- offset zero
print d.WithOffset( 60 ).IsUtc           '' false

'' "Offset zero", not "is a UTC value": a DateTime with no offset is not
'' UTC, it is unzoned
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
