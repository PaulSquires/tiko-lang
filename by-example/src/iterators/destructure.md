# Destructuring and swapping

A list of places in parentheses on the left of `=` assigns a tuple's elements
to them, one each, in order. The right-hand side is evaluated completely before
anything is written, which makes `(a, b) = (b, a)` a swap rather than two
copies of the same value.

```tiko
{{#include ../../examples/iterators/swap.tiko}}
```

**Output**

```text
{{#include ../../examples/iterators/swap.out}}
```

The targets can be any place you could assign to: variables, array elements,
fields. Each step of the Fibonacci loop moves `newer` into `older` and the sum
into `newer` in one statement, with no temporary variable.

There are two forms:

| Form | Does |
|---|---|
| `var (q, r) = DivMod( ... )` | declares `q` and `r`, each with its element's type |
| `(q, r) = DivMod( ... )` | assigns to `q` and `r`, which already exist |

The number of places must match the number of elements exactly:

```tiko
{{#include ../../examples/iterators/toomany.tiko}}
```

```text
toomany.tiko(6,1): error TKO0825: the tuple has 2 elements, and 3 are written
     |
   6 | var (q, r, extra) = DivMod( 17, 5 )     '' three names, two elements
     | ^
```

### Activities

1. Reverse a five-element array using only tuple assignments.
2. Write `(a, a) = (1, 2)` and print `a`. Which element won?
