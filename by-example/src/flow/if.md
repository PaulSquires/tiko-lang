# if/else

`if` runs a block when a condition is true. `elseif` adds more conditions,
tested in order until one holds, and `else` catches everything left over. Only
one branch ever runs.

```tiko
{{#include ../../examples/flow/if.tiko}}
```

**Output**

```text
{{#include ../../examples/flow/if.out}}
```

A temperature of 18 fails the first test and passes the second, so the output
starts with `mild`; the `else` branch is never reached.

When the statement after `then` is on the same line, the `if` is complete on
that line and takes no `end if`. A one-line `if` may also have an `else`. Keep
these short: they suit a guard or a single action, and a multi-line `if` reads
better as soon as there is more to do.

The condition can be any number, and zero counts as false. That is why
`if items then` works: `items` is 3. To join conditions, use `andalso` and
`orelse`, which stop as soon as the answer is known; the
[Expressions](../expressions/index.md) section covers them.

````admonish danger title="Pitfall"
On a one-line `if`, a colon does not end the `if`. Every statement after `then`
on that line belongs to it:

```tiko
if temperature > 30 then print "stay inside" : print "drink water"
```

Neither `print` runs, because the condition is false. If the second statement
should always run, put it on a line of its own.
````

### Activities

1. Set `temperature` to 30, then to 31, and predict each output before running it.
2. Rewrite the `if` / `elseif` chain so that it tests for `cold` first.
