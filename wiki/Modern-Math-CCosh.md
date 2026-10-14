[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CCosh**

# CCosh

The hyperbolic cosine.

## Syntax

```freebasic
CCosh( byref z as Complex ) as Complex
```

## Notes

- `cosh(re)·cos(im) + i·sinh(re)·sin(im)`, written out directly — see `CSinh` for why it is not routed through `CCos`.
- Even: `CCosh( -z )` is `CCosh( z )`.
- Spelled with the `C` prefix because, when this library was a header in namespace `FB`, a function of the unprefixed name shadowed the FreeBASIC intrinsic for every later header — measured, it broke what is now `random.tiko` — after which the intrinsic could not be called back. The name stayed when the header became `std/numeric`.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Complex z = CSet( 3, 4 )

print CToString( CCosh( CZero( ) ) )  '' 1+0i   -- exactly one
print CToString( CCosh( z ) )         '' -6.580663040551157-7.581552742746545i
print CToString( CCosh( -z ) )        '' -6.580663040551157-7.581552742746545i   -- even
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
