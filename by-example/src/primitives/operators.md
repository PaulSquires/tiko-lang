# Operators

Most of tiko's operators are the ones you expect. A few are spelled as words
(`mod`, `and`, `shl`), and three arithmetic ones behave differently from
C-family languages: `/`, `\` and `^`.

```tiko
{{#include ../../examples/primitives/operators.tiko}}
```

**Output**

```text
{{#include ../../examples/primitives/operators.out}}
```

**Arithmetic.** `/` always divides in floating point, so `7 / 2` is 3.5 even
though both operands are whole numbers. Integer division is its own operator,
`\`, and it truncates towards zero: `-7 \ 2` is -3. `mod` is the remainder
that goes with it, so it takes the sign of the left operand: `-7 mod 2` is -1.
`^` raises to a power and always produces a `float64`.

**Comparison.** `=`, `<>`, `<`, `<=`, `>`, `>=` compare numbers, and also
text, alphabetically. Their result is an integer: -1 for true and 0 for false.
That is what `print` shows, so wrap a comparison in `cbool( ... )` when you want
to see `true` or `false`. In a statement such as `x = 3`, the first `=`
assigns; [Expressions](../expressions/index.md) shows what a second one does.

**Bits.** `and`, `or`, `xor` and `not` work on every bit of an integer, and
`shl` / `shr` shift left and right. `not 12` is -13 because every bit flips,
including the sign bit. `bin( )` shows the bits, which makes masks easy to
check. The same words also combine conditions; the
[short-circuit](../expressions/shortcircuit.md) page explains when to use
`andalso` and `orelse` instead.

**Compound assignment.** Every binary operator has an assigning form:
`+=`, `-=`, `*=`, `/=`, `\=`, `^=`, `mod=`, `and=`, `or=`, `xor=`, `shl=`,
`shr=` and `&=` for text.

Dividing by a constant zero is caught when the program is compiled:
`5 \ 0` is error `TKO0671: division by a constant zero`.

The order in which operators apply is on the
[precedence](../expressions/precedence.md) page.

### Activities

1. Print `-7 / 2`, `-7 \ 2` and `fix( -7 / 2 )`. Which two agree?
2. Use `and` with a mask to print the low four bits of 1234.
3. Start with `dim as uint8 flags = 0` and set bits 0 and 3 using `or=` and
   `shl`.
