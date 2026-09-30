[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **IndexOf**

# IndexOf

The index of the first element equal to `v`, or -1 when it is absent.

## Syntax

```freebasic
IndexOf( a, v ) as long
```

## Notes

- Requires `=` on `T`. It is a free procedure rather than a member so that requirement lands on the call site: every member body of a generic is instantiated whether or not it is called, so as a member it would make `Array( of T )` unusable for any `T` without `=`.
- Returns **-1** when the value is absent, which is why the result is signed. Use [Contains](Modern-Array-Contains) when the position is not wanted.
- `T` is inferred from the array, so the value must already be a `T` -- `IndexOf( nums, 3 )` against an `Array( of long )` is error 340, because a bare `3` is an `integer`.
- O(n), comparing from index 0 upward.

## Examples

```freebasic
#include once "fb/array.bi"
using FB

'' A free procedure, not a member: it needs '=' on T, and as a member that
'' requirement would fall on every instantiation of Array whether or not it
'' was ever called
dim v as Array( of string )
v.Push( "ada" ) : v.Push( "grace" )

print IndexOf( v, "grace" )      '' 1
print IndexOf( v, "alan" )       '' -1 -- absent, which is why it is signed

dim as string wanted = "ada"
if IndexOf( v, wanted ) >= 0 then print "present"
```

---

**Library:** [Array Container](Category-Array)  
**Category:** [Array](Category-Array)  
**Documented under:** Members  
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
