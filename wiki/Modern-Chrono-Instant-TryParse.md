[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.TryParse**

# Instant.TryParse

## Syntax

```freebasic
Instant.TryParse
```

## Examples

```freebasic
#import "std/chrono"
using FB

dim as DateTime d

'' The lenient parse: ISO, and the common near-ISO shapes
print DateTime.TryParse( "2026-08-13T14:30:05", d )  '' true
print DateTime.TryParse( "2026-08-13 14:30:05", d )  '' true -- a space
print DateTime.TryParse( "2026-08-13", d )           '' true -- date only

print DateTime.TryParse( "not a date", d )           '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
