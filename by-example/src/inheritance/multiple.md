# Several interfaces

A type has one base, but it can implement any number of interfaces. That is
how one type becomes several things at once: a shape that is also a document,
a document that is also a resource to close.

```tiko
{{#include ../../examples/inheritance/multiple.tiko}}
```

**Output**

```text
{{#include ../../examples/inheritance/multiple.out}}
```

`Drawing` lists three interfaces on one `implements` line; it could equally
write one line per interface. Each member is then mapped on its own:

- **Two interfaces have a `Name`**, and they mean different things: a shape's
  title, a document's file. They are different members, so each gets its own
  method. A method's name does not have to match the member's: `Title`
  implements `IShape.Name`.
- **One method can provide several members.** `Close` implements
  `IDocument.Close` and `IResource.Close` at once.
- **A private method can provide a member.** `WriteOut` cannot be called on a
  `Drawing` from outside (`TKO0625`), yet `doc.Save( )` reaches it.

**`trycast( IResource, s )`** asks the object behind the `IShape` whether it
also implements `IResource`, and gives an `IResource` for the same object if it
does, or an empty one, equal to `nullptr`, if it does not. `s is Drawing` asks
what the object really is. Both work with an interface on either side; see
[Runtime type checks](is.md).

With abstract base types, none of this has a spelling: the type has room for
one base, so it can follow one contract.

```tiko
{{#include ../../examples/inheritance/twobases.tiko}}
```

```text
twobases.tiko(10,27): error TKO0427: a type extends one base type
     |
  10 | type Drawing extends Shape, Saveable
     |                           ^
```

### Activities

1. Add an `IPrintable` interface with `sub Show( )` to `Drawing`, mapped to a
   private method, and call it through an `IPrintable`.
2. Make `Close` print which interface it was called through. Why can it not
   tell?
3. Write a `Label` type that implements only `IShape`, and check with
   `trycast` that it is not an `IDocument`.
