[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CryptoULongInt**

# CryptoULongInt

## Syntax

```freebasic
CryptoULongInt( )
```

## Examples

```freebasic
#include once "fb/random.bi"
using FB

'' Eight cryptographically secure bytes as one number
dim as ulongint a = CryptoULongInt( )
dim as ulongint b = CryptoULongInt( )

print a <> b                 '' -1 (true), with overwhelming probability

'' This is what RngFromEntropy uses for its seed
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
