[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.Invalid**

# Instant.Invalid

## Syntax

```freebasic
Instant.Invalid
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime bad = DateTime.Invalid( )
print bad.IsValid            '' false

'' ABSORBING, and never equal to anything -- IsValid is the only test
print bad.AddDays( 1 ).IsValid           '' false
print ( bad = DateTime.Invalid( ) )      '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
