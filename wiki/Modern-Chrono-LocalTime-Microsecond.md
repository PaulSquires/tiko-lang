[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.Microsecond**

# LocalTime.Microsecond

## Syntax

```freebasic
LocalTime.Microsecond
```

## Examples

```freebasic
#import "std/chrono"
using FB

'' The constructor stops at MILLISECONDS -- there is no microsecond
'' parameter, so finer values are built from ticks
dim as LocalTime t = LocalTime.FromTicks( _
    LocalTime( 14, 30, 5, 123 ).Ticks + 456 * DT_TICKS_PER_MICROSECOND )

print t.Millisecond          '' 123
print t.Microsecond          '' 123456

'' NOTE WHAT THAT NUMBER IS. Millisecond counts within the SECOND and so
'' does Microsecond -- it is 123456, not the 456 left over after the
'' milliseconds. Both are `ticks \ unit mod (units per second)`.
'' For the leftover, take Microsecond mod 1000.
print t.Microsecond mod 1000 '' 456

'' The tick below it, 100 ns, is the finest unit the type carries.
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
