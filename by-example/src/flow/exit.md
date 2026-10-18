# exit and continue

`exit` leaves a block straight away; `continue` abandons the current pass of a
loop and starts the next one. Both name the kind of block they act on:
`exit for`, `exit do`, `continue for`, `continue do`.

```tiko
{{#include ../../examples/flow/exit.tiko}}
```

**Output**

```text
{{#include ../../examples/flow/exit.out}}
```

In the first loop, `continue for` skips 3 and 6 without printing them, and
`exit for` ends the loop when it reaches 8. A `continue for` still moves the
counter on, exactly as reaching `next` would.

**Leaving several loops.** A plain `exit for` leaves only the innermost `for`.
Repeating the kind, `exit for, for`, leaves two of them, which is how the grid
search stops at the first value over 50 without a flag variable. `continue for,
for` works the same way: it gives up on the rest of the inner loop *and* the
rest of the outer loop's current pass, so each row stops at its first zero.
`exit do, do` and `continue do, do` exist too.

**Different kinds.** Because the statement names a kind, it finds the nearest
enclosing block of that kind and passes through any other blocks on the way.
The last loop leaves the `for` from inside a `do`.

The same word leaves a procedure: `exit sub` and `exit function`, covered in
[Procedures](../procedures/index.md).

### Activities

1. Change the grid search to find the first value under 5 instead.
2. In the row printer, replace `continue for, for` with `exit for`. What else
   do you have to change to keep the output the same?
