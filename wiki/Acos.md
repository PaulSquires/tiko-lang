[Home](Home) › [Mathematical Functions](Category-Mathematical-Functions) › **Acos**

# Acos

Finds the arccosine of an angle

## Syntax

```freebasic
Declare Function Acos ( ByVal number As Double ) As Double
```

## Parameters

- `number`

## Description

`Acos` returns the arccosine of the argument `number` as a [`Double`](Double) within the range of 0 to Pi. The arccosine is the inverse of the [`Cos`](Cos) function. The returned angle is measured in radians (not degrees).

 `Acos` can be overloaded as operator to accept user-defined types.

## Return Value

The arccosine of `number`, in radians, in the range \[0..Pi\].

## Remarks

### Usage

`result = Acos( number )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Acos`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Cos`](Cos)

## Examples

```freebasic
Dim h As Double

Dim a As Double

Input "Please enter the length of the hypotenuse of a triangle: ", h

Input "Please enter the length of the adjacent side of the triangle: ", a

Print ""

Print "The angle between the sides is"; Acos ( a / h )

Sleep
```

 The output would look like:

```freebasic
Please enter the length of the hypotenuse of a triangle: 5
Please enter the length of the adjacent side of the triangle: 4

The angle between the sides is 0.6435011087932843
```

---

**Category:** [Mathematical Functions](Category-Mathematical-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
