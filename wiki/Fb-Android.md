[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_ANDROID__**

# __FB_ANDROID__

Intrinsic define set by the compiler

## Syntax

```freebasic
__FB_ANDROID__
```

## Description

Define without a value created at compile time when targeting `android` platforms, when the `-target android` command line option is used. It can be used to compile parts of the program only for a such target.

## Remarks

### Version

- Since fbc 1.20.0

### Differences from QB

- New to FreeBASIC

### See also

- [Compiling FB for Android](Compiling-Fb-with-Emscripten)

## Examples

```freebasic
#ifdef __FB_ANDROID__

  '...instructions only for android target...

#else

  '...instructions not for android target...

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
