# Procedures

A procedure gives a piece of work a name. tiko has two kinds: a `sub` does
something and returns nothing, and a `function` computes a value and hands it
back.

```tiko
{{#include ../../examples/procedures/procedures.tiko}}
```

**Output**

```text
{{#include ../../examples/procedures/procedures.out}}
```

Parameters go in parentheses after the name, each with its type and a word
saying how it is passed (see [Parameters](params.md)). A function names its
result type after the parameter list, as in `as int32`.

A function has two ways to set its result:

- `return value` sets the result and leaves the function at once.
- `function = value` sets the result and carries on. `Sign` uses it to set a
  default answer first and change it further down.

A function that reaches `end function` without setting a result returns zero
(or an empty string), with no warning, so make sure every path sets one.

A function can also be called as a statement, as `Report( )` is: the call runs
and the result is thrown away.

Procedures are written at the top level of a file, and statements at the top
level run in order around them. A procedure sees only its parameters and its
own variables, not the variables of the code that calls it.

### Activities

1. Write a `function Cube` and print the cubes of 1 to 5.
2. Remove the `if n = 0` line from `Sign` and predict what `Sign( 0 )` returns.
