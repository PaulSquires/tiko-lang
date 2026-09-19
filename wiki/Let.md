[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **Let**

# Let

Indicates the assignment operator.

## Syntax

```freebasic
Let variable = value
Let( variable1 [, variable2 [, ... ]] ) = udt
Operator typename.Let ( [ ByRef | ByVal ] rhs As datatype )
statements
end operator
```

## Description

Command intended to help the programmer to distinguish an assignment statement (e.g. `Let a = 1`) from an equality test (e.g. `If a = 1 then ...`). As the compiler does not require it, it is usually omitted.

 **Let** can be used as a left-hand side operator to assign the members of a user defined type to multiple variables. *See [`Operator Let() (Assignment)`](Operator-Let-Assignment)*

 **Let** is used with operator overloading to refer the assignment operator. *`See Operator Let (Assignment)`*

## Remarks

### Dialect Differences

- The use of `Let` to indicate an assignment statement (`Let variable = expr`) is not allowed in the *[-lang fb](Compiler-Option-Lang)* dialect.
  The UDT to multi-variable Let assignment is only available in the *[-lang fb](Compiler-Option-Lang)* dialect.  
  Overloading of operators is not available in the *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects.

### Differences from QB

- None in the *[-lang fb](Compiler-Option-Lang)* dialect.
- The Let operator is new to FreeBASIC.
- The UDT to multi-variable Let assignment is new to FreeBASIC.

### See also

- [`Operator =[>] (Assignment)`](Operator-Assign)
- [`Operator Let (Assignment)`](Operator-Let-Assign)
- [`Operator Let() (Assignment)`](Operator-Let-Assignment)
- [`Operator`](Operator)

## Examples

```freebasic
'' Compile with -lang fblite or qb

#lang "fblite"

' these two lines have the same effect:

Let x = 100

x = 100
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
