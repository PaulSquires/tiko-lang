[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_OUT_LIB__**

# __FB_OUT_LIB__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__FB_OUT_LIB__
```

## Description

`__FB_OUT_LIB__` indicates that the specified output file type on the compiler command line at the time of compilation is a static library.

 Returns non-zero (-1) if the output is a static library. Returns zero (0) otherwise.

 Only one of [`__FB_OUT_DLL__`](Fb-Out-Dll), [`__FB_OUT_EXE__`](Fb-Out-Exe), `__FB_OUT_LIB__`, or [`__FB_OUT_OBJ__`](Fb-Out-Obj) will evaluate to non-zero (-1). All others will evaluate to zero (0).

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_OUT_EXE__`](Fb-Out-Exe)
- [`__FB_OUT_DLL__`](Fb-Out-Dll)
- [`__FB_OUT_OBJ__`](Fb-Out-Obj)
- [Compiler Option: -lib](Compiler-Option-Lib)

## Examples

```freebasic
#if __FB_OUT_LIB__

        '... specific instructions when making a static library

#else

        '... specific instructions when not making a static library

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
