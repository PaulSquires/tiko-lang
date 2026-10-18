# Explicit type arguments

The compiler infers type arguments from a call's *arguments*, and from
nothing else. When that is not enough, you write them yourself, after the
name: `Larger( of float64 )( ... )`.

```tiko
{{#include ../../examples/generics/explicit.tiko}}
```

**Output**

```text
{{#include ../../examples/generics/explicit.out}}
```

There are two situations where you must write them:

- **The arguments disagree.** `2` is an integer and `2.5` is a `float64`, so
  the arguments would bind `T` to two different types, and inference does not
  pick a winner. With `( of float64 )` written, both arguments convert to
  `float64`.
- **`T` is only in the result.** `Blank( of T )( )` has no parameters, so
  there is nothing to infer from. A new `int32` is `0` and a new `ustring` is
  empty.

Leave the type out where the arguments disagree and the program does not
build:

```tiko
{{#include ../../examples/generics/noinfer.tiko}}
```

```text
noinfer.tiko(6,13): error TKO0809: cannot infer the type arguments of 'larger'; write them, as 'larger( of ... )( ... )'
     |
   6 | print Larger( 2, 2.5 )          '' an integer and a float64: which T?
     |             ^
```

### Naming an instantiation

`type Score as Pair( of ustring, int32 )` gives an instantiation a short name.
It is an alias, not a new type: `best` is a `Score`, `same` is a
`Pair( of ustring, int32 )`, and one assigns to the other. An alias is the
usual way to keep a long generic type readable when it appears in several
signatures; [Result](../errors/result.md) uses one for that reason.

### Activities

1. Call `Larger( of int32 )( 2, 2.5 )`. What does it print, and why?
2. Add `type Point as Pair( of float64, float64 )` and use it.
