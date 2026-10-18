# Static assertions

Some facts about a program are known before it runs: the value of a constant,
the size of a type. `#assert` checks one of them while the program is being
compiled, and refuses to build it if the fact is false.

```tiko
{{#include ../../examples/errors/staticok.tiko}}
```

**Output**

```text
{{#include ../../examples/errors/staticok.out}}
```

Each `#assert` takes an expression the compiler can evaluate: constants,
arithmetic on them, and `sizeof`. All three hold here, so the program builds,
and the checks leave nothing behind in it: they cost nothing at run time.

Change a constant so that one no longer holds, and the build stops at that
line:

```tiko
{{#include ../../examples/errors/staticfail.tiko}}
```

```text
staticfail.tiko(5,1): error TKO0604: #assert condition failed
     |
   5 | #assert SLOTS * SLOT_BYTES <= 1024      '' 1280: refused
     | ^
```

The message does not say *why* the condition matters, so put that in a
comment on the same line, as these do: the comment is what the reader sees
next to the error.

Use `#assert` for decisions made in the source that other code depends on,
such as a table size that must be a multiple of four or a record that must
match a file format byte for byte. Facts known only at run time are checked
with [assert](assert.md).

### Activities

1. Add a `uint8` field to `Header`. Which assertion fails?
2. Assert that `SLOTS` is a power of two, using `and`.
