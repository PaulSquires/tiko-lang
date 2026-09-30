[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **Capacity**

# Capacity

## Syntax

```freebasic
Capacity( ) as long
```

## Examples

```freebasic
#include once "fb/array.bi"
using FB

dim v as Array( of long )
print v.Capacity         '' 0 -- nothing allocated yet

v.Push( 1 )
print v.Capacity         '' 8 -- the minimum allocation

for i as long = 2 to 9
    v.Push( i )
next
print v.Count & " of " & v.Capacity     '' 9 of 16 -- doubled, not grown by one
```

---

**Library:** [Array Container](Category-Array)  
**Category:** [Array](Category-Array)  
**Documented under:** Members  
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
