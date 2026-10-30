[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_DARWIN__**

# __FB_DARWIN__

Intrinsic define set by the compiler

## Syntax

```freebasic
__FB_DARWIN__
```

## Description

Define without a value, created when compiling for macOS: the `macos-arm64` target, the default on a Mac, or *[-target macos-arm64](Compiler-Option-Target)* on any host. It can be used to compile parts of the program only for macOS.

`__FB_UNIX__`, `__FB_ARM__` and `__FB_64BIT__` are defined with it; `__FB_LINUX__` and `__FB_X86__` are not. [`TIKO_OS_MACOS`](Category-Tiko-Compiler-Define) is tiko's own name for the same test.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_LINUX__`](Fb-Linux)
- [`TIKO_OS_MACOS`](Category-Tiko-Compiler-Define)
- [Installing on macOS](Quick-Start#installing-on-macos)
- [`__FB_WIN32__`](Fb-Win32)
- [`__FB_UNIX__`](Fb-Unix)
- [Compiler Option: -target](Compiler-Option-Target)

## Examples

```freebasic
#ifdef __FB_DARWIN__

  '...instructions only for macOS...

#else

  '...instructions not for macOS...

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
