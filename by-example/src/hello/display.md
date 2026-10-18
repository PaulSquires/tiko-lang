# Display

`print` and `strings.Format` know how to show numbers, strings and booleans.
To make one of your own types printable, give it a *cast to `ustring`*: an
`operator cast` that returns its text form.

```tiko
{{#include ../../examples/hello/display.tiko}}
```

**Output**

```text
{{#include ../../examples/hello/display.out}}
```

Once the cast exists, a `Point` is accepted wherever text is expected: by
`print`, by the `&` concatenation operator, and by `strings.Format`, where the
format spec — here `{:>14}` — applies to the text the cast produced.

Types and operators are covered properly in [Custom Types](../custom-types/index.md)
and [Objects](../objects/index.md); this page only shows the hook that makes a
value displayable.

### Activities

1. Add a `z` field to `Point` and include it in the text.
2. Write a `Money` type holding a number of cents that prints as `$12.34`.
