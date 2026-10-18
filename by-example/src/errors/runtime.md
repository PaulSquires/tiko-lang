# Runtime errors

Some mistakes can only be found while the program runs: an array index out of
range, a pointer that is null. Compiled with `-exx`, a program checks for
them, and stops with a numbered *runtime error* that says what went wrong and
where, instead of reading memory it does not own.

```tiko
{{#include ../../examples/errors/bounds.tiko}}
```

**Output**

```text
{{#include ../../examples/errors/bounds.out}}
```

The loop's last pass asks for `scores( 3 )`. The check stops the program
before the read: runtime error 6, with the line, the array's name, the index
and the bounds it should have been within. The program's exit status is the
error number, 6, so a script that runs it can tell what happened.

`#cmdline "-exx"` puts the option in the source, so the file alone reproduces
the result. On the command line it is `tiko -exx bounds.tiko`.

`-exx` adds the array-bounds and null-pointer checks, and records the
procedure each runtime error happens in, so the message can name it.

The null-pointer check is shown in [nullptr](../memory/nullptr.md). Without
`-exx` neither check is made: the read past the end returns whatever is in
memory there, and nothing reports it. The message itself goes to standard
error, not standard output.

**Checks cost speed**: a comparison on every array access and a test on every
pointer dereference. Use `-exx` while developing and testing, and decide
deliberately whether a release build keeps it.

### Activities

1. Remove `#cmdline "-exx"` and run the program again. What does it print?
2. Change the loop to `for i as int32 = -1 to 2`. Which index does the
   message report?
