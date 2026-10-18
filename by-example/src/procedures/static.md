# Static locals

An ordinary local variable is created fresh on every call. A `static` local is
created once and keeps its value from one call to the next, which gives a
procedure a memory without a variable outside it:

```tiko
{{#include ../../examples/procedures/static.tiko}}
```

**Output**

```text
{{#include ../../examples/procedures/static.out}}
```

`counter` in `NextTicket` is set to 100 once, before the first call, and each
call moves it on. `Fresh` declares the same variable with `dim`, so every call
starts again from 100.

An array can be `static` too. `Remember` keeps a ring of the last three values
and a `slot` that wraps round, so the fourth value overwrites the first.

A `static` belongs to the procedure, not to a call, so every call shares it:
the calls of a recursion, and calls from two threads at once. Reset it
yourself when its job is done, and give a procedure that several threads call
no `static` it writes to; [Concurrency](../concurrency/index.md) has the tools
for shared state.

### Activities

1. Make `NextTicket` start at 1 and print five tickets.
2. Change `Remember` to keep the last five values.
