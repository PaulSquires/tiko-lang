[Home](Home) › [Memory Functions](Category-Memory-Functions) › **Fb_Memcopy**

# Fb_Memcopy

Copies a number of bytes between two memory areas that do not overlap.

## Syntax

```freebasic
Declare Function fb_memcopy cdecl ( ByRef dst As Any, ByRef src As Any, ByVal bytes As UInteger ) As Any Ptr
```

## Parameters

- `dst`
- `src`
- `bytes`

## Description

`fb_memcopy` copies a given number of bytes from the memory location `src` to the memory location `dst`.  
 Each starting address is taken from a reference to a variable or array element.  
 The memory areas must not overlap (otherwise, the copying is not guaranteed to work properly, especially depending on the platform). Use [`Fb_Memmove`](Fb-Memmove) preferably when the memory areas do overlap (safer approach).  
 To avoid overflows, the valid memory areas pointed to by both `src` and `dst` must be at least equal in size to the number of bytes to be copied.

 The underlying type of the objects pointed to by both the source and destination pointers are irrelevant for this function.  
 The function does not check for any terminating null character in the source area. It always copies exactly the given number of bytes.  
 The result is a binary copy of the data.

 **Note:** In order to copy from/to memory referenced by a [`Pointer`](Pointer-Ptr), it must be dereferenced first (or else specify in argument term the [`ByVal`](Byval) keyword in front of the pointer name). Otherwise, `fb_memcopy` will try to copy the bytes from/to the **pointer variable**'s memory location.

## Return Value

The starting address of destination memory is returned.

## Remarks

### Usage

`[result =] fb_memcopy( dst, src, bytes )`

### Differences from QB

- The behavior and usage is new to FreeBASIC.

### See also

- [`fb_MemCopyClear`](Fb-Memcopyclear)
- [`Fb_Memmove`](Fb-Memmove)

## Examples

```freebasic
Type Person

    Dim As ZString * 40 Name

    Dim As Integer age

End Type

Dim As ZString Ptr mynameptr = @"Pierre de Fermat"

Dim As Person person1, person2

' using fb_memcopy to copy string

fb_memcopy(person1.name, *mynameptr, Len(*mynameptr) + 1)

person1.age = 46

' using fb_memcopy to copy structure

fb_memcopy(person2, person1, SizeOf(Person))

Print person2.name, person2.age

Sleep
```

 Output:

```freebasic
Pierre de Fermat             46

```

---

**Category:** [Memory Functions](Category-Memory-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
