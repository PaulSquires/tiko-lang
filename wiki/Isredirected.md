[Home](Home) › [Operating System Functions](Category-Operating-System-Functions) › **IsRedirected**

# IsRedirected

Checks whether stdin or stdout is redirected to a file

## Syntax

```freebasic
Declare Function IsRedirected ( ByVal is_input As Long = 0 ) As Long
```

## Parameters

- `is_input`

## Description

**IsRedirected** checks whether stdin or stdout is redirected to a file, instead of being connected to the console/terminal as usual.

 If `is_input` is equal to non-zero (`-1`), **IsRedirected** checks stdin.  
 If `is_input` is equal to zero (`0`), **IsRedirected** checks stdout.

## Return Value

Returns non-zero (`-1`) if stdin or stdout is redirected, otherwise returns zero (`0`).

## Remarks

### Usage

```freebasic
#include "fbio.bi"

result = IsRedirected( is_input )
```

### Differences from QB

- New to FreeBASIC.

### See also

- [`Reset(Streamno)`](Reset)

## Examples

```freebasic
'' A Windows based example, just for the use principle

'' Self-sufficient example, using his own .exe file as dummy input file for stdin redirection

#include "fbio.bi"

'' Quotation marks wrapping for compatibility with spaces in path name

Dim As String pathExe = """" & ExePath & """"

Dim As String fileExe = Mid(Command(0), InStrRev(Command(0), "\") + 1)

Dim As String redirection = " < """ & Command(0)

If LCase(Right(Command(0), 4)) = ".exe" Then

  redirection &= """"

Else

  redirection &= ".exe"""

End If

If Command() = "" Then  '' First process without stdin redirection

  '' Check stdin redirection

  Print "First process without stdin redirection: IsRedirected(-1) = "; IsRedirected(-1)

  '' Creation of asynchronous second process with stdin redirected from file.exe

  Shell("start /d " & pathExe & " /b " & fileExe & redirection & " secondprocess")

  '' Waiting for termination of asynchronous second process

  Sleep

ElseIf Command() = "secondprocess" Then  '' Second process with stdin redirection

  '' Check stdin redirection

  Print "Second process with stdin redirection  : IsRedirected(-1) = "; IsRedirected(-1)

End If
```

---

**Category:** [Operating System Functions](Category-Operating-System-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
