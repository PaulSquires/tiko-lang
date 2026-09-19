[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_ARGC__**

# __FB_ARGC__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__FB_ARGC__
```

## Description

Substituted with the number of arguments passed in on the command line including the name of the executable.  
 (for example : `myprogram parm1, parm2, param3` --> **`__FB_ARGC__`** = 4)

 **`__FB_ARGC__`** is the name of a parameter passed to the program's implicit main function, and therefore is only defined in the module level code of the main module for an application.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_ARGV__`](Fb-Argv)
- [`Command`](Command)

## Examples

```freebasic
Dim i As Integer

For i = 0 To __FB_ARGC__ - 1

        Print "arg "; i; " = '"; Command(i); "'"

Next i
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
