[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_JS__**

# __FB_JS__

Intrinsic define set by the compiler

## Syntax

```freebasic
__FB_JS__
```

## Description

Define without a value created at compile time in the emscripten version of the compiler, when the `-target js-asmjs` command line option is used. It can be used to compile parts of the program only for a such target.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [Compiling FB with Emscripten](Compiling-Fb-with-Emscripten)

## Examples

```freebasic
#ifdef __FB_JS__

  '...instructions only for emscripten target...

#else

  '...instructions not for emscripten target...

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
