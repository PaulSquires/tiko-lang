[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_MT__**

# __FB_MT__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__FB_MT__
```

## Description

`__FB_MT__` indicates if the the multithreaded option *[-mt](Compiler-Option-Mt)* was specified on the command line at the time of compilation, or whether one of the [`Threadtcreate`](Threadcreate) or [`ThreadCall`](Threadcall) keywords is used more above in the source code.

 Returns non-zero (-1) if the option was specified. Returns zero (0) otherwise.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_DEBUG__`](Fb-Debug)
- [Compiler Option: -mt](Compiler-Option-Mt)

## Examples

```freebasic
#if __FB_MT__

        #print Using multi-threaded library

#else

        #print Using Single-threaded library

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
