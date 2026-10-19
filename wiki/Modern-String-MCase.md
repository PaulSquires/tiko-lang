[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **MCase**

# MCase

Returns a title-case copy: each word capitalised, the rest lower case.

## Syntax

```freebasic
MCase( s )
```

## Notes

- O(n) — title case

## Examples

```freebasic
#import "std/strings"
using strings

print MCase( "hello wide world" )     '' Hello Wide World
print MCase( "SHOUTING TEXT" )        '' Shouting Text

'' A word starts after any character that is not alphanumeric --
'' no fixed list of punctuation, so "/" and "_" count too
print MCase( "read/write_mode" )      '' Read/Write_Mode
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
