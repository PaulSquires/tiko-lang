[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Tally**

# Tally

Non-overlapping occurrences. "aaaa" contains "aa" TWICE.

## Syntax

```freebasic
Tally( s, match [, ic] )
```

## Notes

- O(n*m) — long

## Examples

```freebasic
#import "std/strings"
using strings

dim as ustring csv = "a,b,,c"

print Tally( csv, "," )              '' 3 -- one per separator
print Tally( "aaaa", "aa" )          '' 2 -- occurrences never overlap
print Tally( "Hello", "L", true )    '' 2 -- ignoreCase
print Tally( csv, "" )               '' 0 -- an empty match counts nothing
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
