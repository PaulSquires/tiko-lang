[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Classify**

# Classify

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Classify( x )
```

## Examples

```freebasic
#include once "fb/math.bi"
using FB

'' One call instead of a chain of predicates, answering with an FpClass
print Classify( 1.0 ) = FP_NORMAL             '' -1 (true)
print Classify( 0.0 ) = FP_ZERO               '' -1 (true)
print Classify( NaN( ) ) = FP_NAN             '' -1 (true)
print Classify( Infinity( ) ) = FP_INFINITE   '' -1 (true)
print Classify( MinSubnormalDouble( ) ) = FP_SUBNORMAL    '' -1 (true)

'' The five categories are exhaustive and mutually exclusive, which a
'' sequence of Is* tests is not obviously
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
