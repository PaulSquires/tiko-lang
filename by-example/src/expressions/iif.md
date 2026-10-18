# iif

`iif( condition, a, b )` is the expression form of `if`: its value is `a`
when the condition is true and `b` when it is false. It is the way to choose
between two values in the middle of a `print`, an argument list or an
initialiser.

```tiko
{{#include ../../examples/expressions/iif.tiko}}
```

**Output**

```text
{{#include ../../examples/expressions/iif.out}}
```

The two values must be of compatible types: two pieces of text, or two
numbers. A text and a number are error
`TKO0655: the two arms of 'iif' have incompatible types`. Numbers of
different types meet at the wider one, so
`iif( n > 5, 10, 2.5 )` is a `float64` even though the 10 was chosen, and
`limit` can hold 10.25 afterwards.

Only the chosen value is evaluated. `Report( "small" )` never runs, which
the output shows, and `100 \ divisor` is never computed while `divisor` is
zero. That makes `iif` safe for a value that is only valid under its
condition.

`iif` calls nest, as the grade line shows, but more than two levels read
badly. A `select case` in a small function is usually clearer.

### Activities

1. Print `"1 item"` or `"n items"` correctly for n from 0 to 3.
2. Rewrite the grade line as a function using `select case`.
