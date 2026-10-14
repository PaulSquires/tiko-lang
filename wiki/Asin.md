[Home](Home) › [Mathematical Functions](Category-Mathematical-Functions) › **Asin**

# Asin

Finds the arcsine of a number

## Syntax

```freebasic
Declare Function Asin ( ByVal number As Double ) As Double
```

## Parameters

- `number`

## Description

`Asin` returns the arcsine of the argument `number` as a [`Double`](Double) within the range of -Pi/2 to Pi/2. The arcsine is the inverse of the [`Sin`](Sin) function. The returned angle is measured in radians (not degrees).

 `Asin` can be overloaded as operator to accept user-defined types.

## Return Value

The arcsine of `number`, in radians, in the range \[-Pi/2..Pi/2\].

## Remarks

### Usage

`result = Asin( number )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Asin`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Sin`](Sin)

## Examples

```freebasic
Dim h As Double

Dim o As Double

Input "Please enter the length of the hypotenuse of a triangle: ", h

Input "Please enter the length of the opposite side of the triangle: ", o

Print ""

Print "The angle between the sides is"; Asin ( o / h )

Sleep
```

 The output would look like:

```freebasic
Please enter the length of the hypotenuse of a triangle: 5
Please enter the length of the opposite side of the triangle: 3
The angle between the sides is 0.6435011087932844
```

---

**Category:** [Mathematical Functions](Category-Mathematical-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
