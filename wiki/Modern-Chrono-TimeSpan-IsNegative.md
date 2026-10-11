[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.IsNegative**

# TimeSpan.IsNegative

## Syntax

```freebasic
TimeSpan.IsNegative
```

## Examples

```freebasic
#import "std/chrono"
using chrono

print TimeSpan.FromHours( -2 ).IsNegative      '' true
print TimeSpan.FromHours( 2 ).IsNegative       '' false
print TimeSpan.Zero( ).IsNegative              '' false -- zero is not negative

'' A negative span is normal: it is what `earlier - later` gives, and
'' the reason the type is signed at all
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
