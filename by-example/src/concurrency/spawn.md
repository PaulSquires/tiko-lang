# spawn

`spawn Proc( args )` runs a procedure call as a goroutine, alongside the code
that spawned it. A goroutine is a work item on a pool of threads that
`std/tasks` manages, not a thread of its own, so starting one is cheap and
thousands of them are fine.

```tiko
{{#include ../../examples/concurrency/spawn.tiko}}
```

**Output**

```text
{{#include ../../examples/concurrency/spawn.out}}
```

The arguments are evaluated and **copied at the `spawn` statement**. Each
goroutine gets the `i` and the `prefix` that existed when it was spawned, so
changing `prefix` afterwards changes nothing any of them see, however late
they run. The four labels arrive in whatever order the goroutines finish,
which is why the program collects them in an
[`OrderedSet`](../containers/ordered.md), which keeps them sorted.

Copying is what makes this safe, and it rules out a `byref` parameter: the
goroutine would hold a reference into a frame that may be gone by the time it
runs.

```tiko
{{#include ../../examples/concurrency/spawnbyref.tiko}}
```

```text
spawnbyref.tiko(9,1): error TKO0812: 'spawn fill' cannot pass its byref parameter 'total'; a string or UDT parameter is byref unless it is written 'byval'
```

The second half of the message matters: a `ustring` or record parameter written
without either keyword is `byref`, so write `byval` on every parameter of a
procedure you mean to spawn. When the goroutine must change something of
yours, pass a pointer, or better, send the result back through a channel.

Two more rules:

- `spawn` takes a `sub` or `function` declared at module level; a function's
  result is discarded. The file must `#import "std/tasks"`, or `spawn` is
  refused with `TKO0423: 'spawn' needs '#import "std/tasks"' in this file
  (and -mt)`.
- **Nothing waits for a goroutine when the program ends.** One still running
  is abandoned. A channel, as here, or a [`WaitGroup`](worker-pool.md) is how
  you wait.

### Activities

1. Spawn ten goroutines and check that all ten labels arrive.
2. Remove `byval` from `prefix` and read the error.
