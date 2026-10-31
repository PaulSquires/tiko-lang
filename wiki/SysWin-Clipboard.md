[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › **Clipboard**

# Clipboard

Puts text and other data on the clipboard, reads it back and empties the clipboard.

Each function opens the clipboard, does its work and closes it again, so there is nothing to
open or close yourself. The clipboard is opened without an owner window.

Data on the clipboard lives in **global memory blocks** (`HGLOBAL`), one per format: text is
`CF_UNICODETEXT`, a bitmap `CF_BITMAP` or `CF_DIB`, and programs can register formats of their
own. Once a block has been placed on the clipboard it belongs to Windows; a block you read back
with [CopyClipboardData](#copyclipboarddata) is a copy, and yours to free.

Placing data **replaces** everything that was on the clipboard, in every format.

## Importing

```freebasic
#import "sys/win"
using win
```

## Example

A console program that puts a line of text on the clipboard and reads it back:

```freebasic
#import "sys/win"
using win

if SetClipboardText( "Copied from tiko: ½ € ж" ) then
    dim text as ustring = GetClipboardText()
    print "the clipboard holds"; len( text ); " characters"
else
    print "the clipboard is in use by another program"
end if
```

## Functions

| Function | Does |
| --- | --- |
| [ClearClipboard](#clearclipboard) | Empties the clipboard. |
| [CopyClipboardData](#copyclipboarddata) | Returns a copy of the clipboard data in one format. |
| [ReplaceClipboardData](#replaceclipboarddata) | Empties the clipboard and places a memory block on it. |
| [GetClipboardText](#getclipboardtext) | Returns the text on the clipboard. |
| [SetClipboardText](#setclipboardtext) | Empties the clipboard and places a text on it. |

## Reference

### ClearClipboard

```freebasic
function ClearClipboard() as boolean
```

Removes everything from the clipboard, in every format.

**Returns** `true` on success; `false` when the clipboard could not be opened (another program
has it open) or emptied.

**Example**

```freebasic
if ClearClipboard() = false then print "the clipboard is busy"
```

Microsoft Learn: [EmptyClipboard](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-emptyclipboard)

### CopyClipboardData

```freebasic
function CopyClipboardData( byval uFormat as DWORD ) as HGLOBAL
```

Copies the clipboard data of one format into a new moveable, zero-filled global memory block
of the same size. The clipboard keeps its own data.

The returned block is yours: lock it with `GlobalLock` to read it, and free it with
`GlobalFree`. This copies memory blocks only; formats whose data is a GDI handle, such as
`CF_BITMAP`, are not memory blocks and give `NULL`.

| Parameter | Meaning |
| --- | --- |
| `uFormat` | The clipboard format: `CF_UNICODETEXT`, `CF_DIB`, or a registered format. |

**Returns** the copy, or `NULL` when that format is not on the clipboard or the clipboard could
not be opened.

**Example**

```freebasic
dim hCopy as HGLOBAL = CopyClipboardData( CF_DIB )
if hCopy then
    dim pih as BITMAPINFOHEADER ptr = GlobalLock( hCopy )
    print "a"; pih->biWidth; " x"; pih->biHeight; " image"
    GlobalUnlock( hCopy ) : GlobalFree( hCopy )
end if
```

Microsoft Learn: [GetClipboardData](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getclipboarddata)

### ReplaceClipboardData

```freebasic
function ReplaceClipboardData( byval uFormat as UINT, byval hData as HANDLE ) as HANDLE
```

Empties the clipboard and places `hData` on it in format `uFormat`. Allocate the block with
`GlobalAlloc( GMEM_MOVEABLE, ... )` and fill it before the call. After a successful call the block
belongs to Windows: do not use it or free it any more.

| Parameter | Meaning |
| --- | --- |
| `uFormat` | The clipboard format of the data. |
| `hData` | The memory block (or, for `CF_BITMAP`, the bitmap handle). |

**Returns** the handle of the data on the clipboard, or `NULL` on failure; then the block is
still yours to free.

**Example**

```freebasic
dim hMem as HGLOBAL = CopyClipboardData( CF_UNICODETEXT )
if hMem then
    if ReplaceClipboardData( CF_UNICODETEXT, hMem ) = NULL then GlobalFree( hMem )
end if
```

Microsoft Learn: [SetClipboardData](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setclipboarddata)

### GetClipboardText

```freebasic
function GetClipboardText( byval uFormat as UINT = CF_UNICODETEXT ) as ustring
```

Returns the text on the clipboard. The clipboard keeps it.

The function copies the whole memory block and treats it as UTF-16: keep the default
`CF_UNICODETEXT`, which Windows supplies whenever any program has put text there. The `ustring`
is as long as the block allows, which can be longer than the text: pass it through `rtrim()`,
which stops at the first null character, when its length matters.

| Parameter | Meaning |
| --- | --- |
| `uFormat` | The clipboard format; keep the default. |

**Returns** the text, or `""` when there is none or the clipboard could not be opened.

**Example**

```freebasic
dim text as ustring = rtrim( GetClipboardText() )
if len( text ) then print "pasted"; len( text ); " characters"
```

Microsoft Learn: [Standard clipboard formats](https://learn.microsoft.com/en-us/windows/win32/dataxchg/standard-clipboard-formats)

### SetClipboardText

```freebasic
function SetClipboardText( byref wszText as wstring, byval uFormat as UINT = CF_UNICODETEXT ) as HANDLE
```

Empties the clipboard and places a copy of `wszText` on it. The text is always stored as UTF-16,
so keep the default `CF_UNICODETEXT`; Windows makes the ANSI and OEM forms for programs that
ask for those.

| Parameter | Meaning |
| --- | --- |
| `wszText` | The text: a literal, a `ustring` or a `wstring`. |
| `uFormat` | The clipboard format; keep the default. |

**Returns** the handle of the data on the clipboard, which Windows owns, or `NULL` on failure.

**Example**

```freebasic
if SetClipboardText( GetWindowText( hCtrl ) ) = NULL then print "copy failed"
```

Microsoft Learn: [SetClipboardData](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setclipboarddata)

## See also

- [Category: sys/win](Category-Sys-Win)
- [Bitmaps](SysWin-Bitmaps) for DIBs, the format images travel in
- [Strings](SysWin-Strings) for converting text between code pages
