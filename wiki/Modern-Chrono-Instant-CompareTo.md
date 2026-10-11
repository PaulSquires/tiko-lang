[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.CompareTo**

# Instant.CompareTo

## Syntax

```freebasic
Instant.CompareTo
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as Instant a = Instant.FromUnixSeconds( 0 )
dim as Instant b = Instant.FromUnixSeconds( 86400 )

print a.CompareTo( b )       '' -1
print b.CompareTo( a )       '' 1
print a.CompareTo( a )       '' 0

'' -2 when either side is Invalid, so it cannot silently sort to one end
print a.CompareTo( Instant.Invalid( ) )      '' -2
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
