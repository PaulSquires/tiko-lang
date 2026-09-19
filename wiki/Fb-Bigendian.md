[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_BIGENDIAN__**

# __FB_BIGENDIAN__

Intrinsic define set by the compiler

## Syntax

```freebasic
__FB_BIGENDIAN__
```

## Description

Define without a value created at compile time if compiling for a big endian target.

 It can be used to compile parts of the program only if the target is big endian.

## Remarks

### Differences from QB

- Did not exist in QB

## Examples

```freebasic
#ifdef __FB_BIGENDIAN__

   '...instructions only for big endian machines

#else

  '...instructions only for little endian machines

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
