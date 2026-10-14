[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **Pop**

# Pop

## Syntax

```freebasic
Pop( ) as T
```

## Examples

```freebasic
#import "std/numeric"
#import "std/containers"
using containers, numeric

dim v as Array( of int32 )
v.Push( 10 ) : v.Push( 20 ) : v.Push( 30 )

print v.Pop( )           '' 30 -- removes and returns the last element
print v.Count            '' 2

'' Popping an empty array is not an error: it yields a default-constructed T
dim e as Array( of int32 )
print e.Pop( )           '' 0
```

---

**Library:** [Array Container](Category-Array)  
**Category:** [Array](Category-Array)  
**Documented under:** Members
