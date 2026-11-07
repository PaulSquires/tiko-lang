# Interfaces

An *interface* is a promise that a type can do certain things, with nothing
said about how. It lists methods and properties, and has no fields and no
code. Any type can take one on with an `implements` line, and a type can take
on as many as it needs without giving up its one base.

```tiko
{{#include ../../examples/inheritance/interfaces.tiko}}
```

**Output**

```text
{{#include ../../examples/inheritance/interfaces.out}}
```

`IEncoder` is all contract: two members, every one public and abstract, so
nothing else is written on them. `Save` is written against `IEncoder` alone. It
runs unchanged for every encoder there is, including ones written after it.

**`implements IEncoder`** at the top of a type's body takes the contract on.
Then each method says which member it provides: `implements IEncoder.Name`.
`IniEncoder` is a plain `type`, with no base and no table of virtual methods;
`JsonEncoder` is a **`class`**, a type that always extends `Object`. Both can
implement an interface, and `Save` cannot tell them apart.

**An interface value is a reference**: the object's address and the table that
type uses for this interface, 16 bytes. `Save( ini )` passes a reference to
`ini`, not a copy of it, and `enc.Name( )` is called with `.`. Because it only
refers to the object, the object must outlive it: a temporary, such as a
function's result, cannot be converted to an interface (`TKO1012`), and
`delete` through an interface is refused (`TKO1013`).

The mapping is explicit. A public `Name` with the right signature does not
implement `IEncoder.Name` until its declaration says so:

```tiko
{{#include ../../examples/inheritance/unmapped.tiko}}
```

```text
unmapped.tiko(7,16): error TKO1000: 'iniencoder' does not implement 'iencoder.name'; add 'implements iencoder.name' to one of its methods
     |
   7 |     implements IEncoder
     |                ^
unmapped.tiko(2,5): note: 'name' is required by interface 'iencoder', declared here
     |
   2 |     function Name( ) as ustring
     |     ^
```

Being explicit is what lets one type follow two contracts that use the same
member name for different things: see [Several interfaces](multiple.md).

An [abstract type](abstract.md) can serve as a contract too, and that is the
right choice when the base should also supply code that derived types share.
But a type extends exactly one base, so a contract written that way uses the
base up.

### Activities

1. Add a `CsvEncoder` that writes `width,640`, and pass one to `Save`.
2. Give `IEncoder` a third member, `function Footer( ) as ustring`, and read
   what the compiler says about each encoder until both provide it.
3. Rename `IniEncoder.Name` to `Label`, keeping `implements IEncoder.Name`.
   What changes in the output?
