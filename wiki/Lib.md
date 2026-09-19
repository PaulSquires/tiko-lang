[Home](Home) › [Procedures](Category-Procedures) › **Lib**

# Lib

Specifies the library where a sub or function can be found as part of a declaration

## Syntax

```freebasic
Declare { Sub | Function } proc_name Lib "libname" [ Alias "symbol_name" ] ( arguments list ) As return_type
Extern "mangling" lib "libname"
declarative statements
end Extern
Type T
As Integer dummy
Declare Constructor Lib "libname" [ Alias "symbol_name" ] ( arguments list )
end Type
```

## Description

In [`Sub`](Sub) or [`Function`](procedures-Function) declarations, and also in class method declarations (including constructors and destructors), `Lib` indicates the library containing the function. Libraries specified in this way are linked in as if [`#Inclib "Libname"`](Inclib) or [`-l libname`](Compiler-Option-L) had been used.

 `Lib` can also be used with [Extern ... End Extern Blocks](Extern-End-Extern) to specifiy a `Lib` for all declarations inside.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`Declare`](Declare)
- [`#inclib`](Inclib)

## Examples

```freebasic
'' mydll.bas

'' compile with:

''   fbc -dll mydll.bas

Public Function GetValue() As Integer Export

  Function = &h1234

End Function
```

```freebasic
Declare Function GetValue Lib "mydll" () As Integer

Print "GetValue = &h"; Hex(GetValue())

' Expected Output :

' GetValue = &h1234
```

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** type

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
