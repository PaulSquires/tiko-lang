# Inheritance

When one type is a more specific kind of another, a bicycle being a kind of
vehicle, `extends` lets it start as the general type and add to it. The
derived type gets every field and method of its base without repeating them,
and it can be handed to any code written for the base.

```tiko
{{#include ../../examples/inheritance/inheritance.tiko}}
```

**Output**

```text
{{#include ../../examples/inheritance/inheritance.out}}
```

`type Bicycle extends Vehicle` makes `Bicycle` a `Vehicle` with one more
field. `bike.speed` and `bike.Describe( )` work although `Bicycle` declares
neither; they are inherited.

**The base part is built first.** `base( 2 )`, the first statement of the
`Bicycle` constructor, chooses which `Vehicle` constructor builds the
`Vehicle` part and with what. Leave it out and the base's default constructor
runs instead. [Calling the base](base.md) covers this further.

**The layout is the base's, then the new fields.** The offsets show
`wheels` and `speed` exactly where they are in a `Vehicle`, with `gears`
after them. A `Bicycle` starts with a complete `Vehicle`, which is why
`Report`, written for a `Vehicle`, accepts `bike` as it is.

A type extends exactly one base. To be several things at once, it implements
[interfaces](interfaces.md) instead: any number of them, beside its one base.

The pages in this section:

| Page | Covers |
|---|---|
| [Virtual methods](virtual.md) | letting the object, not the variable, choose the method |
| [Overriding](override.md) | `override`, and when an override can be overridden again |
| [Abstract methods](abstract.md) | methods every derived type must supply |
| [Calling the base](base.md) | `base( ... )` and `base.Method( )` |
| [Runtime type checks](is.md) | `is` |
| [Interfaces](interfaces.md) | `interface`, `implements` and `class`: a contract any type can take on |
| [Several interfaces](multiple.md) | one type, many contracts; renamed and private mappings; `trycast` |
| [Virtual destructors](destructors.md) | deleting through a base pointer |
| [Slicing](slicing.md) | what passing by value does to a derived object |

### Activities

1. Add a `Truck` that extends `Vehicle` with a `load` field and a
   constructor passing 6 to `base( ... )`, and pass one to `Report`.
2. Print `offsetof( Truck, load )` and explain the number.
