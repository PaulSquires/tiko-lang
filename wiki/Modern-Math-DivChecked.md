[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **DivChecked**

# DivChecked

Integer division, or **nothing** when it is undefined.

## Syntax

```freebasic
DivChecked( byval a as T, byval b as T ) as Optional( of T )
```

## Notes

- **Two** failing cases, not one: division by zero, and the most negative value divided by -1 -- whose true quotient has no representation, exactly as with `AbsChecked`.
- That second case is the one hand-written guards forget; a bare `if b <> 0` is not enough.
- There is no saturating or wrapping division, because neither has a defensible answer for a divide by zero.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as int8 a = 10, b = 0
print DivChecked( a, b ).HasValue( )          '' false -- divide by zero

'' THE CASE A HAND-WRITTEN GUARD FORGETS: -128 \ -1 has no
'' representation in a BYTE
dim as int8 worst = -128, neg = -1
print DivChecked( worst, neg ).HasValue( )    '' false

dim as int8 c = 10, d = 3
print DivChecked( c, d ).Value( )             '' 3
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
