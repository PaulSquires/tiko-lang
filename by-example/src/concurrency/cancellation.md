# Cancellation

A goroutine cannot be stopped from outside. Instead, you **ask** it to stop,
through a `tasks.Context` it was given, and it notices and returns.

```tiko
{{#include ../../examples/concurrency/cancel.tiko}}
```

**Output**

```text
{{#include ../../examples/concurrency/cancel.out}}
```

`tasks.WithCancel( tasks.Context( ) )` makes a context that its `Cancel( )`
cancels; `tasks.WithTimeout( tasks.Context( ), ms )` makes one that cancels
itself after `ms` milliseconds. `tasks.Context( )` on its own is the
background context, which is never cancelled, and each new context is derived
from a parent: cancelling a context cancels every context derived from it.

A goroutine has two ways to notice:

- `ctx.Done( )` is a channel that is **closed** when the context is cancelled,
  and a closed channel is always ready to receive. So cancellation is one more
  case in a [`select`](select.md), as in `Counter`, which offers each value
  until the context is done.
- `ctx.IsCancelled( )` can be tested between pieces of work, as in `Poll`.

`ctx.Err( )` says why the context ended: `cancelled` or `deadline exceeded`.
`Cancel` may be called more than once, so the code that cancels need not check
whether something else already did.

`Counter` reports exactly three values sent: `values` has a capacity of 0, so
a send completes only when the main program receives it, and after the third
receive nobody does.

**Cancellation is a request.** A goroutine that never looks at its context
runs to the end, and one blocked in an operation that does not involve the
context cannot see the request until that operation returns. That is
deliberate: stopping a thread by force would skip its destructors and its
`defer` blocks, the cleanup the language promises.

### Activities

1. Cancel the counter after five values instead of three.
2. Give `Poll` a `WithTimeout` of 200 ms whose parent is `ctx`, and see which
   ends first.
