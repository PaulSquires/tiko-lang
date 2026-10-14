[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_ASM__**

# __FB_ASM__

Intrinsic define set by the compiler

## Syntax

```freebasic
__FB_ASM__
```

## Description

`__FB_ASM__` returns a string equal to `"intel"` or `"att"` depending on whether inline assembly blocks should use the Intel format or the GCC/AT&T format.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [Compiler Option: -asm](Compiler-Option-Asm)

## Examples

```freebasic
Dim a As Long

#if __FB_ASM__ = "intel"

    Asm

         inc dword Ptr [a]

    End Asm

#else

    Asm

        "incl %0\n" : "+m" (a) : :

    End Asm

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
