[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Complex**

# Complex

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

A complex number: two doubles, a real part and an imaginary one.

## Syntax

```freebasic
type Complex
    as double re, im
end type
```

## Notes

- **Sixteen bytes, `double` only.** There is no single-precision `Complexf`. Both libraries this header draws on are double-only, and a single-precision complex buys nothing at 16 bytes versus 8 unless the consumer is an FFT holding millions of them.
- The fields are named `re` and `im` and may be read directly, but `CReal` and `CImag` are the documented spelling — they survive a field rename and they say at the call site that the operand is complex.
- Positional initialisation works — `type<Complex>( 3, 4 )` — and agrees exactly with `CSet( 3, 4 )`.
- **No ordering operators.** `<` on complex numbers has no meaning, so none is defined. `=` and `<>` are.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

dim as Complex z = CSet( 3, 4 )

print CToString( z )                      '' 3+4i
print sizeof( Complex )                   '' 16   -- two doubles, no padding
print CToString( type<Complex>( 3, 4 ) )  '' 3+4i   -- the positional form agrees
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
