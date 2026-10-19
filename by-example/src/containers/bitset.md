# BitSet

`containers.BitSet` is a set of small whole numbers stored as one bit each: a
row of seats, the cells a search has visited, a sieve of primes. A million
flags take 125 KB.

```tiko
{{#include ../../examples/containers/bitset.tiko}}
```

**Output**

```text
{{#include ../../examples/containers/bitset.out}}
```

| Member | Does |
|---|---|
| `Set( i )`, `Reset( i )`, `Flip( i )` | change one bit; `Set` grows the set as needed |
| `Test( i )` | whether bit `i` is set; `false` beyond the length |
| `CountOnes( )`, `Length( )` | bits set; bits addressable |
| `FirstSet( from )`, `NextClear( from )` | the next set or clear bit at or after `from` |
| `UnionWith`, `IntersectWith`, `DifferenceWith` | set algebra, changing the left-hand set |
| `Equals( other )` | same bits set, whatever the lengths |

`BitSet( 40 )` starts with 40 clear bits; a plain `dim` starts empty and grows on
`Set`. `for each` visits the set bits from lowest to highest.

The set operations change the set they are called on, which is why the example
copies `wanted` into `clash` before intersecting. A `BitSet` takes no brace list
at its declaration: call `Set` for each bit.

### Activities

1. Take seats 3 and 4 too, then print the first free seat again.
2. Use `SymmetricDifferenceWith` to find the seats that are in exactly one of
   `taken` and the original `wanted`.
