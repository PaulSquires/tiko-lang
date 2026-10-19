[Home](Home) › [Mathematical Functions](Category-Mathematical-Functions) › **Int**

# Int

Returns the largest whole number not above the value, so Int(-1.3) is -2.

## Syntax

```freebasic
Declare Function Int ( ByVal number As Single ) As Single
Declare Function Int ( ByVal number As Double ) As Double
Declare Function Int ( ByVal number As Integer ) As Integer
Declare Function Int ( ByVal number As UInteger ) As UInteger
```

## Parameters

- `number`

## Description

`Int` returns the floor of `number`. For example, `Int(4.9)` will return `4.0`, and `Int(-1.3)` will return `-2.0`. For integer types, the number is returned unchanged.

 **Note:** To return the ceiling of `number`, i.e. the smallest integer that is greater than or equal to it, one can use `-Int( -number )`.

 The `Int` unary [`Operator`](Operator) can be overloaded with user defined types.

## Return Value

Returns the floor of `number`, i.e. the largest integer that is less than or equal to it.

## Remarks

### Usage

`result = Int( number )`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- None

### See also

- [`Fix`](Fix)
- [`CInt`](Cint)
- [`Operator`](Operator)

## Examples

```freebasic
Print Int(1.9)  '' will print  1

Print Int(-1.9) '' will print -2
```

---

**Category:** [Mathematical Functions](Category-Mathematical-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
