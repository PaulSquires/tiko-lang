# select case

When every branch asks a question about the *same* value, `select case` states
the value once and lists the answers. Each `case` can name single values, a
list, a range or an open comparison:

```tiko
{{#include ../../examples/flow/select.tiko}}
```

**Output**

```text
{{#include ../../examples/flow/select.out}}
```

| Case | Matches |
|---|---|
| `case 0` | one value |
| `case 1, 2, 3` | any value in the list |
| `case 4 to 9` | a range, both ends included |
| `case is < 0` | any value the comparison accepts (`is >`, `is <=`, `is <>` ...) |
| `case 10 to 99, 1000` | a list that mixes the forms |
| `case else` | anything no earlier case matched |

The cases are tried from the top, and the first one that matches is the only
one that runs. There is no fall-through into the next case and nothing to
`break` out of. If no case matches and there is no `case else`, nothing runs.

The value can be a `ustring`. Then `"a" to "m"` is an alphabetical range:
`"kiwi"` is inside it and `"zebra"` is not.

```admonish note
`select case as const` builds a jump table, which is faster for a dense set of
integer cases. It takes only constant values, so an open comparison inside one
is refused: `TKO0419: 'is' is not allowed in a 'select case as const'`.
```

A common use of `select case` is to put `true` at the top and a condition in
each case, so that the first true condition wins:

```tiko
{{#include ../../examples/flow/selecttrue.tiko}}
```

**Output**

```text
{{#include ../../examples/flow/selecttrue.out}}
```

````admonish warning title="Status in this version"
This program prints `take nothing`: a `select case` whose value is the literal
`true` (or a constant equal to it) matches no case, not even `case true`. A
`boolean` variable at the top works as expected. Until this is fixed, write a
chain of conditions as `if` / `elseif`.
````

### Activities

1. Add a case for the numbers 100 to 999 and check which samples move into it.
2. Move `case is < 0` to the top. Does any output change? Why not?
