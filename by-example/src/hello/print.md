# Printing

`print` takes a list of values separated by `;` or `,`, and the separator
decides the spacing:

- `;` puts the next value directly after the previous one.
- `,` moves to the next *print zone*, a column boundary every 14 characters,
  which is a quick way to line up a small table.
- A `;` at the very end keeps the cursor on the same line, so the next `print`
  continues it.

```tiko
{{#include ../../examples/hello/print.tiko}}
```

**Output**

```text
{{#include ../../examples/hello/print.out}}
```

Numbers are printed with room for a sign: a positive number gets a leading
space and a negative one its minus sign. That is why `"answer:"; 42` prints
`answer: 42` with a space you did not write. When you want exact control over
the text, build it with [`strings.Format`](format.md) instead.

### Activities

1. Print a three-column table of names and ages using `,` between the columns.
2. Print the numbers 1 to 3 on one line using a trailing `;` on each `print`.
