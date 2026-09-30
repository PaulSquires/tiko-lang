[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.ToLocaleUString**

# Instant.ToLocaleUString

## Syntax

```freebasic
Instant.ToLocaleUString
```

## Examples

```freebasic
#import "std/chrono"
using FB

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
'' Date AND time, in the machine's locale
dim as ustring s = d.ToLocaleUString( )
print len( s ) > 0           '' -1 (true)

'' lsShort and lsLong are the two styles; which is which is the OS's
'' decision, not this library's
print len( d.ToLocaleUString( lsLong ) ) > 0         '' -1 (true)
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
