# defer

Code that acquires something has to release it on every path out, and early
exits make that easy to get wrong. `defer` takes one statement and runs it
when the enclosing block is left, however it is left. You write the release
next to the acquire, and no later `exit` can skip it:

```tiko
{{#include ../../examples/flow/defer.tiko}}
```

**Output**

```text
{{#include ../../examples/flow/defer.out}}
```

Deferred statements run in **reverse order**: the target is closed before the
source, the opposite of the order they were opened. They run on the normal
path and on the early `exit sub` alike.

In `Ticket` the result is settled by `return n` before the defers run, so the
function returns 1 even though a defer then sets `n` to 100.

## A defer belongs to its block

The block a `defer` belongs to is the nearest enclosing one, and an `if`, a
loop body and a `scope` are all blocks:

```tiko
{{#include ../../examples/flow/deferblock.tiko}}
```

**Output**

```text
{{#include ../../examples/flow/deferblock.out}}
```

````admonish danger title="Pitfall"
A `defer` inside an `if` runs at `end if`, while the procedure carries on.
Writing *acquire inside an `if`, then defer the release* releases the thing at
once and leaves the rest of the procedure using something already closed.
Test for the failure, leave early, and put the acquire and its `defer` in the
procedure's own body.
````

In a loop body the same rule is what you want: the deferred statement runs at
the end of every pass, including the pass that `continue for` cut short and
the one that `exit for` ended.

The deferred statement is not evaluated when the `defer` line is reached. It
runs as written when the block is left, and reads its variables then, so
`LateRead` prints 9. Copy a value into a local first if you need it as it was.

A `defer` directly at the top level of a program has no block to leave and is
refused with `TKO0814: 'defer' is not allowed at module level; put it in a
procedure or a block`. The [Memory and Resources](../memory/index.md) section
shows `defer` alongside destructors.

### Activities

1. Add a third resource to `Copy` and check the order the three are closed in.
2. Move the `defer` in `InAnIf` above the `if` and predict the new output.
