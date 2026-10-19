[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Replace**

# Replace

Replaces every occurrence of the text with other text.

## Syntax

```freebasic
Replace( s, match, with_ [, ic] )
```

## Notes

- O(n*m)

## Examples

```freebasic
#import "std/strings"
using strings

print Replace( "Hello World", "World", "Earth" )    '' Hello Earth
print Replace( "hello world", "WORLD", "Earth", true )    '' hello Earth

'' Single pass: a replacement containing the pattern never cascades
print Replace( "a", "a", "aa" )        '' aa, not a hang
print Replace( "abc", "", "-" )        '' abc -- an empty match copies through
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
