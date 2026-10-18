# Concurrency

A program that does one thing at a time leaves most of the machine idle. With
concurrency, several pieces of work run at once: on different cores, or
while another piece waits for a disk, a network or a timer.

```tiko
{{#include ../../examples/concurrency/overview.tiko}}
```

**Output**

```text
{{#include ../../examples/concurrency/overview.out}}
```

`spawn SumRange( ... )` starts a **goroutine**: the call runs alongside the rest
of the program, and `spawn` returns at once. A goroutine has no return value,
so each one sends its partial sum down a **channel**, and the main program
receives four of them. They can arrive in any order, which is why the program
adds them up rather than printing each one.

Every concurrent program needs two lines at its top:

```tiko
#import "std/tasks"
#cmdline "-mt"
```

`std/tasks` holds goroutines, channels and the tools for coordinating them.
`-mt` builds the program with the runtime that is safe to call from several
threads at once. `std/tasks` refuses to compile without it, with
`TKO0309: #error: "std/tasks needs the multithreaded runtime: build with -mt"`;
a program that starts threads of its own, without `std/tasks`, needs `-mt` all
the same.

The section has two levels:

| Level | Pages |
|---|---|
| Goroutines and channels, from `std/tasks` | [spawn](spawn.md), [channels](channels.md), [select](select.md), [worker pool](worker-pool.md), [cancellation](cancellation.md) |
| Operating-system threads and shared memory | [threads](threads.md), [mutexes](mutex.md), [condition variables](condvar.md), [atomics](atomics.md) |

Reach for goroutines and channels first: values move between them by copy,
and the order of events is visible in the code. Threads and locks are the
foundation underneath, for the cases that need them.

### Activities

1. Split the work into eight goroutines instead of four.
2. Print each partial sum as it arrives, run the program a few times, and
   watch the order change while the total does not.
