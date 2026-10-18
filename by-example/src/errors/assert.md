# assert

An *assertion* states something that must be true if the program is correct.
`assert( condition )` stops the program when the condition is false;
`assertwarn( condition )` reports it and carries on.

```tiko
{{#include ../../examples/errors/assert.tiko}}
```

**Output**

```text
{{#include ../../examples/errors/assert.out}}
```

The first call passes a count of 5000. That is allowed but unusual, so
`assertwarn` reports it and `Average` goes on. The second call passes 0, which
the function cannot work with: `assert` reports it and ends the program with
exit status 1. Each report names the file, the line, the procedure and the
condition as written.

Both report on **standard error**, not standard output, so the messages stay
out of a program's normal output even when that is redirected to a file.

Assertions are compiled in only when asked for: `-g`, the debugging option,
turns them on, and so does `-eassert` on its own. In a build without either,
`assert` and `assertwarn` compile to nothing at all, so they cost nothing in a
release and can stay in the code.

```admonish danger title="Pitfall"
Because an assertion may not be compiled in, it must never be the only thing
standing between the program and a crash. Without `-g`, `Average( 10, 0 )`
skips the check and divides by zero. An assertion documents and checks a
promise the *program* makes; input from outside it is checked with ordinary
code and reported with a [Result](result.md).
```

### Activities

1. Compile without `#cmdline "-g"`. What happens to the two messages, and to
   the program?
2. Add `assert( total >= 0 )` and call `Average( -5, 1 )`.
