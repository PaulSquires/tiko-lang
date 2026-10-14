[Home](Home) › [Mathematical Functions](Category-Mathematical-Functions) › **Tan**

# Tan

Returns the tangent of an angle

## Syntax

```freebasic
Declare Function Tan ( ByVal angle As Double ) As Double
```

## Parameters

- `angle`

## Description

The argument `angle` is measured in radians (not degrees).

 The value returned by this function is undefined for values of `angle` with an absolute value of `2 ^ 63` or greater.

 `Tan` can be overloaded as operator to accept user-defined types.

## Return Value

Returns the tangent of the argument `angle` as a [`Double`](Double) within the range of -infinity to infinity.

## Remarks

### Usage

`result = Tan( angle )`

### Differences from QB

- None

### See also

- [`Atn`](Atn)
- [`Atan2`](Atan2)
- [`Sin`](Sin)
- [`Cos`](Cos)

## Examples

```freebasic
Const PI As Double = 3.1415926535897932

Dim a As Double

Dim r As Double

Input "Please enter an angle in degrees: ", a

r = a * PI / 180    'Convert the degrees to Radians

Print ""

Print "The tangent of a" ; a; " degree angle is"; Tan ( r )

Sleep
```

 The output would look like:

```freebasic
Please enter an angle in degrees: 75
The tangent of a 75 degree angle Is 3.732050807568878
```

---

**Category:** [Mathematical Functions](Category-Mathematical-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
