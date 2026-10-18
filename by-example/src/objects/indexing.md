# Indexing

A type that holds a sequence of values can let callers reach them with
square brackets, `r[ i ]`, while deciding for itself what an index means.
`operator []` is the procedure behind the brackets.

```tiko
{{#include ../../examples/objects/indexing.tiko}}
```

**Output**

```text
{{#include ../../examples/objects/indexing.out}}
```

`Recent` keeps the last four readings in a fixed array that it reuses in a
circle. Where the oldest reading sits in that array changes as readings
arrive, but callers never see it: `r[ 0 ]` is always the oldest, because the
operator turns the index into a position.

**`byref as int32` is the important part.** The operator returns the element
itself rather than a copy of its value, so `r[ i ]` can stand on the left of
`=`, and `r[ 3 ] += 1` updates the element in place.

`operator []` is declared inside the type and takes exactly one index, of
any type. A string index works as well as a number, which is how a
dictionary-like type offers `table[ "key" ]`. A second index is refused with
`TKO0789: operator '[]' takes 1 parameter(s) here`; for a grid, take a row
and column through a method or an indexed [property](properties.md) instead.

```admonish warning title="Status in this version"
An `operator []` that returns by value, without `byref`, should give a
read-only index. Reading through it works, but assigning to it stops the
build with `TKO0994: internal compiler error` rather than a proper
diagnostic. Return `byref` whenever the elements may be written.
```

The standard containers, such as `Array( of T )` and `Map( of K, V )`, use
this same operator: see [Containers](../containers/index.md).

### Activities

1. Make the capacity a constant and change `Recent` to keep the last eight
   readings.
2. Make `[]` refuse an index outside `0` to `Count( ) - 1` by stopping the
   program with an `assert`.
