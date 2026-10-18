# assert in tests

Not every check needs a test library. `assert( condition )` checks a condition
while the program runs, does nothing when it holds, and stops the program when
it does not. It suits quick self-checks in a small test program, and checks of
assumptions inside the code itself.

```tiko
{{#include ../../examples/testing/asserts.tiko}}
```

**Output**

```text
{{#include ../../examples/testing/asserts.out}}
```

Every condition held, so the only output is the program's own line. When one
fails:

```tiko
{{#include ../../examples/testing/assertfail.tiko}}
```

**Output**

```text
{{#include ../../examples/testing/assertfail.out}}
```

The program exits with code 1. The message goes to standard error and names
the file, the line, the procedure (in capitals) and the condition as written.
The first failure ends the program, so `not reached` is never printed: unlike
a test library's assertions, `assert` cannot report two failures in one run.

**`assert` is compiled in only when you ask for it.** `-eassert` turns it on,
and so does `-g`. Built without either, every `assert` vanishes from the
program, and `assertfail.tiko` would print `not reached` and exit with 0. So
never put work the program needs inside an `assert`: the call disappears with
the check.

`assertwarn( condition )` is the gentler form: it prints the same message and
lets the program carry on.

More on errors at run time is in [Error Handling](../errors/index.md).

### Activities

1. Remove the `#cmdline` line, build `assertfail.tiko` again, and run it.
2. Change the second `assert` to `assertwarn` and see what is printed now.
