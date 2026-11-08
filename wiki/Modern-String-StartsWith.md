[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **StartsWith**

# StartsWith

Returns true if the string begins with the given text.

## Syntax

```freebasic
StartsWith( s, prefix [, ic] )
```

## Notes

- Overloads for [slices](Category-String-Slices) take `const` `slice`, `uslice` or `wslice` arguments and copy nothing: `StartsWith( v[0 to 9], "x" )`. A string argument still gets the string overload.
- O(m) — boolean

## Examples

```freebasic
#import "std/strings"
using strings

print StartsWith( "Hello", "He" )         '' true
print StartsWith( "Hello", "he" )         '' false -- case matters by default
print StartsWith( "Hello", "he", true )   '' true
print StartsWith( "Hello", "" )           '' true -- every string starts with ""
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
