# Modules

A program of any size uses code it did not write: the standard library,
libraries of your own, packages from other people. tiko organises that code in
**modules**. A module is compiled once, shows the world only the names it marks
public, and keeps those names behind its own name, so two modules can both have
a `Parse` without colliding.

The standard library is a set of modules. You bring one into a file with
`#import`, and reach its names through the module's name:

```tiko
{{#include ../../examples/modules/importing.tiko}}
```

**Output**

```text
{{#include ../../examples/modules/importing.out}}
```

`#import "std/strings"` binds the name `strings`, the last part of the path.
After it, `strings.Replace` is the `Replace` procedure of that module, and
`containers.Array( of ustring )` is its `Array` type. A value of a module's type
behaves like one of your own: `words.Push` and `words.Count` need no prefix,
because a method belongs to its type.

Two rules apply to every import:

- **`#import` comes before any other code** in the file, including `#define`
  lines. An `#import` further down is `TKO0362`, "'#import' must come before
  any code".
- **The path is quoted and uses `/`** on every platform.

There is nothing to list on the command line: `tiko importing.tiko` reads the
imports, builds each module it needs (or takes it from the build cache), and
links the result.

The rest of this section shows how to [use names without the
prefix](using.md), [write a module](writing.md), decide [what it
exposes](visibility.md), [pass imports on](reexport.md), group modules into
[packages](packages.md), and keep names apart inside one file with
[namespaces](namespaces.md).

### Activities

1. Print `strings.Reverse( "tiko" )`.
2. Move one `#import` line below the first `print` and read the diagnostic.
