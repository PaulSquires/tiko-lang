[Home](Home) › [Memory Functions](Category-Memory-Functions) › **fb_MemCopyClear**

# fb_MemCopyClear

Copies the first bytes of one area into another and sets the rest to zero.

## Syntax

```freebasic
Declare Sub fb_MemCopyClear ( ByRef dst As Any, ByVal dstlen As UInteger, ByRef src As Any, ByVal srclen As UInteger )
```

## Parameters

- `dst`
- `dstlen`
- `src`
- `srclen`

## Description

`fb_memcopycopy` copies a given number of bytes (`dstlen`) from the memory location `src` to the memory location `dst`, but only the first `srclen` bytes are really copied and the rest is cleared (`(dstlen` - `srclen)` bytes).  
 Each starting address is taken from a reference to a variable or array element.  
 The memory areas must not overlap (otherwise, the copying is not guaranteed to work properly, especially depending on the platform).  
 To avoid overflows, the valid memory areas pointed to by both `src` and `dst` must be at least equal in size to the number of bytes to be copied (including the bytes cleared).

 The underlying type of the objects pointed to by both the source and destination pointers are irrelevant for this function.  
 The function does not check for any terminating null character in the source area. It always copies exactly the given number of bytes.  
 The result is a binary copy of the data for the first `srclen` bytes and a zeroing for the rest (`(dstlen` - `srclen)` bytes).

 **Note:** In order to copy from/to memory referenced by a [`Pointer`](Pointer-Ptr), it must be dereferenced first (or else specify in argument term the [`ByVal`](Byval) keyword in front of the pointer name). Otherwise, `fb_MemCopyClear` will try to copy the bytes from/to the **pointer variable**'s memory location.

## Remarks

### Usage

`fb_memcopy( dst, dstlen, src, srclen )`

### Differences from QB

- The behavior and usage is new to FreeBASIC.

### See also

- [`Fb_Memcopy`](Fb-Memcopy)
- [`Fb_Memmove`](Fb-Memmove)

## Examples

```freebasic
Dim src As ZString * 10 = "FreeBASIC"

Dim dst As ZString * 10 = "012345678"

Print "before:"

Print "src = " & src

Print "dst = " & dst

Print

'' copy first 4 bytes and clear the rest

fb_MemCopyClear(dst, SizeOf(dst), src, 4)

Print "after:"

Print "src = " & src

Print "dst = " & dst

Sleep
```

 Output:

```freebasic
before:
src = FreeBASIC
dst = 012345678

after:
src = FreeBASIC
dst = Free

```

---

**Category:** [Memory Functions](Category-Memory-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
