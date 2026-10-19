[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Between**

# Between

Returns the text between two delimiters.

## Syntax

```freebasic
Between( s, open, close [, start] [, ic] )
```

## Notes

- O(n*m)

## Examples

```freebasic
#import "std/strings"
using strings

print Between( "blah (text here) blah", "(", ")" )   '' text here
print Between( "(a)(b)", "(", ")" )                  '' a -- pairs cannot cross
print Between( "blah (unclosed", "(", ")" )          '' (empty) -- both ends required

'' Wrap's inverse when you only want the inside
print Between( "<title>Report</title>", "<title>", "</title>" )    '' Report
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
