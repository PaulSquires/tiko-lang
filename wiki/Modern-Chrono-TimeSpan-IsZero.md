[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.IsZero**

# TimeSpan.IsZero

## Syntax

```freebasic
TimeSpan.IsZero
```

## Examples

```freebasic
#import "std/chrono"
using chrono

print TimeSpan.Zero( ).IsZero             '' true
print TimeSpan.FromTicks( 1 ).IsZero      '' false

'' Reads better than `= TimeSpan.Zero( )` and, unlike that comparison,
'' answers FALSE rather than misleading you when the span is Invalid
print TimeSpan.Invalid( ).IsZero          '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
