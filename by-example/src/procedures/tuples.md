# Returning tuples

A function that has two answers, such as a quotient and a remainder, can
return both at once as a **tuple**: a group of values written in parentheses.
The result type lists the element types, and `return` lists the values:

```tiko
{{#include ../../examples/procedures/tuples.tiko}}
```

**Output**

```text
{{#include ../../examples/procedures/tuples.out}}
```

`var ( quotient, remainder ) = Divide( 17, 5 )` declares two variables and
fills them from the tuple in order. To fill variables that already exist,
leave out `var`, as the last call does with `( q, r )`.

Elements can be named in the result type: `( lo as int32, hi as int32 )`. A
caller that keeps the whole tuple in one variable, like `range`, then reads
`range.lo` and `range.hi`. The names are for reading only; the tuple is the
same type as an unnamed `( int32, int32 )`.

A tuple is the light-weight choice when the values belong together only for
the moment of the return. When they are passed around together, a named
[record type](../custom-types/index.md) says more. Tuples in general, and
taking them apart in `for each`, are in
[Tuples and Iterators](../iterators/index.md).

### Activities

1. Write `function Stats( values( ) as int32 ) as ( count as int32, total as int64 )`
   and print both parts.
2. Swap two variables with `( a, b ) = ( b, a )`.
