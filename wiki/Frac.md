[Home](Home) › [Mathematical Functions](Category-Mathematical-Functions) › **Frac**

# Frac

Returns the fractional part, keeping the sign, so Frac(-1.75) is -0.75.

## Syntax

```freebasic
Declare Function Frac ( ByVal number As Double ) As Double
Declare Function Frac ( ByVal number As Integer ) As Integer
Declare Function Frac ( ByVal number As UInteger ) As UInteger
```

## Parameters

- `number`

## Description

Equivalent to: `(number - Fix(number))`.  
 For example, `Frac(4.25)` will return `0.25`, and `Frac(-1.75)` will return `-0.75`. For integer types, the value `0` is always returned.

 The `Frac` unary [`Operator`](Operator) can be overloaded with user defined types.

## Return Value

Returns the fractional part of a number or expression.

## Remarks

### Usage

`result = Frac( number )`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- New to FreeBASIC

### See also

- [`Fix`](Fix)
- [`Operator`](Operator)

## Examples

```freebasic
Print Frac(10.625)  '' will print  0.625

Print Frac(-10.625) '' will print -0.625
```

---

**Category:** [Mathematical Functions](Category-Mathematical-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
