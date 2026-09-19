[Home](Home) › [Operators](Category-Operators) › **Operator <> (Not Equal)**

# Operator <> (Not Equal)

Compares two expressions for inequality

## Syntax

```freebasic
Declare Operator <> ( ByRef lhs As Byte, ByRef rhs As Byte ) As Integer
Declare Operator <> ( ByRef lhs As UByte, ByRef rhs As UByte ) As Integer
Declare Operator <> ( ByRef lhs As Short, ByRef rhs As Short ) As Integer
Declare Operator <> ( ByRef lhs As UShort, ByRef rhs As UShort ) As Integer
Declare Operator <> ( ByRef lhs As Integer, ByRef rhs As Integer ) As Integer
Declare Operator <> ( ByRef lhs As UInteger, ByRef rhs As UInteger ) As Integer
Declare Operator <> ( ByRef lhs As LongInt, ByRef rhs As LongInt ) As Integer
Declare Operator <> ( ByRef lhs As ULongInt, ByRef rhs As ULongInt ) As Integer
```

## Parameters

- `lhs`
- `rhs`
- `T`

## Description

**`Operator <>` (Not equal)** is a binary operator that compares two expressions for inequality and returns the result - a boolean value mainly in the form of an [`Integer`](Integer): negative one (-1) for true and zero (0) for false. Only if the left and right-hand side types are both [`Boolean`](Boolean), the return type is also [`Boolean`](Boolean). The arguments are not modified in any way.

 This operator can be overloaded to accept user-defined types as well.

## Return Value

Returns negative one (-1) if expressions are not equal, or zero (0) if equal.

## Remarks

### Usage

`result = lhs <> rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- none

### See also

- [`Operator =`](Operator-Equal) (Equal)

## Examples

```freebasic
Dim As String a = "hello", b = "world"

Dim As Integer i = 10, j = i

If (a <> b) Then

  Print a & " does not equal " & b

End If

If (i <> j) Then

  Print "error: " & i & " does not equal " & j

End If
```

 [`Operator =`](Operator-Equal) (Equal) is complement to **`Operator <>` (Not equal)**, and is functionally identical when combined with [`Operator Not`](Operator-Not-Complement) (Bit-wise Complement).

```freebasic
If (69 <> 420) Then Print "(69 <> 420) is true."

   If Not (69 = 420) Then Print "not (69 = 420) is true."
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
