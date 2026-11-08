[Home](Home) › [String Library](Category-String-Library) › [String Slices](Category-String-Slices) › **Equals**

# Equals

Returns true if two slices hold the same code units, optionally ignoring case.

## Syntax

```freebasic
Equals( a, b [, ignoreCase] )
```

## Notes

- `ignoreCase` folds the ASCII letters A to Z only; every other unit must match exactly.
- Slices of different lengths are never equal.
- `a` and `b` are `const` slices of one width; any string can be passed for either.
- O(n) — boolean

## Examples

```freebasic
#import "std/strings"
using strings

dim as ustring s = "Content-Type: text"
dim as const uslice name_ = s[0 to 11]
print Equals( name_, "Content-Type" )          '' true
print Equals( name_, "content-type" )          '' false
print Equals( name_, "content-type", true )    '' true
print Equals( name_, "Content" )               '' false
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Slices](Category-String-Slices)  
**Documented under:** The Functions
