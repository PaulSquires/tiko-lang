[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CNegate**

# CNegate

The negation — both components negated.

## Syntax

```freebasic
CNegate( byref z as Complex ) as Complex
```

## Notes

- The unary `-` operator does the same thing. This exists so that the operation has a name for the same reason `CConj` does.
- AfxNova spelled this `CNeg`, `CNegate` **and** `CNegative`; one name survives.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Complex z = CSet( 3, 4 )

print CToString( CNegate( z ) )  '' -3-4i
print CToString( -z )            '' -3-4i   -- the operator agrees
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
