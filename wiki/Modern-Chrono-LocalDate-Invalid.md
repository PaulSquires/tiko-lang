[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.Invalid**

# LocalDate.Invalid

## Syntax

```freebasic
LocalDate.Invalid
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as LocalDate bad = LocalDate.Invalid( )
print bad.IsValid            '' false

'' ABSORBING: anything touching an Invalid value becomes Invalid
print bad.AddDays( 1 ).IsValid          '' false
print bad.StartOfMonth( ).IsValid       '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
