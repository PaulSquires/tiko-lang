# Worker pool

A **worker pool** shares a stream of jobs between a fixed number of
goroutines: each job goes to whichever worker is free. Spreading the work out is
*fan-out*; collecting the results back into one place is *fan-in*.

```tiko
{{#include ../../examples/concurrency/workerpool.tiko}}
```

**Output**

```text
{{#include ../../examples/concurrency/workerpool.out}}
```

Three `Worker`s receive from the one `jobs` channel and send to the one
`results` channel. Which worker squares which number, and the order the squares
arrive in, change from run to run; the sorted list does not.

The main program's `for each` over `results` ends when `results` is closed,
and it must be closed exactly once, after the **last** worker has finished.
No worker knows that it is the last, so a `tasks.WaitGroup` counts them:

| Member | Does |
|---|---|
| `Add( )` | one more goroutine to wait for (or `Add( n )` for n) |
| `Done( )` | the calling goroutine has finished |
| `Wait( )` | returns when every `Add` has been matched by a `Done` |
| `WaitFor( ms )` | the same, but gives up after `ms` milliseconds |

`CloseWhenDone` waits on the group and then closes `results`. Two rules keep
it correct. Call **`Add` before `spawn`**, never inside the goroutine:
otherwise `Wait` can run before the goroutine has counted itself and return
early. And pass the `WaitGroup` by pointer: it cannot be copied, because a
copy would be a second counter, so passing one `byval` is refused with
`TKO0746: the operator let of 'waitgroup' is private or protected and cannot
be reached from here`.

`Feed` runs as a goroutine too, so the main program can collect results while
jobs are still going out. Had the main program sent every job itself before
collecting anything, it would work only while the jobs fit in the channels'
buffers and the workers' hands. With 20 jobs instead of 10 it stops for good:
both buffers are full, every worker waits to send a result, and the main
program waits to send a job.

### Activities

1. Run the pool with one worker, then with ten. The output is the same; time
   the two with a job that sleeps for 10 ms.
2. Make each result say which worker produced it, and count the jobs each one
   took.
