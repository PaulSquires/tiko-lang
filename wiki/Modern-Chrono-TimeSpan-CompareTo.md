[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.CompareTo**

# TimeSpan.CompareTo

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

-1 0 1, or -2

## Syntax

```freebasic
TimeSpan.CompareTo( other )
```

## Notes

- -1 0 1, or -2

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as TimeSpan a = TimeSpan( 1, 0, 0 )
dim as TimeSpan b = TimeSpan( 2, 0, 0 )

print a.CompareTo( b )       '' -1
print b.CompareTo( a )       '' 1
print a.CompareTo( a )       '' 0

'' -2, NOT an ordering, when either side is Invalid -- so an invalid
'' span cannot silently sort to one end
print a.CompareTo( TimeSpan.Invalid( ) )      '' -2
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
