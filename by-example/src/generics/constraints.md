# What a type parameter asks for

`( of T )` does not say what `T` can do. The compiler therefore checks a
generic's body once for each type it is used with, against that real type. If
the body uses an operator the type does not have, that instantiation fails.

```tiko
{{#include ../../examples/generics/needsgt.tiko}}
```

`Version` has no `>`, so this does not build:

```text
needsgt.tiko(5,14): error TKO0720: no operator > compares this type
     |
   5 |         if x > best then best = x
     |              ^
needsgt.tiko(15,21): note: in instantiation of 'largest( of version )'
     |
  15 | var newest = Largest( releases() )      '' Version has no '>'
     |                     ^
```

The error points at the generic's body, which is correct code. The cause is
in the `note:` under it: line 15 asked for `Largest( of Version )`. Read an
error from a generic to the end before you edit anything.

The fix is on the type's side: give `Version` the operator the generic uses.

```tiko
{{#include ../../examples/generics/ordered.tiko}}
```

**Output**

```text
{{#include ../../examples/generics/ordered.out}}
```

`Largest` did not change. The same generic serves `int32`, which has `>`
built in, and `Version`, which now has one of its own. Because a generic's
demands are not written in its header, state them in a comment above it, as
this one does.

### Activities

1. Write a generic `Contains( of T )( items() as T, byval x as T )` and use it
   with `Version`. Which operator does it need?
2. Remove the `>` operator and add a `<` instead. Does the error change?
