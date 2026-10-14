[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_GUI__**

# __FB_GUI__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__FB_GUI__
```

## Description

`__FB_GUI__` indicates if the executable subsystem option '-s gui' was specified on the command line at the time of compilation.

 Returns non-zero (-1) if the executable subsystem option '-s gui' was specified. Returns zero (0) otherwise (no executable subsystem option specified, or executable subsystem option '-s console' specified).

## Remarks

### Platform Differences

- Supported on Windows and Cygwin only.

### Differences from QB

- New to FreeBASIC

### See also

- [Compiler Option: -s](Compiler-Option-S)

## Examples

```freebasic
#if __FB_GUI__ <> 0

        #print Executable subsystem: gui

#else

        #print Executable subsystem: console

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
