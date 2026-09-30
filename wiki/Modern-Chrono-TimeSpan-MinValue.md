[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.MinValue**

# TimeSpan.MinValue

## Syntax

```freebasic
TimeSpan.MinValue
```

## Examples

```freebasic
#import "std/chrono"
using FB

dim as TimeSpan t = TimeSpan.MinValue( )

print t.IsNegative           '' true
print t.TotalDays < -1000000 '' -1 (true)

'' Arithmetic NEVER wraps: going below this yields Invalid
print t.Subtract( TimeSpan.FromDays( 1 ) ).IsValid      '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
