# Short-Circuit Logic

tiko has two sets of logical operators. `andalso` and `orelse` stop
evaluating as soon as the answer is known. `and`, `or`, `xor` and `not` are
bitwise operators that also work on conditions, and they always evaluate
both sides.

```tiko
{{#include ../../examples/expressions/shortcircuit.tiko}}
```

**Output**

```text
{{#include ../../examples/expressions/shortcircuit.out}}
```

`Check` prints its tag when it runs, so each line of output lists the
operands that were evaluated. When the left side of `andalso` is false, the
whole condition is false and the right side is skipped; when the left side
of `orelse` is true, the whole condition is true and the right side is
skipped. `and` and `or` run both, every time.

That difference is what makes a guard work. In the loop, the bounds tests
come first, and `values( i )` is only read once they have passed. The program
is compiled with `-exx`, which checks every array index while the program
runs, and the indexes 0 and 4 never reach the array. Written with `and`, the
same condition would read `values( 0 )` and stop the program with an
out-of-bounds error.

| Operator | Evaluates the right side | Works on |
|---|---|---|
| `andalso` | only if the left is true | conditions |
| `orelse` | only if the left is false | conditions |
| `and`, `or`, `xor` | always | conditions and the bits of integers |
| `not` | (one operand) | conditions and the bits of integers |

On integers the two sets give different answers: `6 and 3` is 2, the bits the
two numbers share, while `6 andalso 3` is true, because both are non-zero.
Use `andalso` and `orelse` for conditions, and keep `and`, `or`, `xor` and
`not` for bits.

### Activities

1. Change the guard in the loop to use `and` and run the program.
2. Write `if s <> "" andalso left( s, 1 ) = "#" then` for a `ustring` called
   `s`, and test it with an empty string.
