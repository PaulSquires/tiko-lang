[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.Zero**

# TimeSpan.Zero

Returns a duration of zero, the same as a new TimeSpan.

## Syntax

```freebasic
TimeSpan.Zero
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as TimeSpan z = TimeSpan.Zero( )

print z.Ticks                '' 0
print z.IsZero               '' true
print z.IsNegative           '' false -- zero is not negative

'' The identity for Add, and what a default-constructed TimeSpan is
dim as TimeSpan d
print d.IsZero               '' true
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
