[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.ToOffset**

# Instant.ToOffset

convert

## Syntax

```freebasic
Instant.ToOffset( offMin )
```

## Notes

- convert

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
dim as DateTime utc = d.WithOffset( 0 )

'' CONVERTS to another offset, keeping the MOMENT and changing the
'' fields -- the opposite of WithOffset
dim as DateTime plus1 = utc.ToOffset( 60 )

print plus1.Hour             '' 15 -- one hour later on the clock
print plus1.ToInstant( ).Ticks = utc.ToInstant( ).Ticks      '' -1 (true)
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
