[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **Contains**

# Contains

## Syntax

```freebasic
Contains( a, v ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using containers

dim v as Array( of int32 )
v.Push( 10 ) : v.Push( 20 )

'' T is inferred from the array, so the value must already BE a T --
'' a bare `20` is an INTEGER literal and gives error 340
dim as int32 wanted = 20
print Contains( v, wanted )      '' true

dim as int32 absent = 99
print Contains( v, absent )      '' false

'' Exactly IndexOf( ) >= 0, for the common case where the position is
'' not wanted
```

---

**Library:** [Array Container](Category-Array)  
**Category:** [Array](Category-Array)  
**Documented under:** Members
