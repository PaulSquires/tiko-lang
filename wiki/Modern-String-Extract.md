[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Extract**

# Extract

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n*m)   text before match

## Syntax

```freebasic
Extract( start, s, match [, ic] )
Extract( 1, s, missing )
```

## Notes

- O(n*m) — text before match
- the whole remainder

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print Extract( 1, "abacadabra", "cad" )    '' aba -- text before the match
print Extract( 1, "abacadabra", "zzz" )    '' abacadabra -- a miss gives the whole remainder
print Extract( 3, "abacadabra", "a" )      '' (empty) -- position 3 is already an "a"

'' The miss rule is what lets a parse loop keep its last field
dim as string field_ = Extract( 1, "lastfield", "," )
print field_                               '' lastfield
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
