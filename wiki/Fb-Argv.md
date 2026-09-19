[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_ARGV__**

# __FB_ARGV__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__FB_ARGV__
```

## Description

Substituted with a pointer to a list of pointers to the zero terminated command line arguments passed in on the command line including the name of the executable.

 **\_\_FB_ARGV\_\_** is the name of a parameter passed to the program's implicit main function, and therefore is only defined in the module level code of the main module for an application.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_ARGC__`](Fb-Argc)
- [`Command`](Command)

## Examples

```freebasic
Sub displayCommandLineArguments( ByVal argc As Integer, ByVal argv As ZString Ptr Ptr )

    Dim i As Integer

    For i = 0 To argc - 1

        Print "arg "; i; " = '"; *argv[i]; "'"

    Next i

End Sub

displayCommandLineArguments( __FB_ARGC__, __FB_ARGV__ )

Sleep
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
