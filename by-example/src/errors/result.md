# Result

An [Optional](optional.md) says *that* there is no answer. Often the caller
also needs to know *why*, and that is `outcome.Result( of T, E )`: a `T` on
success, or an `E` that explains the failure.

```tiko
{{#include ../../examples/errors/result.tiko}}
```

**Output**

```text
{{#include ../../examples/errors/result.out}}
```

| Procedure or member | Does |
|---|---|
| `outcome.Ok( of T, E )( v )` | a success holding `v` |
| `outcome.Fail( of T, E )( why )` | a failure holding `why` |
| `r.IsOk( )` | whether it succeeded |
| `r.Value( )` | the value; a runtime error if it failed |
| `r.Failure( )` | the reason; a runtime error if it succeeded |
| `r.ValueOr( d )` | the value, or `d` on failure |

`Ok` and `Fail` each take only one of `T` and `E` as a parameter, so the
compiler cannot infer the other, and **both type arguments are always
written**. That is why the result type is named once, with
`type PortResult as outcome.Result( of int32, ustring )`, and the long
spelling appears only where a value is built.

**A new `Result` is a failure.** `dim unset as PortResult` reports
`IsOk( )` false. Code that forgets to set a `Result` cannot claim success by
accident. Because both slots always exist, `T` and `E` must each be a type
that can be created with no arguments.

Within that rule `E` can be any type. A `ustring` is enough to tell a person what went wrong;
a type with a code field lets a program branch on the reason.

### Activities

1. Give `ParsePort` a fourth failure: a port below 1024 is "reserved".
2. Replace the `ustring` failure with a `type PortError` holding an `enum`
   code and a message, and print a different line for each code.
