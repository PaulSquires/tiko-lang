# with

Filling in a record with many fields repeats its name on every line.
`with ... end with` names it once: inside the block, a field written with a
leading dot belongs to that record.

```tiko
{{#include ../../examples/custom-types/with.tiko}}
```

**Output**

```text
{{#include ../../examples/custom-types/with.out}}
```

`.columns = 80` inside `with s` means `s.columns = 80`. The block can name
any record expression, including a nested field such as `doc.layout`, and the
code inside it can still use every other name in scope: `s.columns * 2` reads
a different record entirely.

`with` reads best for short blocks that set or read many fields of one
record. In a long block, a reader has to remember which record the dots
belong to, so the plain `record.field` form is often clearer.

### Activities

1. Use a `with` block to print every field of `s` on one line.
2. Inside a `with doc` block, open `with .layout` and try to set `.path`
   from the inner block. Read the error: which record does the dot refer to?
