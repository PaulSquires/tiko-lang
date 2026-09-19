[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Covariance**

# Covariance

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

How two arrays vary together.

## Syntax

```freebasic
Covariance( x( ) as T, y( ) as T ) as double
```

## Notes

- Positive when they rise together, negative when one rises as the other falls, near zero when they are unrelated.
- **Its magnitude means nothing on its own** -- it is in the product of the two units, so it changes if you measure in metres rather than feet. `Correlation` is the normalised version.
- The sample form, dividing by n-1.
- The arrays must be the same length.

## Examples

```freebasic
#include once "fb/stats.bi"
using FB

dim as double x( 0 to 4 ) = { 1.0, 2.0, 3.0, 4.0, 5.0 }
dim as double y( 0 to 4 ) = { 2.0, 4.0, 6.0, 8.0, 10.0 }

print Covariance( x( ), y( ) ) > 0            '' -1 (true) -- they rise together

'' The magnitude is in the product of the units, so scaling y scales it
dim as double z( 0 to 4 ) = { 20.0, 40.0, 60.0, 80.0, 100.0 }
print Covariance( x( ), z( ) ) > Covariance( x( ), y( ) )      '' -1 (true)

'' Correlation is the version that does not move
print Correlation( x( ), y( ) ) = Correlation( x( ), z( ) )    '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
