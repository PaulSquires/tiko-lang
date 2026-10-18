# Abstract methods

Some base types cannot say how to do something, only that every derived type
can. A `Shape` has no area of its own, yet every shape has one. An `abstract`
method is a virtual method with no body: the base declares it, and each
derived type must supply it.

```tiko
{{#include ../../examples/inheritance/abstract.tiko}}
```

**Output**

```text
{{#include ../../examples/inheritance/abstract.out}}
```

`declare abstract function Area( ) as float64` declares the method and
nothing else; there is no `Shape.Area` body anywhere. `Rect` and `Circle`
each supply both abstract methods with `override`, and `Shape.Describe`,
written once in the base, calls whichever versions the object really has.

A type with an abstract method is incomplete on purpose, so no object of it
can exist; there would be nothing to run if someone asked for its area:

```tiko
{{#include ../../examples/inheritance/abstracterror.tiko}}
```

```text
abstracterror.tiko(5,14): error TKO0620: 's' has an abstract type, which cannot be instantiated
     |
   5 | dim as Shape s                      '' refused: Area has no body
     |              ^
```

A derived type that leaves any abstract method unwritten is abstract too, and
refused with the same error. What *can* exist is a `Shape ptr`, or a `byref`
parameter of type `Shape`, referring to an object of a complete type, as the
`shapes` array does.

Like `virtual`, `abstract` needs a type that extends `Object`: on any other
type it is refused with `TKO0645: 'area' is virtual, but its type does not
extend 'object'`.

### Activities

1. Add a `Triangle` with a base and a height, and put one in the array.
   Which existing lines did you have to change?
2. Leave `Name` out of `Triangle` and read the error.
