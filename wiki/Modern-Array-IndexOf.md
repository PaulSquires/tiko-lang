[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **IndexOf**

# IndexOf

Returns the index of the first element equal to a value, or -1 if there is none.

## Syntax

```freebasic
IndexOf( a, v ) as int32
```

## Notes

- Requires `=` on `T`. It is a free procedure rather than a member so that requirement lands on the call site: every member body of a generic is instantiated whether or not it is called, so as a member it would make `Array( of T )` unusable for any `T` without `=`.
- Returns **-1** when the value is absent, which is why the result is signed. Use [Contains](Modern-Array-Contains) when the position is not wanted.
- `T` is inferred from the array, so the value must already be a `T` -- `IndexOf( nums, 3 )` against an `Array( of int32 )` is error 340, because a bare `3` is an `integer`.
- O(n), comparing from index 0 upward.

## Examples

```freebasic
#import "std/containers"
using containers

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
