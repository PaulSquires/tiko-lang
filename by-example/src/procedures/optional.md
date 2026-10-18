# Optional parameters

A parameter with `= value` after its type has a default. A call may leave the
argument out, and the parameter then takes the default:

```tiko
{{#include ../../examples/procedures/optional.tiko}}
```

**Output**

```text
{{#include ../../examples/procedures/optional.out}}
```

Arguments are matched by position. Leaving out the last ones is the usual
case: `Rule( 4 )` supplies `length` and takes the defaults for `mark` and
`title`. To skip an argument that has others after it, leave its slot empty,
with only the comma: `Rule( , "*" )` and `Rule( 3, , "total " )`.

An empty slot is easy to miss when reading a call. One is fine; when a call
needs several, the parameters are probably in the wrong order, and the ones
callers change most often should come first.

A default does not have to be a literal. It is an expression, worked out at
each call that leaves the argument out; `1 / 4` here is the simplest case.

### Activities

1. Give `Scaled` a default `value` as well and call it with no arguments.
2. Call `Rule` so that it prints `== heading` followed by eight `=` signs.
