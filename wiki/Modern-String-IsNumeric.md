[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **IsNumeric**

# IsNumeric

Returns true if the string is a valid number, with spaces allowed around it.

## Syntax

```freebasic
IsNumeric( s )
```

## Notes

- O(n) — boolean

## Examples

```freebasic
#import "std/strings"
using strings

print IsNumeric( " -1.5e+3 " )    '' true -- surrounding whitespace is allowed
print IsNumeric( "42" )           '' true
print IsNumeric( "12abc" )        '' false -- trailing junk fails
print IsNumeric( "" )             '' false -- at least one digit is required
print IsNumeric( "&HFF" )         '' false -- radix literals are tiko syntax, not numeric text
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
