[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.UnixMilliseconds**

# Instant.UnixMilliseconds

## Syntax

```freebasic
Instant.UnixMilliseconds
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as Instant i = Instant.FromUnixMilliseconds( 1767225600123ll )

print i.UnixMilliseconds     '' 1767225600123
print i.UnixSeconds          '' 1767225600 -- the same moment, coarser
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
