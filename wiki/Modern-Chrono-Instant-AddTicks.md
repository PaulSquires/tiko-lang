[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.AddTicks**

# DateTime.AddTicks

Returns the date-time moved by a number of 100 ns ticks.

## Syntax

```freebasic
DateTime.AddTicks( n )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print d.AddTicks( DT_TICKS_PER_HOUR ).Hour        '' 15

'' The exact form: 100 ns each, no rounding anywhere
print d.AddTicks( 1 ).Ticks - d.Ticks            '' 1
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
