# Bounds checking

An index outside an array's bounds reads or writes memory that belongs to
something else. By default nothing stops it. Compiled with `-exx`, the program
checks every index and stops at the first bad one:

```tiko
{{#include ../../examples/arrays/bounds.tiko}}
```

**Output**

```text
{{#include ../../examples/arrays/bounds.out}}
```

`#cmdline "-exx"` puts the flag in the source, so the file builds the same way
wherever it is compiled. The program stops at the bad write with runtime error
6, prints which array was touched, with which index, and what the bounds are,
and exits with code 6. `print "not reached"` never runs. The message goes to
standard error.

The check works for dynamic arrays too. It reads the bounds the array has at
that moment, so after `redim preserve a( 1 to 2 )`, `a( 3 )` is caught.

`-exx` costs a comparison on every access. Use it while writing and testing a
program. Where an index comes from outside the program, such as input or a
calculation you are not sure of, check it yourself as well, because that check
is there in every build:

```tiko
{{#include ../../examples/arrays/guard.tiko}}
```

**Output**

```text
{{#include ../../examples/arrays/guard.out}}
```

Comparing against `lbound` and `ubound` works on any array. `ScoreAt` returns
-1 for an index outside them; [Error Handling](../errors/index.md) shows ways
to report a failure that cannot be confused with a real value.

### Activities

1. Change `i` to 0 in the first example and read the new message.
2. Remove `#cmdline "-exx"` and compile the program again. Do not rely on what
   it prints.
