# Searching

`containers.IndexOf( xs, v )` returns the index of the first element equal to
`v`, or -1 when there is none; `containers.Contains( xs, v )` says whether there
is one. Both look at the elements one at a time, from the front.

```tiko
{{#include ../../examples/containers/searching.tiko}}
```

**Output**

```text
{{#include ../../examples/containers/searching.out}}
```

`IndexOf` and `Contains` are free procedures rather than members of `Array`
because they need `=` on the element type. A member would demand `=` of every
element type an `Array` is ever declared with; a free procedure asks only where
it is called.

On a **sorted** array, a binary search finds a value by halving the range at
each step: about 20 looks for a million elements, where `IndexOf` may need a
million. The module has no binary search of its own, so `BinarySearch` here is
written out; it relies on the array being sorted, which is why the example
calls `Sort` first. When you search the same values often, an
[`OrderedSet`](ordered.md) keeps them sorted for you, and a [`Set`](set.md)
answers `Contains` without searching at all.

## The value must have the element's type

`IndexOf` and `Contains` are generic, and their type is inferred from **both**
arguments, exactly. That is why the example puts 85 and 60 in `int32`
variables instead of writing them as literals:

```tiko
{{#include ../../examples/containers/searchliteral.tiko}}
```

```text
searchliteral.tiko(4,26): error TKO0809: cannot infer the type arguments of 'contains'; write them, as 'contains( of ... )( ... )'
```

The literal `90` is an `integer`, and the array holds `int32`s, so no single
element type fits both. Pass a variable of the element type, or name the type
as the message suggests: `containers.Contains( of int32 )( scores, 90 )`.

### Activities

1. Make `BinarySearch` return the first of several equal values (the array
   holds 85 twice).
2. Use `cast( int32, 85 )` as the second argument of `IndexOf`.
