[Home](Home) › [Standard Data Types](Category-Standard-Data-Types) › **Sub Pointer**

# Sub Pointer

Data type that stores a pointer to a Sub procedure

## Syntax

```freebasic
Dim variable As Sub [cdecl|pascal|stdcall] [( [parameter_list] )] [= initializer]
```

## Parameters

- `parameter_list`
- `parameter`
- `identifier`
- `type`
- `default_value`
- `intializer`

## Description

A [`Sub`](Sub) pointer is a procedure pointer that stores the memory location of compiled code. If no intializer is given the default initial value is zero (0).

 The memory address for the [`Sub`](Sub) procedure can be assigned to the variable by taking the address of a subroutine with [`ProcPtr`](Operator-Procptr-Procedure-Pointer-and-Vtable-Index) or [`Operator @ (Address Of)`](Operator-Address-of).

 The procedure must match the same [`Sub`](Sub) declaration as the declared [`Sub`](Sub) pointer.

 To call the subroutine assigned, use the `variable` name as if it were a normal declared [`Sub`](Sub), always with parentheses around the parameter list even empty (without parentheses, only the pointer value, ie the address of the subroutine, would be accessed).

 One of the primary uses for [`Sub`](Sub) pointers is to create callback procedures:

**-** A callback [`Sub`](Sub) is a [`Sub`](Sub) that is passed through an argument (a [`Sub`](Sub) pointer) to another procedure which is expected to call back (execute) the "argument" at a convenient time.
 **-** If the callback [`Sub`](Sub) is completely executed before the invocation returns to the caller code, then the callback process is said to be "synchronous".
 **-** If the invocation immediately returns to the caller code, and the callback [`Sub`](Sub) and the caller's next code are running in parallel, then the callback process is said to be "asynchronous".

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`Sub`](Sub)
- [`ProcPtr`](Operator-Procptr-Procedure-Pointer-and-Vtable-Index)
- [`Operator @ (Address Of)`](Operator-Address-of)

## Examples

```freebasic
Sub Hello()

        Print "Hello"

    End Sub

    Sub Goodbye()

        Print "Goodbye"

    End Sub

    Dim x As Sub() = ProcPtr( Hello )

    x()

    x = @Goodbye  '' or procptr(Goodbye)

    x()
```

```freebasic
Sub s0 ()

  Print "'s0 ()'"

End Sub

Sub s1 (ByVal I As Integer)

  Print "'s1 (Byval As Integer)'", I

End Sub

Sub s2 (ByRef S As String, ByVal D As Double)

  Print "'s2 (Byref As String, Byval As Double)'", S, D

End Sub

Dim s0_ptr As Sub () = @s0

Dim s1_ptr As Sub (ByVal I As Integer) = @s1

Dim s2_ptr As Sub (ByRef S As String, ByVal D As Double) = @s2

s0_ptr()

s1_ptr(3)

s2_ptr("PI", 3.14)
```

```freebasic
' Example of advanced callback Sub mechanism (asynchronous) to implement a key pressed event:

' (the user callback Sub address can be modified while the event thread is running)

'   - An asynchronous thread tests the keyboard in a loop, and calls a user callback Sub each time a key is pressed.

'   - An UDT groups the common variables used (callback Sub pointer, character of key pressed, thread end flag),

'       and the static thread Sub plus the thread handle.

'   - An UDT instance pointer is passed to the thread, which then transmits it to the callback Sub each time.

'   - The callback Sub prints the character of the key pressed character,

'       but if the key pressed is <escape> it orders the thread to finish.

'   - As the user callback pointer is a member field of the UDT, it can be modified while the thread is running.

'' UDT for thread environment

  Type threadUDT

    Dim As Sub (ByVal As ThreadUDT Ptr) callback             '' callback Sub pointer

    Dim As Integer threadEnd                                 '' thread end flag

    Dim As String s                                          '' character of the key pressed

    Declare Static Sub threadInkey (ByVal p As Any Ptr)      '' static thread Sub

    Dim As Any Ptr threadHandle                              '' handle to the thread

  End Type

'' thread Sub definition

  Sub threadUDT.threadInkey (ByVal p As Any Ptr)

    Dim As threadUDT Ptr pt = p                              '' convert the any ptr to a threadUDT pointer

    Do

      pt->s = Inkey

      If pt->s <> "" AndAlso pt->callback > 0 Then           '' test condition key pressed & callback Sub defined

        pt->callback(p)

      End If

      Sleep 50, 1

    Loop Until pt->threadEnd                                 '' test condition to finish thread

  End Sub

'' user callback Sub definition

  Sub printInkey (ByVal pt As threadUDT Ptr)

    If Asc(pt->s) = 27 Then                                  '' test condition key pressed = <escape>

      pt->threadEnd = -1                                     '' order thread to finish

      Print

    Else

      Print pt->s;

    End If

  End Sub

'' user main code

  Dim As ThreadUDT t                                         '' create an instance of threadUDT

  t.threadHandle = ThreadCreate(@threadUDT.threadInkey, @t)  '' launch the thread, passing the instance address

  t.callback = @printInkey                                   '' initialize the callback Sub pointer

  ThreadWait(t.threadHandle)                                 '' wait for the thread finish
```

---

**Category:** [Standard Data Types](Category-Standard-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
