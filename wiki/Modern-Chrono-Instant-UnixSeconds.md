[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.UnixSeconds**

# Instant.UnixSeconds

## Syntax

```freebasic
Instant.UnixSeconds
```

## Examples

```freebasic
#import "std/chrono"
using FB

dim as Instant i = Instant.FromUnixSeconds( 1767225600 )

print i.UnixSeconds          '' 1767225600

'' TRUNCATES toward the epoch rather than rounding, so a sub-second
'' remainder is dropped
print Instant.FromUnixMilliseconds( 1500 ).UnixSeconds       '' 1
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
