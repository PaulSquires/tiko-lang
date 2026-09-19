[Home](Home) › [Standard Data Types](Category-Standard-Data-Types) › **Const (Qualifier)**

# Const (Qualifier)

Specifies that a data type or pointer data type is read only.

## Syntax

```freebasic
... As [Const] datatype [ [Const] Ptr ... ]
```

## Parameters

- `datatype`

## Description

Specifies that the `datatype` or [`Ptr`](Pointer-Ptr) immediately to the right of the `Const` qualifier is to be considered as read only. Read-only (`Const`) declarations are a measure of type safety that can be read as 'promises not to change.' The compiler uses the const declarations to check operations on variables and parameters and generate an error at compile time if their data could potentially change. There is no runtime overhead for using `Const` qualifiers since all of the checks are made at compile time.

 `Const` can be used anywhere data type declarations are made. This includes variables, parameters, function return results, user defined type fields, type aliases, and casting. The `datatype` can be any built-in standard data type or user defined type.

 Read-only variables must have an initializer since modifying a read-only variable through an assignment will generate a compiler error. The initializer may appear after the declaration of the variable.

 Both non-const and const variables may be passed to a procedure expecting a const parameter. However, a const variable may not be passed to a procedure taking a non-const parameter, and will generate a compile error.

 Procedures can be overloaded based on the const-ness of parameters. For example a procedure can be overloaded where one version of the procedure takes a `'byref foo as bar'` parameter and another version of the procedure takes a `'byref foo as const bar'` parameter.

 With pointer declarations, `Const` can be used to indicate which part of the pointer declaration is read-only (all other parts are by default read-write). The read-only portion of the pointer data type could be the pointer itself (the address), what the pointer points to (the data), or both. In a declaration with more than one level of [`Ptr`](Pointer-Ptr) indirection, the right most [`Ptr`](Pointer-Ptr) indicates the highest order level of indirection and is therefore dereferenced first.

 The compiler has an internal hard-limit of eight (8) levels of pointer indirection with respect to const qualifiers and the behavior of using `Const` with [`Ptr`](Pointer-Ptr) data types having greater than eight (8) levels of indirection is undefined.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`Const`](Const)
- [`Const (Member)`](Const-Member)
- [`Dim`](Dim)
- [`Type`](Type-Udt)

## Examples

```freebasic
'' Const Variables

'' procedure taking a const parameter

Sub proc1( ByRef x As Const Integer )

  '' can't change x because it is const

  '' x = 10 '' compile error

  '' but we can use it in expressions and

  '' assign it to other variables

  Dim y As Integer

  y = x

  y = y * x + x

End Sub

'' procedure taking a non-const parameter

Sub proc2( ByRef x As Integer )

  '' we can change the value

  x = 10

End Sub

'' declare a non-const and const variable

Dim a As Integer

Dim b As Const Integer = 5

'' proc1() will accept a non-const or const

'' argument because proc1() promises not to

'' change the variable passed to it.

proc1( a )

proc1( b )

'' proc2() will accept a non-const argument

proc2( a )

'' but not a const argument because proc2()

'' might change the variable's data and we

'' promised that 'b' would not change.

'' proc2( b ) '' compile error
```

```freebasic
'' Const Pointers

'' an integer

Dim x As Integer = 1

Dim y As Integer = 2

Dim z As Integer = 3

'' To check that the compiler generates errors

'' when attempting to reassign const variables,

'' uncomment the assignments below.

''

Scope

  '' a pointer to an integer

  Dim p As Integer Ptr = @x

  p = @y       /' OK - pointer can be changed '/

  *p = z       /' OK - data can be changed '/

End Scope

''

Scope

  '' a pointer to a constant integer

  Dim p As Const Integer Ptr = @x

  p = @y       /' OK - pointer can be changed '/

  '' *p = z    /' Error - data is const '/

End Scope

''

Scope

  '' a constant pointer to an integer

  Dim p As Integer Const Ptr = @x

  '' p = @y    /' Error - pointer is const '/

  *p = z       /' OK - data can be changed '/

End Scope

''

Scope

  '' a constant pointer to a constant integer

  Dim p As Const Integer Const Ptr = @x

  '' p = @y    /' Error - pointer is const '/

  '' *p = z    /' Error - data is const '/

End Scope
```

```freebasic
'' Const Parameters in an Overloaded Procedure

'' procedure with non-const parameter

Sub foo Overload( ByRef n As Integer )

  Print "called 'foo( byref n as integer )'"

End Sub

'' procedure with const parameter

Sub foo Overload( ByRef n As Const Integer )

  Print "called 'foo( byref n as const integer )'"

End Sub

Dim x As Integer = 1

Dim y As Const Integer = 2

foo( x )

foo( y )

'' OUTPUT:

'' called 'foo( byref n as integer )'

'' called 'foo( byref n as const integer )'
```

---

**Category:** [Standard Data Types](Category-Standard-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
