[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.CompareTo**

# LocalTime.CompareTo

## Syntax

```freebasic
LocalTime.CompareTo
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as LocalTime a = LocalTime( 9, 0, 0, 0 )
dim as LocalTime b = LocalTime( 17, 0, 0, 0 )

print a.CompareTo( b )       '' -1
print b.CompareTo( a )       '' 1
print a.CompareTo( a )       '' 0

'' -2, NOT an ordering, when either side is Invalid -- an invalid value
'' has no place in a sort
print a.CompareTo( LocalTime.Invalid( ) )      '' -2
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
