[Home](Home) › [Operators](Category-Operators) › **Operator = (Equal)**

# Operator = (Equal)

Compares two expressions for equality

## Syntax

```freebasic
Declare Operator = ( ByRef lhs As Byte, ByRef rhs As Byte ) As Integer
Declare Operator = ( ByRef lhs As UByte, ByRef rhs As UByte ) As Integer
Declare Operator = ( ByRef lhs As Short, ByRef rhs As Short ) As Integer
Declare Operator = ( ByRef lhs As UShort, ByRef rhs As UShort ) As Integer
Declare Operator = ( ByRef lhs As Integer, ByRef rhs As Integer ) As Integer
Declare Operator = ( ByRef lhs As UInteger, ByRef rhs As UInteger ) As Integer
Declare Operator = ( ByRef lhs As LongInt, ByRef rhs As LongInt ) As Integer
Declare Operator = ( ByRef lhs As ULongInt, ByRef rhs As ULongInt ) As Integer
```

## Parameters

- `lhs`
- `rhs`
- `T`

## Description

**`Operator =` (Equality)** is a binary operator that compares two expressions for equality and returns the result - a boolean value mainly in the form of an [`Integer`](Integer): negative one (-1) for true and zero (0) for false. Only if the left and right-hand side types are both [`Boolean`](Boolean), the return type is also [`Boolean`](Boolean). The arguments are not modified in any way.

 This operator can be overloaded to accept user-defined types as well.

 **`Operator =` (Equality)** should not be confused with initializations or assignments, both of which also use the "`=`" symbol.

## Return Value

Returns negative one (-1) if expressions are equal, or zero (0) if unequal.

## Remarks

### Usage

`result = lhs = rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- none

### See also

- [`Operator <>`](Operator-Not-Equal) (Inequality)
- [`Operator =[>]`](Operator-Assign) (Assignment)

## Examples

```freebasic
Dim i As Integer = 0    '' initialization: initialise i with a value of 0

i = 420                 '' assignment: assign to i the value of 420

If (i = 69) Then        '' equation: compare the equality of the value of i and 69

    Print "serious error: i should equal 420"

    End -1

End If
```

 [`Operator <>`](Operator-Not-Equal) (Inequality) is complement to **`Operator =` (Equality)**, and is functionally identical when combined with [`Operator Not`](Operator-Not-Complement) (Bit-wise Complement).

```freebasic
If (420 = 420) Then Print "(420 = 420) is true."

   If Not (69 <> 69) Then Print "not (69 <> 69) is true."
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
