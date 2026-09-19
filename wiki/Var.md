[Home](Home) › [Variable Declarations](Category-Variable-Declarations) › **Var**

# Var

Declares a variable whose type is implied from the initializer expression

## Syntax

```freebasic
[Static] Var [Shared] symbolname = expression[, symbolname = expression]
```

## Description

`Var` declares a variable whose type is implied from the initializer expression. It is illegal to specify an explicit type in a `Var` declaration. The initializer expression can be either a constant or any variable of any type.

 Note: [`WString`](Wstring) is not supported with `Var`, due to the fact that there is no var-len [`WString`](Wstring) type. This isn't likely to change, due to the complexities involved with handling Unicode.

 Since the type of the variable is inferred from what you assign into it, it's helpful to know how literals work. Any literal number without a decimal point defaults to [`Integer`](Integer). A literal number *with* a decimal point defaults to [`Double`](Double). See [Literals](Literals) for further information.

 All [`ZString`](Zstring) expressions, including string literals and dereferenced [`ZString`](Zstring) [`Ptr`](Pointer-Ptr)s, will be given the [`String`](String) variable type.

 Explicit suffixes may be used on literal variables, to change/clarify their type. See [Literals](Literals) and [Variable Types](Standard-Data-Type-Limits) for some more information about suffixes that can be used on literals.

 Note: Suffixes must appear on the initializer, not on the variable. Trying to use `Var` with a variable that has a suffix will throw a compile error.

## Remarks

### Differences from QB

- New to FreeBASIC

### Dialect Differences

- Only valid in the *[-lang fb](Compiler-Option-Lang)* dialect.

### See also

- [`Common`](Common)
- [`Dim`](Dim)
- [`Erase`](Erase)
- [`Extern`](Extern)
- [`LBound`](Lbound)
- [`ReDim`](Redim)
- [`Preserve`](Preserve)
- [`Shared`](Shared)
- [`Static`](procedures-Static)
- [`Byref (Variables)`](Byref-Variables)
- [`UBound`](Ubound)
- [Pointers to Procedures](Pointers-to-Procedures)

## Examples

```freebasic
Var a  = Cast(Byte, 0)

Var b  = Cast(Short, 0)

Var c  = Cast(Integer, 0)

Var d  = Cast(LongInt, 0)

Var au = Cast(UByte, 0)

Var bu = Cast(UShort, 0)

Var cu = Cast(UInteger, 0)

Var du = Cast(ULongInt, 0)

Var e  = Cast(Single, 0.0)

Var f  = Cast(Double, 0.0)

Var g  = @c      '' integer ptr

Var h  = @a      '' byte ptr

Var s2 = "hello" '' var-len string

Var ii = 6728   '' implicit integer

Var id = 6728.0 '' implicit double

Print "Byte: ";Len(a)

Print "Short: ";Len(b)

Print "Integer: ";Len(c)

Print "Longint: ";Len(d)

Print "UByte: ";Len(au)

Print "UShort: ";Len(bu)

Print "UInteger: ";Len(cu)

Print "ULongint: ";Len(du)

Print "Single: ";Len(e)

Print "Double: ";Len(f)

Print "Integer Pointer: ";Len(g)

Print "Byte Pointer: ";Len(h)

Print "Variable String: ";Len(s2)

Print

Print "Integer: ";Len(ii)

Print "Double: ";Len(id)

Sleep
```

---

**Category:** [Variable Declarations](Category-Variable-Declarations)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
