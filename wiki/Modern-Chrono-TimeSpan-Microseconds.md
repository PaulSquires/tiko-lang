[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.Microseconds**

# TimeSpan.Microseconds

## Syntax

```freebasic
TimeSpan.Microseconds
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as TimeSpan t = TimeSpan.FromMicroseconds( 1234567 )

print t.Microseconds         '' 234567 -- within the SECOND, so it
                             '' includes the milliseconds
print t.Milliseconds         '' 234
print t.TotalMicroseconds    '' 1234567
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
