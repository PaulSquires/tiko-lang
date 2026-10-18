# do loop

`do ... loop` repeats a block for as long as a condition says so. The condition
can be written at the top, after `do`, or at the bottom, after `loop`, and it
can be a `while` or an `until`:

```tiko
{{#include ../../examples/flow/do.tiko}}
```

**Output**

```text
{{#include ../../examples/flow/do.out}}
```

| Form | Tests | Body runs |
|---|---|---|
| `do while c ... loop` | before each pass; continues while `c` is true | zero or more times |
| `do until c ... loop` | before each pass; continues until `c` is true | zero or more times |
| `do ... loop while c` | after each pass | at least once |
| `do ... loop until c` | after each pass | at least once |
| `do ... loop` | never | until `exit do` |

The third block shows why the position matters. `n` starts at 10, so `n < 3`
is false from the beginning, yet the body runs once because the test comes
after it. Put the test at the top when the body might not need to run at all,
and at the bottom when the body produces the value the test looks at, as the
square search does.

A `do` with no condition runs until something inside it leaves: `exit do`
here, or `exit sub`, `return`, or an `exit for` aimed at an enclosing loop.
[exit and continue](exit.md) covers those.

### Activities

1. Rewrite the `do until n = 3` loop as a `do while` loop with the same output.
2. Change `loop until n * n > 50` to `loop while n * n <= 50`. Is the result
   the same?
