[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.IsValid**

# LocalTime.IsValid

## Syntax

```freebasic
LocalTime.IsValid
```

## Examples

```freebasic
#import "std/chrono"
using chrono

print LocalTime( 14, 30, 5, 0 ).IsValid      '' true
print LocalTime( 25, 0, 0, 0 ).IsValid       '' false -- no such hour
print LocalTime( 0, 60, 0, 0 ).IsValid       '' false -- no such minute

'' The ONLY correct test. An Invalid value is absorbing: anything that
'' touches it becomes Invalid, and it never compares equal to anything.
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
