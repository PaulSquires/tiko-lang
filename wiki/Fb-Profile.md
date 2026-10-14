[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_PROFILE__**

# __FB_PROFILE__

Intrinsic define set by the compiler

## Syntax

```freebasic
__FB_PROFILE__
```

## Description

Intrinsic define set to an integer to indicate the profiling method.  
 The different value are defined in the `./inc/fbc-int/profile.bi` include file (inside Namespace: `FB` and Enum: `PROFGEN_ID`):

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [Compiler Option: -profgen](Compiler-Option-Profgen)

## Examples

```freebasic
#cmdline "-profgen fb"

#include Once "fbc-int/profile.bi"

Using FBC

Print "__FB_PROFILE__ = ";

Select Case __FB_PROFILE__

Case PROFGEN_ID_NONE

    Print "PROFGEN_ID_NONE"

Case PROFGEN_ID_GMON

    Print "PROFGEN_ID_GMON"

Case PROFGEN_ID_CALLS

    Print "PROFGEN_ID_CALLS"

Case PROFGEN_ID_CYCLES

    Print "PROFGEN_ID_CYCLES"

End Select
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
