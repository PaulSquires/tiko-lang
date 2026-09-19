[Home](Home) › [Tutorials](Category-Tutorials) › **Pointers to Procedures**

# Pointers to Procedures

Pointers that point to procedures

 Just as pointers can be made to point to an [`Integer`](Integer) or [`Single`](Single) type, pointers can also point to procedures, that is, they can store the address of a procedure.

Declaration

To declare a pointer to procedure, use the [`Sub`](Sub) or [`Function`](procedures-Function) keywords, followed by any parameters and return value type:

```freebasic
' declares a pointer to sub procedure that takes no arguments

Dim pointerToProcedure As Sub
```

Procedure pointers store procedure addresses, which are retrieved using [`Operator @`](Operator-Address-of) (Address of) or the [`Procptr Operator`](Operator-Procptr-Procedure-Pointer-and-Vtable-Index):

```freebasic
'' pfunc.bi

Function Add (a As Integer, b As Integer) As Integer

    Return a + b

End Function

Dim pFunc As Function (As Integer, As Integer) As Integer = @Add
```

Calling a procedure pointer

The interesting thing about procedure pointers is that they can be called just like a procedure:

```freebasic
'' .. Add and pFunc as before ..

#include Once "pfunc.bi"

Print "3 + 4 = " & pFunc(3, 4)
```

For a calling example of subroutine pointer, see the [`Operator @ (Address Of)`](Operator-Address-of) page.

 **Note:** When calling a procedure through a procedure pointer, parentheses surrounding the argument list (even empty) are mandatory to resolve ambiguity with a simple access to the pointer value.

Passing procedure pointers to procedures

Passing procedure pointers to other procedures is similar as well:

```freebasic
'' .. Add and pFunc as before ..

#include Once "pfunc.bi"

Function DoOperation (a As Integer, b As Integer, operation As Function (As Integer, As Integer) As Integer) As Integer

    Return operation(a, b)

End Function

Print "3 + 4 = " & DoOperation(3, 4, @Add)
```

Because procedure pointer declarations can be lengthy, it often helps to create a type alias for the procedure pointer, in an effort to make clearer code:

```freebasic
'' .. Add and pFunc as before ..

#include Once "pfunc.bi"

Type operation As Function (As Integer, As Integer) As Integer

Function DoOperation (a As Integer, b As Integer, op As operation) As Integer

    Return op(a, b)

End Function

Print "3 + 4 = " & DoOperation(3, 4, @Add)
```

Pointers to procedure pointers

Because the syntax of a procedure pointer does not allow declaration of a pointer to procedure pointer when the procedure is a function (because ptr applies on return type and not on procedure), a type alias is used. Notice how it is necessary to surround a dereferenced pointer to procedure pointer by parenthesis when calling the procedure. This is because the function-call operator '()' has higher precedence than [`Operator *`](Operator-Value-of) (Value of):

```freebasic
Function Halve (ByVal i As Integer) As Integer

    Return i / 2

End Function

Function Triple (ByVal i As Integer) As Integer

    Return i * 3

End Function

Type operation As Function (ByVal As Integer) As Integer

' an array of procedure pointers, NULL indicates the

' end of the array

Dim operations(20) As operation = _

{ @Halve, @Triple, 0 }

Dim i As Integer = 280

' apply all of the operations to a variable by iterating through the array

' with a pointer to procedure pointer

Dim op As operation Ptr = @operations(0)

While (*op <> 0)

    ' call the procedure that is pointed to, note the extra parenthesis

    i = (*op)(i)

    op += 1

Wend

Print "Value of 'i' after all operations performed: " & i
```

Pointers to member procedures

Before fbc 1.10.0, method pointers are not implemented yet, but it is possible to work-around that by using a static wrapper:

```freebasic
/''

 ' This example shows, before fbc 1.10.0, how you can simulate getting a class method pointer,

 ' until support is properly implemented in the compiler.

 '

 ' When this is supported (since fbc 1.10.0), you will only need to remove the static wrapper

 ' function presented here, to maintain compatibility.

 '/

Type T

    Declare Function test(ByVal number As Integer) As Integer

    Declare Static Function test(ByRef This As T, ByVal number As Integer) As Integer

    Dim As Integer i = 420

End Type

Function T.test(ByVal number As Integer) As Integer

    Return i + number

End Function

Function T.test(ByRef This As T, ByVal number As Integer) As Integer

    Return this.test(number)

End Function

Dim p As Function(ByRef As T, ByVal As Integer) As Integer

p = @T.test

Dim As T obj

Print p(obj, 69) '' prints 489
```

Since fbc 1.10.0, method pointers are implemented via updating the 'Procptr' operator:

```freebasic
/''

 ' This example shows, since fbc 1.10.0, how to directly obtain a class method pointer,

 '/

Type T

    Declare Function test(ByVal number As Integer) As Integer

    Dim As Integer i = 420

End Type

Function T.test(ByVal number As Integer) As Integer

    Return i + number

End Function

Dim p As Function(ByRef As T, ByVal As Integer) As Integer

p = ProcPtr(T.test)  '' or 'p = @T.test'

Dim As T obj

Print p(obj, 69) '' prints 489
```

Typing rule for procedure pointer declaration

The procedure pointer declaration allows to assign to the pointer:

Assigning to a function pointer a fonction with a contravariant parameter and a covariant result, both by pointer:

```freebasic
'Example of assigning to a function pointer a function with:

'   - a contravariant parameter by pointer,

'   - and a covariant result by pointer.

Type A

    Dim As Integer I

    Declare Constructor ()

    Declare Destructor ()

End Type

Constructor A ()

    Print "    A instance constructed", @This

End Constructor

Destructor A ()

    Print "    A instance destroyed", @This

End Destructor

Type B Extends A

    Dim As Integer J

    Declare Constructor ()

    Declare Constructor (ByRef a0 As A)

    Declare Destructor ()

End Type

Constructor B ()

    Print "    B instance constructed", @This

End Constructor

Constructor B (ByRef a0 As A)

    Cast(A, This) = a0

    Print "    B instance constructed", @This

End Constructor

Destructor B ()

    Print "    B instance destroyed", @This

End Destructor

Function f (ByVal pa0 As A Ptr) As B Ptr

    Return New B(*pa0)

End Function

Scope

    Dim As Function (ByVal As B Ptr) As A Ptr pf = @f

    Print "'Scope : Dim As B b0':"

    Dim As B b0

    Print

    Print "'Dim As A Ptr pab = pf(@b0)':"

    Dim As A Ptr pab = pf(@b0)

    Print

    Print "'Delete CPtr(B Ptr, pab)':"

    Delete CPtr(B Ptr, pab)

    Print

    Print "'End Scope':"

End Scope

Sleep
```

Assigning to a function pointer a function with a contravariant parameter and a covariant result, both by reference:

```freebasic
'Example of assigning to a function pointer a function with:

'   - a contravariant parameter by reference,

'   - and a covariant result by reference.

Type A Extends Object

    Dim As Integer I

    Declare Constructor ()

    Declare Virtual Destructor ()

End Type

Constructor A ()

    Print "    A instance constructed", @This

End Constructor

Destructor A ()

    Print "    A instance destroyed", @This

End Destructor

Type B Extends A

    Dim As Integer J

    Declare Constructor ()

    Declare Constructor (ByRef a0 As A)

    Declare Virtual Destructor ()

End Type

Constructor B ()

    Print "    B instance constructed", @This

End Constructor

Constructor B (ByRef a0 As A)

    Cast(A, This) = a0

    Print "    B instance constructed", @This

End Constructor

Destructor B ()

    Print "    B instance destroyed", @This

End Destructor

Function f (ByRef a0 As A) ByRef As B

    Return *New B(a0)

End Function

Scope

    Dim As Function (ByRef As B) ByRef As A pf = @f

    Print "'Scope : Dim As B b0':"

    Dim As B b0

    Print

    Print "'Dim Byref As A rab = pf(b0)':"

    Dim ByRef As A rab = pf(b0)

    Print

    Print "'Delete @rab':"

    Delete @rab

    Print

    Print "'End Scope':"

End Scope

Sleep
```

See also

- [`Sub`](Sub)
- [`Function`](procedures-Function)
- [`Pointer`](Pointer-Ptr)
- [`Operator @ (Address Of)`](Operator-Address-of)
- [`Procptr Operator`](Operator-Procptr-Procedure-Pointer-and-Vtable-Index)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
