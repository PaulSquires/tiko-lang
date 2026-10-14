[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CNthRoot**

# CNthRoot

The k-th of the n n-th roots.

## Syntax

```freebasic
CNthRoot( byref z as Complex, byval n as int32, byval k as int32 = 0 ) as Complex
```

## Notes

- **Gives you all the roots, not just the principal one.** `k = 0` is the principal root and `k = 1 … n-1` are the others, spaced `2π/n` apart around the same circle. Nothing else in the docset does this.
- Every one of them, raised to the n-th power, reproduces the operand.
- `n = 0` gives `CNaN( )`; there is no zeroth root.
- From AfxNova.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Complex z = CSet( 3, 4 )

print CToString( CNthRoot( z, 3, 0 ) )  '' 1.628937145922176+0.5201745023045459i   -- the principal cube root
print CToString( CNthRoot( z, 3, 1 ) )  '' -1.2649529063577518+1.1506136983844504i   -- the second
print CToString( CNthRoot( z, 3, 2 ) )  '' -0.3639842395644245-1.6707882006889965i   -- the third
print CIsNaN( CNthRoot( z, 0, 0 ) )     '' true
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
