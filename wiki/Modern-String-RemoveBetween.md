[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **RemoveBetween**

# RemoveBetween

Removes a pair of delimiters and the text between them.

## Syntax

```freebasic
RemoveBetween( s, opening, closing [, removeAll] [, start] [, ignoreCase] )
```

## Notes

- The delimiters go too, not just the text between them.
- `removeAll` repeats until no pair is left; the default removes only the first.
- An **unbalanced opener stops the walk** and leaves the rest alone, so a stray `(` does not swallow the tail of the string.
- `closing` is searched from the end of `opening`, so a pair cannot be crossed.

## Examples

```freebasic
#import "std/strings"
using strings

print RemoveBetween( "blah (text) blah", "(", ")" )       '' blah  blah

'' removeAll repeats until no pair is left
print RemoveBetween( "var1(34), var2( 73 ), var3(any)", "(", ")", true )
                             '' var1, var2, var3

'' An unbalanced opener stops the walk rather than swallowing the tail
print RemoveBetween( "keep (this", "(", ")" )             '' keep (this
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** Members
