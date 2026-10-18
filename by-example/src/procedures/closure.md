# Closures

A lambda that needs a variable from the code around it lists the variable in
square brackets after `sub` or `function`. That **captures** it, and the lambda
becomes a **closure**: the code plus the captured variables. Every capture
states how it is held:

```tiko
{{#include ../../examples/procedures/closure.tiko}}
```

**Output**

```text
{{#include ../../examples/procedures/closure.out}}
```

| Capture | The closure holds | Writes inside the lambda |
|---|---|---|
| `byref calls` | the caller's variable | reach the caller |
| `byval step_` | its own copy, taken when the lambda expression runs | stay in the copy |

`countCall` increments the caller's `calls`. `addStep` copied `step_` when its
`var` line ran, while it was 5, so it still adds 5 after `step_` becomes 1000;
`addStepNow` holds the variable and sees 1000. `addScaled` mixes the two modes
and copies `step_` at the point it is made, by which time it is 1000.

````admonish danger title="Pitfall"
A `byval` capture is a snapshot taken when the lambda is **made**, not when it
is called. A closure written early and called late, such as a handler or a
comparer kept for later, sees the value from when it was written. Capture
`byref` when the lambda must see the variable as it is at each call.
````

There is no default mode. A capture without `byval` or `byref` is refused:

```tiko
{{#include ../../examples/procedures/capturemode.tiko}}
```

```text
capturemode.tiko(3,17): error TKO0413: every lambda capture needs an explicit 'byval' or 'byref'
```

A closure is not a procedure pointer, because a pointer has no room for the
captured variables. Assigning one to a procedure-pointer type is
`TKO0738: no conversion between these two types`. To pass a closure to a
procedure, the parameter is generic, as [Higher-order procedures](higher-order.md)
shows.

### Activities

1. Write a closure that appends each word it is given to a `ustring` captured
   `byref`, and call it three times.
2. Change `addStep` to capture `byref` and predict its output before running.
