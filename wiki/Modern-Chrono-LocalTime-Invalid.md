[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.Invalid**

# LocalTime.Invalid

Returns the Invalid time of day, which never equals anything, itself included.

## Syntax

```freebasic
LocalTime.Invalid
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as LocalTime bad = LocalTime.Invalid( )

print bad.IsValid            '' false

'' BEWARE: comparing an Invalid value with ANYTHING is false, including
'' with itself -- deliberately, for the same reason IEEE NaN works that
'' way. IsValid is the only correct test.
dim as LocalTime other = LocalTime.Invalid( )
print ( bad = other )        '' false -- two Invalids are not equal
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
