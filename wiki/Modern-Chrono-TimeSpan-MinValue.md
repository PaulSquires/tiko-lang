[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.MinValue**

# TimeSpan.MinValue

Returns the most negative duration a TimeSpan can hold.

## Syntax

```freebasic
TimeSpan.MinValue
```

## Examples

```freebasic
#import "std/chrono"
using chrono

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
