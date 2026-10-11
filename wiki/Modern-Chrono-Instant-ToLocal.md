[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.ToLocal**

# Instant.ToLocal

## Syntax

```freebasic
Instant.ToLocal
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
'' Converts to the machine's current zone offset. The result depends on
'' where and when it runs, so it cannot be asserted by exact string.
dim as DateTime local_ = d.WithOffset( 0 ).ToLocal( )

print local_.HasOffset       '' true
print local_.ToInstant( ).Ticks = d.WithOffset( 0 ).ToInstant( ).Ticks    '' -1 (true)
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
