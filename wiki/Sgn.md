[Home](Home) › [Mathematical Functions](Category-Mathematical-Functions) › **Sgn**

# Sgn

Returns the sign part of a number

## Syntax

```freebasic
Declare Function Sgn ( ByVal number As numtype ) As numtype
```

## Parameters

- `number`
- `numtype`

## Description

The required `number` argument can be any valid numeric expression.  
 Unsigned numbers of size greater than or equal to `SizeOf(Any Ptr)` will be treated as if they were signed, i.e. if the highest bit is set the number will be treated as negative, and `-1` will be returned.

 **Note:**

The return type of **`Sgn`** depends on the type of the passed argument (variable or constant, its data type), and of the used backend (gas, gas64, gcc 32-bit, gcc 64-bit):

**-** **`Sgn`** return type for a variable passed as argument:

| Argument | gas (32-bit) | gas64 (64-bit) | gcc 32-bit (\*) | gcc 64-bit (\*) |
| --- | --- | --- | --- | --- |
| \[U\]BYTE variable | INTEGER | INTEGER | LONG | LONG |
| \[U\]SHORT variable | INTEGER | INTEGER | LONG | LONG |
| \[U\]LONG variable | INTEGER | INTEGER | LONG | LONG |
| \[U\]INTEGER variable | INTEGER | INTEGER | LONG | LONG |
| \[U\]LONGINT variable | LONGINT | INTEGER | LONG | LONG |
| SINGLE variable | SINGLE | LONG | LONG | LONG |
| DOUBLE variable | DOUBLE | LONG | LONG | LONG |

**-** **`Sgn`** return type for a constant passed as argument:

| Argument | gas (32-bit) | gas64 (64-bit) | gcc 32-bit (\*) | gcc 64-bit (\*) |
| --- | --- | --- | --- | --- |
| \[U\]BYTE constant | INTEGER | INTEGER | INTEGER | INTEGER |
| \[U\]SHORT constant | INTEGER | INTEGER | INTEGER | INTEGER |
| \[U\]LONG constant | INTEGER | INTEGER | INTEGER | INTEGER |
| \[U\]INTEGER constant | INTEGER | INTEGER | INTEGER | INTEGER |
| \[U\]LONGINT constant | LONGINT | INTEGER | LONGINT | INTEGER |
| SINGLE constant | SINGLE | SINGLE | SINGLE | SINGLE |
| DOUBLE constant | DOUBLE | DOUBLE | DOUBLE | DOUBLE |

(\*): applicable also for clang and llvm

The `Sgn` unary [`Operator`](Operator) can be overloaded with user defined types.

## Return Value

Returns the sign part of `number`.

- If *number* is greater than zero, then `Sgn` returns `1`.
- If *number* is equal to zero, then `Sgn` returns `0`.
- If *number* is less than zero, then `Sgn` returns `-1`.

## Remarks

### Usage

`result = Sgn( number )`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- None

### See also

- [`Abs`](Abs)
- [`Operator`](Operator)

## Examples

```freebasic
Dim N As Integer = 0

Print Sgn ( -1.87 )

Print Sgn ( 0 )

Print Sgn ( 42.658 )

Print Sgn ( N )
```

The output would look like:

```freebasic
-1
0
1
0
```

---

**Category:** [Mathematical Functions](Category-Mathematical-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
