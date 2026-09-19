[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_GCC__**

# __FB_GCC__

Intrinsic define set by the compiler

## Syntax

```freebasic
__FB_GCC__
```

## Description

Defined to true (`-1`) if [-gen gcc](Compiler-Option-Gen) is used, or false (`0`) otherwise.

## Remarks

### Differences from QB

- Did not exist in QB

## Examples

```freebasic
#if __FB_GCC__ <> 0

        #print Backend Code Emitter And Assembler: gcc

#else

        #print Backend Code Emitter And Assembler: Not gcc

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
