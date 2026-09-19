[Home](Home) › [Tutorials](Category-Tutorials) › **Passing Arrays to Procedures**

# Passing Arrays to Procedures

Declaring/defining array parameters and passing array arguments to procedures

Syntax for array symbol name

As parameter in procedure declaration:

`( [ Any [, Any...] ] ) As datatype`  
 `array_name( [ Any [, Any...] ] ) As datatype`

As parameter in procedure definition:

`array_name( [ Any [, Any...] ] ) As datatype`

As argument in procedure call:

`array_name()`

Parentheses (even empty) are mandatory to specify that the parameter/argument is an array.

Usage of array symbol name

When declaring procedure with array parameter:

`Declare { Sub | Function } proc_name ... ( ( [ Any [, Any...] ] ) As datatype , ... ) [ ... ]`  
 `Declare { Sub | Function } proc_name ... ( array_parameter_name( [ Any [, Any...] ] ) As datatype , ... ) [ ... ]`

When defining procedure with array parameter:

`{ Sub | Function } proc_name ... ( array_parameter_name( [ Any [, Any...] ] ) As datatype , ... ) [ ... ]`

When passing array argument to procedure:

`sub_name ( array_argument_name() , ... )`  
 `sub_name array_argument_name() , ...`  
 `funct_name ( array_argument_name() , ... )`  
 `funct_name array_argument_name() , ...`  
 `... funct_name ( array_argument_name() , ... ) [ ... ]`

 **Note** (same rules as for any parameter/argument list)**:**

When declaring/defining a procedure, parentheses surrounding a non empty parameter list are required.  
 When calling a subroutine, parentheses surrounding an argument list (empty or non empty) are optional.  
 When calling a function as a subroutine (without using the return variable), the same rules as for subroutine apply.  
 When calling a function in an expression (which uses the return value), parentheses surrounding a non empty argument list are required.  
 But it is a common convention to always use parentheses (empty or non empty) after the procedure name, to signify a procedure call.

Description

Array parameter can not have a [`ByVal`](Byval) or [`ByRef`](Byref-Parameters) keyword before them, because arrays don't get passed the same way as normal parameters. While variables get passed by value or by reference, arrays get passed by descriptor (see below). In fact when an array is passed to a procedure, it is a reference to its descriptor which is passed.  
 All the elements of a passed array can be modified, and those changes are reflected at the calling level. Perhaps [`ByRef`](Byref-Parameters) should be allowed by similarity with variable-length string (which are also passed by descriptor).

 There is no direct possibility of passing an array by value. Declaring a passed array parameter `As Constant` only forbids any modification in the procedure body. A workaround would be to pass a user copy of the array.

 **Note:**

A function return can not be an array type variable.  
 A fixed-length [`String`](String) array can not be passed to a procedure.  
 A `ZString/WString` array can not be simply passed to a procedure because the zstring/wstring size is not passed (the `"as zstring/wstring * 1"` type is taken by default by compiler in procedure body). It is a bug at the moment because compiler just fails silently while it badly computes in the procedure body the address of each array element (except the first obviously).

**Array descriptor** (for information purposes only)**:**

For a fixed-length array, the descriptor is only used for passing the array to a procedure (otherwise the compiler does not use it because knowing the fixed characteristics of the array).  
 For a variable-length array, the descriptor is always used (the array descriptor is the only defining the array characteristics).

 The array descriptor has the following structure (each item is coded on an 'Any Ptr' or an 'Uinteger', except on an 'Integer' for lbound and ubound):

**-** pointer to the real or virtual element: @array(0, 0, ...)
 **-** pointer to the first real element: @array(lbound1, lbound2, ...)
 **-** "global" size in bytes: (ubound1 - lbound1 + 1) \* (ubound2 - lbound2 + 1) \* ... \* (size of 1 element in bytes)
 **-** size of one element in bytes
 **-** number of dimensions
 **-** flags**`(*)`**: array points to fixed-length memory (1-bit) / array has nb of dimensions defined at first declaration / nb of dimensions allocated in descriptor (4-bit)
 then for each dimension:
 **-** number of elements: (ubound - lbound + 1)
 **-** lbound
 **-** ubound

 **`(*)`**: Additional member field (an 'Uinteger') for fbc versions >= 1.08
 (see the include file `./inc/fbc-int/array.bi` for fbc versions >= 1.07)

For more information, see [Fbarray (Array Descriptor Structure And Access)](Fbarray-Array-Descriptor-Structure-and-Access).

Example

```freebasic
Declare Sub splitString(ByVal As String, (Any) As String, ByVal As UByte = Asc(","))

Dim As String s = "Programmer's Guide/Variables and Datatypes/Arrays/Passing Arrays to Procedures"

Dim As String array(Any)

splitString(s, array(), Asc("/"))

Print "STRING TO SPLIT:"

Print s

Print

Print "RESULT ARRAY FROM SPLITTING:"

For i As Integer = LBound(array) To UBound(array)

    Print i, array(i)

Next i

Sleep

Sub splitString(ByVal source As String, destination(Any) As String, ByVal delimitor As UByte)

    Do

        Dim As Integer position = InStr(1, source, Chr(delimitor))

        ReDim Preserve destination(UBound(destination) + 1)

        If position = 0 Then

            destination(UBound(destination)) = source

            Exit Do

        End If

        destination(UBound(destination)) = Left(source, position - 1)

        source = Mid(source, position + 1)

    Loop

End Sub
```

See also

- [Passing Arguments to Procedures](Passing-Arguments-to-Procedures)
- [Calling Conventions](Calling-Conventions)
- [Returning Values](Returning-Values)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
