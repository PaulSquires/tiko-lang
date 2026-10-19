[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.IsValid**

# TimeSpan.IsValid

Returns true unless the duration overflowed or came from bad input.

## Syntax

```freebasic
TimeSpan.IsValid
```

## Examples

```freebasic
#import "std/chrono"
using chrono

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
