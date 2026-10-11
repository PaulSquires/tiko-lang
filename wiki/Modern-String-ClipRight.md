[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **ClipRight**

# ClipRight

O(n)

## Syntax

```freebasic
ClipRight( s, count )
```

## Notes

- O(n)

## Examples

```freebasic
#import "std/strings"
using strings

print ClipRight( "1234567890", 3 )     '' 1234567
print ClipRight( "1234567890", 0 )     '' 1234567890
print ClipRight( "1234567890", 99 )    '' (empty)

'' Dropping a known extension
print ClipRight( "report.txt", 4 )     '' report
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
