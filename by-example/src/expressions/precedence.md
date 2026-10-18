# Precedence

When an expression has no parentheses, precedence decides which operator
applies first: `2 + 3 * 4` is 14 because `*` binds tighter than `+`. Most of
tiko's order is the one you know from arithmetic, but a few places differ
from other languages, and those are where bugs hide.

```tiko
{{#include ../../examples/expressions/precedence.tiko}}
```

**Output**

```text
{{#include ../../examples/expressions/precedence.out}}
```

From tightest to loosest:

| Level | Operators |
|---|---|
| 1 | `^` |
| 2 | unary `-` |
| 3 | `*` `/` |
| 4 | `\` |
| 5 | `mod` |
| 6 | `shl` `shr` |
| 7 | `+` `-` |
| 8 | `&` |
| 9 | `=` `<>` `<` `<=` `>` `>=` |
| 10 | `not` |
| 11 | `and` |
| 12 | `or` |
| 13 | `xor` |
| 14 | `andalso` `orelse` |

Operators on one level group from left to right.

The places that catch people out, all shown in the example:

- **`-2 ^ 2` is -4.** `^` binds tighter than the minus sign, so it means
  `-(2 ^ 2)`. And `2 ^ 3 ^ 2` groups to the left, giving 64, not 512.
- **`\` and `mod` sit below `*`.** `7 \ 2 * 2` is `7 \ 4`, which is 1, not 6.
  `9 mod 5 \ 2` is `9 mod 2`, which is 1, not 2.
- **Shifts bind tighter than `+`.** `1 shl 2 + 3` shifts first, giving 7.
- **Comparisons bind tighter than `and`.** `n and 1 <> 0` compares first and
  gives 6, not the bit test it looks like. Write `( n and 1 ) <> 0`.
- **`not` is looser than comparisons.** `not a = b` means `not ( a = b )`.
- **`andalso` and `orelse` share a level.** They group left to right, so
  `true orelse false andalso false` is `( true orelse false ) andalso false`,
  which is false.

```admonish danger title="Pitfall"
In most languages *and* binds tighter than *or*, and that is true here for
`and` and `or`. It is **not** true for `andalso` and `orelse`. Put parentheses
round every condition that mixes the two.
```

### Activities

1. Predict `2 + 3 * 4 ^ 2 \ 5` and check it.
2. Print `cbool( ( n and 1 ) <> 0 )` for n = 6 and n = 7, then the same
   without the parentheses, and explain the difference.
