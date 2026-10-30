# Operators and Expressions

Operators are the part of a language people assume they already know, which is exactly why they
are worth a chapter. Most of tiko's behave as you expect. A handful do not, and each of those is a
bug waiting in code that was written by assumption rather than by reading.

Everything in this chapter was measured against the compiler. Where tiko's grouping differs from
the language you came from, the listing prints both readings so you can see which one won.

## Arithmetic

```tiko
{{#include ../examples/ch05/arithmetic.tiko}}
```

```text
{{#include ../examples/ch05/arithmetic.out}}
```

Three of those need naming.

**`/` is always floating point.** `7 / 2` is 3.5 even though both operands are whole numbers.
Integer division is a separate operator, `\`, and it truncates: `7 \ 2` is 3.

**`mod` is a remainder, not a modulus.** It takes the sign of its left operand, so `-7 mod 2` is
−1 rather than 1. When you want the mathematical modulus — always non-negative for a positive
divisor — `std/numeric`'s `FloorMod` is the one to reach for. This matters the moment you use
`mod` to wrap an index that might be negative.

**`^` produces a float.** `2 ^ 10` is 1024, but it is a `float64` that happens to hold a whole
number, and it was computed in floating point. For integer powers where exactness matters,
`std/numeric` has `IPow`.

## Precedence, and its four surprises

tiko's precedence table was established by compiling 484 operator pairs and reading what the
compiler did with each. Four of the answers differ from what a C, Python or Java programmer
expects, and this listing prints each one beside both possible groupings:

```tiko
{{#include ../examples/ch05/precedence.tiko}}
```

```text
{{#include ../examples/ch05/precedence.out}}
```

| Expression | tiko groups it | Many languages |
|---|---|---|
| `2 ^ 3 ^ 2` | `(2 ^ 3) ^ 2` = 64 | right, giving 512 |
| `1 shl 2 + 3` | `(1 shl 2) + 3` = 7 | `+` first, giving 32 |
| `not a = b` | `not (a = b)` | `(not a) = b` |
| `x orelse y andalso z` | left to right | `andalso` first |

```admonish danger title="Pitfall"
**`not` is looser than the comparisons.** `not a = b` asks "is it not the case that a equals b",
which is usually what was meant — but it is the opposite of C, where `!a == b` compares `!a`
against `b`.

**`andalso` and `orelse` share one precedence level**, so they group strictly left to right. In C,
Python and nearly everything else, `and` binds tighter than `or`, so `x or y and z` means
`x or (y and z)`. Here it means `(x orelse y) andalso z`, which is a different answer.

Both are cases where code that looks right and compiles clean can be wrong. Parenthesise any
mixed `andalso`/`orelse` expression, every time.
```

## Two families of logical operator

```tiko
{{#include ../examples/ch05/logic.tiko}}
```

```text
{{#include ../examples/ch05/logic.out}}
```

`andalso` and `orelse` **short-circuit**: once the answer is known the right-hand side is never
evaluated. `and`, `or`, `xor` and `not` do not — they are bitwise operators that also serve for
logic, and they always evaluate both sides.

The difference matters whenever the right-hand side has an effect, or would fail:

- `if p <> 0 andalso p->count > 0` is safe.
- `if p <> 0 and p->count > 0` dereferences a null pointer.

Use `andalso` and `orelse` for conditions, and reserve `and`/`or`/`xor`/`not` for bits.

```admonish note
tiko refuses to mix the two families silently. Combining a boolean and a non-boolean in an
`andalso` chain draws a warning, because the result is almost never what was meant — hoist the
value into a `boolean` first.
```

## Working with bits

```tiko
{{#include ../examples/ch05/bits.tiko}}
```

```text
{{#include ../examples/ch05/bits.out}}
```

`shl` and `shr` shift; `bitset`, `bitreset` and `bit` turn one bit on, off, or read it; `lobyte`,
`hibyte`, `loword` and `hiword` pull a piece out of a wider value. `bin( )` and `hex( )` print a
value in a base where the bits are visible, which is most of the battle when debugging a mask.

Remember that shifts bind tighter than arithmetic. `1 shl n + 1` shifts by `n` and then adds — not
what the spacing suggests.

## Joining, choosing, and shorthand

```tiko
{{#include ../examples/ch05/expressions.tiko}}
```

```text
{{#include ../examples/ch05/expressions.out}}
```

**`&` joins text; `+` adds numbers.** `+` will also join two strings, which is exactly why the
book always uses `&`: `1 & 2` is the text `12`, while `1 + 2` is the number 3, and `&` never has
to be guessed at.

**`iif( condition, a, b )`** chooses between two values inside an expression, where an `if`
statement would need several lines. Both arms are evaluated, so do not use it where one of them
has an effect.

**Compound assignment** — `+=`, `-=`, `*=`, `/=`, `\=`, `&=` — and **`swap a, b`**, which exchanges
two variables of the same type without a temporary.

## Summary

- `/` is floating point, `\` is integer division, and `^` produces a `float64`.
- `mod` is a remainder and takes its left operand's sign; `FloorMod` in `std/numeric` is the
  mathematical one.
- **`^` groups to the left**, and **`shl`/`shr` bind tighter than `+`**.
- **`not` is looser than the comparisons**, and **`andalso`/`orelse` share one level**, grouping
  left to right — parenthesise mixed conditions.
- `andalso`/`orelse` short-circuit; `and`/`or`/`xor`/`not` are bitwise and always evaluate both.
- `&` joins text and never means anything else; `iif` chooses within an expression; `swap`
  exchanges two variables.

## Exercises

1. Build a permissions value from three named bit positions, then read one back. Do it twice —
   once with `bitset`/`bit`, once with `1 shl n` masks — and check the two agree.
   {solution="ex05-01"}
2. Write expressions where parentheses change the answer, and one where they only make the
   existing grouping obvious. Which of the four surprises above would have bitten you?
   {solution="ex05-02"}
3. `7 mod -2` and `-7 mod 2` give different signs. Predict both before running them, then work out
   what `FloorMod` would give instead.
4. Rewrite `if p <> 0 and p->count > 0` so it is safe, and explain in one sentence what the
   original does when `p` is null.
