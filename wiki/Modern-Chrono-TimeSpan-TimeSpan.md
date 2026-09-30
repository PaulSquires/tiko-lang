[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.TimeSpan**

# TimeSpan.TimeSpan

zero

## Syntax

```freebasic
TimeSpan( )
TimeSpan( ticks )
TimeSpan( h, mi, s )
TimeSpan( d, h, mi, s, ms )
```

## Notes

- zero

## Examples

```freebasic
#import "std/chrono"
using FB

'' A FIXED duration -- an exact count of 100 ns ticks. Signed, so
'' `earlier - later` is meaningful rather than an error.
dim as TimeSpan a = TimeSpan( 1, 2, 3, 4, 5 )     '' d, h, mi, s, ms
dim as TimeSpan b = TimeSpan( 2, 3, 4 )           '' h, mi, s
dim as TimeSpan c = TimeSpan( 36000000000ll )     '' raw ticks

print a.ToIsoString( )       '' P1DT2H3M4.005S
print b.ToIsoString( )       '' PT2H3M4S
print c.TotalHours           '' 1

'' NOT a calendar period. "One month" is not a TimeSpan, because a month
'' has no fixed length -- that is AddMonths. There is no FromMonths.
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
