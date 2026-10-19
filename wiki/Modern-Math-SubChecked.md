[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **SubChecked**

# SubChecked

Subtracts two integers, returning an empty Optional if the result would overflow.

## Syntax

```freebasic
SubChecked( byval a as T, byval b as T ) as Optional( of T )
```

## Notes

- Returns an **Optional**: empty means the true result does not fit in `T`. The overflow is reported rather than wrapped, which is what `a - b` does silently.
- The check happens **before** the operation, so nothing undefined occurs on the way to finding out.
- `SubSaturating` clamps instead, and `SubWrapping` wraps on purpose.

## Examples

```freebasic
#import "std/outcome"
#import "std/numeric"
using numeric, outcome

dim as int8 a = 100, b = 100

var r = SubChecked( a, b )
print r.HasValue( )          '' false -- 200 does not fit in a BYTE

dim as int8 small = 1
var ok = SubChecked( small, small )
print ok.HasValue( )         '' true
print ok.Value( )
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
