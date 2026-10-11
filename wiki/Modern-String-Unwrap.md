[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Unwrap**

# Unwrap

O(n)

## Syntax

```freebasic
Unwrap( s [, open] [, close] [, ic] )
```

## Notes

- O(n)

## Examples

```freebasic
#import "std/strings"
using strings

print Unwrap( "<Paul>", "<", ">" )    '' Paul
print Unwrap( "<Paul", "<", ">" )     '' <Paul -- unbalanced, left untouched
print Unwrap( "''x''", "'" )          '' 'x' -- ONE pair removed, not all
print Unwrap( """quoted""" )          '' quoted -- the default pair
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
