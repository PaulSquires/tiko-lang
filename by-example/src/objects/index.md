# Objects

A record from [Custom Types](../custom-types/index.md) holds data and leaves
every rule about that data to the code around it. An *object* is a type that
also carries procedures of its own, its *methods*, so the code that looks
after the data lives with the data.

```tiko
{{#include ../../examples/objects/objects.tiko}}
```

**Output**

```text
{{#include ../../examples/objects/objects.out}}
```

A method is declared inside the type with `declare` and defined outside it,
under the name `Type.Method`. It is called on an object with a dot:
`clicks.Increment( )`.

Inside a method, the object it was called on is `this`. A field can be named
on its own, as `Increment` does with `count`, or as `this.count`, which you
need when a parameter or local has the same name as the field.

Methods cost nothing per object: `sizeof( Counter )` is 4, the size of its
one `int32` field. A method call is an ordinary procedure call with the
object passed in by reference.

The rest of this section:

| Page | Covers |
|---|---|
| [Constructors](constructors.md) | how objects are created |
| [Destructors](destructors.md) | what runs when they go away |
| [Properties](properties.md) | methods that read and write like fields |
| [Access control](access.md) | `public:` and `private:` |
| [Static members](static.md) | fields and methods that belong to the type |
| [Const methods](const.md) | methods that promise not to change the object |
| [Operator overloading](operators.md) | `+`, `=`, `<`, `let`, `+=` on your own types |
| [Indexing](indexing.md) | `operator []` |
| [Copying](copying.md) | copy constructors and `operator let` |

Types that build on other types are in [Inheritance](../inheritance/index.md).

### Activities

1. Add a `Reset` method to `Counter` that sets the count back to 0.
2. Add a method `Add` that takes another `Counter` and adds its count,
   then call `clicks.Add( errors )`. Two methods may share a name when their
   parameters differ.
