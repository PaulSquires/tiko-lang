# Optional

`outcome.Optional( of T )` is a `T` that might not be there. Returning one
puts the possibility of "no answer" into the function's type, so a caller
cannot get the value out without deciding what to do when there is none. It
lives in the standard library's `std/outcome` module.

```tiko
{{#include ../../examples/errors/optional.tiko}}
```

**Output**

```text
{{#include ../../examples/errors/optional.out}}
```

| Procedure or member | Does |
|---|---|
| `outcome.Some( v )` | an `Optional` holding `v` |
| `outcome.None( of T )( )` | an `Optional` holding nothing |
| `o.HasValue( )` | whether there is a value |
| `o.Value( )` | the value; **a runtime error if there is none** |
| `o.ValueOr( d )` | the value, or `d` when there is none; never fails |
| `o.Clear( )` | drop the value and become empty |

`IndexOf` can now say "earth is at 2" and "pluto is not here" without
inventing an index that means nothing.

A few details matter in practice:

- **A new `Optional` is empty.** `dim later as outcome.Optional( of ustring )`
  holds no value; there is no third, uninitialised state.
- **`Some` takes its type from its argument.** `outcome.Some( i )` with an
  `int32` `i` is an `Optional( of int32 )`. A bare literal is an `integer`, so
  `outcome.Some( 42 )` does not convert to an `Optional( of int32 )`
  (`TKO0738`); write `outcome.Some( of int32 )( 42 )`. `None` has no argument
  to infer from, so its type is always written.
- **`Value( )` on an empty `Optional` is a bug at the call site**, and raises
  runtime error 1, "illegal function call".
  [Error numbers and handlers](handlers.md) shows it being caught. Ask
  `HasValue( )` first, or use `ValueOr( )`.

When the caller also needs to know *why* there is no value, use a
[Result](result.md) instead.

### Activities

1. Write `FirstNegative( a() as int32 )` returning an
   `Optional( of int32 )`, and use it with `ValueOr`.
2. Rewrite `Average` from the [section overview](index.md) to return an
   `Optional( of float64 )`.
