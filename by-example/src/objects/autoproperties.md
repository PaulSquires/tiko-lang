# Auto-properties and property blocks

Most properties only store a value. An *auto-property* says so in one line:
the declaration ends in its accessors, and the compiler writes both of them
over a hidden field.

```tiko
{{#include ../../examples/objects/autoprops.tiko}}
```

**Output**

```text
{{#include ../../examples/objects/autoprops.out}}
```

- `get, set` reads and writes like a plain field.
- `get, private set` can be read anywhere but written only by the type's own
  code, as `Birthday` does. The setter may be less visible than the getter,
  never more.
- `get, init` (or `get` alone) can be read anywhere and assigned only by a
  constructor.
- `= 18` gives the hidden field its first value.

Writing a private setter from outside is refused:

```tiko
{{#include ../../examples/objects/autopropserror.tiko}}
```

```text
autopropserror.tiko(6,2): error TKO0625: 'age' is not accessible here
```

An auto-property has no code of its own. When the setter has a rule to keep,
write an ordinary property over a field of your own.

## Property blocks

A property block defines the getter and setter together, between `property`
and `end property`. The type declares them as usual.

```tiko
{{#include ../../examples/objects/propblock.tiko}}
```

**Output**

```text
{{#include ../../examples/objects/propblock.out}}
```

Inside both sections `value` is the value crossing the boundary:

- In `set`, it is the value being assigned. It can be changed before it is
  stored, as the absolute-zero check does.
- In `get`, it is the result. It starts at the type's default, and whatever it
  holds at `end get` is returned. `return` works too.

Either section can be left out: `Fahrenheit` has only a `get`. `get` and `set`
open a section only when they stand alone on their line.

## Static, indexed and namespace properties

```tiko
{{#include ../../examples/objects/staticprops.tiko}}
```

**Output**

```text
{{#include ../../examples/objects/staticprops.out}}
```

- A property can take **any number of indices**. The setter's value comes last.
- A `static` property belongs to the type, not to an object: `Grid.Created`.
  It can be an auto-property too.
- A property can live in a **namespace**, with no object at all.
- A property passed to a `byref` parameter is **written back** through its
  setter when the call returns, so `Bump` changes the cell.
- Compound assignment (`+=`, `&=`, ...) and `swap` call the getter and then
  the setter.

### Activities

1. Give `Person` an `Email` auto-property that only `Person` may change, and a
   `SetEmail` method that refuses a value with no `@`.
2. Turn `Settings.Level` into a property block over `level_`.
