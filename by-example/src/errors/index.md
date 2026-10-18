# Error Handling

Every program meets things that go wrong: input that does not parse, a value
that is not there, an index one past the end. The question is where the program
finds out, and whether the code that finds out can do something about it.

The oldest answer is a special return value that means "no answer". It is
only safe while that value can never be a real answer:

```tiko
{{#include ../../examples/errors/sentinel.tiko}}
```

**Output**

```text
{{#include ../../examples/errors/sentinel.out}}
```

Both calls return 0. One means "there were no readings", the other is the
true average of readings that cancel out, and the caller has no way to tell
them apart. The fix is a return type with room for "no answer" beside every
possible answer.

tiko gives you several tools, each for a different kind of failure:

| Tool | For | Page |
|---|---|---|
| `-exx` runtime checks | bugs: a bad index, a null pointer | [Runtime errors](runtime.md) |
| `assert`, `assertwarn` | conditions that must hold if the program is right | [assert](assert.md) |
| `outcome.Optional( of T )` | a value that may be absent, with no reason needed | [Optional](optional.md) |
| `outcome.Result( of T, E )` | a value, or the reason there is none | [Result](result.md) |
| returning a `Result` up | stopping at the first failure in a chain of calls | [Propagating errors](propagate.md) |
| `error n`, `on error goto` | numbered runtime errors and their handlers | [Error numbers and handlers](handlers.md) |
| `#assert` | facts about constants, checked while compiling | [Static assertions](static.md) |

The rule of thumb: a failure the caller is expected to handle belongs in the
return type, as an `Optional` or a `Result`. A failure that means the program
itself is wrong is an assertion or a runtime check.

### Activities

1. Change `Average` to return an `outcome.Optional( of float64 )` after
   reading the [Optional](optional.md) page.
2. Think of a function in your own code that returns `-1`, `0` or `""` to
   mean "nothing". Could that value ever be a real answer?
