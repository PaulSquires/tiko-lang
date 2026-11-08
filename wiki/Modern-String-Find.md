[Home](Home) › [String Library](Category-String-Library) › [String Slices](Category-String-Slices) › **Find**

# Find

Returns the position of the first match in a slice, counting from 0, or -1.

## Syntax

```freebasic
Find( v, pat [, start] )
```

## Notes

- Positions count code units from 0, as `v[i]` does — not from 1 as `InStr` does.
- Searching starts at `start` (default 0); a `start` below 0 is taken as 0, and one past `len( v )` answers -1.
- An empty `pat` is found at `start`.
- `v` and `pat` are `const` slices of one width: `slice`, `uslice` or `wslice`. Any string can be passed for either; a string of the slice's width is viewed, not copied.
- O(n·m) — integer

## Examples

```freebasic
#import "std/strings"
using strings

dim as ustring s = "key = value"
dim as const uslice v = s[0 to len( s ) - 1]
print Find( v, "=" )          '' 4
print Find( v, "e", 2 )       '' 10 -- the first "e" at or after 2
print Find( v, "zz" )         '' -1
print Find( v, "" )           '' 0
print Find( "abc", "c" )      '' 2
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Slices](Category-String-Slices)  
**Documented under:** The Functions
