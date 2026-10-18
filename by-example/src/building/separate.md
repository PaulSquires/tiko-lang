# Separate compilation

A large program is built a part at a time. `-c` compiles a source file
without linking it, into an **object file**; a later command links the
objects into a program. A part whose source has not changed need not be
compiled again.

```tiko
{{#include ../../examples/building/separate/greet.tiko}}
```

```tiko
{{#include ../../examples/building/separate/main.tiko}}
```

Built with two commands:

```bash
tiko -c greet.tiko
tiko main.tiko greet.o
```

**Output**

```text
{{#include ../../examples/building/separate/main.out}}
```

- **`tiko -c greet.tiko`** writes `greet.o`.
- **`tiko main.tiko greet.o`** compiles `main.tiko` and links it with the
  object. `main.tiko` declares `Greet` with `declare`, because it is compiled
  on its own and knows only what it has been told.
- **The first file named is the main one.** Its top-level code is the program.
  The top-level code of every other file runs before it, which is why
  `greet.tiko is set up` comes first.

For your own code, [modules](../modules/writing.md) do this job with no
`declare` lines and no build commands: `#import` compiles each module once and
caches it. Separate compilation is what you use with code that is not a
module, and underneath every [library](libraries.md).

### Activities

1. Name the object file first: `tiko greet.o main.tiko`. Does the order
   change the output?
2. Remove the `declare` line from `main.tiko` and read the diagnostic.
