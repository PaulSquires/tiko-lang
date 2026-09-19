[Home](Home) › [Standard Data Types](Category-Standard-Data-Types) › **Function Pointer**

# Function Pointer

Data type that stores a pointer to a Function procedure returning a value

## Syntax

```freebasic
Dim variable As Function [cdecl|pascal|stdcall] [( [parameter_list] )] [ ByRef ] [As return_type] [= initializer]
```

## Parameters

- `parameter_list`
- `parameter`
- `identifier`
- `type`
- `default_value`
- `return_value`
- `intializer`

## Description

A [`Function`](procedures-Function) pointer is a procedure pointer that stores the memory location of compiled code that returns a value. If no intializer is given the default initial value is zero (0).

 The memory address for the [`Function`](procedures-Function) procedure can be assigned to the variable by taking the address of a function with [`ProcPtr`](Operator-Procptr-Procedure-Pointer-and-Vtable-Index) or [`Operator @ (Address Of)`](Operator-Address-of).

 The procedure must match the same [`Function`](procedures-Function) declaration as the declared [`Function`](procedures-Function) pointer.

 To call the function assigned, use the `variable` name as if it were a normal declared [`Function`](procedures-Function), always with parentheses around the parameter list even empty (without parentheses, only the pointer value, ie the address of the function, would be accessed).

 One of the primary uses for [`Function`](procedures-Function) pointers is to create callback procedures:

**-** A callback [`Function`](procedures-Function) is a [`Function`](procedures-Function) that is passed through an argument (a [`Function`](procedures-Function) pointer) to another procedure which is expected to call back (execute) the "argument" at a convenient time.
 **-** If the callback [`Function`](procedures-Function) is completely executed before the invocation returns to the caller code, then the callback process is said to be "synchronous".
 **-** If the invocation immediately returns to the caller code, and the callback [`Function`](procedures-Function) and the caller's next code are running in parallel, then the callback process is said to be "asynchronous".

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`Function`](procedures-Function)
- [`ProcPtr`](Operator-Procptr-Procedure-Pointer-and-Vtable-Index)
- [`Operator @ (Address Of)`](Operator-Address-of)

## Examples

```freebasic
Function ConcatSelf( x As String ) As String

    Return x & x

End Function

Dim x As Function( x As String ) As String = ProcPtr( ConcatSelf )

Print x( "Hello" )
```

```freebasic
Function x2 (ByVal i As Integer) As Integer

  Return i * 2

End Function

Function x3 (ByVal i As Integer) As Integer

  Return i * 3

End Function

Function operation (ByVal i As Integer, ByVal op As Function (ByVal As Integer) As Integer) As Integer

  Return op(i)

End Function

Print operation(4, @x2)

Print operation(4, @x3)
```

```freebasic
' Example of basic callback Function mechanism (asynchronous) to implement a key pressed event:

' (the user callback Function address cannot be modified while the event thread is running)

'   - An asynchronous thread tests the keyboard in a loop, and calls a user callback Function each time a key is pressed.

'   - The callback Function address is passed to the thread.

'   - The callback Function prints the character of the key pressed,

'       but if the key pressed is <escape> it orders the thread to finish by using the function return value.

'   - As the user callback address is passed to the thread as argument, it cannot be modified while the thread is running.

'' thread Sub definition

  Sub threadInkey (ByVal p As Any Ptr)

    If p > 0 Then                                                '' test condition callback Function defined

      Dim As Function (ByRef As String) As Integer callback = p  '' convert the any ptr to a callback Function pointer

      Do

        Dim As String s = Inkey

        If s <> "" Then                                          '' test condition key pressed

          If callback(s) Then                                    '' test condition to finish thread

            Exit Do

          End If

        End If

        Sleep 50, 1

      Loop

    End If

  End Sub

'' user callback Function definition

  Function printInkey (ByRef s As String) As Integer

    If Asc(s) = 27 Then                                        '' test condition key pressed = <escape>

      Print

      Return -1                                                '' order thread to finish

    Else

      Print s;

      Return 0                                                 '' order thread to continue

    End If

  End Function

'' user main code

  Dim As Any Ptr p = ThreadCreate(@threadInkey, @printInkey)   '' launch the thread, passing the callback Function address

  ThreadWait(p)                                                '' wait for the thread finish
```

---

**Category:** [Standard Data Types](Category-Standard-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
