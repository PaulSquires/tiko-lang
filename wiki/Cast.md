[Home](Home) › [Converting Data Types](Category-Converting-Data-Types) › **Cast**

# Cast

Converts an expression to a specified data type

## Syntax

```freebasic
Cast( datatype, expression )
```

## Parameters

- `datatype`
- `expression`

## Description

Converts `expression` into a different `datatype`. Useful to be used in macros when `datatype` is unknown and also when converting to [Type Alias](Type-Alias).

 This is a general form of conversion operators such as [`CInt`](Cint) or [`CDbl`](Cdbl).  
 `Cast` is more versatile because it can be used on built-in types that have a built-in [`Cast Operator`](Operator), but don't have a built-in keyword for it: e.g. `Cast( Byte, boolean )`.  
 It is also suitable for use in cases where the type of a variable is not fixed in the code - for example, it might be [`Define`](Define)d earlier, or may be the [`Type Of`](Typeof) a different variable or expression.

 **Note:** If you want to use an operator specifically for converting to different types of [`Pointer`](Pointer-Ptr)s, consider using [`CPtr`](Cptr) instead.

 **Upcasting:** In an inheritance structure, the upcasting is converting a derived type reference or pointer into a base type.
 In this special use, `Cast` applied on a derived-type instance (`expression`) can be used to return a base-type (`datatype`) reference.

 By using a member [`Operator Cast`](Operator-Cast), `Cast` can be overloaded for a user defined type expression.

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Cast`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Cast (Operator)`](Operator-Cast)
- [`CPtr`](Cptr)
- [`CInt`](Cint)
- [`TypeOf`](Typeof)

## Examples

```freebasic
'' will print -128 because the integer literal will be converted to a signed Byte

'' (this Casting operation is equivalent to using CByte)

Print Cast( Byte, &h0080 )

'' will print 3 because the floating-point value will be converted to an Integer

'' (this Casting operator is equivalent to using CInt)

Print Cast( Integer, 3.1 )

Sleep
```

```freebasic
'' macro sizeofDerefPtr(): returns the size of the dereferenced pointer

#define sizeofDerefPtr(ptrToDeref) SizeOf(*Cast(TypeOf(ptrToDeref), 0))

'' macro typeofDerefPtr(): returns the type of the dereferenced pointer

#define typeofDerefPtr(ptrToDeref) TypeOf(*Cast(TypeOf(ptrToDeref), 0))

' Allocate dynamically memory for a Double by New

Dim As Double Ptr pd

pd = New typeofDerefPtr(pd)

*pd = 3.14159

Print *pd

' Allocate dynamically memory for a Zstring*10 by Callocate

Dim As ZString Ptr pz

pz = CAllocate(10, sizeofDerefPtr(pz))

*pz = "FreeBASIC"

Print *pz

Sleep

Delete pd

Deallocate(pz)
```

---

**Category:** [Converting Data Types](Category-Converting-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
