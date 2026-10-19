[Home](Home) › [Memory Functions](Category-Memory-Functions) › **Fb_Memmove**

# Fb_Memmove

Copies a number of bytes between two memory areas, even when they overlap.

## Syntax

```freebasic
Declare Function fb_memmove cdecl ( ByRef dst As Any, ByRef src As Any, ByVal bytes As UInteger ) As Any Ptr
```

## Parameters

- `dst`
- `src`
- `bytes`

## Description

`fb_memmove` copies a given number of bytes from the memory location `src` to the memory location `dst`. Each starting address is taken from a reference to a variable or array element.  
 Copying takes place as if an intermediate buffer were used, allowing the destination and source areas to overlap in any way (safer approach, and for any platform). Using [`Fb_Memcopy`](Fb-Memcopy) is sufficient (and may induce greater speed) when the memory areas do not overlap.  
 To avoid overflows, the valid memory areas pointed to by both `src` and `dst` must be at least equal in size to the number of bytes to be copied.

 The underlying type of the objects pointed to by both the source and destination pointers are irrelevant for this function.  
 The function does not check for any terminating null character in the source area. It always copies exactly the given number of bytes.  
 The result is a binary copy of the data.

 **Note:** In order to copy from/to memory referenced by a [`Pointer`](Pointer-Ptr), it must be dereferenced first (or else specify in argument term the [`ByVal`](Byval) keyword in front of the pointer name). Otherwise, `fb_memmove` will try to copy the bytes from/to the **pointer variable**'s memory location.

## Return Value

The starting address of destination memory is returned.

## Remarks

### Usage

`[result =] fb_memmove( dst, src, bytes )`

### Differences from QB

- The behavior and usage is new to FreeBASIC.

### See also

- [`Fb_Memcopy`](Fb-Memcopy)
- [`fb_MemCopyClear`](Fb-Memcopyclear)

## Examples

```freebasic
Dim As ZString * 33 z = "memmove can be very useful......"

Print z

fb_memmove(z[20], z[15], 11)

Print z

Sleep
```

 Output:

```freebasic
memmove can be very useful......
memmove can be very very useful.

```

---

**Category:** [Memory Functions](Category-Memory-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
