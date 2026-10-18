# Destructors

A *destructor* runs when an object goes away. It is where an object gives
back what it holds: memory, a file, a lock. Because the compiler calls it for
you, the clean-up cannot be forgotten on any path out of a scope.

```tiko
{{#include ../../examples/objects/destructors.tiko}}
```

**Output**

```text
{{#include ../../examples/objects/destructors.out}}
```

An object is destroyed when the block that declared it ends:

| Declared in | Destroyed |
|---|---|
| a `scope` or other block | at its end |
| a procedure | when the procedure returns |
| a loop body | at the end of every pass |
| an expression, as a temporary | when the statement finishes |
| the program's top level | when the program ends |

**Objects in one block are destroyed in reverse order of creation**: `second`
before `first`. Something created later may depend on something created
earlier, never the other way round, so this order is always safe.

A type has one destructor, with no parameters. If you do not write one, the
compiler still destroys every field: a field that is itself an object gets
its destructor, and a `ustring` field frees its text, without your help.

Objects made with `new` live until you `delete` them; they are covered in
[Memory and Resources](../memory/index.md). When a type is meant to be
destroyed through a pointer to its base type, its destructor must be
`virtual`: see [Virtual destructors](../inheritance/destructors.md).

### Activities

1. Add a third `Tracer` to the scope and predict the order of the lines.
2. Put `exit for` in the loop on the first pass. Does `lap` still get its
   destructor?
