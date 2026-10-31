[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › **Resources**

# Resources

Reads raw data embedded in a program's resources into a string or out to a file.

A resource script (`.rc`) compiled into the program can carry whole files: a PNG, a font, a
database, as `RCDATA`. These two functions find such a resource by name or number and copy its
bytes. The resource itself stays in the module, read-only; nothing has to be freed.

A resource is named either by a text name (`"LOGO"`) or by a number written as text with a
leading `#` (`"#101"`). The type defaults to `RT_RCDATA` (10); pass another type, such as
`RT_HTML` or a custom type name, as the last argument.

## Importing

```freebasic
#import "sys/win"
using win
```

## Example

A program that copies the resource `LOGO` out of itself into `logo.png`. Put the line
`LOGO RCDATA "logo.png"` in `logo.rc` and build with `tiko logo.tiko logo.rc`; built without
the script, it reports that there is none:

```freebasic
#import "sys/win"
using win

dim bytes as string = ExtractResource( NULL, "LOGO" )
if len( bytes ) = 0 then
    print "this program carries no LOGO resource"
elseif ExtractResourceToFile( NULL, "LOGO", "logo.png" ) then
    print "wrote logo.png,"; len( bytes ); " bytes"
end if
```

## Functions

| Function | Does |
| --- | --- |
| [ExtractResource](#extractresource) | Returns the bytes of a resource as a string. |
| [ExtractResourceToFile](#extractresourcetofile) | Writes the bytes of a resource to a file. |

## Reference

### ExtractResource

```freebasic
function ExtractResource( byval hInstance as HINSTANCE, byref wszResourceName as wstring, byval pResourceType as LPWSTR = MAKEINTRESOURCEW(10) ) as string
```

Finds a resource and returns a copy of its bytes in a `string`, which is a byte buffer here, not
text: `len()` is the size of the resource and `strptr()` points at the first byte.

| Parameter | Meaning |
| --- | --- |
| `hInstance` | The module that holds the resource; `NULL` for the program itself. |
| `wszResourceName` | The resource name, or `#` and its number (`"#101"`). |
| `pResourceType` | The resource type; `RT_RCDATA` by default. |

**Returns** the bytes, or `""` when there is no such resource or it is empty.

**Example**

```freebasic
dim png as string = ExtractResource( NULL, "#101" )
print "resource 101 is"; len( png ); " bytes"
```

Microsoft Learn: [FindResourceW](https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-findresourcew)

### ExtractResourceToFile

```freebasic
function ExtractResourceToFile( byval hInstance as HINSTANCE, byref wszResourceName as wstring, byref wszFileName as wstring, byval pResourceType as LPWSTR = MAKEINTRESOURCEW(10) ) as boolean
```

Finds a resource and writes its bytes to a file, replacing a file of that name.

| Parameter | Meaning |
| --- | --- |
| `hInstance` | The module that holds the resource; `NULL` for the program itself. |
| `wszResourceName` | The resource name, or `#` and its number (`"#101"`). |
| `wszFileName` | The path of the file to write. |
| `pResourceType` | The resource type; `RT_RCDATA` by default. |

**Returns** `true` when the file was written; `false` when there is no such resource, it is
empty, or the file cannot be created or written.

**Example**

```freebasic
if ExtractResourceToFile( NULL, "MANUAL", GetExePathName() & "manual.pdf" ) = false then print "no manual"
```

Microsoft Learn: [LoadResource](https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-loadresource)

## See also

- [Category: sys/win](Category-Sys-Win)
- [Paths and files](SysWin-Paths-and-Files) for building the output path
- [Images (GDI+)](SysWin-GdiPlus-Images) for loading an image straight from a resource
