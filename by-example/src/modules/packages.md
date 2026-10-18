# Packages

Modules that sit beside one program are enough for that program. Modules meant
for several programs become a **package**: a directory tree of modules with a
`tiko.toml` at its root naming the package. A program that uses the package
says where to find it, in a `tiko.toml` of its own.

```text
units/
    tiko.toml
    length/length.tiko
    temperature/temperature.tiko
app/
    tiko.toml
    main.tiko
```

```toml
{{#include ../../examples/modules/units/tiko.toml}}
```

```tiko
{{#include ../../examples/modules/units/length/length.tiko}}
```

```tiko
{{#include ../../examples/modules/units/temperature/temperature.tiko}}
```

The program's `tiko.toml` names the dependency by path, and declares the
program it builds:

```toml
{{#include ../../examples/modules/app/tiko.toml}}
```

```tiko
{{#include ../../examples/modules/app/main.tiko}}
```

Built with `tiko build` in the `app` directory, and run as
`out/debug/convert`:

**Output**

```text
{{#include ../../examples/modules/app/main.out}}
```

- **`[package] name`** is the package's name. The module `length` inside
  `units` has the full name `units.length`, so it never collides with a
  `length` module from another package. The program still calls it `length`,
  the last part of the import path.
- **`[dependencies]`** maps a package name to a directory, relative to the
  `tiko.toml`. An import whose first part is `units` is looked for there. The
  dependency is written in the repository, so a fresh checkout builds with no
  setup.
- **`[target.convert]`** declares an executable built from `main.tiko`. The
  [Building](../building/projects.md) section covers targets, profiles and
  `tiko build`.

`tiko --print-graph main.tiko` lists the modules a program imports, in the
order they are built, with the directory each came from. For this program it
prints the standard library's modules and then:

```text
units.length       ../units/length
units.temperature  ../units/temperature
```

### Activities

1. Add a module `units/weight` with a public `ToPounds` and use it from the
   program.
2. Rename the dependency in `app/tiko.toml` to `measures` without changing
   the imports, and read what the build says.
