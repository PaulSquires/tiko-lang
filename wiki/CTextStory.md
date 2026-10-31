[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/richedit](SysWin-RichEdit) › **CTextStory**

# CTextStory

Reads and replaces the text of a rich edit story and gives ranges over it.

`CTextStory` wraps the Text Object Model's `ITextStory` interface. A **story** is one
continuous text of a document: the main text, or in a word processor footnotes, headers and the
like. A plain rich edit control has a single story, its main text, so a story object is mostly a
way to get or set the whole text, plain or RTF, in one call, and to make
[ranges](CTextRange2) over it.

You get a story from [CRichEditCtx](CRichEditCtx-Document): `MainStory()` or `GetMainStory()`
for the main text, `GetActiveStory()` for the story with the focus, `GetStory( Index )` for
another one. `GetNewStory()` returns `NULL` in a rich edit control.

**Ownership.** The constructor takes the `ITextStory` pointer as it is, without adding a
reference (pass `true` as the second argument to add one), and the destructor releases it, so
`dim story as CTextStory = pRichEdit.MainStory()` takes over the pointer. The pointer is in the
public field `m_pTextStory`. Do not copy one `CTextStory` into another: both copies would
release the same pointer. Pass it `byref`.

**Results.** Each `GetX()` returns the value and each `SetX( Value )` returns the `HRESULT`;
both store the `HRESULT`, which `GetLastResult()` returns, and `GetErrorInfo()` turns it into
text. These come from the base class `CTextObjectBase` (see [Text Object Model](SysWin-RichEdit-TOM)).
No member checks for a `NULL` pointer.

The examples assume `hCtrl` is a rich edit control made by [CRichEditCtx](CRichEditCtx).

## Importing

```freebasic
#import "sys/win"
#import "sys/win/richedit"
using win, richedit
```

## Example

A rich edit control filled from an RTF string through its main story; the button counts the
characters of the story.

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/richedit"
using win, gui, richedit

const IDC_RICHEDIT = 101
const IDC_COUNT = 102

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "StoryDemo"
    dim hWin as HWND = pWindow.Create( NULL, "CTextStory", @WndProc )
    SetWindowClientSizeForDpi( hWin, 500, 260 )
    CenterWindow( hWin )
    dim pRichEdit as CRichEditCtx = CRichEditCtx( @pWindow, IDC_RICHEDIT, "", 10, 10, 480, 200 )
    pWindow.AddControl( "Button", hWin, IDC_COUNT, "&Count", 400, 220, 90, 28 )
    scope
        dim story as CTextStory = pRichEdit.MainStory()
        story.SetText( tomConvertRTF, "{\rtf1 A story with \b bold\b0  and \i italic\i0  text.\par Second paragraph.}" )
    end scope
    pRichEdit.SetModify( 0 )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_COMMAND
            if CBCTL( wParam, lParam ) = IDC_COUNT andalso CBCTLMSG( wParam, lParam ) = BN_CLICKED then
                dim story as CTextStory = CRichEditCtxPtr( hwnd, IDC_RICHEDIT )->MainStory()
                SetWindowText( hwnd, "characters: " & len( story.GetText( tomUseCRLF ) ) )
            end if
            return 0
        case WM_DESTROY
            PostQuitMessage( 0 )
            return 0
    end select
    return DefWindowProcW( hwnd, uMsg, wParam, lParam )
end function

end main()
```

## Members

| Member | Does |
| --- | --- |
| [Constructor](#constructor) | Makes an empty object or wraps an `ITextStory` pointer. |
| [Destructor](#destructor) | Releases the pointer. |
| [Let, Cast](#let-cast) | Takes over a pointer; reads the pointer back. |
| [TextStoryPtr](#textstoryptr) | Returns the `ITextStory` pointer. |
| [Attach](#attach) | Replaces the pointer the object holds. |
| [Detach](#detach) | Gives up the pointer without releasing it. |
| [GetActive, SetActive](#getactive-setactive) | Whether the story is shown and takes input. |
| [GetDisplay](#getdisplay) | A display for the story (not in a rich edit control). |
| [GetIndex](#getindex) | The story's index in the document. |
| [GetType, SetType](#gettype-settype) | The kind of story. |
| [GetProperty, SetProperty](#getproperty-setproperty) | A story property by id. |
| [GetRange](#getrange) | A range of the story's text. |
| [GetText, SetText](#gettext-settext) | The whole text of the story, plain or RTF. |
| [SetFormattedText](#setformattedtext) | Replaces the story with formatted text from a range. |

## Reference

### Constructor

```freebasic
constructor
constructor( byval pTextStory as ITextStory ptr, byval fAddRef as boolean = false )
```

The first form makes an empty object, to be filled later with [Let](#let-cast) or
[Attach](#attach). The second wraps an `ITextStory` pointer: with `fAddRef` `false` (the
default) the object takes over the reference you hand it, which is right for the result of
`MainStory` or `GetStory`; with `true` it adds a reference of its own and you keep yours.

A `NULL` pointer leaves the object empty with `GetLastResult()` returning `E_INVALIDARG`. Every
member calls through the pointer, so do not use an empty object.

| Parameter | Meaning |
| --- | --- |
| `pTextStory` | The story interface. |
| `fAddRef` | `true` to add a reference; `false` to take over the caller's. |

**Example**

```freebasic
dim story as CTextStory = CRichEditCtxPtr( hCtrl )->MainStory()
if story.TextStoryPtr() then print "type:"; story.GetType()
```

### Destructor

```freebasic
destructor
```

Releases the `ITextStory` pointer, if there is one, when the variable goes out of scope.

**Example**

```freebasic
scope
    dim story as CTextStory = CRichEditCtxPtr( hCtrl )->MainStory()
    story.SetText( 0, "Fresh text" )
end scope   ' released here
```

### Let, Cast

```freebasic
operator let( byval pTextStory as ITextStory ptr )
operator cast() as ITextStory ptr
```

`Let` releases the pointer the object holds and takes over the one assigned, without adding a
reference. Assigning `NULL` is refused: the object keeps its pointer and `GetLastResult()` is
`E_INVALIDARG`. `Cast` returns the pointer, so the object can be passed where an
`ITextStory ptr` is wanted; the reference stays with the object.

**Example**

```freebasic
dim story as CTextStory
story = CRichEditCtxPtr( hCtrl )->GetActiveStory()
dim pStory as ITextStory ptr = story
```

### TextStoryPtr

```freebasic
function TextStoryPtr() as ITextStory ptr
```

Returns the `ITextStory` pointer the object holds, or `NULL`, without adding a reference.

**Example**

```freebasic
dim story as CTextStory = CRichEditCtxPtr( hCtrl )->MainStory()
if story.TextStoryPtr() = NULL then print story.GetErrorInfo()
```

### Attach

```freebasic
function Attach( byval pTextStory as ITextStory ptr, byval fAddRef as boolean = false ) as HRESULT
```

Releases the pointer the object holds, if any, and stores `pTextStory`, adding a reference when
`fAddRef` is `true`. A `NULL` pointer is refused with `E_INVALIDARG`.

**Returns** `E_INVALIDARG` for `NULL`. Otherwise not an `HRESULT`: when the object held a
pointer, the reference count that pointer was left with after its release (also stored as the
last result); when it was empty, the last result as it was.

**Example**

```freebasic
dim story as CTextStory
story.Attach( CRichEditCtxPtr( hCtrl )->MainStory() )
print "index:"; story.GetIndex()
```

### Detach

```freebasic
function Detach() as ITextStory ptr
```

Returns the pointer and empties the object without releasing it; you release it yourself.

**Returns** the pointer, or `NULL`.

**Example**

```freebasic
dim story as CTextStory = CRichEditCtxPtr( hCtrl )->MainStory()
dim pStory as ITextStory ptr = story.Detach()
pStory->lpVtbl->Release( pStory )
```

### GetActive, SetActive

```freebasic
function GetActive() as long
function SetActive( byval Value as long ) as HRESULT
```

Whether the story is shown and takes keyboard and mouse input: `tomStoryInactive` (0),
`tomStoryActiveDisplay` (1, shown), `tomStoryActiveUI` (2, takes input) or
`tomStoryActiveDisplayUI` (3, both). The main story of a rich edit control is always
`tomStoryActiveDisplayUI`; setting another state leaves it so and returns `S_FALSE`.

**Returns** `GetActive`: the state. `SetActive`: the `HRESULT`.

**Example**

```freebasic
dim story as CTextStory = CRichEditCtxPtr( hCtrl )->MainStory()
if story.GetActive() = tomStoryActiveDisplayUI then print "shown and editable"
```

Microsoft Learn: [ITextStory::GetActive](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextstory-getactive), [ITextStory::SetActive](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextstory-setactive)

### GetDisplay

```freebasic
function GetDisplay() as IUnknown ptr
```

Asks for a new display for the story. A rich edit control does not implement it.

**Returns** `NULL`, with `GetLastResult()` `E_NOTIMPL`. Release a pointer you do get.

**Example**

```freebasic
dim story as CTextStory = CRichEditCtxPtr( hCtrl )->MainStory()
dim pDisplay as IUnknown ptr = story.GetDisplay()
if pDisplay then pDisplay->lpVtbl->Release( pDisplay )
```

Microsoft Learn: [ITextStory::GetDisplay](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextstory-getdisplay)

### GetIndex

```freebasic
function GetIndex() as long
```

Returns the story's index among the stories of the document. The main story of a rich edit
control is 0.

**Returns** the index.

**Example**

```freebasic
dim story as CTextStory = CRichEditCtxPtr( hCtrl )->GetActiveStory()
print "active story:"; story.GetIndex()
```

Microsoft Learn: [ITextStory::GetIndex](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextstory-getindex)

### GetType, SetType

```freebasic
function GetType() as long
function SetType( byval Value as long ) as HRESULT
```

The kind of story: `tomMainTextStory` (1) for the main text; the others (`tomFootnotesStory`,
`tomCommentsStory`, `tomPrimaryHeaderStory` …) are for documents with more than one story.
The control accepts a new type from `SetType` and reports it from then on.

**Returns** `GetType`: the type. `SetType`: the `HRESULT`.

**Example**

```freebasic
dim story as CTextStory = CRichEditCtxPtr( hCtrl )->MainStory()
if story.GetType() = tomMainTextStory then print "the main text"
```

Microsoft Learn: [ITextStory::GetType](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextstory-gettype), [ITextStory::SetType](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextstory-settype)

### GetProperty, SetProperty

```freebasic
function GetProperty( byval nType as long ) as long
function SetProperty( byval nType as long, byval VaLue as long ) as HRESULT
```

Reads or sets a story property by its id. A rich edit control does not implement either: both
fail with `E_NOTIMPL`, and `GetProperty` returns 0.

| Parameter | Meaning |
| --- | --- |
| `nType` | The property id. |
| `VaLue` | The new value. |

**Returns** `GetProperty`: the value. `SetProperty`: the `HRESULT`.

**Example**

```freebasic
dim story as CTextStory = CRichEditCtxPtr( hCtrl )->MainStory()
dim v as long = story.GetProperty( 0 )
if story.GetLastResult() = E_NOTIMPL then print "no story properties"
```

Microsoft Learn: [ITextStory::GetProperty](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextstory-getproperty), [ITextStory::SetProperty](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextstory-setproperty)

### GetRange

```freebasic
function GetRange( byval cpActive as long, byval cpAnchor as long ) as ITextRange2 ptr
```

Returns a range of the story's text between two character positions, counted from 0. The
caller owns it: wrap it in a [CTextRange2](CTextRange2).

| Parameter | Meaning |
| --- | --- |
| `cpActive` | The active end of the range. |
| `cpAnchor` | The other end. |

**Returns** the range, or `NULL` on failure.

**Example**

```freebasic
dim story as CTextStory = CRichEditCtxPtr( hCtrl )->MainStory()
dim rng as CTextRange2 = story.GetRange( 0, 5 )
print rng.GetText()                                  ' the first five characters
```

Microsoft Learn: [ITextStory::GetRange](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextstory-getrange)

### GetText, SetText

```freebasic
function GetText( byval Flags as long ) as ustring
function SetText( byval Flags as long, byref wszText as wstring ) as HRESULT
```

Reads or replaces the whole text of the story. Paragraphs end in a carriage return (13) alone.

With `Flags` 0, `GetText` returns the text with its final paragraph mark: `"One"`, `chr( 13 )`,
`"Two"` comes back as eight characters, `One`, 13, `Two`, 13. With `tomUseCRLF` each paragraph
mark becomes a carriage return and line feed and the final one is left off: the same text comes
back as `One`, 13, 10, `Two`. Other `tom*` flags, such as `tomNoHidden` or
`tomIncludeNumbering`, can be added.

`SetText` with `Flags` 0 puts in plain text; with `tomConvertRTF` it reads `wszText` as RTF and
applies the formatting.

| Parameter | Meaning |
| --- | --- |
| `Flags` | Conversion flags, 0 for none. |
| `wszText` | The new text. |

**Returns** `GetText`: the text. `SetText`: the `HRESULT`.

**Example**

```freebasic
dim story as CTextStory = CRichEditCtxPtr( hCtrl )->MainStory()
story.SetText( tomConvertRTF, "{\rtf1 \b Bold\b0  plain}" )
print story.GetText( tomUseCRLF )                    ' Bold plain
```

Microsoft Learn: [ITextStory::GetText](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextstory-gettext), [ITextStory::SetText](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextstory-settext)

### SetFormattedText

```freebasic
function SetFormattedText( byval pUnk as IUnknown ptr ) as HRESULT
```

Replaces the whole story with formatted text: the text and formatting of a range, from this
document or another one.

| Parameter | Meaning |
| --- | --- |
| `pUnk` | The formatted text: an `ITextRange` or `ITextRange2`, passed as `IUnknown ptr`. |

**Returns** the `HRESULT`.

**Example**

```freebasic
dim story as CTextStory = CRichEditCtxPtr( hCtrl )->MainStory()
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
story.SetFormattedText( cast( IUnknown ptr, rng.m_pTextRange2 ) )   ' the story is now those five characters
```

Microsoft Learn: [ITextStory::SetFormattedText](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextstory-setformattedtext)

## See also

- [sys/win/richedit](SysWin-RichEdit)
- [CRichEditCtx: document](CRichEditCtx-Document) for `MainStory`, `GetStory` and the story count
- [CTextRange2](CTextRange2) for the ranges `GetRange` returns
- [Text Object Model](SysWin-RichEdit-TOM) for the `tom*` constants and the base class
