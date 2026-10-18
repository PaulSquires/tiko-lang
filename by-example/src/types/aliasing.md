# Aliasing

`type Name as T` gives an existing type a second name. The alias is the same
type under another name, so it costs nothing and converts nothing; what it
adds is meaning for the reader, or a shorter way to write a long type.

```tiko
{{#include ../../examples/types/aliasing.tiko}}
```

**Output**

```text
{{#include ../../examples/types/aliasing.out}}
```

`Celsius` is a `float64` and `UserId` a `uint32`; `sizeof` confirms it.
Because an alias is not a new type, a `Celsius` and a `float64` assign to each
other freely, as `plain` and `fromPlain` show. An alias documents intent, but
it will not stop you passing a `UserId` where a temperature was wanted. When
you need that protection, declare a [record](../custom-types/records.md)
with one field instead: two different record types never convert into each
other.

Aliases pay for themselves with long types. `Span` names a
[tuple](../primitives/tuples.md) type with two named elements, and from then
on parameters, results and variables can all say `Span`.

An alias can name a record type too: `Vec2` and `Point2D` are one type, so a
`Vec2` initialises a `Point2D` directly.

### Activities

1. Add `type Fahrenheit as float64` and assign a `Celsius` to it. Does the
   compiler object?
2. Write a function returning a `Span` that covers two other `Span`s.
