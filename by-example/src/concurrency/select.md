# select

`select channel` waits until one of several channel operations can go ahead,
and runs that case. It is how a goroutine listens to more than one channel at
once, and how it waits for a channel without waiting for ever.

```tiko
{{#include ../../examples/concurrency/select.tiko}}
```

**Output**

```text
{{#include ../../examples/concurrency/select.out}}
```

The first `select` has a `case else`, so it does not wait: nothing has been
sent yet, and the `else` runs at once. The second waits for whichever channel
has a value first; the quick reply comes after 20 ms, well inside the timeout.
The third waits only 100 ms, and the slow reply is not due for three seconds,
so the `timeout` case runs. The program then ends without receiving it.

| Case | Runs when |
|---|---|
| `case receive v from ch` | a value can be received into `v`, declared beforehand |
| `case receive from ch` | a value can be received; it is thrown away |
| `case send v to ch` | `v` can be sent |
| `case timeout ms` | nothing else became ready within `ms` milliseconds |
| `case else` | nothing is ready right now |

A `select` may have a `timeout` or an `else`, not both: the `else` would run
every time, and the timeout could never be reached.

When several cases are ready at once, one of them is chosen, in no fixed order,
so a channel that always has a value cannot starve the others. A closed
channel always counts as ready to receive, which is what makes
[cancellation](cancellation.md) one more `case`. Like `spawn`, `select channel`
needs `#import "std/tasks"` in the file.

### Activities

1. Change the second `timeout` to `10` and predict the output.
2. Put the second and third `select` in a loop that runs until both replies
   have arrived, with a `timeout` of 5000.
