# Interfaces

An *interface* is a promise that a type can do certain things, with nothing
said about how. In tiko it is an abstract type with no data: a list of
[abstract methods](abstract.md) that any type can extend and fill in.

```tiko
{{#include ../../examples/inheritance/interfaces.tiko}}
```

**Output**

```text
{{#include ../../examples/inheritance/interfaces.out}}
```

`Encoder` is all contract: two abstract methods, no fields and no code.
`IniEncoder` and `JsonEncoder` each extend it and supply both methods, and
neither knows the other exists.

`Save` is written against `Encoder` alone. It runs unchanged for every
encoder there is, including ones written after it, because all it relies on
is the contract. Adding a third format means writing one new type; `Save`
does not change.

`implements`, the keyword some languages use for this, is reserved in tiko
but has no meaning yet, so a type cannot declare that it implements a
contract on top of extending a base:

```tiko
{{#include ../../examples/inheritance/implements.tiko}}
```

```text
implements.tiko(6,43): error TKO0420: expected the end of the statement
     |
   6 | type IniEncoder extends Object implements Encoder
     |                                           ^
```

A type extends exactly one base. When a type needs to be two things at once,
let it extend the contract that callers use it through, and give it the
other part as a field.

```admonish warning title="Status in this version"
A second base in the list, `type C extends A, B`, should be an error. In this
version it is accepted silently, and everything after the first base is
ignored: `C` gets `A`'s members and none of `B`'s.
```

An object that is used only through its contract is often created with `new`
and kept as a pointer to the contract type. Give such a contract a
[virtual destructor](destructors.md) so that deleting through that pointer
runs the right one.

### Activities

1. Add a `CsvEncoder` that writes `width,640`, and pass one to `Save`.
2. Give `Encoder` a third abstract method, `Footer( )`, and see which types
   the compiler then refuses to create.
