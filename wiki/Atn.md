[Home](Home) › [Mathematical Functions](Category-Mathematical-Functions) › **Atn**

# Atn

Returns the arctangent of a number

## Syntax

```freebasic
Declare Function Atn ( ByVal number As Double ) As Double
```

## Parameters

- `number`

## Description

`Atn` returns the arctangent of the argument `number` as a [`Double`](Double) within the range of -[Pi](Different-Ways-Angles-Are-Measured)/2 to [Pi](Different-Ways-Angles-Are-Measured)/2. The arctangent is the inverse of the [`Tan`](Tan) function. The returned angle is measured in [radians](Different-Ways-Angles-Are-Measured) (not [degrees](Different-Ways-Angles-Are-Measured)).

 `Atn` can be overloaded as operator to accept user-defined types.

## Return Value

The angle, in radians, whose tangent is `number`, in the range \[-Pi/2..Pi/2\].

## Remarks

### Usage

`result = Atn( number )`

### Differences from QB

- None

### See also

- [`Tan`](Tan)
- [`Atan2`](Atan2)
- [A Brief Introduction To Trigonometry](A-Brief-Introduction-to-Trigonometry)

## Examples

```freebasic
Print "Pi ="; Atn ( 1.0 ) * 4

Print Atn ( 4 / 5 )
```

 The output would be:

```freebasic
Pi = 3.141592653589793
0.6747409422235527
```

---

**Category:** [Mathematical Functions](Category-Mathematical-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
