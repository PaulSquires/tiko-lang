[Home](Home) › [Memory Functions](Category-Memory-Functions) › **Allocate**

# Allocate

Reserves a number of bytes and returns a pointer to them, or 0; the bytes are not cleared.

## Syntax

```freebasic
Declare Function Allocate cdecl ( ByVal count As UInteger ) As Any Ptr
```

## Parameters

- `count`

## Description

Allocates, or reserves, `count` number of bytes from the free store (heap). The newly allocated memory is not initialized.

 As the initial value of newly allocated memory is unspecified, **Allocate** must not be directly used with [`String`](String) or [`Udt`](Type-Udt) containing string, because the string descriptor being not cleared (containing random data), that may induce corrupted string or more (trying to write to a random place in memory or trying to deallocate a random pointer). It is mandatory in that case (with string or UDT containing string) to use [`CAllocate`](Callocate) (clearing memory), or [`New Expression`](Operator-New-Expression) (calling constructor) in case of **UDT**, or at worst after **Allocate** to explicitly clear the descriptor (setting to 0) before the first string use.  
 For allocating memory for a [`ZString`](Zstring) or a [`WString`](Wstring), see the corresponding page.

 The pointer that is returned is an [Any](Any) [Ptr](Pointer-Ptr) and points to the start of the allocated memory. This pointer is guaranteed to be unique, even if `count` is zero.

 Allocated memory must be deallocated, or returned back to the free store, with [`Deallocate`](Deallocate) when no longer needed.

## Return Value

If successful, the address of the start of the allocated memory is returned. Otherwise, if the requested block size could not be allocated, or if `count < 0`, then the null pointer (`0`) is returned.

## Remarks

### Usage

`result = Allocate( count )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Allocate`

### Differences from QB

- New to FreeBASIC

### See also

- [`CAllocate`](Callocate)
- [`Reallocate`](Reallocate)
- [`Deallocate`](Deallocate)

## Examples

```freebasic
'' This program uses the ALLOCATE(...) function to create a buffer of 15 integers that is

'' then filled with the first 15 numbers of the Fibonacci Sequence, then output to the

'' screen. Note the call to DEALLOCATE(...) at the end of the program.

    Const integerCount As Integer = 15

    '' Try allocating memory for a number of integers.

    ''

    Dim buffer As Integer Ptr

    buffer = Allocate(integerCount * SizeOf(Integer))

    If (0 = buffer) Then

        Print "Error: unable to allocate memory, quitting."

        End -1

    End If

    '' Prime and fill the memory with the fibonacci sequence.

    ''

    buffer[0] = 0

    buffer[1] = 1

    For i As Integer = 2 To integerCount - 1

        buffer[i] = buffer[i - 1] + buffer[i - 2]

    Next

    '' Display the sequence.

    ''

    For i As Integer = 0 To integerCount - 1

        Print buffer[i] ;

    Next

    Deallocate(buffer)

    End 0
```

Output is:

```freebasic
 0 1 1 2 3 5 8 13 21 34 55 89 144 233 377
```

It is important to free allocated memory if it's not going to be used anymore. Unused memory that isn't freed is simply wasting memory, and if the address of that memory is somehow overwritten or forgotten, that memory can never be freed. This condition is known as a memory leak, and should be avoided at all costs. Note that leaked memory is always completely freed when the application terminates, either by an "ordinary" exit or crash, so the leak "persists" only as long as the application runs, nevertheless it's a good habit to free any allocated memory inside your application. The following example demonstrates a function with a memory leak, where the address of allocated memory is lost and isn't and can't be freed anymore. If such a function is called frequently, the total amount of memory wasted can add up quickly.

```freebasic
'' Bad example of Allocate usage, causing memory leaks

Sub BadAllocateExample()

    Dim p As Byte Ptr

    p = Allocate(420)   '' assign pointer to new memory

    p = Allocate(420)   '' reassign same pointer to different memory,

                        '' old address is lost and that memory is leaked

    Deallocate(p)

End Sub

    '' Main

    BadAllocateExample() '' Creates a memory leak

    Print "Memory leak!"

    BadAllocateExample() '' ... and another

    Print "Memory leak!"

    End
```

---

**Category:** [Memory Functions](Category-Memory-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
