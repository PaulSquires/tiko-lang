[Home](Home) › [Mathematical Functions](Category-Mathematical-Functions) › **Sqr**

# Sqr

Returns the square root of a number.

## Syntax

```freebasic
Declare Function Sqr ( ByVal number As Double ) As Double
```

## Parameters

- `number`

## Description

This is the same as raising the argument `number` to the one-half power: `y = x ^ (1/2)` . The required `number` argument can be any valid numeric expression greater than or equal zero.

 If a [`LongInt`](Longint) or [`ULongInt`](Ulongint) is passed to `Sqr`, it may be converted to [`Double`](Double) precision first. For numbers over `2^52`, this will cause a very small loss of precision. Without making any assumptions about the rounding method, the maximum error due to this will be `Sqr(2^64) - Sqr(2^64-2^12)`, which is about `4.8e-7`. However this may cause erroneous results if the floor or ceiling of this value is taken, and the result of this may be out by `1`, particularly for square numbers and numbers that are close by.

 `Sqr` can be overloaded as operator to accept user-defined types.

## Return Value

Returns the square root of the argument `number`.

 If `number` equals zero, `Sqr` returns zero (`0.0`).

 If `number` is less than zero, `Sqr` returns a special value representing "not defined", printing like "`NaN`" or `"IND"`, exact text is platform dependent.

## Remarks

### Usage

`result = Sqr( number )`

### Differences from QB

- None

### See also

- [`Operator ^ (Exponentiate)`](Operator-Exponentiate)
- [Arithmetic Operators](Mathematical-Functions)

## Examples

```freebasic
'' Example of Sqr function: Pythagorean theorem

Dim As Single a, b

Print "Pythagorean theorem, right-angled triangle"

Print

Input "Please enter one leg side length: ", a

Input "Please enter the other leg side length: ", b

Print

Print "The hypotenuse has a length of: " & Sqr( a * a + b * b )
```

 The output would look like:

```freebasic
Pythagorean theorem, right-angled triangle

Please enter one leg side length: 1.5
Please enter the other leg side length: 2

The hypotenuse has a length of: 2.5
```

---

**Category:** [Mathematical Functions](Category-Mathematical-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
