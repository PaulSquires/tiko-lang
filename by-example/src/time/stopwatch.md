# Measuring elapsed time

To time how long something takes, do not subtract two readings of the wall
clock: the operating system corrects it and users change it, so it can jump
backwards. A `Stopwatch` reads a clock that only moves forward.

```tiko
{{#include ../../examples/time/stopwatch.tiko}}
```

**Output**

```text
{{#include ../../examples/time/stopwatch.out}}
```

`Stopwatch.StartNew( )` makes a running stopwatch. `Elapsed` is a
[`TimeSpan`](spans.md); `ElapsedMilliseconds` and `ElapsedTicks` are
numbers. `Restart( )` zeroes it and keeps it running, `Reset( )` zeroes and
stops it, and `Start( )` resumes. `Stop_( )` has a trailing underscore because
`stop` is a statement. A stopwatch adds up only the time it was running, so
the `sleep` while it was stopped is not counted.

The time taken differs on every run and every machine, so the example prints
facts about it rather than the time. For a real measurement, run the work
several times, keep the fastest, and build with optimisation on.

`chrono.CpuClock.ProcessTime( )` is the other clock worth knowing: the
processor time the program has used, which a `sleep` does not add to.

### Activities

1. Time `SumTo( 10000000 )` and print the result with `TotalMilliseconds`.
2. Stop the stopwatch, sleep, start it again, and check that `IsRunning` is
   true and the paused time is still not counted.
