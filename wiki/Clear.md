[Home](Home) › [Memory Functions](Category-Memory-Functions) › **Clear**

# Clear

Sets a number of bytes, starting at a variable, to zero or to a given value.

## Syntax

```freebasic
Declare Sub Clear cdecl ( ByRef dst As Any, ByVal value As Long = 0, ByVal bytes As UInteger )
```

## Parameters

- `dst`
- `value`
- `bytes`

## Description

`Clear` sets one or more bytes in memory to a certain value (the default value is zero (`0`) if not specified). The starting address is taken from a reference to a variable or array element.

 **NOTE:** In order to clear memory referenced by a [`Pointer`](Pointer-Ptr), it must be dereferenced first (or else specifying in argument term the [`ByVal`](Byval) keyword in front of the pointer name). Otherwise, `Clear` will try to clear the bytes at the **pointer variable**'s memory location.

## Remarks

### Usage

`Clear( dst, [value], bytes )`

### Differences from QB

- The behavior and usage is new to FreeBASIC
  The keyword `CLEAR` was used in QB to erase all variables, close all files, and optionally change the stack size. This use is not supported in FreeBASIC.

### See also

- [`Erase`](Erase)
- [`Reset`](Reset)

## Examples

```freebasic
'create an array with 100 elements

Dim array(0 To 99) As Integer

'clear the contents of the array to 0, starting with the first element

Clear array(0), , 100 * SizeOf(Integer)

'allocate 20 bytes of memory

Dim As Byte Ptr p = Allocate(20)

'set each of the first ten bytes to 0

Clear *p, 0, 10

'set each of the next ten bytes to 42

Clear p[10], 42, 10

'check the values of the allocated bytes

For i As Integer = 0 To 19

    Print i, p[i]

Next

'deallocate memory

Deallocate p
```

---

**Category:** [Memory Functions](Category-Memory-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
