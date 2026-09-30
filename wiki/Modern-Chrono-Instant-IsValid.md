[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.IsValid**

# Instant.IsValid

## Syntax

```freebasic
Instant.IsValid
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print DateTime( 2026, 8, 13 ).IsValid     '' true
print DateTime( 2025, 2, 30 ).IsValid     '' false -- no such date
print DateTime( 2026, 8, 13, 25, 0, 0, 0 ).IsValid       '' false

'' Out-of-range construction yields Invalid rather than raising
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
