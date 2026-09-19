[Home](Home) › [Procedures](Category-Procedures) › **ByVal**

# ByVal

Declaration specifier to explicitly pass a parameter by value

## Syntax

```freebasic
ByVal param As datatype
```

## Description

`ByVal` in a parameter list of a declare statement causes a copy of the variable to be passed to the procedure (for example, a sub or function) by its value.

 This means that if the value of the variable *`x`* is passed, then the original variable *`x`* will not be modified in any way; however, if the variable were passed [`ByRef`](Byref-Parameters), the value of the original variable *`x`* could be modified by the called function.

 Opposite of [`ByRef`](Byref-Parameters).

 The `ByVal` keyword is also used in the context of `Byref` [Parameters](Byref-Parameters) and [Function Results](Byref-Function-Results), where it can be used to explicitly override the by-reference semantics in order to pass or assign a pointer as-is to a `Byref` parameter or function result. For reference:

**Note:** `ByVal` (passing by copy) is good for small objects (4 or 8 bytes, a bit more will still be ok) that are easy to copy, like numeric types. Passing `ByVal` avoids the overhead of the pointer used by [`ByRef`](Byref-Parameters).
 [`ByRef`](Byref-Parameters) is better for passing huge objects like strings or big UDTs that should not be copied. Even though [`ByRef`](Byref-Parameters) has some overhead because it has to pass a pointer (and dereference at each access to the object), this is still better than copying a multitude of bytes on to the stack every-time the procedure is called.

## Remarks

### Usage

`[ Declare ] { Sub | Function } proc_name ( ByVal param As datatype )`

### Dialect Differences

- In the *[-lang fb](Compiler-Option-Lang)* dialect, `ByVal` is the default parameter passing convention for all built-in types except [`String`](String) and user-defined [`Type`](Type-Udt) which are passed [`ByRef`](Byref-Parameters) by default. The [`ZString`](Zstring) and [`WString`](Wstring) built-in types are also passed [`ByRef`](Byref-Parameters) by default, but passing `ByVal` is forbidden. Arrays are always passed [`ByRef`](Byref-Parameters) and the use of the specifier [`ByRef`](Byref-Parameters) or `ByVal` is forbidden.
  In *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects, [`ByRef`](Byref-Parameters) is the default parameter passing convention.

### Differences from QB

- QB only used `ByVal` in declarations to non-Basic subroutines

### See also

- [Passing Arguments to Procedures](Passing-Arguments-to-Procedures)
- [`Declare`](Declare)
- [`ByRef`](Byref-Parameters)

## Examples

```freebasic
Sub MySub(ByVal value As Integer)

    value += 1

End Sub

Dim MyVar As Integer

MyVar = 1

Print "MyVar: "; MyVar 'output = 1

MySub MyVar

Print "MyVar: "; MyVar 'output = 1, because byval won't change the values passed into it globally.

Sleep

End
```

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
