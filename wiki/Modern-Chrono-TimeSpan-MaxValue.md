[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.MaxValue**

# TimeSpan.MaxValue

## Syntax

```freebasic
TimeSpan.MaxValue
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as TimeSpan t = TimeSpan.MaxValue( )

print t.TotalDays > 1000000  '' -1 (true)
print t.Add( TimeSpan.FromDays( 1 ) ).IsValid           '' false

'' Overflow is Invalid rather than a wrap to a negative duration
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
