# for

`for ... next` repeats a block a counted number of times. The counter starts at
the first value, and the loop runs while it has not passed the second:

```tiko
{{#include ../../examples/flow/for.tiko}}
```

**Output**

```text
{{#include ../../examples/flow/for.out}}
```

Both ends of the range are included: `1 to 5` runs five times. `step` sets how
much the counter changes after each pass, and a negative step counts down;
`10 to 1 step -3` stops at 1 because the next value, -2, is past the end. A
range that is already finished, such as `5 to 1` with the default step of 1,
runs the body zero times.

The end value is worked out once, when the loop starts. Changing `last` inside
the body does not stretch the loop.

`for i as int32 = ...` declares the counter as part of the loop, so it exists
only inside it; using `i` after `next` is `TKO0743: 'i' is not declared`. That
is usually what you want. A counter declared before the loop, like `k`, is an
ordinary variable that keeps its value afterwards, and that value is the one
that ended the loop: 4, not 3.

To leave a `for` early or skip a pass, see [exit and continue](exit.md). To
walk the elements of an array without a counter, see [for each](foreach.md).

### Activities

1. Print the multiples of 7 from 7 to 70 with one `for` and a `step`.
2. Count down from 1 to 0 in steps of -0.1 and look closely at the last
   values printed.
