# Conversion

Programs move values between forms all the time: text read from a user or a
file becomes a number, numbers of one type meet numbers of another, and
results become text again for display. Each of those steps is a conversion,
and tiko has a tool for each.

```tiko
{{#include ../../examples/conversion/conversion.tiko}}
```

**Output**

```text
{{#include ../../examples/conversion/conversion.out}}
```

| From | To | With |
|---|---|---|
| text | number | `val`, `valint`, `vallng`, or `numeric.TryParse...` to reject bad input |
| number | number | assignment, `cast( T, x )`, `cint`, `cdbl` and the other `c...` functions |
| number | text | `str( x )`, the `&` operator, `strings.Format` |
| your type | another type | a constructor and an `operator cast` |

The example uses one of each. `valint` and `val` read the two strings,
`quantity * price` converts the integer to `float64` before multiplying,
`cint` rounds the total back to a whole number, and `&` turns every operand
into text as it joins them.

The pages that follow take the steps one at a time:
[numbers to text](totext.md), [text to numbers](fromtext.md),
[conversions for your own types](castops.md), and the rules for
[rounding](rounding.md) when a fraction has to go.

### Activities

1. Change `quantityText` to `"12 boxes"`. What does `valint` make of it?
2. Change `priceText` to `"seven"` and explain the total.
