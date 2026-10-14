[Home](Home) › [Mathematical Functions](Category-Mathematical-Functions) › **Cos**

# Cos

Returns the cosine of an angle

## Syntax

```freebasic
Declare Function Cos ( ByVal angle As Double ) As Double
```

## Parameters

- `angle`

## Description

The argument `number` is measured in radians (not degrees).

 The value returned by this function is undefined for values of `angle` with an absolute value of `2 ^ 63` or greater.

 `Cos` can be overloaded as operator to accept user-defined types.

## Return Value

Returns the cosine of the argument `angle` as a [`Double`](Double) within the range of `-1.0` to `1.0`.

## Remarks

### Usage

`result = Cos( angle )`

### Differences from QB

- None

### See also

- [`Acos`](Acos)
- [`Sin`](Sin)
- [`Tan`](Tan)

## Examples

```freebasic
Const PI As Double = 3.1415926535897932

Dim a As Double

Dim r As Double

Input "Please enter an angle in degrees: ", a

r = a * PI / 180    'Convert the degrees to Radians

Print ""

Print "The cosine of a" ; a; " degree angle is"; Cos ( r )

Sleep
```

 Output:

```freebasic
Please enter an angle in degrees: 30
The cosine of a 30 degree angle Is 0.8660254037844387
```

---

**Category:** [Mathematical Functions](Category-Mathematical-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
