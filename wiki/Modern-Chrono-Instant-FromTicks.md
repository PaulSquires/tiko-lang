[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.FromTicks**

# Instant.FromTicks

## Syntax

```freebasic
Instant.FromTicks
Instant.FromTicks( t, offMin )
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

'' Ticks of 100 ns since 0001-01-01T00:00:00 UTC
dim as Instant i = Instant.FromTicks( 638914932000000000ll )

print i.Ticks                '' 638914932000000000
print i.IsValid              '' true

'' Out of range yields Invalid rather than wrapping
print Instant.FromTicks( -1 ).IsValid       '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
