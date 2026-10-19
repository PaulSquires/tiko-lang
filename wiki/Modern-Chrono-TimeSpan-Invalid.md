[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.Invalid**

# TimeSpan.Invalid

Returns the Invalid duration, which spreads to anything computed from it.

## Syntax

```freebasic
TimeSpan.Invalid
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as TimeSpan bad = TimeSpan.Invalid( )

print bad.IsValid            '' false

'' ABSORBING: anything touching an Invalid becomes Invalid
print bad.Add( TimeSpan.FromDays( 1 ) ).IsValid         '' false
print bad.Duration( ).IsValid                            '' false

'' And it never compares equal to anything, itself included
print ( bad = TimeSpan.Invalid( ) )      '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
