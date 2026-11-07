# Properties

A *property* is a pair of methods that reads and writes like a field. The
caller writes `t.Celsius = 21.5` and `print t.Celsius`, and the type runs code
on each side: that is where it checks the value, converts it, or computes it
from other fields.

```tiko
{{#include ../../examples/objects/properties.tiko}}
```

**Output**

```text
{{#include ../../examples/objects/properties.out}}
```

A property is declared with `property` instead of `sub` or `function`:

- The **getter** takes no value and returns one: `property Celsius( ) as
  float64`. It runs wherever the property is read.
- The **setter** takes the new value and returns nothing. It runs wherever
  the property is assigned, and it is the place the type defends its rules:
  asking for -500 degrees gives absolute zero.
- A property with **only a getter** is read-only. `Fahrenheit` is computed
  from `celsius_` every time, so it can never disagree with it.
- A property can take an **index**, as `Preset( slot )` does. It then reads
  like an array whose elements the type controls.

A property with only a setter can be assigned but never read:

```tiko
{{#include ../../examples/objects/writeonly.tiko}}
```

```text
writeonly.tiko(14,8): error TKO0934: 'code' is a property with only a setter: it can be assigned, not read
     |
  14 | print d.Code                        '' refused: there is no getter
     |        ^
```

The fields behind the properties are `private:`, which is what makes the
setter's rule hold: nothing outside the type can write `celsius_` directly.
[Access control](access.md) explains the sections.

When a property only stores a value, an [auto-property](autoproperties.md)
writes both accessors for you, and a [property block](autoproperties.md#property-blocks)
keeps a getter and setter together in one place.

### Activities

1. Add a read-write `Kelvin` property that stores into the same `celsius_`
   field.
2. Make the `Preset` setter ignore a slot outside 1 to 3 instead of writing
   past the array.
