[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Parity**

# Parity

Returns 1 if an odd number of bits are set, or 0 if an even number are.

## Syntax

```freebasic
Parity( byval x as T ) as int32
```

## Notes

- `PopCount` mod 2, computed by folding rather than by counting -- so it is cheaper when the count itself is not wanted.
- The check digit behind a parity bit and the simplest error-detecting code there is.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as uint32 x = &b1011
print Parity( x )            '' 1 -- three bits, odd

dim as uint32 y = &b1010
print Parity( y )            '' 0 -- two bits, even

print Parity( x ) = PopCount( x ) mod 2       '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
