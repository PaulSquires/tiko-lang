[Home](Home) › [Operators](Category-Operators) › **Operator =[>] (Assign)**

# Operator =[>] (Assign)

Assigns a value to a variable

## Syntax

```freebasic
Declare Operator Let ( ByRef lhs As T1, ByRef rhs As T2 )
```

## Parameters

- `lhs`
- `T1`
- `rhs`
- `lhs`
- `T2`
- `T2`

## Description

This operator assigns the value of its right-hand side operand (`rhs`) to its left-hand side operand (`lhs`). The right-hand side operand must be implicitly convertible to the left-hand side type (`T1`) (for conversion of a boolean to an integer, false or true boolean value becomes 0 or -1 integer value). For example, you cannot assign a numeric value to a string type; to do that, first convert the numeric value to a string using [`Str`](Str) or [`WStr`](Wstr).  
 Assignment between arrays is not supported presently.

 Avoid confusion with [`Operator = (Equal)`](Operator-Equal), which also uses the '`=`' symbol.  
 For this purpose and for solving some cases of ambiguity of the parser (see [`Byref (Function Results)`](Byref-Function-Results)), the alternative symbol '=>' can be used for assignments in place of '=' (same as already for the initializers).

*Note: the '=>' symbol has been chosen against '<=' (already the operator 'Less Than Or Equal') and ':=' (':' used as statement separator).*

This operator can be overloaded for user-defined types as a member [`Operator`](Operator) using the appropriate syntax.

## Remarks

### Usage

`lhs = rhs`*or*`lhs => rhs`*or, in the*QB*dialect,*`[ Let ] lhs = rhs`*or*`[ Let ] lhs => rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.
- In the *[-lang qb](Compiler-Option-Lang)* dialect, an assignment expression can be preceded by the [`Let`](Let) keyword.

### Differences from QB

- None

### See also

- [`Operator = (Equal)`](Operator-Equal)
- [`Operator Let (Assignment)`](Operator-Let-Assign)
- [`Swap`](Swap)
- [Coercion and Conversion](Coercion-and-Conversion)

## Examples

```freebasic
Dim i As Integer

i = 420    ' <- this is the assignment operator

If  i = 69 Then   '<-this is the equivalence operator

  Print "ERROR: i should equal 420"

  End -1

End If

Print "All is good."

End 0
```

```freebasic
' compile with -lang fblite or qb

#lang "fblite"

Dim i As Integer

Let i = 300 ' <-alternate syntax
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
