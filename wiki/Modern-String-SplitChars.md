[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **SplitChars**

# SplitChars

Breaks a string into an Array wherever a character from a set appears.

## Syntax

```freebasic
SplitChars( s [, chars] [, ic] )
```

## Notes

- O(n*k) — Array( of T )

## Examples

```freebasic
#import "std/containers"
#import "std/strings"
using strings, containers

'' Split on a SET of characters rather than one delimiter string
dim as Array( of string ) parts = SplitChars( "a,b;c", ",;" )

print parts.Count        '' 3
print parts[ 1 ]         '' b

'' Every delimiter counts, so runs produce empty fields
print SplitChars( "a,,b", "," ).Count    '' 3
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
