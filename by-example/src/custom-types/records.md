# Records

A `type` declares a record: a set of named fields that travel together as
one value. Each field has a name and a type, and that type can itself be a
record.

```tiko
{{#include ../../examples/custom-types/records.tiko}}
```

**Output**

```text
{{#include ../../examples/custom-types/records.out}}
```

`as int32 x, y` declares two fields of one type on one line, the same way
`dim` declares variables. A field may carry a starting value, as `size`,
`title` and `visible` do; every new `Frame` starts with those values, and the
fields without one start at zero, or `""` for text.

A list in parentheses, `( 3, 4 )`, fills the fields of a record in the order
they are declared. A record nested inside another takes its own list, as in
`size as Point = ( 640, 480 )`.

A dot reaches a field, and a chain of dots reaches into nested records:
`w.size.x`. A whole record can be assigned at once, as `w.origin = corner`
does.

Assignment **copies** every field, text included. Changing `twin` afterwards
leaves `w` as it was: two record variables never share their contents.

Records cannot be compared with `=` until you define what equality means
for them: `a = b` on two `Point`s is error
`TKO0720: no operator = compares this type`.
[Objects](../objects/index.md) shows how to define it. Field layout and padding
are on the [Sizes](../types/sizes.md) page.

### Activities

1. Add a `Rect` type holding two `Point`s, and print its width and height.
2. Write a function that takes a `Point` and returns a new one moved by 10
   in each direction.
