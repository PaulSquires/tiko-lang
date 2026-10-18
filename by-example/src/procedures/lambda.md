# Lambdas

A small procedure that is used in one place reads better written in that
place. A **lambda** is a procedure without a name, written as an expression:
`function( parameters ) as Type ... end function`, or `sub( parameters ) ...
end sub` when nothing is returned.

```tiko
{{#include ../../examples/procedures/lambda.tiko}}
```

**Output**

```text
{{#include ../../examples/procedures/lambda.out}}
```

A lambda can go wherever an expression can:

- into a variable of a matching [procedure pointer](procptr.md) type, like
  `double_`;
- into a `var`, which takes its type from the lambda, like `cube` and `greet`;
- straight into an argument, like the one `ApplyAll` receives.

The body is ordinary statements. Because `:` separates statements, a short
body fits on one line, as `cube`'s does. A lambda is called like any other
procedure: `cube( 3 )`.

A lambda that uses only its own parameters and locals is compiled to an
ordinary procedure, and its value is that procedure's address. That is why it
can be stored in a `Transform` variable and passed where a `Transform` is
wanted. A lambda that uses variables from the code around it is a
[closure](closure.md), which is a different kind of value.

### Activities

1. Pass `ApplyAll` a lambda that replaces every value with its square.
2. Store a lambda that returns the larger of two `int32` values in a `var`, and
   call it.
