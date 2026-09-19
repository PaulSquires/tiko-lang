[Home](Home) › [Mathematical Functions](Category-Mathematical-Functions) › **Fix**

# Fix

Returns the integer part of a number, rounding towards zero

## Syntax

```freebasic
Declare Function Fix ( ByVal number As Single ) As Single
Declare Function Fix ( ByVal number As Double ) As Double
Declare Function Fix ( ByVal number As Integer ) As Integer
Declare Function Fix ( ByVal number As UInteger ) As UInteger
```

## Parameters

- `number`

## Description

Equivalent to: `Sgn(number) * Int(Abs(number))`. For example, `Fix(1.3)` will return `1.0`, and `Fix(-4.9)` will return `-4.0`. For integer types, the number is returned unchanged.

 Note: this function is also equivalent to `number - Frac(number)`.

 The `Fix` unary [`Operator`](Operator) can be overloaded with user defined types.

## Return Value

Returns the integer part of `number`, rounding towards zero.

## Remarks

### Usage

`result = Fix( number )`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- None

### See also

- [`Int`](Int)
- [`Frac`](Frac)
- [`CInt`](Cint)
- [`Operator`](Operator)

## Examples

```freebasic
Print Fix(1.9)  '' will print  1

Print Fix(-1.9) '' will print -1
```

---

**Category:** [Mathematical Functions](Category-Mathematical-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
