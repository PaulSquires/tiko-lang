[Home](Home) › [Compiler Options](Category-Compiler-Options) › **__FB_DEBUG__**

# __FB_DEBUG__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__FB_DEBUG__
```

## Description

`__FB_DEBUG__` indicates if the the generate debug information option [`-g`](Compiler-Option-G) or the enable intrinsic define `__FB_DEBUG__` option [`Compiler Option: -edebug`](Compiler-Option-Edebug) was specified on the command line at the time of compilation.

 Returns non-zero (-1) if either option was specified. Returns zero (0) otherwise.

 [`__FB_ERR__`](Fb-Err) can be used to determine in user source code if the `-g` or `-edebug` option was specified or implied on the command line.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_ERR__`](Fb-Err)
- [`__FB_MT__`](Fb-Mt)
- [Compiler Option: -edebug](Compiler-Option-Edebug)
- [Compiler Option: -g](Compiler-Option-G)

## Examples

```freebasic
#if __FB_DEBUG__ <> 0

        #print Debug mode

#else

        #print Release mode

#endif
```

---

**Category:** [Compiler Options](Category-Compiler-Options)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
