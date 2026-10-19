[Home](Home) › [Optional](Category-Optional) › [Optional](Category-Optional) › **Value**

# Value

Returns the value by reference; raises an error if the Optional is empty.

## Syntax

```freebasic
Value( ) byref as T
```

## Examples

```freebasic
#import "std/outcome"
using outcome

dim o as Optional( of integer ) = Some( 42 )

print o.Value( )             '' 42

'' Byref, so it assigns in place
o.Value( ) = 43
print o.Value( )             '' 43

'' EMPTY ACCESS RAISES: Value( ) on an empty Optional raises
'' FB_RTERROR_ILLEGALFUNCTIONCALL through the ordinary runtime-error path, so it is
'' catchable by `on error` and reports a line under -exx. Reading a value
'' that is not there is a bug at the call site, not a condition to
'' recover from. ValueOr( ) is the branch-free alternative.
```

---

**Library:** [Optional](Category-Optional)  
**Category:** [Optional](Category-Optional)  
**Documented under:** Members
