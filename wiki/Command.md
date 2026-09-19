[Home](Home) › [Operating System Functions](Category-Operating-System-Functions) › **Command**

# Command

Returns command line parameters used to call the program

## Syntax

```freebasic
Declare Function Command ( ByVal index As Long = -1 ) As String
```

## Parameters

- `index`

## Description

`Command` returns command-line arguments passed to the program upon execution.

 If `index` is less than zero (`< 0`), a space-separated list of all command-line arguments is returned, otherwise, a single argument is returned. A value of zero (`0`) returns the name of the executable; and values of one (`1`) and greater return each command-line argument.

 If `index` is greater than the number of arguments passed to the program, the null string (`"``"`) is returned.

 When the command line is parsed for arguments, everything between double quotes in the parameter list will be considered as a single block, and is returned without the double quotes.

 By default, filename globbing for arguments (expansion of wildcards to filenames) is used on all ports of FreeBASIC for compatibility. Arguments on the command line containing wildcards are typically not expanded if when no file is matched or if properly quoted. Other special characters for redirection are typically not returned unless properly quoted. Consult the documentation on the shell being used for more information on the proper quoting of command line arguments.  
 There may be some strange behavior when using backslash(es) in command line arguments, and the result may even depend on the platform.

 ***WARNING**: By nature of constructor precedence in FreeBASIC and main() initialization, calling `Command` within a global constructor (module constructor or UDT constructor called for static/shared object) is not safe (may even induce a runtime error).*

 *Disabling filename globbing under Windows*

Define the following global variable(s) somewhere in the source:

```freebasic
'' For MinGW.org and Cygwin runtimes:

Extern _CRT_glob Alias "_CRT_glob" As Long

Dim Shared _CRT_glob As Long = 0

'' For MinGW-w64 runtime:

Extern _dowildcard Alias "_dowildcard" As Long

Dim Shared _dowildcard As Long = 0
```

*Disabling filename globbing under Dos*

Define the following function somewhere in the source:

```freebasic
Function __crt0_glob_function Alias "__crt0_glob_function" ( ByVal arg As UByte Ptr ) As UByte Ptr Ptr

  Return 0

End Function
```

*Disabling filename globbing under Linux*

Filename globbing is handled by the command shell. Quote the argument containing wildcards or disable filename globbing in the shell prior to executing the command. For example in bash use 'set -f' to disable wildcard expansion

## Return Value

Returns the command-line arguments(s).

## Remarks

### Usage

`result = Command[$]( [ index ] )`

### Dialect Differences

- The string type suffix "$" is required in the *[-lang qb](Compiler-Option-Lang)* dialect.
  The string type suffix "$" is optional in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is ignored in the *[-lang fb](Compiler-Option-Lang)* dialect, warn only with the *[-w suffix](Compiler-Option-W)* compile option (or *[-w pedantic](Compiler-Option-W)* compile option).

### Differences from QB

- The numeric argument was not supported in QB.
- QB converted the parameter list to uppercase before returning it, FreeBASIC doesn't.
- By default arguments containing wildcard characters are expanded (filename globbing)

### See also

- [`__FB_ARGC__`](Fb-Argc)
- [`__FB_ARGV__`](Fb-Argv)
- [`Exec`](Exec)
- [`Run`](Run)

## Examples

```freebasic
Print "program launched via: " & Command(0)

Dim As Long i = 1

Do

    Dim As String arg = Command(i)

    If Len(arg) = 0 Then

        Exit Do

    End If

    Print "command line argument " & i & " = """ & arg & """"

    i += 1

Loop

If i = 1 Then

    Print "(no command line arguments)"

End If

Sleep
```

---

**Category:** [Operating System Functions](Category-Operating-System-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
