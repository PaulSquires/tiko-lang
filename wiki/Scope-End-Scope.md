[Home](Home) › [Variable Declarations](Category-Variable-Declarations) › **Scope...End Scope**

# Scope...End Scope

Statement to begin a new scope block

## Syntax

```freebasic
Scope
[statements]
End Scope
```

## Description

The Scope block allows variables to be (re)defined and used locally in a program.

 When a variable is (re)defined with [`Dim`](Dim) within a scope structure, this local working variable can be used from its (re)definition until the end of the scope. During this time, any variables outside the scope that have the same name will be ignored, and will not be accessible by that name. Any statements in the Scope block before the variable is redefined will use the variable as defined outside the Scope.

 The local variables are reserved on stack at granularity level of each procedure (including the main part of the program), not at granularity level of each individual scope block. So a same memory space can be used by local variables belonging to different scope blocks.

 To access duplicated symbols defined as global outside the scope block, add one or preferably two dot(s) as prefix: `.SomeSymbol` or preferably `..SomeSymbol` (or only `..SomeSymbol` if inside a [With..End With](With) block).

 `Scope..End Scope` is not permitted when compiling with in the *[-lang qb](Compiler-Option-Lang)* dialect.

## Remarks

### Dialect Differences

- Explicit `Scope`..`End Scope` blocks are available only in the *[-lang fb](Compiler-Option-Lang)* and *[-lang deprecated](Compiler-Option-Lang)* dialects.
  Explicit `Scope`..`End Scope` blocks are not available in the *[-lang fblite](Compiler-Option-Lang)* and *[-lang qb](Compiler-Option-Lang)* dialects.

### Differences from QB

- New to FreeBASIC

### See also

- [`Dim`](Dim)
- [`ReDim`](Redim)
- [`Static`](procedures-Static)
- [`Var`](Var)
- [`Byref (Variables)`](Byref-Variables)

## Examples

```freebasic
Dim As Integer x = 5, y = 2

Print "x ="; x; ", "; "y ="; y

Scope

    Dim x As Integer = 3

    Print "x ="; x; ", "; "y ="; y

    Scope

        Dim y As Integer = 4

        Print "x ="; x; ", "; "y ="; y

    End Scope

End Scope

Print "x ="; x; ", "; "y ="; y
```

---

**Category:** [Variable Declarations](Category-Variable-Declarations)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
