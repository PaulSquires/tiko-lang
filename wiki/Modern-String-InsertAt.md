[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **InsertAt**

# InsertAt

O(n)

## Syntax

```freebasic
InsertAt( s, insert, position )
```

## Notes

- O(n)

## Examples

```freebasic
#import "std/strings"
using FB

print InsertAt( "1234567890", "--", 6 )    '' 12345--67890
print InsertAt( "12345", "--", 99 )        '' 12345-- -- past the end appends
print InsertAt( "12345", "--", 0 )         '' 12345 -- below 1 does not insert

'' The one-sided wrap Wrap deliberately does not do
print InsertAt( "value", "$", 1 )          '' $value
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
