# Arrays

A fixed-size array holds a set number of values of one type. Its bounds are
written in the declaration, and a brace list can fill it there too.

```tiko
{{#include ../../examples/primitives/arrays.tiko}}
```

**Output**

```text
{{#include ../../examples/primitives/arrays.out}}
```

`primes( 0 to 4 )` has five elements, numbered 0 to 4. An element is reached
with parentheses, `primes( 2 )`, and `lbound` and `ubound` give the lowest
and highest index, so a loop over them visits every element whatever the
bounds are.

The lower bound can be any integer, `days( 1 to ... )` starts at 1, and `...`
as the upper bound takes the size from the list. A single number in the
declaration is the **upper** bound with 0 as the lower, so `readings( 3 )`
has four elements. Elements that no initialiser fills start at zero.

An array can have more than one dimension. Each dimension gets its own pair
of bounds and its own level of braces, and `ubound( grid, 2 )` asks about the
second dimension.

Arrays that grow and shrink, passing arrays to procedures, and bounds checks
are in the [Arrays](../arrays/index.md) section.

### Activities

1. Declare `dim as int32 squares( 1 to 10 )`, fill it in a loop, and print
   the last element.
2. Change `days` to hold all seven days and print the number of elements
   as `ubound( days ) - lbound( days ) + 1`.
