[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.LocalTime**

# LocalTime.LocalTime

midnight

## Syntax

```freebasic
LocalTime( )
LocalTime( h, mi, s, ms )
```

## Notes

- midnight

## Examples

```freebasic
#import "std/chrono"
using chrono

'' A time of day with no date and no zone. One LONGINT of 100 ns ticks.
dim as LocalTime t = LocalTime( 14, 30, 5, 0 )

print t.Hour & ":" & t.Minute & ":" & t.Second      '' 14:30:5
print t.ToIsoString( )                              '' 14:30:05

'' Out-of-range construction yields Invalid rather than raising
dim as LocalTime bad = LocalTime( 25, 0, 0, 0 )
print bad.IsValid            '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
