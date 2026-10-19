[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **DeleteAt**

# DeleteAt

Deletes a number of characters at a position.

## Syntax

```freebasic
DeleteAt( s, start, count )
```

## Notes

- O(n)

## Examples

```freebasic
#import "std/strings"
using strings

print DeleteAt( "1234567890", 4, 3 )    '' 1237890
print DeleteAt( "1234567890", 4, 99 )   '' 123 -- a count past the end takes what is there

'' Every invalid argument is a no-op, never a truncation
print DeleteAt( "1234567890", 0, 3 )    '' 1234567890 -- start below 1
print DeleteAt( "1234567890", 99, 3 )   '' 1234567890 -- start past the end
print DeleteAt( "1234567890", 4, 0 )    '' 1234567890 -- nothing to remove
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
