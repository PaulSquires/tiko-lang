# Library demands: Hashable keys

The standard containers are generics, so they make demands of the types you
put in them. A `containers.Map( of K, V )` needs two things of its key type:
that two keys can be compared with `=`, and that a key can produce a hash.
Built-in types such as `int32` and `ustring` have both. Your own type supplies
them like this:

```tiko
{{#include ../../examples/generics/hashkey.tiko}}
```

**Output**

```text
{{#include ../../examples/generics/hashkey.out}}
```

`Cell` **extends `containers.Hashable`** and overrides its `HashOf( )`. The
map's code lives in the `std/containers` module and asks the key for its hash;
extending `Hashable` is how your type's hash becomes visible there. Inside the
override, `containers.HashOf( ... )` hashes each field.

`operator =` is not optional. The hash leads the map to the right bucket, and
equality decides which entry there is yours. Writing `Cell( 1, 1 )` a second
time finds the same entry, so the map still holds two cells.

A key type with `=` but no hash does not build:

```tiko
{{#include ../../examples/generics/nohash.tiko}}
```

```text
map.tiko(150,35): error TKO0632: no overload of 'hashof' matches these arguments
     |
 150 | dim as long i = cast( long, HashOf( k ) and cast( ulongint, mask ) )
     |                                   ^
```

As on the [previous page](constraints.md), the error is reported inside the
generic, here in the container module's own source.

```admonish warning title="Status in this version"
When the generic lives in a module, the error does not yet carry the
`note: in instantiation of` line that names your program's line, and it is
repeated for each place in the map's code that needs the hash. Look for the
`containers.Map( of ... )` your program declares.
```

Key types for every container are covered in
[Custom keys](../containers/custom-keys.md).

### Activities

1. Add a `containers.Set( of Cell )` and add the same cell twice. What is its
   count?
2. Make `HashOf( )` return `0` for every cell. Does the program still work?
   What would that cost with a million cells?
