# Atomics

For a single shared counter or flag, a mutex is more than you need. An
**atomic** operation reads, changes and writes a value in one step that no
other thread can interrupt.

```tiko
{{#include ../../examples/concurrency/atomics.tiko}}
```

**Output**

```text
{{#include ../../examples/concurrency/atomics.out}}
```

`fbatomic.bi` declares three operations on a 32-bit integer, reached through a
pointer to it:

| Call | Does | Returns |
|---|---|---|
| `FB.AtomicFetchAddLong( p, v )` | adds `v` to `*p` | the value **before** the add |
| `FB.AtomicCasLong( p, expected, desired )` | stores `desired` only if `*p` is `expected` | the value before; success is `result = expected` |
| `FB.AtomicLoadLong( p )` | reads `*p` | the value |

Four runners add 1 a hundred thousand times each, with no lock, and `hits` is
exactly 400000. Then each runner tries to change `winner` from 0 to 1. The
compare-and-swap succeeds for exactly one of them, because only one can find
the 0 still there; the other three see the 1 it stored, and do nothing. Which
runner wins changes from run to run, so the program prints only how many did.

`AtomicLoadLong` exists for its ordering, not its atomicity: it makes sure the
read sees what the other threads wrote, where an ordinary read of a variable
another thread is changing may not. Every one of the three is a full memory
barrier.

An atomic protects one variable. When an update touches two values that must
stay consistent with each other, use a [mutex](mutex.md).

### Activities

1. Use the value `AtomicFetchAddLong` returns to give each of the four threads
   a distinct number from 0 to 3, and print the sum of the numbers.
2. Replace the atomic add with `r->hits += 1` and run the program a few times.
