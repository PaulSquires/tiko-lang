[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › **System folders**

# System folders

Returns the paths of the Windows, system and temporary folders and of known folders.

Never write `C:\Windows` or `C:\Users\...` into a program: Windows can be installed on another
drive, and the user's folders can be moved or redirected. Ask for the folder instead.

Folders that belong to the user (Documents, the desktop, application data) are *known folders*,
each named by a `FOLDERID_*` constant; [GetKnownFolderPath](#getknownfolderpath) returns their
paths. The older `CSIDL_*` numbers still work through
[GetSpecialFolderLocation](#getspecialfolderlocation).

Every path comes back as a `ustring` without a trailing backslash, except the temporary folder,
which has one.

## Importing

```freebasic
#import "sys/win"
using win
```

## Example

A console program that prints where Windows keeps things on this computer:

```freebasic
#import "sys/win"
using win

function main() as long
    print "Windows:      "; GetWinDir()
    print "system:       "; GetSystemDirectory()
    print "system drive: "; GetSystemDrive()
    print "temporary:    "; GetTempPath()
    print "documents:    "; GetKnownFolderPath( @FOLDERID_Documents )
    print "fonts:        "; GetSpecialFolderLocation( CSIDL_FONTS )
    print "user32.dll:   "; GetSystemDllPath( "user32.dll" )
    return 0
end function

end main()
```

On a typical installation it prints `C:\Windows`, `C:\Windows\system32`, `C:`,
`C:\Users\<name>\AppData\Local\Temp\`, `C:\Users\<name>\Documents`, `C:\Windows\Fonts` and
`C:\Windows\System32\USER32.dll`.

## Functions

| Function | Does |
| --- | --- |
| [GetWinDir](#getwindir) | Returns the Windows folder. |
| [GetTempPath](#gettemppath) | Returns the folder for temporary files, with a trailing backslash. |
| [GetSystemDrive](#getsystemdrive) | Returns the drive Windows is installed on, such as `C:`. |
| [GetSystemDirectory](#getsystemdirectory) | Returns the Windows system folder. |
| [GetSystemWow64Directory](#getsystemwow64directory) | Returns the folder of the 32-bit system files on a 64-bit Windows. |
| [GetSystemDllPath](#getsystemdllpath) | Returns the full path of the DLL Windows loads for a name. |
| [GetKnownFolderPath](#getknownfolderpath) | Returns the path of a known folder, named by a `FOLDERID_*` constant. |
| [GetSpecialFolderLocation](#getspecialfolderlocation) | Returns the path of a special folder, named by a `CSIDL_*` value. |

## Reference

### GetWinDir

```freebasic
function GetWinDir() as ustring
```

Returns the path of the Windows folder, such as `C:\Windows`, without a trailing backslash.

**Returns** the path, or an empty string on failure.

**Example**

```freebasic
print "Windows is in "; GetWinDir()
```

Microsoft Learn: [GetWindowsDirectoryW](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getwindowsdirectoryw)

### GetTempPath

```freebasic
function GetTempPath overload() as ustring
```

Returns the folder for temporary files, **with** a trailing backslash, so a file name can be
added straight on. It is the folder named by the `TMP` or `TEMP` environment variable, usually
`C:\Users\<name>\AppData\Local\Temp\`.

The Windows function of the same name, which fills a buffer, is still there with two arguments.

**Returns** the path, or an empty string on failure.

**Example**

```freebasic
dim ustrFile as ustring = GetTempPath() & "report.txt"
print ustrFile
```

Microsoft Learn: [GetTempPathW](https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-gettemppathw)

### GetSystemDrive

```freebasic
function GetSystemDrive() as ustring
```

Returns the drive Windows is installed on, as a letter and a colon: `C:`. It is the first two
characters of the Windows folder.

**Returns** the drive.

**Example**

```freebasic
print "Windows is on drive "; GetSystemDrive()
```

### GetSystemDirectory

```freebasic
function GetSystemDirectory overload() as ustring
```

Returns the path of the Windows system folder, where the system DLLs are: `C:\Windows\system32`
on a typical installation, without a trailing backslash. A 64-bit program gets the 64-bit system
folder.

The Windows function of the same name, which fills a buffer, is still there with two arguments.

**Returns** the path, or an empty string on failure.

**Example**

```freebasic
print GetSystemDirectory() & "\notepad.exe"
```

Microsoft Learn: [GetSystemDirectoryW](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getsystemdirectoryw)

### GetSystemWow64Directory

```freebasic
function GetSystemWow64Directory overload() as ustring
```

Returns the folder that holds the 32-bit system files on a 64-bit Windows: `C:\Windows\SysWOW64`
on a typical installation.

The string returned ends in a null character after the path, so it is one character longer than
the path (20 rather than 19 for `C:\Windows\SysWOW64`). Printing it shows the path; before joining
a file name to it or comparing it, take the part before the null as the example does.

The Windows function of the same name, which fills a buffer, is still there with two arguments.

**Returns** the path, or an empty string on a 32-bit Windows, which has no such folder.

**Example**

```freebasic
dim ustrWow as ustring = GetSystemWow64Directory()
dim ustrPath as ustring = *cast( wstring ptr, strptr( ustrWow ) )   ' the path without the null
print ustrPath; len( ustrPath )
```

Microsoft Learn: [GetSystemWow64DirectoryW](https://learn.microsoft.com/en-us/windows/win32/api/wow64apiset/nf-wow64apiset-getsystemwow64directoryw)

### GetSystemDllPath

```freebasic
function GetSystemDllPath( byval pwszDllName as const wstring ptr ) as ustring
```

Returns the full path of the DLL that Windows loads for a name, such as
`C:\Windows\System32\USER32.dll` for `user32.dll`. The DLL is loaded to find out and released
again, so its start-up code runs; the name is looked up the way Windows looks up any DLL, so it
need not be a system DLL. The capitals in the path are the ones Windows reports.

| Parameter | Meaning |
| --- | --- |
| `pwszDllName` | The DLL's file name, with or without a path. |

**Returns** the path, or an empty string if the DLL could not be loaded.

**Example**

```freebasic
print "the common controls: "; GetSystemDllPath( "comctl32.dll" )
```

Microsoft Learn: [GetModuleFileNameW](https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-getmodulefilenamew)

### GetKnownFolderPath

```freebasic
function GetKnownFolderPath( byval rfid as const KNOWNFOLDERID const ptr, byval dwFlags as DWORD = 0, byval hToken as HANDLE = NULL ) as ustring
```

Returns the path of a known folder: Documents (`FOLDERID_Documents`), the desktop
(`FOLDERID_Desktop`), roaming application data (`FOLDERID_RoamingAppData`), local application
data (`FOLDERID_LocalAppData`), Program Files (`FOLDERID_ProgramFiles`) and many more. Pass the
address of the constant.

A known folder can be listed by Windows and still not exist on a given computer; then the call
fails unless `dwFlags` asks for it to be created.

| Parameter | Meaning |
| --- | --- |
| `rfid` | The address of a `FOLDERID_*` constant. |
| `dwFlags` | 0, or `KF_FLAG_*` values: `KF_FLAG_CREATE` creates the folder if it is missing, `KF_FLAG_DONT_VERIFY` returns the path without checking it. |
| `hToken` | `NULL` for the current user. An access token gives another user's folder, and `cast(HANDLE, -1)` the default profile copied into new accounts (that needs administrator rights). |

**Returns** the path, or an empty string on failure.

**Example**

```freebasic
dim ustrData as ustring = GetKnownFolderPath( @FOLDERID_RoamingAppData, KF_FLAG_CREATE )
print "settings go in "; ustrData & "\MyProgram"
```

Microsoft Learn: [SHGetKnownFolderPath](https://learn.microsoft.com/en-us/windows/win32/api/shlobj_core/nf-shlobj_core-shgetknownfolderpath), [KNOWNFOLDERID](https://learn.microsoft.com/en-us/windows/win32/shell/knownfolderid)

### GetSpecialFolderLocation

```freebasic
function GetSpecialFolderLocation( byval nFolder as long ) as ustring
```

Returns the path of a special folder named by a `CSIDL_*` value: `CSIDL_FONTS`,
`CSIDL_PERSONAL` (Documents), `CSIDL_APPDATA`, `CSIDL_WINDOWS` and so on. The `CSIDL_*` values
are the older form of the known folders; prefer [GetKnownFolderPath](#getknownfolderpath) in new
code. A virtual folder with no path in the file system, such as `CSIDL_PRINTERS`, gives an empty
string.

| Parameter | Meaning |
| --- | --- |
| `nFolder` | A `CSIDL_*` value. |

**Returns** the path, or an empty string on failure.

**Example**

```freebasic
print "fonts are in "; GetSpecialFolderLocation( CSIDL_FONTS )
```

Microsoft Learn: [SHGetSpecialFolderLocation](https://learn.microsoft.com/en-us/windows/win32/api/shlobj_core/nf-shlobj_core-shgetspecialfolderlocation), [CSIDL](https://learn.microsoft.com/en-us/windows/win32/shell/csidl)

## See also

- [Category: sys/win](Category-Sys-Win)
- [Paths and files](SysWin-Paths-and-Files) for the program's own folder
- [Windows version and system](SysWin-Windows-Version)
