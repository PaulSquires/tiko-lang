[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Join**

# Join

Joins an Array of strings into one, with a separator between them.

## Syntax

```freebasic
Join( parts [, delim] )
```

## Notes

- O(total) text

## Examples

```freebasic
#import "std/containers"
#import "std/strings"
using strings, containers

dim as Array( of string ) parts = Split( "a,b,c" )

print Join( parts )            '' a,b,c -- the default delimiter is a comma
print Join( parts, " | " )     '' a | b | c
print Join( parts, "" )        '' abc

'' Join( Split( s ) ) is s for every s
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
