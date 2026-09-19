[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.Zero**

# TimeSpan.Zero

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TimeSpan.Zero
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as TimeSpan z = TimeSpan.Zero( )

print z.Ticks                '' 0
print z.IsZero               '' true
print z.IsNegative           '' false -- zero is not negative

'' The identity for Add, and what a default-constructed TimeSpan is
dim as TimeSpan d
print d.IsZero               '' true
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
