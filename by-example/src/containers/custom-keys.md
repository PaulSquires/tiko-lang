# Keys of your own

Every built-in type can be a `Map` key or a `Set` element. A record type needs
two things before it can be one: `=`, to say when two keys are the same, and a
**hash**, a number computed from the key that decides where in the table it is
stored. You supply the hash by extending `containers.Hashable` and overriding
its `HashOf( )`:

```tiko
{{#include ../../examples/containers/customkey.tiko}}
```

**Output**

```text
{{#include ../../examples/containers/customkey.out}}
```

`probe` is a different variable from the `Cell( 2, 3 )` the entry was stored
under, with the same fields, and the map finds it: the two are equal, so they
hash the same and land in the same place. `containers.HashOf` has an overload
for every built-in type, so a key's hash is usually built from the hashes of
its fields, combined so that `( 2, 3 )` and `( 3, 2 )` do not come out equal:
`containers.HashInt` scrambles the row's hash before the `xor`, so the row and
the column are not interchangeable.

One rule makes it work: **equal keys must produce equal hashes.** Compute the
hash from exactly the fields that `=` compares. A hash that used a field `=`
ignores would put two equal keys in different places, and the map would lose
entries with no error.

Without a hash, the key type is refused when the `Map` is declared:

```tiko
{{#include ../../examples/containers/nohash.tiko}}
```

```text
map.tiko(150,35): error TKO0632: no overload of 'hashof' matches these arguments
```

The message points into the module's own `map.tiko`, where the hash is used,
not at your declaration. When you see `hashof` named in an error from inside
`std/containers`, a key type is missing its `HashOf( )`.

The [ordered containers](ordered.md) need no hash, only `<` on the key.
`extends` and `override` are covered in
[Inheritance](../inheritance/index.md).

### Activities

1. Give `Cell` a `label` field that `=` ignores, and check that `HashOf` must
   ignore it too.
2. Make the hash `containers.HashOf( row ) xor containers.HashOf( col )` and
   explain why `Cell( 2, 3 )` and `Cell( 3, 2 )` now collide, and why the map
   still works.
