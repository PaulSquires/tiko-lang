[Home](Home) › [Threading Support Functions](Category-Threading-Support-Functions) › **ThreadSelf**

# ThreadSelf

Returns the handle of the thread that calls it.

## Syntax

```freebasic
Declare Function ThreadSelf ( ) As Any Ptr
```

## Description

**ThreadSelf** is used to get the handle of the current thread.

 This function can uniquely identify the existing threads:

**-** If there are multiple threads, and one thread is completed, then that handle can be reused.
 **-** So for all the only threads still running, the handles are unique.

When a new thread is created, a handle to the thread is returned by the creation function.  
 When the thread runs code, **ThreadSelf** allows to return the handle of the thread (the implicit main thread also has its own unique handle).

 **ThreadSelf** may be used to code some sort of TLS (Thread Local Storage) from the unique handle of each thread (including the implicit main thread).
 Therefore, a same global variable name may be defined, but with a stored value specific to the thread that accesses it.  
 This allows generic procedures to be coded, but with parameters depending on the thread which executes them (see 3rd example below).

## Return Value

**ThreadSelf** returns an `Any Ptr` handle of the current thread.

## Remarks

### Usage

```freebasic
#include "fbthread.bi"

result = ThreadSelf
```

### Dialect Differences

- Threading is not allowed in the *[-lang qb](Compiler-Option-Lang)* dialect.

### Platform Differences

- **ThreadSelf** is not available with the DOS version of FreeBASIC, because multithreading is not supported by DOS kernel nor the used extender.

### Differences from QB

- New to FreeBASIC

### See also

- [`ThreadCreate`](Threadcreate)

## Examples

```freebasic
#include "fbthread.bi"

Dim As Any Ptr phandle(1 To 10)

Sub myThread (ByVal p As Any Ptr)

    Print "Thread handle: " & ThreadSelf()

End Sub

For I As Integer = 1 To 10

    phandle(I) = ThreadCreate(@myThread)

Next I

For I As Integer = 1 To 10

    ThreadWait(phandle(I))

Next I

Sleep
```

 Checking for equality between the thread handle returned by ThreadCreate at thread creation and the one returned by ThreadSelf from thread running:

```freebasic
#include "fbthread.bi"

Dim As Any Ptr phandle(1 To 10)

Dim Shared As Any Ptr pmutex

Sub myThread (ByVal p As Any Ptr)

    MutexLock(pmutex)  ' to ensure that ThreadCreate line is completed before accessing the handle value

    Dim As Any Ptr phandle1 = *CPtr(Any Ptr Ptr, p)

    MutexUnlock(pmutex)

    Dim As Any Ptr phandle2 = ThreadSelf()

    Print Left("   ThreadCreate: " & phandle1 & Space(18), 36) _

          & "   ThreadSelf: " & phandle2  ' single print with concatenated string avoids using a mutex

    Sleep 100, 1

End Sub

Print "Handles returned from:"

pmutex = MutexCreate()

For I As Integer = 1 To 10

    MutexLock(pmutex)  ' to ensure that ThreadCreate line is completed before thread accesses the handle value

    phandle(I) = ThreadCreate(@myThread, @phandle(I))

    MutexUnlock(pmutex)

Next I

For I As Integer = 1 To 10

    ThreadWait(phandle(I))

Next I

MutexDestroy(pmutex)

Sleep
```

 Example of a sort of TLS (Thread Local Storage):  
 (see the end of the "Description" paragraph)

```freebasic
#include Once "fbthread.bi"

Function TLSindex() As Integer  ' returning a unique thread index (incremented with each new thread)

    Static As Any Ptr TLSind()

    Dim As Integer index = -1

    For I As Integer = LBound(TLSind) To UBound(TLSind)

        If TLSind(I) = ThreadSelf() Then

            index = I

            Exit For

        End If

    Next I

    If index = -1 Then

        index = UBound(TLSind) + 1

        ReDim Preserve TLSind(index)

        TLSind(index) = ThreadSelf()

    End If

    Return index

End Function

Function TLSinteger() ByRef As Integer  ' emulation of global integer with value depending on thread using it

    Static As Integer TLSint()

    Dim As Integer index = TLSindex()

    If index > UBound(TLSint) Then

        ReDim Preserve TLSint(index)

    End If

    Return TLSint(index)

End Function

'------------------------------------------------------------------------------

Type threadData

    Dim As Any Ptr handle

    Dim As String prefix

    Dim As String suffix

    Dim As Double tempo

End Type

Function counter() As Integer  ' definition of a generic counter with counting depending on thread calling it

    TLSinteger() += 1

    Return TLSinteger()

End Function

Sub Thread(ByVal p As Any Ptr)

    Dim As threadData Ptr ptd = p

    Dim As UInteger c

    Do

        c = counter()

        Print ptd->prefix & c & ptd->suffix & " ";  ' single print with concatenated string avoids using a mutex

        Sleep ptd->tempo, 1

    Loop Until c = 12

End Sub

'------------------------------------------------------------------------------

Print "|x| : counting from thread a"

Print "(x) : counting from thread b"

Print "[x] : counting from thread c"

Print

Dim As threadData mtlsa

mtlsa.prefix = "|"

mtlsa.suffix = "|"

mtlsa.tempo = 250

mtlsa.handle = ThreadCreate(@Thread, @mtlsa)

Dim As threadData mtlsb

mtlsb.prefix = "("

mtlsb.suffix = ")"

mtlsb.tempo = 150

mtlsb.handle = ThreadCreate(@Thread, @mtlsb)

Dim As threadData mtlsc

mtlsc.prefix = "["

mtlsc.suffix = "]"

mtlsc.tempo = 100

mtlsc.handle = ThreadCreate(@Thread, @mtlsc)

ThreadWait(mtlsa.handle)

ThreadWait(mtlsb.handle)

ThreadWait(mtlsc.handle)

Print

Print

Print "end of threads"

Sleep
```

---

**Category:** [Threading Support Functions](Category-Threading-Support-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
