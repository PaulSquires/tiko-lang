[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_OPTION_PROFILE__**

# __FB_OPTION_PROFILE__

Intrinsic define set by the compiler

## Syntax

```freebasic
__FB_OPTION_PROFILE__
```

## Description

Intrinsic define set to an integer to indicate that the profiling code is generated:

**`__FB_OPTION_PROFILE__`** is set to non-zero when profiling code is generated
 **`__FB_OPTION_PROFILE__`** is set to zero when profiling code is not generated

[`#Pragma Profile`](Pragma) allows to control the generation of profiling code.  
 This allows optionally including or excluding sections of source code to be profiled:

when `#pragma profile = true`, then profiling code is generated  
 when `#pragma profile = false`, then profiling code is not generated

## Remarks

### Version

- Since fbc 1.20.0

### Differences from QB

- New to FreeBASIC

### See also

- [Compiler Option: -profgen](Compiler-Option-Profgen)
- [Profiling for gmon/gprof](Profiling-for-Gmon-Gprof)
- [Profiling with fb's profiler](Profiling-with-Fb-S-Profiler)
- [#pragma](Pragma)

## Examples

```freebasic
#cmdline "-profgen fb"

' profiling code generated

Print __FB_OPTION_PROFILE__

#pragma profile = False

' profiling code not generated

Print __FB_OPTION_PROFILE__

#pragma profile = True

' profiling code generated

Print __FB_OPTION_PROFILE__
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
