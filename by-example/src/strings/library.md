# The strings module

The built-in functions find and cut text. The standard library's
`std/strings` module adds the operations most programs end up writing for
themselves: prefix and suffix tests, counting, replacing, padding, and
asking whether text is a number.

```tiko
{{#include ../../examples/strings/library.tiko}}
```

**Output**

```text
{{#include ../../examples/strings/library.out}}
```

`#import "std/strings"` brings the module in, and its procedures are called
through the module name: `strings.Replace`. Write `using strings` after the
import if you would rather call them bare.

| Group | Procedures |
|---|---|
| Tests | `StartsWith`, `EndsWith`, `Contains`, `IsNumeric`, `IsBlank` |
| Counting | `Tally` (non-overlapping matches) |
| Pieces | `Extract` (text before a match), `Remain` (text after it), `Between` |
| Changes | `Replace`, `Remove`, `Shrink`, `MCase`, `Reverse`, `Repeat` |
| Layout | `PadLeft`, `PadRight`, `PadCenter` |

Every search takes an optional last argument, `ignoreCase`. `EndsWith( path,
".TIKO" )` is false; with `true` added it matches. Case folding covers letters
beyond ASCII too, the same way `ucase` does.

Like the built-in functions, these return a new string; the one passed in is
not changed. Positions are counted from 1 and 0 means "not found", as with
`instr`.

`Shrink` collapses each run of spaces to one and removes the spaces at the
ends, which is what you want for text a person typed.

`IsNumeric` answers a question `val` cannot: `val( "12abc" )` returns 12,
but `IsNumeric( "12abc" )` is false, because the whole text is not a number.

Cutting a string into a list of fields, and joining one back together, have
a page of their own: [Split and Join](split.md).

### Activities

1. Use `Replace` with `ignoreCase` to change every `cat` in
   `"Cat, cat and CAT"` to `dog`.
2. Print a three-row table where the first column is padded to 10 characters
   with `PadRight` and the second right-aligned in 6 with `PadLeft`.
