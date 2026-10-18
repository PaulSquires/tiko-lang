# Virtual methods

A derived type can declare a method with the same name as one in its base.
Whether code written for the base then reaches the derived version depends on
one word, `virtual`. Without it, the type of the *variable* decides:

```tiko
{{#include ../../examples/inheritance/hiding.tiko}}
```

**Output**

```text
{{#include ../../examples/inheritance/hiding.out}}
```

`Dog.Sound` *hides* `Animal.Sound`: on a `Dog`, `Sound` means the dog's.
But inside `Speak` the parameter is an `Animal`, so `a.Sound( )` is compiled
as a call to `Animal.Sound`, whatever object arrives. That is the right
behaviour for most methods, and it costs nothing at run time.

When code that sees "an animal" must reach each object's own method, make
the method virtual:

```tiko
{{#include ../../examples/inheritance/virtual.tiko}}
```

**Output**

```text
{{#include ../../examples/inheritance/virtual.out}}
```

Three things changed:

- **`extends Object`.** `Object` is the built-in root type. Extending it
  gives every object a hidden pointer to its type's table of virtual
  methods, which is how a call finds the right code at run time.
- **`virtual`** on `Animal.Sound` says derived types may replace it. A call
  to it goes through the table, so it reaches the version that belongs to
  the object really there.
- **`override`** on `Dog.Sound` and `Cat.Sound` says each replaces a virtual
  method. The compiler checks there is one to replace; see
  [Overriding](override.md).

`Introduce` is not virtual, yet its answer differs for every animal, because
the call to `Sound` *inside* it is virtual. The base writes the procedure
once; the derived types supply the part that differs. The array of
`Animal ptr` shows the payoff: one loop over many types, with no `select
case` on what each one is.

A virtual call is an indirect call through the table, a few instructions
more than a direct one, and the hidden pointer adds 8 bytes to every object
(see [Slicing](slicing.md)). Make a method virtual because a derived type
needs to replace it.

### Activities

1. Add a `Cow` to `virtual.tiko` and put it in the `zoo` array. What did you
   have to change outside `Cow` itself?
2. Remove `virtual` from `Animal.Sound` and read the compiler's message for
   the `override` lines.
