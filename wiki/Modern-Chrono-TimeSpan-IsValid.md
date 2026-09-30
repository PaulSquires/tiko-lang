[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.IsValid**

# TimeSpan.IsValid

## Syntax

```freebasic
TimeSpan.IsValid
```

## Examples

```freebasic
#import "std/chrono"
using FB

print TimeSpan.FromDays( 1 ).IsValid      '' true
print TimeSpan.Invalid( ).IsValid         '' false

'' Overflow and NaN both land here rather than raising
print TimeSpan.FromDays( 1e300 ).IsValid  '' false

'' The ONLY correct test -- comparison with an Invalid is always false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
