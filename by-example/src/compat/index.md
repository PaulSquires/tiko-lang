# Compatibility

tiko is compatible with FreeBASIC: it implements FreeBASIC's `fb` dialect,
and a great deal of existing FreeBASIC code compiles with it unchanged. This
section is for reading and bringing over that code. It shows the older forms
tiko still accepts, the ones it refuses, and what modern tiko code writes
instead. Everywhere else on this site the modern forms are used.

Older code usually lives in `.bas` files, with `.bi` headers. tiko compiles a
`.bas` file exactly as it compiles a `.tiko` one:

```tiko
{{#include ../../examples/compat/classic.bas}}
```

**Output**

```text
{{#include ../../examples/compat/classic.out}}
```

The same program, written the way the rest of this site writes it:

```tiko
{{#include ../../examples/compat/modern.tiko}}
```

**Output**

```text
{{#include ../../examples/compat/modern.out}}
```

| Older form | Modern tiko |
|---|---|
| `.bas` sources, `.bi` headers | `.tiko` sources, `.ti` headers |
| `string` | `ustring`, which holds text rather than bytes ([next pages](strings.md)) |
| `long`, `integer` | `int32`, `int64`; `integer` only where pointer size is the point |
| `while` … `wend` | `do while` … `loop` |
| `+` to join strings | `&`, which also converts numbers |
| a counter and a loop | `for each`, and arrays with initialisers |

FreeBASIC has several dialects, chosen with `#lang`; tiko implements `fb`
only. Code that asks for another is refused:

```tiko
{{#include ../../examples/compat/dialect.bas}}
```

```text
dialect.bas(2,1): error TKO0317: unsupported language mode 'qb'; tiko-lang implements "fb" only
     |
   2 | #lang "qb"
     | ^
```

Code written for the `qb` or `fblite` dialects has to be brought across to
`fb`. The pages that follow cover the forms that matter most: [inline
data](data.md), [jumps and subroutines](jumps.md), and [type suffixes and the
two string types](strings.md).

### Activities

1. Rewrite `classic.bas` with `do while … loop` and `&`, keeping the `.bas`
   extension, and check it still compiles.
2. Rename `classic.bas` to `classic.tiko`. Does anything change?
