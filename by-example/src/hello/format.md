# Formatted print

`print` is fine for quick output, but most programs want to lay text out
precisely. `strings.Format`, from the standard library's `std/strings` module,
builds a `ustring` from a *format string* and a list of values:

```tiko
{{#include ../../examples/hello/format.tiko}}
```

**Output**

```text
{{#include ../../examples/hello/format.out}}
```

Each `{}` in the format string is replaced by the next argument. Inside the
braces you can write:

| Part | Example | Meaning |
|---|---|---|
| a position | `{1}` | use argument 1 (counting from 0) instead of the next one |
| fill and alignment | `{:-^12}` | centre in 12 columns, padding with `-` |
| `<` `>` `^` | `{:>8}` | align left, right or centre |
| `0` and a width | `{:05}` | pad a number with zeros |
| `+` | `{:+}` | always show the sign |
| `x` `o` `b` | `{:#x}` | hexadecimal, octal, binary; `#` adds the prefix |
| `.n` and `f` / `e` | `{:.3f}` | fixed-point or exponent notation with n digits |

A format string is checked when the program is compiled wherever it is a
literal, so a placeholder that refers to an argument you did not pass is an
error at build time, not a surprise at run time.

`#import "std/strings"` brings in the module; its procedures are then called
through the module name, as `strings.Format`.

### Activities

1. Print `pi` with 2, 5 and 10 digits after the point.
2. Print the numbers 1, 10 and 100 right-aligned in a column 6 wide.
3. Print 255 in binary, padded with zeros to 16 digits.
