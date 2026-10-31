[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › **Windows version and system**

# Windows version and system

Reports the Windows version, build, edition and bitness, and the version of any file.

The version functions ask the system kernel directly, so they return the real version whatever
the program's manifest says. The older `GetVersionExW` call does not: in a program without a
manifest it reports 6.2, build 9200 (Windows 8), even on Windows 11. Windows 10 and Windows 11 both report version 10.0; tell them
apart by the build number, which is 22000 or higher on Windows 11.

Versions are returned as one number, the major version times 100 plus the minor version:
`1000` for 10.0, `601` for 6.1, `582` for 5.82.

## Importing

```freebasic
#import "sys/win"
using win
```

## Example

A console program that describes the Windows it runs on:

```freebasic
#import "sys/win"
using win

function main() as long
    dim nBuild as long = GetWindowsBuild()
    dim ustrName as ustring
    if GetWindowsMajorVersion() = 10 andalso nBuild >= 22000 then
        ustrName = "Windows 11"
    else
        ustrName = "Windows " & GetWindowsMajorVersion() & "." & GetWindowsMinorVersion()
    end if
    print ustrName; " "; GetWindowsFeatureUpdate(); ", build"; nBuild; ","; GetWindowsBitness(); "-bit"
    print "version number:"; GetWindowsVersion()
    print "user32.dll version:"; GetFileVersion( "user32.dll" )
    return 0
end function

end main()
```

On a 64-bit Windows 11, build 26300, it prints `Windows 11 26H2, build 26300, 64-bit`, then
`version number: 1000` and `user32.dll version: 1000`.

## Functions

| Function | Does |
| --- | --- |
| [GetWindowsVersion](#getwindowsversion) | Returns the Windows version as one number, 1000 for 10.0. |
| [GetWindowsMajorVersion](#getwindowsmajorversion) | Returns the major version, 10 on Windows 10 and 11. |
| [GetWindowsMinorVersion](#getwindowsminorversion) | Returns the minor version, 0 on Windows 10 and 11. |
| [GetWindowsBuild](#getwindowsbuild) | Returns the build number. |
| [GetWindowsBitness](#getwindowsbitness) | Returns 64 on a 64-bit Windows, 32 on a 32-bit one. |
| [GetWindowsProductType](#getwindowsproducttype) | Returns the edition, as a `PRODUCT_*` value. |
| [GetWindowsFeatureUpdate](#getwindowsfeatureupdate) | Returns the feature update name, such as `26H2`. |
| [GetFileVersion](#getfileversion) | Returns the version of a file as one number. |
| [ShowSysInfo](#showsysinfo) | Opens the System Information program. |
| [GetMACAddress](#getmacaddress) | Returns the hardware address of a network adapter. |

## Reference

### GetWindowsVersion

```freebasic
function GetWindowsVersion() as long
```

Returns the version of Windows as the major version times 100 plus the minor version.

| Value | Windows |
| --- | --- |
| 600 | Vista, Server 2008 |
| 601 | 7 |
| 602 | 8 |
| 603 | 8.1 |
| 1000 | 10 and 11, Server 2016 and later |

**Returns** the version, or 0 if it could not be read.

**Example**

```freebasic
if GetWindowsVersion() < 1000 then print "this program needs Windows 10 or later"
```

Microsoft Learn: [RtlGetVersion](https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/wdm/nf-wdm-rtlgetversion)

### GetWindowsMajorVersion

```freebasic
function GetWindowsMajorVersion() as long
```

Returns the major version of Windows: 10 on Windows 10 and Windows 11, 6 on Vista to 8.1.

**Returns** the major version, or 0 if it could not be read.

**Example**

```freebasic
print "major version:"; GetWindowsMajorVersion()
```

### GetWindowsMinorVersion

```freebasic
function GetWindowsMinorVersion() as long
```

Returns the minor version of Windows: 0 on Windows 10 and Windows 11, 1 on Windows 7.

**Returns** the minor version, or 0 if it could not be read.

**Example**

```freebasic
print "Windows"; GetWindowsMajorVersion(); "."; GetWindowsMinorVersion()
```

### GetWindowsBuild

```freebasic
function GetWindowsBuild() as long
```

Returns the build number of Windows. It is 22000 or higher on Windows 11, lower on Windows 10.

**Returns** the build number, or 0 if it could not be read.

**Example**

```freebasic
if GetWindowsBuild() >= 22000 then print "Windows 11"
```

### GetWindowsBitness

```freebasic
function GetWindowsBitness() as long
```

Returns the bitness of the operating system, not of the program: 64 on an x64 or ARM64 Windows,
32 otherwise.

**Returns** 64 or 32.

**Example**

```freebasic
print GetWindowsBitness(); "-bit Windows"
```

Microsoft Learn: [GetNativeSystemInfo](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getnativesysteminfo)

### GetWindowsProductType

```freebasic
function GetWindowsProductType() as DWORD
```

Returns the edition of Windows installed, as one of the `PRODUCT_*` values: for example
`PRODUCT_PROFESSIONAL` (`&h30`) for Pro, `PRODUCT_CORE` (`&h65`) for Home and
`PRODUCT_ENTERPRISE` (`&h04`) for Enterprise.

**Returns** the `PRODUCT_*` value, or `PRODUCT_UNDEFINED` (0) if it could not be read.

**Example**

```freebasic
if GetWindowsProductType() = PRODUCT_PROFESSIONAL then print "Windows Pro"
```

Microsoft Learn: [GetProductInfo](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getproductinfo)

### GetWindowsFeatureUpdate

```freebasic
function GetWindowsFeatureUpdate() as ustring
```

Returns the name of the installed feature update, the twice-yearly release name such as `22H2`
or `26H2`, as Windows shows it under Settings › System › About. It is read from the
`DisplayVersion` value under `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion`.

**Returns** the name, or an empty string on Windows versions that do not record one.

**Example**

```freebasic
print "feature update: "; GetWindowsFeatureUpdate()
```

Microsoft Learn: [RegGetValueW](https://learn.microsoft.com/en-us/windows/win32/api/winreg/nf-winreg-reggetvaluew)

### GetFileVersion

```freebasic
function GetFileVersion( byval pwszFileName as wstring ptr ) as long
```

Returns the version of a file from its version resource, as the major version times 100 plus
the minor version: 610 for 6.10. The build and revision parts are not included. A minor version
above 99 runs into the major part, so the number is only unambiguous for minor versions of 0 to
99.

A file name without a path is looked for the way Windows looks for a DLL. So
`GetFileVersion( "comctl32.dll" )` returns 582, the version-5 common controls in the system
folder, even in a program that uses version 6 through its manifest.

| Parameter | Meaning |
| --- | --- |
| `pwszFileName` | The file: an executable, a DLL or any other file with a version resource. |

**Returns** the version, or 0 if the file has no version resource or cannot be found.

**Example**

```freebasic
print "user32.dll:"; GetFileVersion( "user32.dll" )   ' 1000 on Windows 10 and 11
```

Microsoft Learn: [GetFileVersionInfoW](https://learn.microsoft.com/en-us/windows/win32/api/winver/nf-winver-getfileversioninfow), [VS_FIXEDFILEINFO](https://learn.microsoft.com/en-us/windows/win32/api/verrsrc/ns-verrsrc-vs_fixedfileinfo)

### ShowSysInfo

```freebasic
function ShowSysInfo( byval hWin as HWND ) as boolean
```

Starts the Windows System Information program (`msinfo32.exe`), found through the path it
records under `HKEY_LOCAL_MACHINE\Software\Microsoft\Shared Tools\MSInfo`. It does not wait for
the program to close.

| Parameter | Meaning |
| --- | --- |
| `hWin` | The window that owns any error message Windows shows, or `NULL`. |

**Returns** `true` if the program was started; `false` if its path is not recorded or it could not
be started.

**Example**

```freebasic
if ShowSysInfo( hwnd ) = false then MsgBox( hwnd, "System Information is not available." )
```

Microsoft Learn: [ShellExecuteW](https://learn.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-shellexecutew)

### GetMACAddress

```freebasic
function GetMACAddress() as string
```

Returns the hardware (MAC) address of a network adapter as six pairs of upper-case hexadecimal
digits joined by dashes, `MM-MM-MM-SS-SS-SS`: 17 characters. The first three pairs identify the
maker of the adapter.

The address is the one Windows puts into a sequential `UUID`, so on a computer with several
adapters it is one of them and you cannot choose which. On a computer with no network adapter
Windows makes the address up.

**Returns** the address, or an empty string if it could not be read.

**Example**

```freebasic
dim mac as string = GetMACAddress()
if len( mac ) then print "adapter address: "; mac
```

Microsoft Learn: [UuidCreateSequential](https://learn.microsoft.com/en-us/windows/win32/api/rpcdce/nf-rpcdce-uuidcreatesequential)

## See also

- [Category: sys/win](Category-Sys-Win)
- [Program basics](SysWin-Program-Basics)
- [System folders](SysWin-System-Folders)
