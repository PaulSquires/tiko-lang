[Home](Home) › **Error Handling**

# Error Handling

Handling runtime errors.

 FreeBASIC can handle the errors in the following ways:

- By default the program does nothing with the errors - they are silently ignored and code continues. In this case code should process possible errors in the next line by using the [`Err`](Err) function.
  If compiled with *[-e](Compiler-Option-E)*, *[-ex](Compiler-Option-Ex)* or *[-exx](Compiler-Option-Exx)* options, FreeBASIC uses QB-like error handling.
  **Future** OOP versions of FreeBASIC may have a java-like TRY..CATCH...FINALLY exception handler implemented.

**NOTE:** The following information is valid unless the error produces an OS General Protection Fault (for example if the program writes outside the process memory area). In these cases the OS will immediately stop the program and issue an error: nothing can avoid it from inside FreeBASIC.

Default error handling

The default FreeBASIC behavior is to set the ERR variable and continue.

```freebasic
Dim As Integer e

Open "xzxwz.zwz" For Input As #1

e = Err

Print e

Sleep
```

 (The example program supposes there is no `xzxwz.zwz` file). The program does not stop; it sets the ERR variable and continues. The error can be processed in the next line.

 Some IO functions such as [`Open`](Open) and [`Put #`](Put-File-I-O)... can be used in function form, returning an error number or zero if successful.

```freebasic
Print Open ("xzxwz.zwz" For Input As #1)

Sleep
```

QuickBASIC-like error handling

If the *[-e](Compiler-Option-E)*, *[-ex](Compiler-Option-Ex)* or *[-exx](Compiler-Option-Exx)* switch is used at compile time, the program is expected to have a QB-like error handler enabled. If no handler processes the error, the program stops with an error.

 Notice: if QB-Like error handling is used, the programmer should be prepared to handle all error conditions.

```freebasic
'' Compile with QB (-lang qb) dialect

'$lang: "qb"

On Error Goto FAILED

Open "xzxwz.zwz" For Input As #1

On Error Goto 0

Sleep

End

FAILED:

Dim e As Integer

e = Err

Print e

Sleep

End
```

 [`On Error`](On-Error) sets an error handling routine which the program will jump to when an error is found. `On Error Goto 0` disables the error handling.

 If an error handling routine is not set when an error occurs, the program will stop and send the console an error message.

```freebasic
Aborting program due to runtime error 2 (file not found)

```

The error handler routine can be at the end of the program, as in QB. The [`On Local Error`](Local) statement allows the setting of a local error handler routine at the end of the same [`Sub`](Sub) or [`Function`](procedures-Function) in which the error occurs.

```freebasic
'' Compile with -e

'' The -e command line option is needed to enable error handling.

Declare Sub foo

  foo

Sleep

Sub foo

    Dim filename As String

    Dim errmsg As String

    filename = ""

    On Local Error Goto fail

  Open filename For Input Access Read As #1

    Print "No error"

    On Local Error Goto 0

    Exit Sub

  fail:

  errmsg = "Error " & Err & _

           " in function " & *Erfn & _

           " on line " & Erl

  Print errmsg

End Sub
```

 If the *[-e](Compiler-Option-E)* switch is used (whatever the *[-lang](Compiler-Option-Lang)* dialect), the error handler must terminate the program.  
 With (*[-ex](Compiler-Option-Ex)* or *[-exx](Compiler-Option-Exx)*) and *[-lang qb](Compiler-Option-Lang)* dialect only, the error routine can end by using [`Resume`](Resume) (retries the statement that caused the error) or [`Resume Next`](Resume-Next) (continues at the next instruction) .

Error codes

See Runtime Error Codes for a listing of runtime error numbers and their associated meaning.

 No user error code range is defined. If [`Error`](Error) is used to set an error code it is wise to use high values to avoid collisions with the list of built-in error codes. (This built-in list may be expanded later.)

'On \[Local\] Error Goto' statement use

*'On \[Local\] Error Goto label'* causes a program jump to a specified label as soon as an error occurs. Such errors can be triggered by built-in statements such as *'Open'*, *'Get'*, *'Put'*, or when the [`Error`](Error) statement is used.
 The error checking for built-in statements is only enabled if the program is compiled with one of the *[-e](Compiler-Option-E)*, *[-ex](Compiler-Option-Ex)* or *[-exx](Compiler-Option-Exx)* options. Otherwise, no jump will be performed, but the command will still consume processor time.  
 When triggered by the only [`Error`](Error) statement, *'On \[Local\] Error Goto label'* remains always working even when none of these compile options are used.
 *'On Error Goto 0'* deactivates the current error handler. If an error occurs, FreeBASIC will not jump.

 The optional [`Local`](Local) keyword (authorized only inside Sub/Function) was intended to be used to define an error handler only in the same procedure the *'On Local Error'* is in (for compatibility with PDS 7.1 and VB Dos 1.0 for example). In this case, FreeBASIC should have searched for the label in the current procedure only.  
 But presently, the [`Local`](Local) clause is ignored by the compiler, and the error handler can be either in the scope of the same procedure the *'On \[Local\] Error'* is in, or in the main part of the module (if defined before the procedure).  
 Exception when *[-gen gcc](Compiler-Option-Gen)* is used (or for the 64-bit compiler): the [`Local`](Local) clause seems to be rightly taken into account, but except inside a local scope!

 *'On \[Local\] Error Goto label'* is not the best way to catch errors from a built-in procedure when a syntax in the form of a function is available. The return error code can be directly tested (using the returned error code from function inhibits the QuickBASIC-like error checking and statement *'On Error Goto'*).

 It is advisable to try to write programs compatible with the *[-lang fb](Compiler-Option-Lang)* dialect and *[-exx](Compiler-Option-Exx)* option, because to test programs with option *[-exx](Compiler-Option-Exx)* for debugging purposes is a great helping:

**-** Avoid to use the statement [`Resume`](Resume) or [`Resume Next`](Resume-Next), because it is not at all supported by *[-lang fb](Compiler-Option-Lang)* (compilation error).
 **-** On the other hand, sometimes when it is useful (when no form of a function is available), use the statement *'On \[Local\] Error Goto'*, because it runs with any option among *[-e](Compiler-Option-E)*, *[-ex](Compiler-Option-Ex)*, *[-exx](Compiler-Option-Exx)*. Otherwise (no error checking option), *'On \[Local\] Error Goto'* is inactive (without compilation error), but it consumes CPU time.

Accordingly and if necessary, usually write QuickBasic-like error handling (*'On \[Local\] Error Goto label'* ..... *'label:'* .....), with conditional assembly directive depending on the value of [`__FB_ERR__`](Fb-Err), in order not to penalize the execution speed (if not error checking option is used).

 The behavior of statement *'On Error Goto'* (-lang fb) regarding compilation options (none, -e/-ex/-exx) is enlighten with the following program including several examples (4), to be compiled with or without error checking option (4\*2=8 tests):

```freebasic
#define Config 1

'#DEFINE Config 2

'#DEFINE Config 3

'#DEFINE Config 4

#if Config = 1 '-----------------------------------------------------------

Open "does_not_exist" For Input As #1

Print "main end"

Sleep

System

' - with compiler option 'none' :

'     console output :

'       'main end'

'

' - with compiler option '-e' or '-ex' or '-exx' :

'     console output :

'       'Aborting due to runtime error 2 (file not found) at line 10 of .....'

#endif '-------------------------------------------------------------------

#if Config = 2 '-----------------------------------------------------------

Dim As Integer Result = Open("does_not_exist" For Input As #1)

If Result <> 0 Then

    Print "error code returned: " & Result

    Print "file not found (processed by 'Result = Open(.....)')"

End If

Print "main end"

Sleep

End

' - with compiler option 'none' or '-e' or '-ex' or '-exx' :

'     console output :

'       'error code returned: 2'

'       'file not found (processed by 'Result = Open(.....)')'

'       'main end'

#endif '-------------------------------------------------------------------

#if Config = 3 '-----------------------------------------------------------

On Error Goto Error_Handler

Open "does_not_exist" For Input As #1

Print "main end"

Sleep

End

error_handler:

Print "file not found (processed by 'On Error Goto')"

On Error Goto 0

Print "QB-like error handling end"

Sleep

End

' - with compiler option 'none' :

'     console output :

'       'main end'

'

' - with compiler option '-e' or '-ex' or '-exx' :

'     console output :

'       'file not found (processed by 'On Error Goto')'

'       'QB-like error handling end'

#endif '-------------------------------------------------------------------

#if Config = 4 '-----------------------------------------------------------

On Error Goto error_handler

Dim As Integer Result = Open("does_not_exist" For Input As #1)

If Result <> 0 Then

    Print "error code returned: " & Result

    Print "file not found (processed by 'Result = Open(.....)')"

End If

Print "main end"

Sleep

End

error_handler:

Print "file not found (processed by 'On Error Goto')"

On Error Goto 0

Print "QB-like error handling end"

Sleep

End

' - with compiler option 'none' or '-e' or '-ex' or '-exx' :

'     console output :

'       'error code returned: 2'

'       'file not found (processed by 'Result = Open(.....)')'

'       'main end'

#endif '-------------------------------------------------------------------
```

 The Config=2 and Config=4 sections highlight that when FB function is called using explicitly its returned error code (-lang fb dialect), 'On Error Goto' is by-passed whatever the error checking level ('none', '-e', '-ex', '-exx').

See also

- [Error Handling Functions](Error-Handling-Functions)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
