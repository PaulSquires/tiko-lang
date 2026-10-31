[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/com](SysWin-Com) › **BSTRING**

# BSTRING

Wraps a COM `BSTR` string and frees it when the variable goes out of scope.

A `BSTR` is the string type of COM and Automation: UTF-16 text in a block allocated by
`SysAllocString`, with its length in bytes stored just before the first character. COM methods
take and return text this way, and the memory belongs to whoever holds the handle.

A `BSTRING` holds one such handle in its public field `m_bstr` and frees it in its destructor.
The model to keep in mind:

- **It owns its handle.** The destructor calls `SysFreeString` on `m_bstr`. Anything you store in
  `m_bstr` yourself becomes the `BSTRING`'s to free.
- **A new `BSTRING` is empty and has no handle.** `dim bs as BSTRING` leaves `m_bstr` at `NULL`:
  `len( bs )` is 0 and it converts to an empty `ustring`, but a COM method that requires a valid
  `BSTR` gets a null one. [Append](#append) and [Let](#let) give it a handle.
- **Text in, by encoding.** A wide string (`wstr( "…" )`, a `wstring` buffer, another
  `BSTRING`) is copied as it is, and so is text assigned with `=` ([Let](#let)), narrow or wide.
  A narrow string, literal or `ustring` given when the variable is created goes through the
  code-page [Constructor](#constructor), which reads it as ANSI unless you pass `CP_UTF8`: start a
  `BSTRING` that holds characters outside ASCII from `wstr()`.
- **Text out.** Assign to a `ustring` (`dim u as ustring = bs`) or read [Utf8](#utf8). A
  function that reads a `BSTR` takes the `BSTRING` itself; `*bs` is the handle.
- **Copy with care.** `dim b2 as BSTRING = b1` copies the text into a new `BSTR`, but the
  assignment `b2 = b1` between two existing variables copies the handle: both variables then free
  the same string. Assign `b2 = *b1` to copy the text.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/com"
using win, com
```

## Example

Builds a string, edits it in place, passes it to a COM function that reads a `BSTR` and lets
one fill a `BSTRING`:

```freebasic
#import "sys/win"
#import "sys/win/com"
using win, com

dim bs as BSTRING = wstr( "Café" )
bs.Append( " au lait" )
print "length:"; len( bs )

bs[0] = asc( "c" )
dim u as ustring = bs
print u

' A function that reads a BSTR takes the BSTRING as it is
dim other as BSTRING = wstr( "CAFÉ AU LAIT" )
if VarBstrCmp( bs, other, LOCALE_USER_DEFAULT, NORM_IGNORECASE ) = VARCMP_EQ then print "same text"

' A function that writes a BSTR gets the address of the handle
dim num as BSTRING
VarBstrFromI4( 1234, LOCALE_USER_DEFAULT, 0, @num.m_bstr )
print num.Utf8; " has "; len( num ); " characters"
```

It prints:

```text
length:12
café au lait
same text
1234 has 4 characters
```

## Members

| Member | Does |
| --- | --- |
| [Constructor](#constructor) | Creates an empty `BSTRING`, or one holding a copy of some text. |
| [Destructor](#destructor) | Frees the `BSTR`. |
| [Append](#append) | Adds text to the end. |
| [Clear](#clear) | Frees the `BSTR` and leaves the variable empty. |
| [IsUtf8](#isutf8) | Tells whether a narrow string is valid UTF-8. |
| [Utf8](#utf8) | Reads the text as UTF-8, or replaces it with UTF-8 text. |
| [wchar](#wchar) | Returns a copy of the text in memory from `CoTaskMemAlloc`. |
| [Let](#let) | Replaces the text with a copy of a wide string. |
| [Cast](#cast) | Converts to the text or to the `BSTR` handle. |
| [Operator \[\] (character index)](#operator--character-index) | Reads or changes one UTF-16 code unit. |
| [Operator @ (address)](#operator--address) | Frees the text and returns the address of the handle, for an output parameter. |

## Reference

### Constructor

```freebasic
constructor
constructor( byval pwszStr as const wstring ptr )
constructor( byref ansiStr as string = "", byval nCodePage as UINT = 0 )
constructor( byval nChars as long, byref wszFill as const wstring )
```

- With no argument the `BSTRING` is empty and `m_bstr` is `NULL`.
- With a wide-string pointer it holds a copy of that text; `NULL` gives an empty string with a
  handle.
- With a narrow string it converts the text from code page `nCodePage`: 0 (`CP_ACP`, the default)
  is the system ANSI code page. With `CP_UTF8` the text is first checked with
  [IsUtf8](#isutf8) and read as ANSI if it is not valid UTF-8. The UTF-8 conversion keeps the
  terminating null as a last character, so the length is one more than the number of characters
  (`BSTRING( "año", CP_UTF8 )` has a length of 4); text appended after it is hidden from anything
  that stops at the first null. A narrow literal with only ASCII characters is the simple case:
  `dim bs as BSTRING = "Hello"`.
- With a count and a fill string it holds `nChars` copies of the first character of `wszFill`,
  or of a space when `wszFill` is empty. A count below 1 gives one character.

| Parameter | Meaning |
| --- | --- |
| `pwszStr` | The text to copy. |
| `ansiStr` | Narrow text to convert. |
| `nCodePage` | The code page of `ansiStr`: `CP_ACP` (0) or `CP_UTF8`. |
| `nChars` | The number of characters. |
| `wszFill` | A string whose first character is repeated. |

**Example**

```freebasic
dim b1 as BSTRING = "Hello"
dim b2 as BSTRING = wstr( "año" )
dim b3 as BSTRING = BSTRING( 5, "*" )
print len( b1 ), len( b2 ), len( b3 )   ' 5  3  5
```

Microsoft Learn: [SysAllocString](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-sysallocstring)

### Destructor

```freebasic
destructor
```

Frees `m_bstr` with `SysFreeString` when it is not `NULL`. It runs when the variable goes out
of scope.

**Example**

```freebasic
scope
    dim bs as BSTRING = "temporary"
end scope   ' the BSTR is freed here
```

Microsoft Learn: [SysFreeString](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-sysfreestring)

### Append

```freebasic
sub Append( byval pwszStr as const wstring ptr )
```

Adds a copy of `pwszStr` to the end, in a new `BSTR` that replaces the old one. Appending an
empty string does nothing; appending to an empty `BSTRING` gives it a handle. `pwszStr` must not
be `NULL`.

**Example**

```freebasic
dim bs as BSTRING = "Hello"
bs.Append( ", world" )
dim u as ustring = bs
print u   ' Hello, world
```

Microsoft Learn: [SysAllocStringLen](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-sysallocstringlen)

### Clear

```freebasic
sub Clear
```

Frees the `BSTR` and sets `m_bstr` to `NULL`, as a new `BSTRING` is. Call it before handing
`@bs.m_bstr` to a function that writes a new `BSTR` there, or the old one leaks.

**Example**

```freebasic
dim bs as BSTRING = "old"
bs.Clear()
VarBstrFromI4( 42, LOCALE_USER_DEFAULT, 0, @bs.m_bstr )
```

### IsUtf8

```freebasic
function IsUtf8( byref s as string ) as boolean
```

Tells whether the bytes of `s` are valid UTF-8. A string that starts with the UTF-8 byte-order
mark counts as UTF-8 whatever follows; an empty string does not. Plain ASCII is valid UTF-8.

**Returns** `true` when `s` is valid UTF-8.

**Example**

```freebasic
dim bs as BSTRING
print bs.IsUtf8( "abc" ), bs.IsUtf8( chr( &hC3 ) )   ' true  false
```

Microsoft Learn: [MultiByteToWideChar](https://learn.microsoft.com/en-us/windows/win32/api/stringapiset/nf-stringapiset-multibytetowidechar)

### Utf8

```freebasic
property Utf8() as string
property Utf8( byref utf8String as string )
```

Reading `Utf8` returns the text converted to UTF-8, or `""` for an empty `BSTRING`. Every
character the `BSTR` holds is converted, including a terminating null that the code-page
constructor or the setter stored.

Setting `Utf8` frees the current text and stores `utf8String` converted from UTF-8. Like the
`CP_UTF8` constructor, it keeps the terminating null as a last character: setting `"año"` gives a
length of 4.

**Returns** the text as UTF-8 (the getter).

**Example**

```freebasic
dim bs as BSTRING = wstr( "año" )
dim s as string = bs.Utf8
print len( s )   ' 4 bytes
```

Microsoft Learn: [WideCharToMultiByte](https://learn.microsoft.com/en-us/windows/win32/api/stringapiset/nf-stringapiset-widechartomultibyte)

### wchar

```freebasic
function wchar() as wstring ptr
```

Returns a copy of the characters in a block allocated with `CoTaskMemAlloc`, for a method that
takes a wide string and frees it itself. Free it with `CoTaskMemFree` when nothing else does.

The block is exactly as large as the characters, with no room for a terminating null, so the
copy is only null-terminated when the text is empty; pass the length along or terminate it
yourself.

**Returns** the copy, or `NULL` when the allocation fails.

**Example**

```freebasic
dim bs as BSTRING = "abc"
dim p as wstring ptr = bs.wchar()
CoTaskMemFree( p )
```

Microsoft Learn: [CoTaskMemAlloc](https://learn.microsoft.com/en-us/windows/win32/api/combaseapi/nf-combaseapi-cotaskmemalloc)

### Let

```freebasic
operator let( byval pwsz as const wstring ptr )
```

Frees the current text and stores a copy of `pwsz`. A narrow literal, `string` or `ustring`
assigned this way is read as UTF-8: after `bs = "año"` the length is 3, where
`dim bs as BSTRING = "año"` reads the bytes as ANSI.

Assigning one `BSTRING` variable to another (`b2 = b1`) does not come here: it copies the
`m_bstr` handle itself, so both variables free the same `BSTR` and the old text of `b2` leaks.
Write `b2 = *b1` to copy the text.

**Example**

```freebasic
dim b1 as BSTRING = "first"
dim b2 as BSTRING = "second"
b2 = *b1   ' b2 now holds its own copy of "first"
```

### Cast

```freebasic
operator cast() byref as const wstring
operator cast() as any ptr
```

The first form gives the text as a wide string, which is how a `BSTRING` turns into a `ustring`
or a `wstring`. The second gives the `BSTR` handle, which is how a `BSTRING` is passed to a
parameter of type `BSTR`. Both read `m_bstr` directly; an empty `BSTRING` converts to an empty
`ustring` and passes a `NULL` handle.

**Example**

```freebasic
dim bs as BSTRING = "Hello"
dim u as ustring = bs
print u; " "; SysStringLen( bs )   ' Hello 5
```

### Operator [] (character index)

```freebasic
operator []( byval nIndex as UINT ) byref as ushort
```

Returns a reference to the UTF-16 code unit at the zero-based position `nIndex`, so it can be
read or changed. The index is not checked.

**Returns** the code unit at `nIndex`.

**Example**

```freebasic
dim bs as BSTRING = "Hello"
bs[0] = asc( "J" )
print bs[1]   ' 101, the code of "e"
```

### Operator @ (address)

```freebasic
operator @() as BSTR ptr
```

Frees the current text, stores a new empty `BSTR` and returns the address of `m_bstr`, so that a
function with an output `BSTR` parameter writes its result into the `BSTRING`. A function that
overwrites the parameter without freeing it leaves that empty string behind.

Applying `@` to a `BSTRING` currently stops the build with an internal compiler error. Until it
builds, call [Clear](#clear) and pass `@bs.m_bstr`, which does the same without the empty
string.

**Returns** the address of `m_bstr`.

**Example**

```freebasic
dim bs as BSTRING = "old"
bs.Clear()
VarBstrFromI4( 7, LOCALE_USER_DEFAULT, 0, @bs.m_bstr )   ' the form that builds today
```

## Related functions

| Function | Does |
| --- | --- |
| [Len](#len) | Returns the length in characters. |
| [Operator * (handle)](#operator--handle) | Returns the `BSTR` handle. |
| [BstrMsg](#bstrmsg) | Shows the text in a message box. |

### Len

```freebasic
operator len( byref bs as BSTRING ) as UINT
```

Returns the number of UTF-16 code units in the `BSTR`, read from its length prefix, or 0 for an
empty `BSTRING`.

**Returns** the length.

**Example**

```freebasic
dim bs as BSTRING = "Hello"
print len( bs )   ' 5
```

Microsoft Learn: [SysStringLen](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-sysstringlen)

### Operator * (handle)

```freebasic
operator *( byref bs as BSTRING ) as wstring ptr
```

Returns the `BSTR` handle, `m_bstr`, typed as a `wstring ptr`. `**bs` is the text. Use it to
pass the string where a `BSTR` is wanted and to copy the text into another `BSTRING`
(`b2 = *b1`). The handle still belongs to the `BSTRING`: do not free it.

**Returns** `m_bstr`.

**Example**

```freebasic
dim bs as BSTRING = "Hello"
print SysStringByteLen( *bs )   ' 10
```

### BstrMsg

```freebasic
function BstrMsg overload( byref bs as BSTRING, byval pwszCaption as const wstring ptr = NULL, byval uType as DWORD = 0 ) as long
function BstrMsg overload( byval hWin as HWND, byref bs as BSTRING, byval pwszCaption as const wstring ptr = NULL, byval uType as DWORD = 0 ) as long
```

Shows the text of `bs` in a message box, application-modal, owned by `hWin` or, in the first
form, by the active window of the calling thread. `uType` takes the usual `MB_*` button and icon
flags; `MB_APPLMODAL` is always added.

| Parameter | Meaning |
| --- | --- |
| `hWin` | The owner window, or `NULL`. |
| `bs` | The text to show. |
| `pwszCaption` | The title, or `NULL` for the default ("Error"). |
| `uType` | `MB_*` flags. |

**Returns** the button the user pressed (`IDOK`, `IDYES` …), or 0 on failure.

**Example**

```freebasic
dim bs as BSTRING = "Saved."
BstrMsg( hwnd, bs, "Notice", MB_ICONINFORMATION )
```

Microsoft Learn: [MessageBoxW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-messageboxw)

## See also

- [sys/win/com](SysWin-Com)
- [DVARIANT](DVARIANT), which converts to and from `BSTRING`
- [DSafeArray](DSafeArray) for arrays of `BSTR`
- [COM procedures](SysWin-Com-Procedures)
- [Strings](SysWin-Strings) for code pages and UTF-8 in `sys/win`
