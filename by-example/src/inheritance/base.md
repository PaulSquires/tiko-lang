# Calling the base

A derived type usually adds to what its base does rather than replacing it.
`base` reaches the base's version of the work: `base( ... )` in a constructor
builds the base part, and `base.Method( )` calls the base's method from
inside the derived one.

```tiko
{{#include ../../examples/inheritance/base.tiko}}
```

**Output**

```text
{{#include ../../examples/inheritance/base.out}}
```

**`base( owner, opening )` chooses the base constructor.** It is the first
statement of the `Savings` constructor, and the `Account` part is built
before anything else runs, as the output shows. Its arguments choose among
the base's constructors like any overloaded call. Without a `base( ... )`
line, the base's default constructor runs.

**`base.Describe( )` calls `Account.Describe`**, even though `Describe` is
virtual and `this` is a `Savings`. A plain `Describe( )` there would call
`Savings.Describe` again, forever. Building on the base's text means the two
descriptions cannot drift apart.

The comment on `Account`'s constructor matters. A derived type is given a
copy constructor without writing one, and that free one starts by building
the base part with the base's *default* constructor. If the base has none,
the derived type cannot be copied, and the compiler says so at its
declaration:

```tiko
{{#include ../../examples/inheritance/nodefault.tiko}}
```

```text
nodefault.tiko(11,1): error TKO0926: 'savings' needs a copy constructor: its base has no constructor that takes no argument, so none can be made for it
     |
  11 | type Savings extends Account
     | ^
```

There are two ways out: give the base constructor's parameters default
values, as `base.tiko` does, or write the copy constructor yourself,
`declare constructor( byref other as const Savings )`, and call `base( ... )`
from it.

```admonish warning title="Status in this version"
`base( ... )` belongs on the first line of the constructor, but the compiler
does not yet insist on it. Written later, it is accepted without a word, and
whatever the constructor assigned to its own fields before it is lost:
`this.rate = rate` followed by `base( owner, opening )` leaves `rate` at 0.
Keep `base( ... )` first.
```

### Activities

1. Add a `Checking` type that extends `Account` with an `overdraft` field,
   and give it a `Describe` that builds on `base.Describe( )`.
2. Fix `nodefault.tiko` the second way, with a copy constructor of its own.
