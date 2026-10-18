# Procedure pointers

A procedure has an address, and a variable can hold it. That lets a program
decide *which* procedure to call while it runs, and lets one procedure take
another as a parameter:

```tiko
{{#include ../../examples/procedures/procptr.tiko}}
```

**Output**

```text
{{#include ../../examples/procedures/procptr.out}}
```

The type of a procedure pointer is the procedure's signature without its name:
`function( byval as float64 ) as float64` holds any function that takes one
`float64` by value and returns a `float64`. Parameter names are optional in the
type. A `sub` pointer is written the same way with `sub`, as `callback` is.

`@Twice` and `procptr( Twice )` both take the address. For an overloaded name,
`procptr` also takes the signature you mean, as in
`procptr( Describe, sub( byval as float64 ) )`.

A pointer is called with ordinary call syntax: `op( 5 )`, `f( i )`. A `type`
alias such as `Operation` gives the signature a name, which keeps parameter
lists like `Tabulate`'s readable and lets a function such as `Pick` return
one.

A procedure pointer is one address and nothing more, so it cannot carry any
data along with the code. [Closures](closure.md) can.

### Activities

1. Add a `Negate` function and pass it to `Tabulate` without changing
   `Tabulate`.
2. Make `Pick` return `@Negate` for the name `"negate"` and call the result.
