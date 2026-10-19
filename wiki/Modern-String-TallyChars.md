[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **TallyChars**

# TallyChars

Counts the characters that belong to a set.

## Syntax

```freebasic
TallyChars( s, chars [, ic] )
```

## Notes

- O(n*k) — long

## Examples

```freebasic
#import "std/strings"
using strings

print TallyChars( "hello world", "lo" )      '' 5 -- l, l, o, o, l
print TallyChars( "hello world", "" )        '' 0 -- an empty set matches nothing
print TallyChars( "Hello World", "LO", true )  '' 5 -- ignoreCase

dim as ustring pw = "s3cr3t!"
print "digits: " & TallyChars( pw, "0123456789" )   '' digits: 2
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
