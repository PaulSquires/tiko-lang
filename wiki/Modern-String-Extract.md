[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Extract**

# Extract

O(n*m)   text before match

## Syntax

```freebasic
Extract( start, s, match [, ic] )
Extract( 1, s, missing )
```

## Notes

- O(n*m) — text before match
- the whole remainder

## Examples

```freebasic
#import "std/strings"
using strings

print Extract( 1, "abacadabra", "cad" )    '' aba -- text before the match
print Extract( 1, "abacadabra", "zzz" )    '' abacadabra -- a miss gives the whole remainder
print Extract( 3, "abacadabra", "a" )      '' (empty) -- position 3 is already an "a"

'' The miss rule is what lets a parse loop keep its last field
dim as ustring field_ = Extract( 1, "lastfield", "," )
print field_                               '' lastfield
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
