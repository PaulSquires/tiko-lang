[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Repeat**

# Repeat

O(n*count)

## Syntax

```freebasic
Repeat( count, s )
```

## Notes

- O(n*count)

## Examples

```freebasic
#import "std/strings"
using FB

print Repeat( 3, "ab" )       '' ababab
print Repeat( 0, "ab" )       '' (empty) -- 0 or less gives ""

'' STRING( n, ch ) repeats one character; this repeats a whole string,
'' in one allocation rather than n concatenations
print Repeat( 20, "-" )       '' --------------------
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
