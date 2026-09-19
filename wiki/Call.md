[Home](Home) › [Procedures](Category-Procedures) › **Call**

# Call

Statement to invoke a subroutine

## Syntax

```freebasic
Call procname ([parameter list])
```

## Description

Calls a [`Sub`](Sub) or [`Function`](procedures-Function).

 This keyword is a holdover from earlier dialects of BASIC, and is mainly deprecated.

 In *[-lang qb](Compiler-Option-Lang)*, it can be used to call [`Sub`](Sub)s in code before they are declared. The function will be implicitly [`Declare`](Declare)'d, with any parameters passed `ByRef As Any`.  
 Note: until the function is declared, no type-checking is done on the parameters, so it is up to the programmer to ensure they are of the correct type.

## Remarks

### Dialect Differences

- The use of `Call` is not allowed in the *[-lang fb](Compiler-Option-Lang)* dialect.
  The *[-lang fblite](Compiler-Option-Lang)* dialect does not allow you to call functions that have not been previously declared.

### Differences from QB

- The procedure must have already been declared.
  `Call` in QB will make a copy of all parameters, so changes made to the arguments inside the called [`Sub`](Sub) will not be reflected in the variables in the caller.

### See also

- [`Declare`](Declare)
- [`Sub`](Sub)

## Examples

```freebasic
'' Compile with -lang qb or -lang fblite

#lang "fblite"

Declare Sub foobar(ByVal x As Integer, ByVal y As Integer)

Call foobar(35, 42)

Sub foobar(ByVal x As Integer, ByVal y As Integer)

Print x; y

End Sub
```

```freebasic
'' Compile with -lang qb or -lang fblite

#lang "fblite"

Function f ( ) As Integer

f = 42

End Function

Call f ' execute function f, but ignore the answer
```

```freebasic
'' Compile with -lang qb

'$lang: "qb"

Call mysub(15, 16) '' call "mysub" before it has been declared, or even mentioned.

Sub mysub(ByRef a As Integer, ByRef b As Integer)

    Print a, b

End Sub
```

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
