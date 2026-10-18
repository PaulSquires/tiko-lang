# Tuples and Iterators

Two small problems come up in almost every program. A function has two answers
to give, a minimum and a maximum, and a function returns one value. And a loop
over a collection needs an index it does not care about, with bounds to get
wrong. A *tuple* solves the first, and `for each` with the *iterator protocol*
solves the second.

```tiko
{{#include ../../examples/iterators/minmax.tiko}}
```

**Output**

```text
{{#include ../../examples/iterators/minmax.out}}
```

`MinMax` returns `(lo as int32, hi as int32)`, a tuple type, and
`return (lo, hi)` builds a value of it. The caller can take it apart with
`var (coldest, warmest) = ...`, which declares two variables, or keep it whole
and reach the elements by the names the function's declaration gave them.
Tuple types and literals themselves are introduced in
[Tuples](../primitives/tuples.md).

Inside `MinMax`, `for each v in values` visits every element without an
index. It walks arrays, the library containers, and any type of your own that
follows the iterator protocol.

This section covers:

- [Destructuring and swapping](destructure.md): `(a, b) = (b, a)`.
- [Named elements](named.md): where element names come from, and why they
  are not part of the type.
- [for each over containers](containers.md): arrays, sets, maps and pairs.
- [for each and strings](strings.md): bytes, characters and words.
- [Making a type iterable](protocol.md): `GetIterator`, `IsValid`, `Value`,
  `MoveNext`.
- [An iterable generic collection](ring.md): a ring buffer.
- [Lazy sequences](lazy.md): elements computed as they are walked.
- [Changing a collection while walking it](changing.md).

### Activities

1. Make `MinMax` return a third element, the number of values, and print it.
2. Call `MinMax` on an array with a single element. What does it return?
