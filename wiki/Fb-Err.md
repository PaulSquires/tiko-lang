[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_ERR__**

# __FB_ERR__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__FB_ERR__
```

## Description

`__FB_ERR__` indicates if *[-e](Compiler-Option-E)*, *[-ex](Compiler-Option-Ex)*, or *[-exx](Compiler-Option-Exx)* was specified on the compiler command line at the time of compilation of a module.

 `__FB_ERR__` indicates if *[-earray](Compiler-Option-Earray)*, *[-enullptr](Compiler-Option-Enullptr)*, or *[-elocation](Compiler-Option-Elocation)* was specified on the compiler command line, or implied by use of *[-exx](Compiler-Option-Exx)*, at the time of compilation of a module.

 `__FB_ERR__` indicates if *[-edebug](Compiler-Option-Edebug)*, *[-edebuginfo](Compiler-Option-Edebuginfo)*, or *[-eassert](Compiler-Option-Eassert)* was specified on the compiler command line, or implied by use of *[-g](Compiler-Option-G)*, at the time of compilation of a module.

 `__FB_ERR__` indicates if *[-eunwind](Compiler-Option-Eunwind)* was specified on the compiler command line, or implied by use of *[-e](Compiler-Option-E)*, *[-ex](Compiler-Option-Ex)*, or *[-exx](Compiler-Option-Exx)*, at the time of compilation of a module.

 `__FB_ERR__` indicates if *[-earraydims](Compiler-Option-Earraydims)* was specified on the compiler command line, or implied by use of *[-exx](Compiler-Option-Exx)*, at the time of compilation of a module.

 Returns bit-wise `OR` of the following values:

| value | flag | description |
| --- | --- | --- |
| 0 | no flag | |
| 1 | errorcheck | implied by '-e', '-ex', '-exx' |
| 2 | resumeerr | implied by '-ex', '-exx' |
| 4 | extraerrchk | implied by '-exx' |
| 8 | arrayboundchk | implied by '-earray', '-exx' |
| 16 | nullptrchk | implied by '-enullptr', '-exx' |
| 32 | assertions | implied by '-eassert', '-g' |
| 64 | debuginfo | implied by '-edebuginfo', '-g' |
| 128 | debug | implied by '-edebug', '-g' |
| 256 | errlocation | implied by '-elocation', '-exx' |
| 512 | unwindinfo | implied by '-eunwind', '-e', '-ex', '-exx' |
| 1024 | arraydimscheck | implied by '-earraydims', '-exx' |

`__FB_ERR__` is always defined.

## Remarks

### Version

- Since fbc 1.20.0: *[-earraydims](Compiler-Option-Earraydims)* indication.
  Since fbc 1.10.0: *[-eunwind](Compiler-Option-Eunwind)* indication.  
  Since fbc 1.07.0: *[-earray](Compiler-Option-Earray)*, *[-enullptr](Compiler-Option-Enullptr)*, *[-elocation](Compiler-Option-Elocation)*, *[-edebug](Compiler-Option-Edebug)*, *[-edebuginfo](Compiler-Option-Edebuginfo)*, and *[-eassert](Compiler-Option-Eassert)* indications.

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_MT__`](Fb-Mt)
- [`__FB_DEBUG__`](Fb-Debug)
- [Compiler Option: -e](Compiler-Option-E)
- [Compiler Option: -ex](Compiler-Option-Ex)
- [Compiler Option: -exx](Compiler-Option-Exx)
- [Compiler Option: -eunwind](Compiler-Option-Eunwind)
- [Error Handling](Error-Handling)

## Examples

```freebasic
'Example code to demonstrate a use of __FB_ERR__

Dim fb_err_value As Integer

fb_err_value = __FB_ERR__

If fb_err_value = 0 Then

    Print "no flag enabled"

Else

    If fb_err_value And 1 Then

        Print "'errorcheck' flag enabled"

    End If

    If fb_err_value And 2 Then

        Print "'resumeerr' flag enabled"

    End If

    If fb_err_value And 4 Then

        Print "'extraerrchk' flag enabled"

    End If

    If fb_err_value And 8 Then

        Print "'arrayboundchk' flag enabled"

    End If

    If fb_err_value And 16 Then

        Print "'nullptrchk' flag enabled"

    End If

    If fb_err_value And 32 Then

        Print "'assertions' flag enabled"

    End If

    If fb_err_value And 64 Then

        Print "'debuginfo' flag enabled"

    End If

    If fb_err_value And 128 Then

        Print "'debug' flag enabled"

    End If

    If fb_err_value And 256 Then

        Print "'errlocation' flag enabled"

    End If

    If fb_err_value And 512 Then

        Print "'unwindinfo' flag enabled"

    End If

    If fb_err_value And 1024 Then

        Print "'arraydimscheck' flag enabled"

    End If

End If
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
