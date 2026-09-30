[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **MCase**

# MCase

O(n)     title case

## Syntax

```freebasic
MCase( s )
```

## Notes

- O(n) — title case

## Examples

```freebasic
#include once "fb/string.bi"
using FB

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
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
