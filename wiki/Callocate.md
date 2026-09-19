[Home](Home) › [Memory Functions](Category-Memory-Functions) › **CAllocate**

# CAllocate

Allocates memory for a certain number of elements from the free store and clears the contents

## Syntax

```freebasic
Declare Function CAllocate cdecl ( ByVal num_elements As UInteger, ByVal size As UInteger = 1 ) As Any Ptr
```

## Parameters

- `num_elements`
- `size`

## Description

`CAllocate` initializes the allocated memory with zeros.  
 Consequently, `CAllocate` can be also directly used with [`String`](String) or [`Udt`](Type-Udt) containing string, because the string descriptor is cleared (set to 0) first.  
 Similarly, `CAllocate` can also be used directly with [`ZString`](Zstring) or [`WString`](Wstring) because string data is created with null characters.

## Return Value

If successful, the address of the start of the allocated memory is returned. Otherwise, the null pointer (`0`) is returned.

## Remarks

### Usage

`result = CAllocate( num_elements [, size ] )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Callocate`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Allocate`](Allocate)
- [`Deallocate`](Deallocate)
- [`Reallocate`](Reallocate)

## Examples

```freebasic
' Allocate and initialize space for 10 integer elements.

Dim p As Integer Ptr = CAllocate(10, SizeOf(Integer))

' Fill the memory with integer values.

For index As Integer = 0 To 9

    p[index] = (index + 1) * 10

Next

' Display the integer values.

For index As Integer = 0 To 9

    Print p[index] ;

Next

' Free the memory.

Deallocate(p)
```

 Outputs:

```freebasic
 10 20 30 40 50 60 70 80 90 100

```

---

**Category:** [Memory Functions](Category-Memory-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
