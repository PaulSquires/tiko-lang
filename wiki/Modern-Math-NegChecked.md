[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NegChecked**

# NegChecked

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The negation, or **nothing** for the one input that has none.

## Syntax

```freebasic
NegChecked( byval a as T ) as Optional( of T )
```

## Notes

- One failing case, and it is the same one `AbsChecked` has: the **most negative value of a two's-complement type has no positive counterpart**. On a BYTE there is no +128.
- Every other input negates cleanly.
- `NegSaturating` clamps that case and `NegWrapping` returns it unchanged, which is what the bare `-` already does.

## Examples

```freebasic
#include once "fb/mathint.bi"
using FB

dim as byte worst = -128

var r = NegChecked( worst )
print r.HasValue( )          '' false -- there is no +128 in a BYTE

'' The bare operator does something DIFFERENT again: it promotes the
'' BYTE to an integer first, so the answer is a correct 128 that no
'' longer fits back in the type it came from
print -worst                 '' 128

dim as byte ordinary = 100
print NegChecked( ordinary ).Value( )         '' -100
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
