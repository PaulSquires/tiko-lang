[Home](Home) › [Tutorials](Category-Tutorials) › **Variadic Arguments**

# Variadic Arguments

Allows a procedure to accept a **variable** number of **arguments**.

 **Preamble:**

 Normal procedures take a fixed number of arguments. When such a procedure is defined, the data-type of each argument is specified.  
 Every call to this procedure should supply the expected number of arguments, with types that can be converted to the specified ones.

 Variadic arguments allow to define procedures which accept a variable number of arguments.  
 Support for variadic procedures differs widely among programming languages.

 Variadic procedures can expose type-safety problems because the language support for variadic procedures is not type-safe:

- it allows to extract any number of arguments from the stack or elsewhere,
 - and this while defining their types from entered user parameters.

If the variable arguments are all of same type or compatible with the same type, a sized array can be passed instead, but this requires slightly more work at the caller level.

 *Table of Contents*

**1. Syntax for using variadic procedures**
 **2. ' FB's va\_\* ' support's keywords family** (**deprecated** `va_*` support but kept for backwards compatibility on some targets)
 **3. ' C's va\_\* ' support's keywords family** (**recommended** `va_*` support for all new coding)

1. Syntax for using variadic procedures

The ellipsis `"..."` (three dots), as last parameter, is used in procedure declarations (and definitions) to indicate a variable length argument list:

**-** A first fixed parameter (at least) must always be specified:

The fixed parameters(s) can provide information about how many variadic arguments there are, by any mechanism not imposed on the user.  
 Otherwise a terminal argument can be added in the variable length argument list, but this reserves a special argument value forbidden to the useful variadic arguments.

(if one choose to pass the variable arguments all by pointer, in this case an obvious terminal argument is the null pointer)

**-** The procedure must be called with the C calling convention [`cdecl`](Cdecl).
 **-** Two `va_*` support's keywords families exist to retrieve the variable arguments in the variadic procedure body.
 **-** A variadic procedure can never be overloaded:

so this also excludes its use in UDT for constructors and properties,  
 but otherwise it can be declared abstract or virtual or even overriding.

**-** For variadic procedure members, the implicit passed [This](This) parameter is not taken into account as first fixed parameter (at least one explicit fixed parameter must always be specified).

*Declaration syntax*

[Declare](Declare) { [Sub](Sub) | [Function](procedures-Function) } *proc_name* [cdecl](Cdecl) ( *param_list*, **...** ) { | \[ [ByRef](Byref-Function-Results) \] [As](As) *return_type* }

`param_list`

Parenthesized comma-separated list of fixed parameters.

`return_type`

The return type of a [`Function`](procedures-Function).

`proc_name`

The name or symbol of the procedure.

*Calling syntax*

There is nothing special to do for calling a variadic procedure.  
 The procedure is simply called by writing the arguments for the fixed parameters, followed by the additional variable arguments, as usual.

 Only numeric types and pointers are supported as variable arguments:

**-** All bytes and shorts passed on variable arguments are implicitly converted to integers.
 **-** All singles passed on variable arguments are implicitly converted to doubles.
 **-** [`String`](String)s `(or WString`s`)` can be directly passed by user, in which case a `ZString Ptr` `(or a WString Ptr)` to the string (or the wstring) data is taken into account as internal passed argument.

*Retrieving variable arguments*

Variable arguments may use the stack, or registers, as per the normal conventions for the compiler:

**-** For some compilers in the past, while registers were used for normal procedures, stack was (always) used for variadic procedures.
 **-** The gcc compiler family all seem to agree that the call signatures for variadic procedures are exactly the same as properly specified procedures. This means that some of the variable arguments may be in registers and some may be on the stack if there are too many.

The `va_*` support's keywords create an interface to retrieve these variable arguments in procedure body:

**-** The first FreeBASIC `va_*` support's keywords family developed have been the FB's `va_*` support's keywords family:

These FB's `va_*` support's keywords are very x86-specific and only work with the gas for x86 GAS assembly backend, because using a pointer to the argument stack.  
 These FB's `va_*` support's keywords don't work on all targets (like 64-bit) because arguments can be passed to procedures in cpu registers.  
 These FB's `va_*` support's keywords are now deprecated but kept for backwards compatibility on some targets.

**-** More recently, a FreeBASIC update added a new support's keywords family for variadic procedure argument lists:

This is the C's `va_*` support's keywords family compatible for all target platforms.  
 These C's `va_*` support's keywords are now recommended for all new coding.

Back to top

2. ' FB's va\_\* ' support's keywords family

**Deprecated** `va_*` support but kept for backwards compatibility on some targets.

 There are 3 FB's `va_*` support's keywords (`va_first`, `va_arg`, `va_next`):

`pointer_variable = va_first( )`

`va_first` provides an untyped [pointer](Pointers) value that points to the first variable argument passed to a procedure.

`variable = va_arg( argument_list, datatype )`

`va_arg` returns the current argument in the list, `argument_list`, with an expected data type of `datatype`.  
 (before first `va_arg` use, `argument_list` must be initialized with the command `va_first`)

`argument_pointer = va_next( argument_list, datatype )`

`va_next` provides a `datatype` pointer value that points to the next argument within the list `argument_list`, `datatype` being the type of the current argument being stepped over.

Note:

`pointer_variable = va_first( )`  
 computes the address in the stack following the address of the last passed fixed parameter.

 `variable = va_arg( argument_list, datatype )`  
 is equivalent to:  
 `variable = *CPtr( datatype Ptr, CPtr( Any Ptr, argument_list ) )`

 `argument_pointer = va_next( argument_list, datatype )`  
 is equivalent to:  
 `argument_pointer = CPtr( datatype Ptr, CPtr( Any Ptr, argument_list ) ) + 1`

Examples:

```freebasic
' Variadic function:

'    The first(fixed) parameter provides the number of elements.

'    The variable arguments are all strings except the last one which must be a float.

'    The user's string arguments are in fact passed under the hood through zstring pointers.

Function concatenation cdecl (ByVal count As Integer, ...) As String

    Dim arg As Any Ptr

    Dim s As String

    arg = va_first()

    For i As Integer = 1 To count

        If i < count Then

            s &= *va_arg(arg, ZString Ptr)

            arg = va_next(arg, ZString Ptr)

        Else

            s &= va_arg(arg, Double)

        End If

    Next

    Return s

End Function

Print concatenation(6, "Free", "BASIC", " ", "version", " ", 0.13)

Sleep

' Output: FreeBASIC version 0.13
```

```freebasic
' Variadic sub:

'    The first(fixed) parameter provides the number of elements.

'    The variable arguments are all UDT Ptr.

Type UDT

    Dim As String s

    Dim As Single d

End Type

Sub printUDT cdecl (ByVal count As Integer, ...)

    Dim arg As Any Ptr

    Dim pu As UDT Ptr

    arg = va_first()

    For i As Integer = 1 To count

        pu = va_arg(arg, UDT Ptr)

        Print pu->s, pu->d

        arg = va_next(arg, UDT Ptr)

    Next

End Sub

Dim As UDT u1, u2, u3

u1.s = "4*Atn(1)" : u1.d = 4 * Atn(1)

u2.s = "Sqr(2)"   : u2.d = Sqr(2)

u3.s = "Log(10)"  : u3.d = Log(10)

printUDT(3, @u1, @u2, @u3)

Sleep

' Output:

' 4*Atn(1)       3.141593

' Sqr(2)         1.414214

' Log(10)        2.302585
```

```freebasic
' Variadic sub:

'    The first (fixed) parameter is the type of the variable arguments (Integer Ptr or Double Ptr).

'    One terminal argument (added after the useful arguments) must be the null pointer.

Sub printNumericList cdecl (ByRef argtype As String, ...)

    Dim As Integer datatype = 0

    If UCase(argtype) = "INTEGER PTR" Then

        datatype = 1

        Print "List of integers : ";

    ElseIf UCase(argtype) = "DOUBLE PTR" Then

        datatype = 2

        Print "List of doubles : ";

    Else

        Print "Invalid argument type"

        Exit Sub

    End If

    Dim arg As Any Ptr

    Dim pn As Any Ptr

    arg = va_first()

    Do

        pn = va_arg(arg, Any Ptr)

        If pn = 0 Then Exit Do

        Print ,

        Select Case As Const datatype

        Case 1

            Print *CPtr(Integer Ptr, pn);

        Case 2

            Print *CPtr(Double Ptr, pn);

        End Select

        arg = va_next(arg, Any Ptr)

    Loop

    Print

End Sub

printNumericList("Integer Ptr", @Type<Integer>(123), @Type<Integer>(456), @Type<Integer>(789), CPtr(Integer Ptr, 0))

printNumericList("Double Ptr", @Type<Double>(1.2), @Type<Double>(3.4), @Type<Double>(5.6), @Type<Double>(7.8), CPtr(Double Ptr, 0))

Sleep

' Output:

' List of integers :           123           456           789

' List of doubles :            1.2           3.4           5.6           7.8
```

Back to top

3. ' C's va\_\* ' support's keywords family

**Recommended** `va_*` support for all new coding.

 There are 5 C's `va_*` support's keywords (`Cva_List`, `Cva_Start`, `Cva_Copy`, `Cva_Arg`, `Cva_End`):

`Dim variable As Cva_List`

`Cva_List` is a built in data type for working with the variable length argument list in a variadic procedure.

`Cva_Start( argument_list, last_param )`

`Cva_Start` "constructs" the `argument_list` object declared of `Cva_List` data-type, settling on the `last_param` declared in the procedures parameter list before the [Ellipsis](Ellipsis) [`"..."`](Ellipsis).

`Cva_Copy( dst_list, src_list )`

`Cva_Copy` "copy-constructs" the `dst_list` object declared of `Cva_List` data-type, from an already constructed `src_list` object.

`variable = Cva_Arg( argument_list, datatype )`

`Cva_Arg` returns the current argument in the `argument_list`, with an expected data-type of `datatype`.  
 (`Cva_Arg` automatically increments `argument_list` to the next argument within the list after obtaining the value of the current argument)

`Cva_End( argument_list )`

`Cva_End` "destructs" the `argument_list` object of `Cva_List` data-type (previously "constructed" with `Cva_Start` or `Cva_Copy`).

The implementation and code emitted for `Cva_List`, `Cva_Start`, `Cva_Copy`, `Cva_Arg`, `Cva_End` varies depending on target, backend, and architecture.

 Note:

The exact type and size of `Cva_List` depends on `-target`, `-arch`, `-gen` command line options:

In `-gen gas`, `Cva_List` is a pointer.  
 In `-gen gcc`, `Cva_List` is a pointer, a struct, or a struct array. The `Cva_List` type is replaced by `"__builtin_va_list"` in gcc.  
 On 32-bit targets, gas backend: `type Cva_List as any alias "char" ptr`  
 On 32-bit targets, gcc backend: `type Cva_List as any alias "__builtin_va_list" ptr`  
 On Windows 64-bit, gcc backend: `type Cva_List as any alias "__builtin_va_list" ptr`  
 On Linux x86_64, gcc backend: `type Cva_List as __va_list_tag alias "__builtin_va_list[]"`  
 On arm64, gcc backend: `type Cva_List as __va_list alias "__builtin_va_list"`

`Cva_Start (or Cva_Copy)` is like a constructor (or a copy-constructor) for the variadic `argument_list` object and must finally have a matching call to `Cva_End`, which is like a destructor.  
 After `Cva_End` for `argument_list` has been called, `argument_list` can be reused and reinitialized with another call to `Cva_Start (or Cva_Copy)`.  
 The `Cva_Start (or Cva_Copy)` and `Cva_End` calls must both be called in pairs in the same procedure (for cross platform compatibility).

Examples:

```freebasic
' Variadic function:

'    The first(fixed) parameter provides the number of elements.

'    The variable arguments are all strings except the last one which must be a float.

'    The user's string arguments are in fact passed under the hood through zstring pointers.

Function concatenation cdecl (ByVal count As Integer, ...) As String

    Dim s As String

    Dim args As Cva_List

    Cva_Start(args, count)

    For i As Integer = 1 To count

        If i < count Then

            s &= *Cva_Arg(args, ZString Ptr)

        Else

            s &= Cva_Arg(args, Double)

        End If

    Next

    Cva_End(args)

    Return s

End Function

Print concatenation(6, "Free", "BASIC", " ", "version", " ", 1.07)

Sleep

' Output: FreeBASIC version 1.07
```

```freebasic
' Variadic sub:

'    The first(fixed) parameter provides the number of elements.

'    The variable arguments are all UDT Ptr.

Type UDT

    Dim As String s

    Dim As Single d

End Type

Sub printUDT cdecl (ByVal count As Integer, ...)

    Dim args As Cva_List

    Dim pu As UDT Ptr

    Cva_Start(args, count)

    For i As Integer = 1 To count

        pu = Cva_Arg(args, UDT Ptr)

        Print pu->s, pu->d

    Next

    Cva_End(args)

End Sub

Dim As UDT u1, u2, u3

u1.s = "4*Atn(1)" : u1.d = 4 * Atn(1)

u2.s = "Sqr(2)"   : u2.d = Sqr(2)

u3.s = "Log(10)"  : u3.d = Log(10)

printUDT(3, @u1, @u2, @u3)

Sleep

' Output:

' 4*Atn(1)       3.141593

' Sqr(2)         1.414214

' Log(10)        2.302585
```

```freebasic
' Variadic sub:

'    The first (fixed) parameter is the type of the variable arguments (Integer Ptr or Double Ptr).

'    One terminal argument (added after the useful arguments) must be the null pointer.

Sub printNumericList cdecl (ByRef argtype As String, ...)

    Dim As Integer datatype = 0

    If UCase(argtype) = "INTEGER PTR" Then

        datatype = 1

        Print "List of integers : ";

    ElseIf UCase(argtype) = "DOUBLE PTR" Then

        datatype = 2

        Print "List of doubles : ";

    Else

        Print "Invalid argument type"

        Exit Sub

    End If

    Dim args As Cva_List

    Dim pn As Any Ptr

    Cva_Start(args, argtype)

    Do

        pn = Cva_Arg(args, Any Ptr)

        If pn = 0 Then Exit Do

        Print ,

        Select Case As Const datatype

        Case 1

            Print *CPtr(Integer Ptr, pn);

        Case 2

            Print *CPtr(Double Ptr, pn);

        End Select

    Loop

    Print

    Cva_End(args)

End Sub

printNumericList("Integer Ptr", @Type<Integer>(123), @Type<Integer>(456), @Type<Integer>(789), CPtr(Integer Ptr, 0))

printNumericList("Double Ptr", @Type<Double>(1.2), @Type<Double>(3.4), @Type<Double>(5.6), @Type<Double>(7.8), CPtr(Double Ptr, 0))

Sleep

' Output:

' List of integers :           123           456           789

' List of doubles :            1.2           3.4           5.6           7.8
```

Back to top

See also

- [`... (Ellipsis)`](Ellipsis)
- [`va_first`](Va-First)
- [`va_arg`](Va-Arg)
- [`va_next`](Va-Next)
- [`Cva_List`](Cva-List)
- [`Cva_Start`](Cva-Start)
- [`Cva_Copy`](Cva-Copy)
- [`Cva_Arg`](Cva-Arg)
- [`Cva_End`](Cva-End)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
