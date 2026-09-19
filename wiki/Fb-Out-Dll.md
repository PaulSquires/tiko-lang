[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_OUT_DLL__**

# __FB_OUT_DLL__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__FB_OUT_DLL__
```

## Description

`__FB_OUT_DLL__` indicates that the specified output file type on the compiler command line at the time of compilation is a shared library.

 Returns non-zero (-1) if the output is a shared library. Returns zero (0) otherwise.

 Only one of `__FB_OUT_DLL__`, [`__FB_OUT_EXE__`](Fb-Out-Exe), [`__FB_OUT_LIB__`](Fb-Out-Lib), or [`__FB_OUT_OBJ__`](Fb-Out-Obj) will evaluate to non-zero (-1). All others will evaluate to zero (0).

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_OUT_EXE__`](Fb-Out-Exe)
- [`__FB_OUT_LIB__`](Fb-Out-Lib)
- [`__FB_OUT_OBJ__`](Fb-Out-Obj)
- [Compiler Option: -dll](Compiler-Option-Dll)

## Examples

```freebasic
#if __FB_OUT_DLL__

        '... specific instructions when making a shared library (DLL)

#else

        '... specific instructions when not making a shared library (DLL)

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
