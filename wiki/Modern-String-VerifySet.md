[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **VerifySet**

# VerifySet

First position NOT in the set, or 0 if every one is.

## Syntax

```freebasic
VerifySet( start, s, chars [, ic] )
```

## Notes

- O(n*k) — long

## Examples

```freebasic
#import "std/strings"
using strings

const digits = "0123456789"

print VerifySet( 1, "12345", digits )    '' 0 -- every character is in the set
print VerifySet( 1, "123x5", digits )    '' 4 -- the first one that is not

'' The classic "is this made only of these characters" test
if VerifySet( 1, "9042", digits ) = 0 then print "all digits"
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
