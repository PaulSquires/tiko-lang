[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **ReplaceChars**

# ReplaceChars

[, all] [, start] [, ic] )    O(n*m)

## Syntax

```freebasic
ReplaceChars( s, chars, with_ [, ic] )
```

## Notes

- O(n*k) — length is invariant

## Examples

```freebasic
#import "std/strings"
using strings

print ReplaceChars( "abacadabra", "bac", "*" )    '' *****d**r*
print ReplaceChars( "a/b\c", "/\", "." )         '' a.b.c

'' The length never changes, so `with_` must be exactly one unit --
'' anything else returns the string unchanged rather than guessing
print ReplaceChars( "abc", "b", "xy" )            '' abc
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
