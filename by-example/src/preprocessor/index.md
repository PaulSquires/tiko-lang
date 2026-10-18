# The Preprocessor

Before the compiler reads a word of a program, the **preprocessor** rewrites
its text. It replaces names with the text they stand for, keeps or drops whole
blocks of lines, and reports problems of its own. Every line that starts with
`#` is an instruction to it.

The simplest instruction is `#define`, which gives a name to a piece of text:

```tiko
{{#include ../../examples/preprocessor/defines.tiko}}
```

**Output**

```text
{{#include ../../examples/preprocessor/defines.out}}
```

- **`#define MAX_ITEMS 5`** makes every later `MAX_ITEMS` read `5`. The
  replacement is text, so `BANNER` becomes a whole expression, with
  `APP_NAME` replaced inside it.
- **`#undef`** removes a definition, and **`#ifdef`** asks whether a name is
  defined at that point in the file. The [conditional
  compilation](conditional.md) page covers the full family.
- **`const`** is the better tool for a plain value. A constant has a type and
  obeys scope, and a mistake in its value is reported where it is written,
  not at every use.

Use `#define` for what only the preprocessor can do: switches that choose
which code is compiled, names for the build to set from outside, and
[macros](macros.md) that generate code.

### Activities

1. Change `MAX_ITEMS` to `8` and check the array follows.
2. Use `MAX_ITEMS` after the `#undef` and read what the compiler says.
