# Expressions

A tiko program is a list of **statements**: declarations, assignments,
calls to subs, `if` blocks, loops. Inside them are **expressions**, which
compute a value of some type. Knowing which is which explains a few rules
that otherwise look arbitrary.

```tiko
{{#include ../../examples/expressions/expressions.tiko}}
```

**Output**

```text
{{#include ../../examples/expressions/expressions.out}}
```

An expression can be as large as you like, and it can contain calls to
functions, because a function call has a value. A call to a `sub` has none,
so it can only stand alone as a statement, as `Announce( ... )` does;
`print Announce( 3 )` is error `TKO0873: 'announce' is a sub and has no value`.

Assignment is a statement, not an expression. In `flag = y = 36` the first
`=` assigns and the second compares, so `flag` receives -1, the value of the
comparison `y = 36`. Writing the comparison in parentheses, as on the next
line, makes that easier to read.

`if` is also a statement: it chooses what to *do*. To choose a *value* inside
an expression, use [`iif`](iif.md). And when a value takes several steps to
compute, put the steps in a function: the call is then a single expression,
as `Hypotenuse( 3, 4 )` is.

This section covers [`iif`](iif.md), the
[short-circuit](shortcircuit.md) operators `andalso` and `orelse`, and the
[precedence](precedence.md) that decides how an expression without
parentheses is grouped.

### Activities

1. Print `y = 36` directly, then `cbool( y = 36 )`.
2. Write a function `Clamp( x, lo, hi )` and use it inside a `print`.
