[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Choice**

# Choice

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Choice( r, a( ) )
```

## Examples

```freebasic
#include once "fb/random.bi"
using FB

dim r as Rng = RngFromEntropy( )
dim as string names_( 0 to 2 ) = { "ada", "grace", "alan" }

'' One element, uniformly. It returns BYREF, so it can be assigned
'' through as well as read.
dim as string picked = Choice( r, names_( ) )
print picked = "ada" orelse picked = "grace" orelse picked = "alan"    '' -1
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
