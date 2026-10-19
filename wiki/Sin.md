[Home](Home) › [Mathematical Functions](Category-Mathematical-Functions) › **Sin**

# Sin

Returns the sine of an angle in radians.

## Syntax

```freebasic
Declare Function Sin ( ByVal angle As Double ) As Double
```

## Parameters

- `angle`

## Description

The argument `angle` is measured in radians (not degrees).

 The value returned by this function is undefined for values of `angle` with an absolute value of `2 ^ 63` or greater.

 `Sin` can be overloaded as operator to accept user-defined types.

## Return Value

Returns the sine of the argument `angle` as a [`Double`](Double) within the range of `-1.0` to `1.0`.

## Remarks

### Usage

`result = Sin( angle )`

### Differences from QB

- None

### See also

- [`Asin`](Asin)
- [`Cos`](Cos)
- [`Tan`](Tan)

## Examples

```freebasic
Const PI As Double = 3.1415926535897932

Dim a As Double

Dim r As Double

Input "Please enter an angle in degrees: ", a

r = a * PI / 180    'Convert the degrees to Radians

Print ""

Print "The sine of a" ; a; " degree angle is"; Sin ( r )

Sleep
```

 The output would look like:

```freebasic
Please enter an angle in degrees: 30
The sine of a 30 degree angle Is 0.5
```

---

**Category:** [Mathematical Functions](Category-Mathematical-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
