[Home](Home) › [Memory Functions](Category-Memory-Functions) › **Reallocate**

# Reallocate

Resizes a block, keeping its contents, and returns the new pointer, or 0 on failure.

## Syntax

```freebasic
Declare Function Reallocate cdecl ( ByVal pointer As Any Ptr, ByVal count As UInteger ) As Any Ptr
```

## Parameters

- `pointer`
- `count`

## Description

Reallocates memory previously allocated with [`Allocate`](Allocate) or [`CAllocate`](Callocate). The contents of the buffer are preserved, although if `count` is less than the original size of the memory block, the buffer will be truncated. If the size is increased, the added memory range is not initialized to anything.

 The reallocation first attempts to resize the memory already allocated without moving its starting address in order to avoid recopying the data to be kept (returned pointer value unchanged). If this is not possible, a new separate memory area is allocated with recopy of the data to be kept before deallocating the old memory area (returned pointer value modified).

 When using `Reallocate`, the `result` pointer must be saved to prevent a potential memory leak, because the original `pointer` may no longer be valid after reallocation. The value of the new pointer should be checked - if it is `0`, the reallocation has failed - the original `pointer` remains valid, and the amount of memory allocated to it has not changed.

 Reallocated memory must be freed with [`Deallocate`](Deallocate) when no longer needed.

 If `pointer` is null (`0`), then `ReAllocate` behaves identically to [`Allocate`](Allocate). If `pointer` is valid and `count` is null (0), then `ReAllocate` behaves similar to [`Deallocate`](Deallocate) and a null (0) pointer is returned.

 If the memory has previously been deallocated by a call to [`Deallocate`](Deallocate) or `ReAllocate`, the behavior is undefined.

 When manually allocating memory for [`String`](String) descriptors (or [`Udt`](Type-Udt)s that contain one), if `count` is larger than the original size of the memory block, the new extra memory range must be explicitly cleared to zeroes before the first string use (for example, using [`Clear`](Clear)). Otherwise accessing the string will cause undefined results (trying to write or read at a random place in memory, or trying to deallocate a random pointer).

 **Note:**

`Reallocate` cannot be used inside a member procedure if `pointer` points to the instance itself of the object, because that could cause horrible crashes:

## Return Value

The address of the reallocated memory. A null (`0`) pointer is returned if reallocation was unsuccessful, and the original memory pointed to by `pointer` remains unchanged.

## Remarks

### Usage

`result = Reallocate( pointer, count )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Reallocate`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Allocate`](Allocate)
- [`CAllocate`](Callocate)
- [`Deallocate`](Deallocate)

## Examples

```freebasic
Dim a As Integer Ptr, b As Integer Ptr, i As Integer

a = Allocate( 5 * SizeOf(Integer) )   ' Allocate memory for 5 integers

If a = 0 Then Print "Error Allocating a": End

For i = 0 To 4

  a[i] = (i + 1) * 2   ' Assign integers to the buffer

Next i

b = Reallocate( a, 10 * SizeOf(Integer) )   ' Reallocate memory for 5 additional integers

If b <> 0 Then

    a = b   ' Discard the old pointer and use the new one

    For i = 5 To 9

      a[i] = (i + 1) * 2   ' Assign more integers to the buffer

    Next i

    For i = 0 To 9   ' Print the integers

      Print i, a[i]

    Next i

    Print

Else '' Reallocate failed, memory unchanged

    Print "Error Reallocating a"

    For i = 0 To 4   ' Print the integers

      Print i, a[i]

    Next i

    Print

End If

Deallocate a   ' Clean up
```

---

**Category:** [Memory Functions](Category-Memory-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
