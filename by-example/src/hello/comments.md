# Comments

Every program needs comments, and tiko has two kinds:

- **Line comments** start with `''` and run to the end of the line.
- **Block comments** start with `/'` and end with `'/`. They can span several
  lines, sit in the middle of an expression, and nest inside one another.

```tiko
{{#include ../../examples/hello/comments.tiko}}
```

**Output**

```text
{{#include ../../examples/hello/comments.out}}
```

The block comment inside the expression removes `90 +` from the program, so
`x` is `5 + 5`. Because block comments nest, you can comment out a region of
code that already contains one without breaking it.

A single `'` also starts a line comment, but the doubled `''` is the form tiko
code uses, and the one this site uses throughout.

### Activities

1. Remove the block comment in the `dim` line and predict the new output.
2. Comment out the `print` line with a block comment, then wrap that whole line
   in a second block comment.
