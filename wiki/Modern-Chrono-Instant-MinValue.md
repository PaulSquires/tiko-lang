[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.MinValue**

# Instant.MinValue

## Syntax

```freebasic
Instant.MinValue
```

## Examples

```freebasic
#import "std/chrono"
using FB

dim as DateTime d = DateTime.MinValue( )

print d.ToIsoString( )       '' 0001-01-01T00:00:00
print d.Subtract( TimeSpan.FromTicks( 1 ) ).IsValid      '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
