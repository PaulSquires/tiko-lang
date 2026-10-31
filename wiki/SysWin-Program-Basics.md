[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › **Program basics**

# Program basics

Reads the command line, shows message boxes, pumps messages and explains Windows errors.

These are the calls almost every Windows program needs once: what it was started with, a quick
way to tell the user something, a way to keep the window responsive during a long loop, and the
text behind an error code from `GetLastError()`.

The command line is read as Unicode, so arguments in any script come through intact. Arguments
are split the way Windows splits them: by spaces, with double quotes grouping words, and the
quotes themselves removed. Index 0 is the program itself.

## Importing

```freebasic
#import "sys/win"
using win
```

## Example

A console program that lists its arguments, and explains what is wrong when there are none:

```freebasic
#import "sys/win"
using win

function main() as long
    dim n as long = wCommandArgsc()
    print "arguments:"; n - 1
    for i as long = 1 to n - 1
        print i; ": "; wCommand( i )
    next
    if n < 2 then
        print rtrim( GetWinErrMsg( ERROR_BAD_ARGUMENTS ), any wchr( 13, 10 ) )
        return 1
    end if
    return 0
end function

end main()
```

Run as `args one "two words"` it prints `arguments: 2` and then the two arguments, `one` and
`two words`, numbered. Run with no arguments it prints `arguments: 0` and `One or more arguments are not correct.`

## Functions

| Function | Does |
| --- | --- |
| [wCommand](#wcommand) | Returns one command-line argument, or all of them. |
| [wCommandArgsc](#wcommandargsc) | Returns the number of command-line arguments, the program included. |
| [MsgBox](#msgbox) | Shows a message box and returns the button the user chose. |
| [DoEvents](#doevents) | Processes the messages waiting in the queue, with dialog keyboard handling. |
| [PumpMessages](#pumpmessages) | Processes the messages waiting in the queue. |
| [GetWinErrMsg](#getwinerrmsg) | Returns the system's description of a Windows error code. |

## Reference

### wCommand

```freebasic
function wCommand( byval nIndex as long = -1 ) as ustring
```

Returns a command-line argument, read from the Unicode command line. Index 0 is the program as
it was started (usually its full path), 1 the first argument, and so on. With a negative index,
the default, it returns every argument after the program joined by single spaces; the quotes
that grouped an argument are gone, so `"two words"` comes back as two words with nothing to say
they were one argument.

| Parameter | Meaning |
| --- | --- |
| `nIndex` | 0 for the program, 1 and up for an argument, or a negative number for all arguments. |

**Returns** the argument, or an empty string when there is no argument with that index.

**Example**

```freebasic
if wCommandArgsc() > 1 then print "opening "; wCommand( 1 )
print "all arguments: "; wCommand()
```

Microsoft Learn: [CommandLineToArgvW](https://learn.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-commandlinetoargvw)

### wCommandArgsc

```freebasic
function wCommandArgsc() as long
```

Returns how many items the command line splits into, the program itself included: 1 when the
program was started with no arguments.

**Returns** the count, so the arguments run from 1 to `wCommandArgsc() - 1`.

**Example**

```freebasic
for i as long = 1 to wCommandArgsc() - 1
    print i; ": "; wCommand( i )
next
```

### MsgBox

```freebasic
function MsgBox overload( byval hWin as HWND, byval pwszText as const wstring ptr, byval pwszCaption as const wstring ptr = NULL, byval uType as DWORD = 0 ) as long
function MsgBox overload( byval pwszText as const wstring ptr, byval pwszCaption as const wstring ptr = NULL, byval uType as DWORD = 0 ) as long
```

Shows a message box and waits for the user to close it. The box is application-modal
(`MB_APPLMODAL` is always added to `uType`): the owner window is disabled until the box closes.
The form without a window handle uses the active window of the calling thread as the owner, or
none if there is no active window.

With the defaults the box has an OK button and the caption `Error`, which Windows supplies when
`pwszCaption` is `NULL`.

| Parameter | Meaning |
| --- | --- |
| `hWin` | The owner window, or `NULL` for none. |
| `pwszText` | The message. |
| `pwszCaption` | The caption, or `NULL` for Windows' default. |
| `uType` | `MB_*` flags: the buttons (`MB_OK`, `MB_YESNO`, `MB_OKCANCEL` …), an icon (`MB_ICONINFORMATION`, `MB_ICONWARNING` …) and the default button. |

**Returns** the button chosen: `IDOK`, `IDCANCEL`, `IDYES`, `IDNO` and so on, or 0 if the box
could not be shown.

**Example**

```freebasic
if MsgBox( hwnd, "Save the changes?", "Editor", MB_YESNO or MB_ICONQUESTION ) = IDYES then print "saving"
MsgBox( "The file has been saved.", "Editor", MB_ICONINFORMATION )
```

Microsoft Learn: [MessageBoxW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-messageboxw)

### DoEvents

```freebasic
sub DoEvents( byval hWin as HWND = NULL )
```

Takes every message waiting in the calling thread's queue and processes it, then returns. Call it
now and then inside a long loop so that windows repaint and the user can still click and type.

Each message is first offered to `IsDialogMessageW` for `hWin`, so Tab, the arrow keys, Enter and
Esc move between and press its controls as they would in a dialog; messages it does not handle
are translated and dispatched as usual. When `hWin` is `NULL` the thread's active window is
used.

A `WM_QUIT` taken off the queue here is dispatched like any other message and so is lost: the
program's own message loop never sees it. If the work can be cancelled by closing the window,
set a flag in `WM_CLOSE` or `WM_DESTROY` and test it in the loop.

| Parameter | Meaning |
| --- | --- |
| `hWin` | The window or dialog whose keyboard navigation to handle, or `NULL` for the active window. |

**Example**

```freebasic
for i as long = 1 to 1000
    ' ... one slice of a long job ...
    DoEvents( hwnd )
next
```

Microsoft Learn: [PeekMessageW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-peekmessagew), [IsDialogMessageW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-isdialogmessagew)

### PumpMessages

```freebasic
sub PumpMessages
```

Takes every message waiting in the calling thread's queue, translates it and dispatches it, then
returns: [DoEvents](#doevents) without the dialog keyboard handling. A `WM_QUIT` it takes off the
queue is lost in the same way.

**Example**

```freebasic
dim t as double = timer
do
    ' ... one slice of a long job ...
    PumpMessages()
loop while timer - t < 2
```

Microsoft Learn: [PeekMessageW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-peekmessagew)

### GetWinErrMsg

```freebasic
function GetWinErrMsg( byval dwError as DWORD ) as ustring
```

Returns the system's description of a Windows error code, such as the value of `GetLastError()`,
in the user's default language. The text ends with a carriage return and line feed, as Windows
writes it: `GetWinErrMsg( 5 )` is `Access is denied.` and those two characters, 19 in all.

| Parameter | Meaning |
| --- | --- |
| `dwError` | A Windows error code (`ERROR_*`), or an `HRESULT` from the system. |

**Returns** the description, or an empty string for a code the system has no text for.

**Example**

```freebasic
if DeleteFileW( "missing.txt" ) = 0 then
    print "delete failed: "; rtrim( GetWinErrMsg( GetLastError() ), any wchr( 13, 10 ) )
end if
```

Microsoft Learn: [FormatMessageW](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-formatmessagew)

## See also

- [Category: sys/win](Category-Sys-Win)
- [Windows version and system](SysWin-Windows-Version)
- [Paths and files](SysWin-Paths-and-Files) for the program's own path
- [CWindow](CWindow) for a window with its own message loop
