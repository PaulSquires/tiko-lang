[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_MAIN__**

# __FB_MAIN__

Intrinsic define set by the compiler

## Syntax

```freebasic
__FB_MAIN__
```

## Description

`__FB_MAIN__` is defined in the main module and not defined in other modules.

 The main module is determined by the compiler as either the first source file listed on the command line or explicitly named using the -m option on the command line.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [Compiler Option: -m](Compiler-Option-M)
- [`#ifdef`](Ifdef)
- [`#ifndef`](Ifndef)

## Examples

```freebasic
#ifdef __FB_MAIN__

  #print Compiling the main module

#else

  #print Compiling an additional module

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
