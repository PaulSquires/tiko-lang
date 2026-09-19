[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Median**

# Median

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The middle value, or the mean of the two middle values.

## Syntax

```freebasic
Median( a( ) as T ) as double
```

## Notes

- **Resistant to outliers** in a way the mean is not: one absurd value moves the mean and leaves the median where it was.
- An even count averages the two middle values, so the result need not be an element of the array.
- It sorts a copy; the input array is left alone.

## Examples

```freebasic
#include once "fb/stats.bi"
using FB

dim as double a( 0 to 4 ) = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print Median( a( ) )         '' 4

'' One absurd value moves the mean and leaves the median alone
dim as double b( 0 to 4 ) = { 2.0, 4.0, 4.0, 4.0, 1e9 }
print Median( b( ) )         '' 4
print Mean( b( ) ) > 1e8     '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
