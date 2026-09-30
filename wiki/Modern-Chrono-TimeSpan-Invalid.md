[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.Invalid**

# TimeSpan.Invalid

## Syntax

```freebasic
TimeSpan.Invalid
```

## Examples

```freebasic
#import "std/chrono"
using FB

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
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
