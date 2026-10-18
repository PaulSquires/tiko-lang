# Lazy sequences

An iterator does not have to walk anything stored. `Value( )` can return a
number it computed, and `MoveNext( )` can compute the next one. The sequence
then exists only as far as a loop asks for it.

```tiko
{{#include ../../examples/iterators/collatz.tiko}}
```

**Output**

```text
{{#include ../../examples/iterators/collatz.out}}
```

The Collatz sequence halves an even number and turns an odd one into
`3 * n + 1`, until it reaches 1. `CollatzIterator` holds one number and a flag:
`MoveNext( )` applies the rule, and on reaching 1 marks the walk as done after
that element has been seen.

- The walk from 6 prints every element.
- The walk from 27 visits 112 numbers, and the loop keeps only a count and
  the highest value. Nothing else is stored.
- The walk from 989345275647 stops at `exit for` after four elements. The
  rest of the sequence is never computed.

The cost of laziness is that nothing is remembered: walking `twentySeven` a
second time computes every element again.

### Activities

1. Write a `Squares` type whose iterator yields 1, 4, 9, ... for ever, and print
   the first square above 1000 with `exit for`.
2. Change the program to find which start below 100 takes the most steps.
