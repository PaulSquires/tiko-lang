[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CryptoBytes**

# CryptoBytes

## Syntax

```freebasic
CryptoBytes( ptr, n )
```

## Examples

```freebasic
#include once "fb/random.bi"
using FB

'' From the OS CSPRNG -- BCryptGenRandom or getrandom -- not from the
'' Rng, which is fast and reproducible but NOT secure
dim as ubyte buf( 0 to 15 )
print CryptoBytes( @buf( 0 ), 16 )        '' true

dim as long nonzero = 0
for i as long = 0 to 15
    if buf( i ) <> 0 then nonzero += 1
next
print nonzero > 0            '' -1 (true)

'' For keys, tokens and salts. Never Rng, and never RND.
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
