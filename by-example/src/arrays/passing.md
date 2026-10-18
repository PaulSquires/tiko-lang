# Passing arrays

A procedure that takes an array writes the parameter as `name( ) as Type`, and
the caller passes `name( )`. The empty parentheses are required at both ends:

```tiko
{{#include ../../examples/arrays/passing.tiko}}
```

**Output**

```text
{{#include ../../examples/arrays/passing.out}}
```

An array is always passed **by reference**: `Fill` writes straight into the
caller's array, and nothing is copied however large the array is. To promise
that a procedure only reads, write the parameter `as const`, as `Sum` does.

The bounds travel with the array. `odd` runs from -2 to 2 and `Fill` sees
exactly that, which is why a procedure written between `lbound` and `ubound`
works on any array of the right type without being told its size.

A dynamic array can be resized by the procedure it was passed to: `Grow` adds
three elements to the caller's `list`.

A `const` array parameter is meant to refuse writes, so this should not
compile:

```tiko
{{#include ../../examples/arrays/constarray.tiko}}
```

````admonish warning title="Status in this version"
The program above compiles and prints 0: an element of a `const` array
parameter can be assigned, and the array can be resized with `redim`, without
an error. `for each byref` over one is refused, as it should be. Until this is
fixed, `as const` on an array parameter documents the intent but does not
enforce it.
````

The parameter states the number of dimensions with commas and nothing else:
`m( , ) as int32` takes any two-dimensional `int32` array, whatever its
bounds.

### Activities

1. Write `sub Reverse( values( ) as int32 )` that reverses an array in place,
   and test it on `small` and on `odd`.
2. Write `function Largest( m( , ) as const int32 ) as int32`.
