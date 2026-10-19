[Home](Home) › [Mathematical Functions](Category-Mathematical-Functions) › **Atan2**

# Atan2

Returns the angle in radians, from -pi to pi, of the point at x, y.

## Syntax

```freebasic
Declare Function Atan2 ( ByVal y As Double, ByVal x As Double ) As Double
```

## Description

`ATan2` returns the arctangent of the ratio `y/x` as a [`Double`](Double) within the range of -Pi to Pi. The arctangent is the inverse of the [`Tan`](Tan) function. The returned angle is measured in radians (not degrees).

 `ATan2` cannot be overloaded as operator to accept user-defined types.

## Return Value

The angle whose tangent is `y/x`, in radians, in the range \[-Pi..Pi\].

## Remarks

### Usage

`result = ATan2( y, x )`

### Differences from QB

- New to FreeBASIC

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Atan2`.

### See also

- [`Tan`](Tan)
- [`Atn`](Atn)

## Examples

`Print Atan2 ( 4, 5 ) 'this is the same as PRINT ATN ( 4 / 5 )`

 The output would be:

```freebasic
0.6747409422235527
```

---

**Category:** [Mathematical Functions](Category-Mathematical-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
