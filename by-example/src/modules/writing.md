# Writing a module

A module of your own is a directory of source files. The directory's name is
the module's name, and every file in it says so on its first line:

```text
writing.tiko
greet/
    greet.tiko
```

```tiko
{{#include ../../examples/modules/greet/greet.tiko}}
```

The program imports the directory by a path relative to itself:

```tiko
{{#include ../../examples/modules/writing.tiko}}
```

**Output**

```text
{{#include ../../examples/modules/writing.out}}
```

- **`#module "greet"`** must be the first directive of every file of the
  module (comments may come before it), and the name must match the directory.
- **`#import "./greet"`** starts with `./`, so it is looked for beside the
  importing file. The import binds `greet`, and the program calls
  `greet.Hello`.
- **`public`** marks what importers may use: `Hello` and `DEFAULT_NAME`.
  `Capitalise_` has no keyword, so it belongs to the module alone. The
  [next page](visibility.md) shows the three levels.

`tiko writing.tiko` finds the `greet` directory, compiles it, caches the
result, and links it in. A module may hold as many files as it needs; together
they form one module. Inside a module, declaration order does not matter: a
file can call a procedure declared further down, or in another file of the
module, without a `declare` line. `Hello` calls `Capitalise_` before it is
declared.

### Activities

1. Add a public `Goodbye` function to `greet` and call it from the program.
2. Change the name in `#module` to `"greeter"` and read the diagnostic.
