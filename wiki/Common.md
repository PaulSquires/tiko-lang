[Home](Home) › [Modularizing](Category-Modularizing) › **Common**

# Common

Variable declaration and scope modifier

## Syntax

```freebasic
Common [Shared] symbolname[()] [AS DataType] [, ...]
```

## Description

Declares a variable which is shared between code modules, including those to be compiled as static and dynamic libraries (DLLs).  
 A matching `Common` statement must appear in all other code modules using the variable.

 `Common` variables cannot be initialized.  
 `Common` arrays are always variable-length, and must be defined with an empty parameter list `()`, and its dimensions set in a later [`Dim`](Dim) or [`ReDim`](Redim) statement.  
 `Common` variables cannot be instances of a user-defined type having a constructor or a destructor even implicit.

 The `Shared` optional parameter makes the variable global so that it can be used inside [`Sub`](Sub)s and [`Function`](procedures-Function)s, as well as at module level.

## Remarks

### Platform Differences

- Windows does not support `Common` with a dynamic library (compiled with -dll or -dylib).

### Differences from QB

- The arrays will be always variable-length.
- `blockname` is not needed and must be removed because the order of declaration no longer matters, only the symbol names.
- `Common` does not allow to keep the values of certain variables when chaining programs with [`Chain`](Chain).

### See also

- [`Dim`](Dim)
- [`Erase`](Erase)
- [`Extern`](Extern)
- [`LBound`](Lbound)
- [`ReDim`](Redim)
- [`Preserve`](Preserve)
- [`Shared`](Shared)
- [`Static`](procedures-Static)
- [`UBound`](Ubound)
- [`Var`](Var)

## Examples

```freebasic
'' common1.bas

Declare Sub initme()

Common Shared foo() As Double

ReDim foo(0 To 2)

initme()

Print foo(0), foo(1), foo(2)
```

```freebasic
'' common2.bas

Common Shared foo() As Double

Sub initme()

  foo(0) = 4*Atn(1)

  foo(1) = foo(0)/3

  foo(2) = foo(1)*2

End Sub
```

 After compiling the two files like:  
 `fbc common1.bas common2.bas`  
 running `common1` produces the output:

```freebasic
 3.141592653589793           1.047197551196598           2.094395102393195
```

---

**Category:** [Modularizing](Category-Modularizing)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
