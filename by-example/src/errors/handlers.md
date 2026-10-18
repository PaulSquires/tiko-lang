# Error numbers and handlers

A *runtime error* is a numbered failure that stops the normal flow of the
program. The runtime raises them itself, for a bad index under `-exx` or an
empty `Optional`, and your code can raise one with `error n`. Unhandled, it
ends the program with that number as the exit status. `on local error goto`
installs a handler that catches it instead.

```tiko
{{#include ../../examples/errors/handlers.tiko}}
```

**Output**

```text
{{#include ../../examples/errors/handlers.out}}
```

`on local error goto failed` installs a handler for the rest of the
procedure. When anything it calls raises an error, control jumps to the
`failed:` label, and these describe what happened:

| Function | Gives |
|---|---|
| `err` | the error number |
| `erl` | the line it was raised on |
| `erfn( )` | the procedure it was raised in, as a `zstring ptr` |
| `ermn( )` | the source file it was raised in, as a `zstring ptr` |

**Copy `err` before doing anything else.** The next call into the runtime,
such as a `print`, resets it to 0. `erfn( )` needs the location information
that `-exx` compiles in; without it, it gives an empty name.

Some of the numbers the runtime itself raises:

| Number | Meaning |
|---|---|
| 1 | illegal function call: `Value( )` of an empty `Optional`, for one |
| 6 | an array index out of bounds (`-exx`) |
| 7 | a null pointer followed (`-exx`) |
| 11 | a floating-point error signal; under `-exx` that includes an integer division by zero |

A handler can inspect the error, clean up and leave the procedure. It cannot
go back into the code that failed: tiko has no `resume`.

```tiko
{{#include ../../examples/errors/noresume.tiko}}
```

```text
noresume.tiko(7,8): error TKO0409: 'RESUME' is not available in the fb dialect
     |
   7 | resume next                 '' tiko has no resume
     |        ^
```

````admonish danger title="Pitfall"
**When an error jumps out of a procedure to a handler further out, that
procedure's destructors and `defer` statements do not run.**

```tiko
{{#include ../../examples/errors/escape.tiko}}
```

```text
{{#include ../../examples/errors/escape.out}}
```

`Transfer` opens a `Connection` and schedules a `defer`, and neither the
destructor nor the deferred `print` runs. The handlers in the first example
are different: each sits in the procedure that raised the error and leaves it
with `exit sub`, so its locals are cleaned up as usual. Keep handlers next to
the resources they protect, or report failures with a [Result](result.md),
which returns like any other value.
````

### Activities

1. Move the `on error goto` and the handler into `Transfer`. What does
   `escape.tiko` print now?
2. Print `*ermn( )` in `Report`'s handler.
