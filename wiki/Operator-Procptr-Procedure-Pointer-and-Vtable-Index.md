[Home](Home) › [Operators](Category-Operators) › **Operator Procptr (Procedure Pointer And Vtable Index)**

# Operator Procptr (Procedure Pointer And Vtable Index)

Returns the address of any procedure, and the index in the vtable for a virtual/abstract member procedure.

## Syntax

```freebasic
Declare Operator ProcPtr ( ByRef identifier As proctype [, Any|user_proctype ] ) As internal_proctype Ptr
Declare Operator ProcPtr ( ByRef identifier As proctype, virtual [ Any|user_proctype ] ) As Integer
```

## Parameters

- `identifier`
- `user_proctype`
- `internal_proctype`

## Description

First syntax:

- This operator returns the address of a [`Sub`](Sub) or [`Function`](procedures-Function) static/member procedure or member operator.
 - The type of the return value corresponds to the internal signature of the procedure (user signature, plus a supplementary first parameter `byref as udt_name` for a member procedure) .

Second syntax (with qualifier `virtual`):

- This operator returns the zero based index in the vtable for a virtual/abstract member procedure or member operator.
 - In case of overridden member procedure (polymorphism), the vtable index allows access, from the vtable of the used instance, to the address of the most derived override member procedure.

When using the `user_proctype` argument, `ProcPtr` syntax allows of getting procedure pointer or vtable index for based on parameter types (including sub/function type and return type if any).  
 This makes it possible to explicitly specify the right procedure to resolve procedure overloads, or make a check for parameter types (including sub/function type and return type if any) on non-overloaded procedures.

 [`Operator @ (Address Of)`](Operator-Address-of), when used with procedures, behaves the same as the first `ProcPtr` syntax without second argument.

 **Note:**

- If the procedure member is abstract, then `ProcPtr ( identifier [, any|user_proctype ] )` returns a null procedure pointer of the member procedure call signature (`internal_proctype`).
 - If there is no vtable entry (or no vtable at all) then `ProcPtr ( identifier , virtual [any|user_proctype] )` returns the special value of `-1`.

## Return Value

Returns the address of any procedure (first syntax), or the index in the vtable for a virtual/abstract member procedure (second syntax with additional qualifier `virtual`).  
 (`any`, ie any procedure signature, does not induce any particular selection (compared to its non-use), but just allows for writing `ProcPtr` always with 2 arguments)

## Remarks

### Usage

`result = ProcPtr ( identifier [, [virtual] [any|user_proctype] ] )`

### Version

- Before fbc 1.10.0, the member procedures/operators were not supported.
- Before fbc 1.09.0, the second argument (the optional) was not supported.

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Procptr` (but does not support qualifier `virtual`).

### Differences from QB

- New to FreeBASIC

### See also

- [`Sub`](Sub)
  [`VarPtr`](Operator-Varptr-Variable-Pointer)  
  [`StrPtr`](Operator-Strptr-String-Pointer)  
  [`Any`](Any)

  ```freebasic
  Virtual

   Pointers
  ```

## Examples

```freebasic
' This example uses ProcPtr to demonstrate function pointers

Declare Function Subtract( x As Integer, y As Integer) As Integer

Declare Function Add( x As Integer, y As Integer) As Integer

Dim myFunction As Function( x As Integer, y As Integer) As Integer

' myFunction will now be assigned to Add

myFunction = ProcPtr( Add )

Print myFunction(2, 3)

' myFunction will now be assigned to Subtract.  Notice the different output.

myFunction = ProcPtr( Subtract )

Print myFunction(2, 3)

Function Add( x As Integer, y As Integer) As Integer

    Return x + y

End Function

Function Subtract( x As Integer, y As Integer) As Integer

    Return x - y

End Function
```

```freebasic
Sub s Overload()

End Sub

Sub s( ByVal i As Integer )

End Sub

'----- since fbc 1.09.0, ProcPtr supports a second parameter (optional):

Var s1 = ProcPtr( s, Sub() )

Var s2 = ProcPtr( s, Sub( ByVal i As Integer ) )

'----- before fbc 1.09.0, it was only possible with:

'Dim s1 As Sub()

's1 = ProcPtr( s )

'Dim s2 As Sub( Byval i As Integer)

's2 = ProcPtr( s )
```

```freebasic
' Since fbc 1.10.0, ProcPtr supports the member procedures/operators with various syntaxes

Type UDT Extends Object

    Dim As String s1

    Dim As String s2

    Declare Virtual Sub test()

    Declare Virtual Operator Cast() As String

End Type

Sub UDT.test()

    Print This.s1

End Sub

Operator UDT.Cast() As String

    Return This.s2

End Operator

Var testPtr1 = ProcPtr(UDT.test)

Var testPtr2 = ProcPtr(UDT.test, Any)

Var testPtr3 = ProcPtr(UDT.test, Sub())

Dim As Function(ByRef As UDT) As String castPtr1 = ProcPtr(UDT.cast)

Dim As Function(ByRef As UDT) As String castPtr2 = ProcPtr(UDT.cast, Any)

Dim As Function(ByRef As UDT) As String castPtr3 =  ProcPtr(UDT.cast, Function() As String)

Var testIndex1 = ProcPtr(UDT.test, Virtual)

Var testIndex2 = ProcPtr(UDT.test, Virtual Any)

Var testIndex3 = ProcPtr(UDT.test, Virtual Sub())

Dim As Integer castIndex1 = ProcPtr(UDT.cast, Virtual)

Dim As Integer castIndex2 = ProcPtr(UDT.cast, Virtual Any)

Dim As Integer castIndex3 = ProcPtr(UDT.cast, Virtual Function() As String)

Print testPtr1  '' absolue address value of UDT.test pointer

Print testPtr2  '' absolue address value of UDT.test pointer

Print testPtr3  '' absolue address value of UDT.test pointer

Print

Print castPtr1  '' absolue address value of UDT.Cast pointer

Print castPtr2  '' absolue address value of UDT.Cast pointer

Print castPtr3  '' absolue address value of UDT.Cast pointer

Print

Print testIndex1  '' vtable index of UDT.test

Print testIndex2  '' vtable index of UDT.test

Print testIndex3  '' vtable index of UDT.test

Print

Print castIndex1  '' vtable index of UDT.Cast

Print castIndex2  '' vtable index of UDT.Cast

Print castIndex3  '' vtable index of UDT.Cast

Print

Dim As UDT u

u.s1 = "Virtual Sub test()"

u.s2 = "Virtual Operator Cast() As String"

testPtr1(u)  '' execute u.test() through its procedure pointer

testPtr2(u)  '' execute u.test() through its procedure pointer

testPtr3(u)  '' execute u.test() through its procedure pointer

Print

Print castPtr1(u)  '' execute Cast(UDT, u) through its procedure pointer

Print castPtr2(u)  '' execute Cast(UDT, u) through its procedure pointer

Print castPtr3(u)  '' execute Cast(UDT, u) through its procedure pointer

Print

CPtr(Sub(ByRef As UDT), CPtr(Any Ptr Ptr Ptr, @u)[0][testIndex1])(u)  '' execute u.test() through its vtable index

CPtr(Sub(ByRef As UDT), CPtr(Any Ptr Ptr Ptr, @u)[0][testIndex2])(u)  '' execute u.test() through its vtable index

CPtr(Sub(ByRef As UDT), CPtr(Any Ptr Ptr Ptr, @u)[0][testIndex3])(u)  '' execute u.test() through its vtable index

Print

Print CPtr(Function(ByRef As UDT) As String, CPtr(Any Ptr Ptr Ptr, @u)[0][castIndex1])(u)  '' execute Cast(UDT, u) through its vtable index

Print CPtr(Function(ByRef As UDT) As String, CPtr(Any Ptr Ptr Ptr, @u)[0][castIndex2])(u)  '' execute Cast(UDT, u) through its vtable index

Print CPtr(Function(ByRef As UDT) As String, CPtr(Any Ptr Ptr Ptr, @u)[0][castIndex3])(u)  '' execute Cast(UDT, u) through its vtable index

Print

Sleep
```

```freebasic
' Since fbc 1.10.0, ProcPtr also allows to access the vtable index of a virtual/abstract member procedure/operator

Type Parent Extends Object

    Declare Abstract Sub VirtualTest()

    Declare Virtual Operator Cast() As String

    Declare Sub NormalTest()

End Type

Operator Parent.Cast() As String

    Return "Parent.Cast() As String"

End Operator

Sub Parent.NormalTest()

    Print "Parent.NormalTest()"

End Sub

Type Child Extends Parent

    Declare Virtual Sub VirtualTest()          '' or Declare Sub test()

    Declare Virtual Operator Cast() As String  '' or Declare Operator Cast() As String

    Declare Sub NormalTest()

End Type

Sub Child.VirtualTest()

    Print "Child.VirtualTest"

End Sub

Operator Child.Cast() As String

    Return "Child.Cast() As String"

End Operator

Sub Child.NormalTest()

    Print "Child.NormalTest()"

End Sub

Dim As Parent Ptr p = New Child

(*p).VirtualTest()      '' or p->VirtualTest()

Print Cast(Parent, *p)  '' or Print *p

(*p).NormalTest()       '' or p->NormalTest()

Print

#define RuntimeProcPtr(instance, procedure, signature...) _   '' pointer to procedure

    __FB_IIF__(ProcPtr(procedure, Virtual signature) >= 0, _  '' (the most derived override if exists)

               CPtr(TypeOf(ProcPtr(procedure, signature)), _

                    CPtr(Any Ptr Ptr Ptr, @(instance)) _

                    [0][ProcPtr(procedure, Virtual signature)]), _

               ProcPtr(procedure, signature))

'' Here, providing the procedure signature to the macro is useless

'' (because there are no procedure overloads to solve in this case)

RuntimeProcPtr(*p, Parent.VirtualTest)(*p)  '' execute (*p).VirtualTest() through its vtable index

Print RuntimeProcPtr(*p, Parent.Cast)(*p)   '' execute Cast(Parent, *p) through its vtable index

RuntimeProcPtr(*p, Parent.NormalTest)(*p)   '' execute (*p).NormalTest() through its compile address

Print

Delete p

Sleep
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
