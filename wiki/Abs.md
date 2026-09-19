[Home](Home) › [Mathematical Functions](Category-Mathematical-Functions) › **Abs**

# Abs

Calculates the absolute value of a number

## Syntax

```freebasic
Declare Function Abs ( ByVal number As Integer ) As Integer
Declare Function Abs ( ByVal number As UInteger ) As UInteger
Declare Function Abs ( ByVal number As Double ) As Double
```

## Parameters

- `number`

## Description

The absolute value of a number is its positive magnitude. If a number is negative, its value will be negated and the positive result returned. For example, `Abs(-1)` and `Abs(1)` both return `1`. The required `number` argument can be any valid numeric expression.  
 Unsigned numbers will be treated as if they were signed, i.e. if the highest bit is set the number will be treated as negative, and its value negated.  
 The value returned will be greater than or equal to `0`, with the exception of signed integers containing the lowest possible negative value that can be stored in its type, in which case negating it will overflow the result.

 The `Abs` unary [`Operator`](Operator) can be overloaded with user defined types.

## Return Value

The absolute value of `number`.

## Remarks

### Usage

`result = Abs( number )`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- None

### See also

- [`Sgn`](Sgn)
- [`Operator`](Operator)

## Examples

```freebasic
Dim n As Integer

Print Abs( -1 )

Print Abs( -3.1415 )

Print Abs( 42 )

Print Abs( n )

n = -69

Print Abs( n )
```

 Output:

```freebasic
1
3.1415
42
0
69
```

---

**Category:** [Mathematical Functions](Category-Mathematical-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
