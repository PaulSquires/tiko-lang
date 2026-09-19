[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.UnixSeconds**

# Instant.UnixSeconds

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Instant.UnixSeconds
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as Instant i = Instant.FromUnixSeconds( 1767225600 )

print i.UnixSeconds          '' 1767225600

'' TRUNCATES toward the epoch rather than rounding, so a sub-second
'' remainder is dropped
print Instant.FromUnixMilliseconds( 1500 ).UnixSeconds       '' 1
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
