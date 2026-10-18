# Propagating errors

A function that calls another fallible function usually wants to stop at the
first failure and hand it to its own caller, adding what it knows on the way.
With a `Result` that is an early `return`.

```tiko
{{#include ../../examples/errors/propagate.tiko}}
```

**Output**

```text
{{#include ../../examples/errors/propagate.out}}
```

Three levels of calls, each either handling a failure or passing it on:

- `ParsePort` checks one number and fails with the reason.
- `ParseEndpoint` can fail on its own, with no `:`, and calls `ParsePort`.
  When that fails it returns at once, building its own failure from
  `port.Failure( )`. A `Result( of int32, ... )` and a `Result( of Endpoint, ... )`
  are different types, so the failure is re-wrapped rather than returned as it
  is.
- `LoadSetting` adds the setting's name to any failure from below. On success
  `ep` already has the right type and is returned unchanged.

Nothing below the top level prints anything. The loop at the bottom is the one
place that decides what a failure means to the user, and it sees exactly
which setting failed and why.

The cost is one branch per call, paid where the decision is made. Compare a
runtime error from `error n`, which jumps to a handler and, on the way out of
a procedure, skips its cleanup; see [Error numbers and
handlers](handlers.md).

### Activities

1. Make `ParseEndpoint` refuse an empty host, and check that `LoadSetting`
   adds its context to the new failure without any change of its own.
2. Change the loop to stop at the first failing setting, as a configuration
   loader that must not run with a half-read file would.
