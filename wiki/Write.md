[Home](Home) › [Console Functions](Category-Console-Functions) › **Write**

# Write

Outputs a comma-separated list of values to the screen

## Syntax

```freebasic
Write [ expressionlist ]
```

## Parameters

- `expressionlist`

## Description

Outputs the values in `expressionlist` to the screen. The values are separated with commas, and strings are enclosed in double quotes. Numeric values with an absolute value of less than one are prefixed with a zero (`0`) if none is given (e.g. `0.5`, `-0.123`). Floating-point numbers with absolute values greater than or equal to `10^16`, or with absolute values greater than `0` and less than `10^-5` are printed in scientific notation (e.g. `1.8e+019`, `3e-005`)

 If no expression list is given, `Write` outputs a carriage return.

## Remarks

### Differences from QB

- QBASIC might print format floating-point values in slightly different ways.

### See also

- [`Write #`](procedures-Write)
- [`Print`](Print)
- [`?`](Print)

## Examples

```freebasic
Dim i As Integer = 10

Dim d As Double = 123.456

Dim s As String = "text"

Write 123, "text", -.45600

Write

Write i, d, s
```

 will produce the output:

```freebasic
123,"text",-0.456

10,123.456,"text"
```

---

**Category:** [Console Functions](Category-Console-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
