# Checked builds

The same source can be built to find bugs or to run fast. A **checked build**
adds code that tests every array index and every pointer, and stops the
program at the first bad one, with its location:

```tiko
{{#include ../../examples/building/checked.tiko}}
```

**Output**

```text
{{#include ../../examples/building/checked.out}}
```

The program exits with code 6, the number of the runtime error, and the
message goes to standard error. It names the line, the procedure and the
array, the index used and the bounds the array has, which is usually enough to
see the bug without a debugger: the loop runs to `count`, and the caller passed
one more than the array holds.

Without `-exx`, nothing checks the index. The same program reads whatever
memory lies past the end of the array, adds it to the total, and prints a
number as if nothing were wrong.

| Build | Options | Use it for |
|---|---|---|
| checked | `-exx`, often with `-g` | development and tests |
| release | `-O2` or `-O3` | the program you ship |

The checks cost time: every index is compared with both bounds, and every
pointer with null. Test with the checks on and ship with them off, or, for a
program where a wrong answer costs more than speed buys, ship checked. The
parts of `-exx` are available one at a time as `-earray`, `-enullptr` and
`-elocation`.

[Arrays](../arrays/index.md) and [Error Handling](../errors/index.md) say more
about the errors themselves.

### Activities

1. Remove the `#cmdline` line, build again, and run the program.
2. Replace `-exx` with `-earray` and compare the message.
