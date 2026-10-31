[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › **Paths and files**

# Paths and files

Splits paths into folder, name and extension, and detects UTF-16 and UTF-8 text.

The `GetExe*` functions describe the program that is running, from the path Windows loaded it
from. The other path functions only **parse text**: they never look at the disk, so a path
works whether or not the file exists, and a folder name with a period in it can be mistaken for
a file name. They split at the last `\`, `/` or `:` and at the last period; each entry says what
it returns when one of those is missing, because the functions do not all agree.

The four `Is*` functions guess the encoding of text: in a string, or in the first kilobyte of a
file.

## Importing

```freebasic
#import "sys/win"
using win
```

## Example

A console program that prints where it runs from and splits a path:

```freebasic
#import "sys/win"
using win

print "running "; GetExeFileNameX(); " from "; GetExePath()

dim path as ustring = "C:\Tools\report.final.txt"
print "folder:    "; GetPathName( path )        ' C:\Tools\
print "name:      "; GetFileName( path )        ' report.final
print "extension: "; GetFileExt( path )         ' .txt
print "with ext:  "; ParsePathName( "NAMEX", path )
```

## Functions

| Function | Does |
| --- | --- |
| [GetExePath](#getexepath) | Returns the folder of the running program, without a trailing backslash. |
| [GetExePathName](#getexepathname) | Returns the folder of the running program, with a trailing backslash. |
| [GetExeFileName](#getexefilename) | Returns the program's file name without its extension. |
| [GetExeFileNameX](#getexefilenamex) | Returns the program's file name with its extension. |
| [GetExeFileExt](#getexefileext) | Returns the program's extension. |
| [GetExeFullPath](#getexefullpath) | Returns the full path of the program. |
| [GetFileName](#getfilename) | Returns the file name of a path, without its extension. |
| [GetFileNameX](#getfilenamex) | Returns the file name of a path, with its extension. |
| [GetFileExt](#getfileext) | Returns the extension of a path, with its period. |
| [GetPathName](#getpathname) | Returns the folder part of a path, with its trailing separator. |
| [GetFolderName](#getfoldername) | Returns the folder part of a path, without a trailing separator. |
| [ParsePathName](#parsepathname) | Returns the part of a path that a keyword names. |
| [SaveTempFile](#savetempfile) | Writes a text to a new file in the temporary folder. |
| [IsTextUnicode](#istextunicode) | Tells whether a wide string looks like UTF-16 text. |
| [IsTextUtf8](#istextutf8) | Tells whether a byte string is valid UTF-8. |
| [IsFileUnicode](#isfileunicode) | Tells whether a file is likely to hold Unicode text. |
| [IsFileUtf8](#isfileutf8) | Tells whether a file holds UTF-8 text. |

## Reference

### GetExePath

```freebasic
function GetExePath() as ustring
```

Returns the folder the running program was loaded from, without a trailing backslash, except
for the root of a drive (`C:\`).

**Returns** the folder, such as `C:\Tools`.

**Example**

```freebasic
dim settings as ustring = GetExePath() & "\settings.ini"
```

Microsoft Learn: [GetModuleFileNameW](https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-getmodulefilenamew)

### GetExePathName

```freebasic
function GetExePathName() as ustring
```

Returns the folder the running program was loaded from, **with** a trailing backslash, ready to
have a file name appended.

**Returns** the folder, such as `C:\Tools\`.

**Example**

```freebasic
dim logFile as ustring = GetExePathName() & "app.log"
```

### GetExeFileName

```freebasic
function GetExeFileName() as ustring
```

Returns the file name of the running program without its extension: `path1` for
`C:\Tools\path1.exe`.

**Returns** the name.

**Example**

```freebasic
SetWindowText( hwnd, GetExeFileName() )
```

### GetExeFileNameX

```freebasic
function GetExeFileNameX() as ustring
```

Returns the file name of the running program with its extension: `path1.exe`.

**Returns** the name and extension.

**Example**

```freebasic
print "usage: "; GetExeFileNameX(); " <file>"
```

### GetExeFileExt

```freebasic
function GetExeFileExt() as ustring
```

Returns the extension of the running program with its leading period, normally `.exe`. Only
when the full path has no period anywhere does it return the whole path.

**Returns** the extension.

**Example**

```freebasic
print GetExeFileExt()   ' .exe
```

### GetExeFullPath

```freebasic
function GetExeFullPath() as ustring
```

Returns the full path of the running program: folder, name and extension.

**Returns** the path, such as `C:\Tools\path1.exe`.

**Example**

```freebasic
print "this program is "; GetExeFullPath()
```

### GetFileName

```freebasic
function GetFileName( byref wszPath as const wstring ) as ustring
```

Returns the file name in a path without its extension: the text after the last `\`, `/` or
`:`, up to its last period. `C:\Tools\report.final.txt` gives `report.final`.

A name with **no** period gives `""`: `C:\Tools\README` returns nothing. Use
`ParsePathName( "NAME", ... )`, which returns `README` there.

| Parameter | Meaning |
| --- | --- |
| `wszPath` | A path or a bare file name. |

**Returns** the name, or `""` when it has no extension.

**Example**

```freebasic
print GetFileName( "C:\Tools\report.txt" )   ' report
```

### GetFileNameX

```freebasic
function GetFileNameX( byref wszPath as const wstring ) as ustring
```

Returns the file name in a path with its extension: the text after the last `\`, `/` or `:`.
A path with no separator is returned whole; a path ending in a separator gives `""`.

**Returns** the name and extension.

**Example**

```freebasic
print GetFileNameX( "C:\Tools\report.txt" )   ' report.txt
```

### GetFileExt

```freebasic
function GetFileExt( byref wszPath as const wstring ) as ustring
```

Returns the extension of a path with its period: the text from the last period on.
`C:\Tools\report.final.txt` gives `.txt`.

The function looks for the last period anywhere in the path. With no period at all it returns
the **whole path** (`C:\Tools\README` gives `C:\Tools\README`), and a period in a folder name
counts (`C:\my.dir\README` gives `.dir\README`). `ParsePathName( "EXTN", ... )` looks only in the
file name and returns `""` in both cases.

**Returns** the extension, or the whole path when there is no period.

**Example**

```freebasic
if lcase( GetFileExt( "notes.TXT" ) ) = ".txt" then print "a text file"
```

### GetPathName

```freebasic
function GetPathName( byref wszPath as const wstring ) as ustring
```

Returns the folder part of a path: everything up to and including the last `\`, `/` or `:`.
`C:\Tools\report.txt` gives `C:\Tools\`; `C:report.txt` gives `C:`.

**Returns** the folder with its trailing separator, or `""` when the path has no separator.

**Example**

```freebasic
print GetPathName( "C:\Tools\report.txt" )   ' C:\Tools\
```

### GetFolderName

```freebasic
function GetFolderName( byref wszPath as const wstring ) as ustring
```

Returns the folder part of a path without a trailing separator. Whether the last part of the
path is taken for a file depends only on whether the path holds a period:

- With a period anywhere in it, everything before the last `\` or `/` is returned:
  `C:\Tools\report.txt` gives `C:\Tools`, and `C:\my.dir\Sub` gives `C:\my.dir`, because of the
  period in the folder name.
- With no period, the path is taken to be a folder already and comes back whole, less one
  trailing backslash: `C:\Tools\Sub` and `C:\Tools\Sub\` both give `C:\Tools\Sub`.

**Returns** the folder; a bare file name with no separator comes back unchanged.

**Example**

```freebasic
print GetFolderName( "C:\Tools\report.txt" )   ' C:\Tools
```

### ParsePathName

```freebasic
function ParsePathName( byref wszOption as const wstring, byref wszFileSpec as wstring ) as ustring
```

Returns one part of a path, picked by a keyword (upper or lower case). The separators are the
last `\`, `/` or `:`; only the file name is searched for the period.

| `wszOption` | Returns | For `C:\Tools\report.final.txt` |
| --- | --- | --- |
| `"PATH"` | the folder, with its trailing separator; `""` when there is none | `C:\Tools\` |
| `"NAME"` | the file name without its extension; the whole name when it has none | `report.final` |
| `"NAMEX"` | the file name with its extension | `report.final.txt` |
| `"EXTN"` | the extension with its period; `""` when there is none | `.txt` |

| Parameter | Meaning |
| --- | --- |
| `wszOption` | `PATH`, `NAME`, `NAMEX` or `EXTN`. |
| `wszFileSpec` | The path. |

**Returns** the part, or `""` for an empty path or an unknown keyword.

**Example**

```freebasic
print ParsePathName( "NAME", "C:\Tools\README" )   ' README
```

### SaveTempFile

```freebasic
function SaveTempFile( byval pwszBuffer as wstring ptr, byref wszExtension as wstring = "" ) as ustring
```

Creates a new file with a unique name such as `TMPD2A9.tmp` in the user's temporary folder,
writes the text into it followed by a carriage return and line feed, and returns its full path.
With `wszExtension` the `tmp` extension is replaced by it: pass it **without** a period
(`"html"` gives `TMPD2AA.html`; `".htm"` gives `TMPD2AB..htm`).

The text is written in the narrow 8-bit form, not as Unicode: characters outside ASCII came out
as `?` when measured. Pass text you need intact through another route.

The file is not deleted for you.

| Parameter | Meaning |
| --- | --- |
| `pwszBuffer` | The text to write. It must not be `NULL`. |
| `wszExtension` | Optional extension, without the period. |

**Returns** the full path of the file, or `""` when it could not be created. When renaming to
the new extension fails, the path with `.tmp` is returned.

**Example**

```freebasic
dim page as ustring = SaveTempFile( "<h1>Report</h1>", "html" )
if len( page ) then ShellExecuteW( NULL, "open", page, NULL, NULL, SW_SHOWNORMAL )
```

Microsoft Learn: [GetTempFileNameW](https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-gettempfilenamew)

### IsTextUnicode

```freebasic
function IsTextUnicode overload( byref wszText as const wstring ) as boolean
```

Runs Windows' statistical tests on a wide string to judge whether it is likely to be UTF-16
text. The one-argument form belongs to `win`; the Windows function, which takes a buffer, its
size in bytes and a set of tests, is still there with three arguments. Both `"Hello, world"` and
`"Привет"` pass.

The tests are a guess, made for raw bytes of unknown origin: use the three-argument form on a
buffer you have read from somewhere.

**Returns** `true` when the text passes the tests.

**Example**

```freebasic
print IsTextUnicode( "Hello, world" )   ' true
```

Microsoft Learn: [IsTextUnicode](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-istextunicode)

### IsTextUtf8

```freebasic
function IsTextUtf8( byref s as string ) as boolean
```

Tells whether a byte string is valid UTF-8. A string that starts with the UTF-8 byte order mark
(`EF BB BF`) is accepted without looking further. Plain ASCII is valid UTF-8.

| Parameter | Meaning |
| --- | --- |
| `s` | The bytes to test. |

**Returns** `true` for valid UTF-8 or a leading byte order mark; `false` for invalid bytes and
for an empty string. `chr( &hC3, &hA9 )` (é in UTF-8) gives `true`; `chr( &hE9 )` (é in
Windows-1252) gives `false`.

**Example**

```freebasic
dim raw as string = chr( &hC3, &hA9 )
if IsTextUtf8( raw ) then print Utf8ToWide( raw ) else print Ucode( raw )
```

Microsoft Learn: [MultiByteToWideChar](https://learn.microsoft.com/en-us/windows/win32/api/stringapiset/nf-stringapiset-multibytetowidechar)

### IsFileUnicode

```freebasic
function IsFileUnicode( byref wszFileName as const wstring ) as boolean
```

Judges whether a file holds Unicode text. A byte order mark settles it: UTF-8, UTF-16 (little
or big endian) or UTF-32 (little or big endian). Without one, the first 1024 bytes go through the
statistical tests of [IsTextUnicode](#istextunicode), which look for UTF-16; a UTF-8 file
without a byte order mark gives `false`.

| Parameter | Meaning |
| --- | --- |
| `wszFileName` | The path of the file. |

**Returns** `true` when a byte order mark is found or the tests pass; `false` otherwise, and when
the file cannot be opened.

**Example**

```freebasic
if IsFileUnicode( "notes.txt" ) then print "Unicode text"
```

### IsFileUtf8

```freebasic
function IsFileUtf8( byref wszFileName as const wstring ) as boolean
```

Tells whether a file holds UTF-8 text: either it starts with the UTF-8 byte order mark, or its
first 1024 bytes are valid UTF-8. A plain ASCII file is valid UTF-8; a UTF-16 file is not. A
multi-byte character cut in two at byte 1024 makes the test fail.

| Parameter | Meaning |
| --- | --- |
| `wszFileName` | The path of the file. |

**Returns** `true` for UTF-8; `false` otherwise, and when the file cannot be opened.

**Example**

```freebasic
if IsFileUtf8( "notes.txt" ) then print "read it as UTF-8"
```

## See also

- [Category: sys/win](Category-Sys-Win)
- [System folders](SysWin-System-Folders) for the Windows, temporary and known folders
- [Strings](SysWin-Strings) for converting between UTF-8, code pages and UTF-16
- [Resources](SysWin-Resources) for files embedded in the program
