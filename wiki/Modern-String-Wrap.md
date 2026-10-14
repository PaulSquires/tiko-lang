[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Wrap**

# Wrap

O(n)

## Syntax

```freebasic
Wrap( s [, open] [, close] )
```

## Notes

- O(n)

## Examples

```freebasic
#import "std/strings"
using strings

print Wrap( "Paul" )               '' "Paul" -- double quotes by default
print Wrap( "Paul", "'" )          '' 'Paul' -- an empty closing means "same as opening"
print Wrap( "Paul", "<", ">" )     '' <Paul>

'' A genuinely one-sided wrap is InsertAt's job
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
