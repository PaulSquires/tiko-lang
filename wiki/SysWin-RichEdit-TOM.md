[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/richedit](SysWin-RichEdit) › **Text Object Model**

# Text Object Model
Lists the Text Object Model interfaces and constants, and the base of the TOM classes.

<!-- scope: CTextObjectBase -->

The **Text Object Model** (TOM) is the set of COM interfaces through which a rich edit control
exposes its document. The model is a small tree:

- the **document** (`ITextDocument2`) holds one or more **stories**, separate texts
  (`ITextStory`); a plain rich edit control has one, its main text;
- a **range** (`ITextRange2`) is a span of a story between two character positions, counted
  from 0; the **selection** (`ITextSelection2`) is the range the user sees highlighted;
- a range has a **character format** (`ITextFont2`) and a **paragraph format**
  (`ITextPara2`), and inside a table a **row** (`ITextRow`).

`sys/win/richedit` wraps each of these in a class, all built on the base class
[CTextObjectBase](#ctextobjectbase) described below:

| Class | Wraps | Get one from |
| --- | --- | --- |
| [CRichEditCtx](CRichEditCtx) | `ITextDocument2`, which it keeps for the life of the control | the control itself: see [CRichEditCtx](CRichEditCtx) |
| [CTextRange2](CTextRange2) | `ITextRange2` | `CRichEditCtx.Range`, `RangeFromPoint`; `CTextStory.GetRange`; `GetDuplicate` and `GetFormattedText` of a range or the selection |
| [CTextSelection2](CTextSelection2) | `ITextSelection2` | `CRichEditCtx.Selection2` or `GetSelection2` |
| [CTextFont2](CTextFont2) | `ITextFont2` | `GetFont` of a range or the selection; `CRichEditCtx.GetDocumentFont`; `CTextFont2.GetDuplicate` |
| [CTextPara2](CTextPara2) | `ITextPara2` | `GetPara` of a range or the selection; `CRichEditCtx.GetDocumentPara`; `CTextPara2.GetDuplicate` |
| [CTextRow](CTextRow) | `ITextRow` | `GetRow` of a range or the selection |
| [CTextStory](CTextStory) | `ITextStory` | `CRichEditCtx.MainStory`, `GetActiveStory`, `GetStory` |

**Ownership.** Every member that returns an interface pointer hands the caller a reference.
Each class's constructor takes such a pointer over **without** adding a reference, and its
destructor releases it, so the usual line is `dim rng as CTextRange2 = pRichEdit.Range( 0, 5 )`.
Pass `true` as the constructor's second argument to add a reference instead, when you keep the
pointer yourself. Release any pointer you do not wrap. No class has a copy constructor: do not
copy one object into another (both would release the same pointer); pass them `byref`.

**Results.** Members return the value an interface method reports, or its `HRESULT` for a
setter. Either way the `HRESULT` is kept, and [GetLastResult](#getlastresult) returns it.

**The raw interfaces.** Each class has its pointer in a public field (`m_pTextRange2`,
`m_pTextFont2` …) for the methods it does not wrap. The interfaces below are declared as a
`TYPE` holding `lpVtbl`, a pointer to a table of function pointers: call
`p->lpVtbl->Method( p, ... )`. Interfaces with no class of their own (`ITextRange`,
`ITextStrings`, `ITextStoryRanges2` …) are reached the same way.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/com"
#import "sys/win/richedit"
using win, com, richedit
```

## Example

A console program that walks the model from the control to a story, a range and its formats,
reaches an interface the classes do not wrap, and turns a failed call's result into text. The
rich edit control lives in a window that is never shown.

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/com"
#import "sys/win/richedit"
using win, gui, com, richedit

function main() as long
    ' A rich edit control in a window that is never shown.
    dim pWindow as CWindow = "TomDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Text Object Model" )
    dim pRichEdit as CRichEditCtx = CRichEditCtx( @pWindow, 101, "", 0, 0, 400, 200 )
    pRichEdit.SetText( "Hello world" & chr( 13 ) & "Second paragraph" )

    dim story as CTextStory = pRichEdit.MainStory()        ' the document's main text
    dim rng as CTextRange2 = story.GetRange( 0, 5 )        ' its first five characters
    dim font as CTextFont2 = rng.GetFont()                 ' their character format
    dim para as CTextPara2 = rng.GetPara()                 ' the format of their paragraph
    font.SetBold( tomTrue )
    para.SetSpaceAfter( 6 )
    print rng.GetText(); ": bold"; font.GetBold(); ", space after"; para.GetSpaceAfter()

    ' An interface the classes do not wrap, through QueryInterface and an IID_ constant.
    dim iid as IID = GetGuid( IID_ITextRange )
    dim pRange as ITextRange ptr
    if rng.m_pTextRange2->lpVtbl->QueryInterface( rng.m_pTextRange2, @iid, @pRange ) = S_OK then
        dim nEnd as long
        pRange->lpVtbl->GetEnd( pRange, @nEnd )
        print "ITextRange end:"; nEnd
        pRange->lpVtbl->Release( pRange )
    end if

    ' A call that fails, and its result code as text.
    dim pDisplay as IUnknown ptr = story.GetDisplay()
    if pDisplay = NULL then print story.GetErrorInfo()
    return 0
end function

end main()
```

It prints:

```text
Hello: bold-1, space after 6
ITextRange end: 5
Error &h80004001
Not implemented
```

## Types

### Interfaces

Each interface `ITextX` comes as four names: `ITextX`, the type to declare pointers with;
`ITextX_`, the object layout (one field, `lpVtbl`); `ITextXVTbl`, the table of methods; and
`LPITEXTX`, an `ITextX ptr`.

| Interface | Types | Is | Microsoft Learn |
| --- | --- | --- | --- |
| `ITextDocument` | `ITextDocument_`, `ITextDocumentVTbl`, `LPITEXTDOCUMENT` | The original document interface: open, save, undo, ranges, the selection. | [ITextDocument](https://learn.microsoft.com/en-us/windows/win32/api/tom/nn-tom-itextdocument) |
| `ITextDocument2` | `ITextDocument2_`, `ITextDocument2VTbl`, `LPITEXTDOCUMENT2` | The current document interface, the one [CRichEditCtx](CRichEditCtx) holds. | [ITextDocument2](https://learn.microsoft.com/en-us/windows/win32/api/tom/nn-tom-itextdocument2) |
| `ITextDocument2Old` | `ITextDocument2Old_`, `ITextDocument2OldVTbl`, `LPITextDocument2Old` | An earlier version of the second document interface, kept for old rich edit versions. | [tom.h](https://learn.microsoft.com/en-us/windows/win32/api/tom/) |
| `ITextFont` | `ITextFont_`, `ITextFontVTbl`, `LPITEXTFONT` | The original character-format interface. | [ITextFont](https://learn.microsoft.com/en-us/windows/win32/api/tom/nn-tom-itextfont) |
| `ITextFont2` | `ITextFont2_`, `ITextFont2VTbl`, `LPITEXTFONT2` | Character format, wrapped by [CTextFont2](CTextFont2). | [ITextFont2](https://learn.microsoft.com/en-us/windows/win32/api/tom/nn-tom-itextfont2) |
| `ITextPara` | `ITextPara_`, `ITextParaVTbl`, `LPITEXTPARA` | The original paragraph-format interface. | [ITextPara](https://learn.microsoft.com/en-us/windows/win32/api/tom/nn-tom-itextpara) |
| `ITextPara2` | `ITextPara2_`, `ITextPara2VTbl`, `LPITEXTPARA2` | Paragraph format, wrapped by [CTextPara2](CTextPara2). | [ITextPara2](https://learn.microsoft.com/en-us/windows/win32/api/tom/nn-tom-itextpara2) |
| `ITextRange` | `ITextRange_`, `ITextRangeVTbl`, `LPITEXTRANGE` | The original range interface. | [ITextRange](https://learn.microsoft.com/en-us/windows/win32/api/tom/nn-tom-itextrange) |
| `ITextRange2` | `ITextRange2_`, `ITextRange2VTbl`, `LPITEXTRANGE2` | A span of text, wrapped by [CTextRange2](CTextRange2). | [ITextRange2](https://learn.microsoft.com/en-us/windows/win32/api/tom/nn-tom-itextrange2) |
| `ITextSelection` | `ITextSelection_`, `ITextSelectionVTbl`, `LPITEXTSELECTION` | The original selection interface. | [ITextSelection](https://learn.microsoft.com/en-us/windows/win32/api/tom/nn-tom-itextselection) |
| `ITextSelection2` | `ITextSelection2_`, `ITextSelection2VTbl`, `LPITEXTSELECTION2` | The selection, wrapped by [CTextSelection2](CTextSelection2). | [ITextSelection2](https://learn.microsoft.com/en-us/windows/win32/api/tom/nn-tom-itextselection2) |
| `ITextStory` | `ITextStory_`, `ITextStoryVTbl`, `LPITEXTSTORY` | One story of the document, wrapped by [CTextStory](CTextStory). | [ITextStory](https://learn.microsoft.com/en-us/windows/win32/api/tom/nn-tom-itextstory) |
| `ITextStoryRanges` | (forward name only) | The collection of the document's stories, from `CRichEditCtx.GetStoryRanges`. Only the pointer type is declared: no method table, so use `ITextStoryRanges2`. | [ITextStoryRanges](https://learn.microsoft.com/en-us/windows/win32/api/tom/nn-tom-itextstoryranges) |
| `ITextStoryRanges2` | `ITextStoryRanges2_`, `ITextStoryRanges2VTbl`, `LPITEXTSTORYRANGES2` | The same collection, giving `ITextRange2` objects, from `CRichEditCtx.GetStoryRanges2`. | [ITextStoryRanges2](https://learn.microsoft.com/en-us/windows/win32/api/tom/nn-tom-itextstoryranges2) |
| `ITextStrings` | `ITextStrings_`, `ITextStringsVTbl`, `LPITEXTSTRINGS` | A stack of formatted strings for building text, from `CRichEditCtx.GetStrings`. | [ITextStrings](https://learn.microsoft.com/en-us/windows/win32/api/tom/nn-tom-itextstrings) |
| `ITextRow` | `ITextRow_`, `ITextRowVTbl`, `LPITEXTROW` | A table row, wrapped by [CTextRow](CTextRow). | [ITextRow](https://learn.microsoft.com/en-us/windows/win32/api/tom/nn-tom-itextrow) |
| `ITextDisplays` | `ITextDisplays_`, `ITextDisplaysVTbl`, `LPITEXTDISPLAYS` | The document's displays, from `CRichEditCtx.GetDisplays`; it has only the `IDispatch` methods. | [ITextDisplays](https://learn.microsoft.com/en-us/windows/win32/api/tom/nn-tom-itextdisplays) |
| `ITextMsgFilter` | `ITextMsgFilter_`, `ITextMsgFilterVTbl`, `LPITEXTMSGFILTER` | A message filter attached to a document; undocumented. | [tom.h](https://learn.microsoft.com/en-us/windows/win32/api/tom/) |

In every table but `ITextMsgFilterVTbl` and `ITextStoryVTbl`, which derive from `IUnknown`, the
first seven slots are the `IDispatch` methods. The `GetIDsOfNames` slot is declared with the
parameters of `GetTypeInfo`; to call it, go through an `IDispatch ptr`. The slots of
`ITextDisplaysVTbl` are declared with `this` as an `ITextRow ptr`.

### Enumerations

| Enum | Holds | Microsoft Learn |
| --- | --- | --- |
| `tomConstants` | Every `tom*` value the classes take and return: `tomTrue` (-1), `tomFalse` (0), `tomUndefined`, `tomToggle`, `tomDefault`; units (`tomCharacter`, `tomWord`, `tomParagraph` …); alignments, list types, line-spacing rules, underlines, story types and states, text flags (`tomUseCRLF`, `tomConvertRTF` …), table flags and math constants. | [tomConstants](https://learn.microsoft.com/en-us/windows/win32/api/tom/ne-tom-tomconstants) |
| `tomOBJECTTYPE` | The kinds of inline object: `tomSimpleText`, `tomRuby`, `tomEq`, `tomFraction`, `tomMatrix`, `tomRadical` … (the Windows header calls it `OBJECTTYPE`). | [OBJECTTYPE](https://learn.microsoft.com/en-us/windows/win32/api/tom/ne-tom-objecttype) |
| `MANCODE` | Math alphanumeric styles: `MBOLD`, `MITAL`, `MGREEK` and the alphabets `MROMN`, `MSCRP`, `MFRAK`, `MOPEN`, `MSANS`, `MMONO` …. | [MANCODE](https://learn.microsoft.com/en-us/windows/win32/api/tom/ne-tom-mancode) |

The enums are not scoped: after `using richedit` their members are written bare, `tomTrue`,
`tomCharacter`.

### Interface identifiers

`IID_ITextDocument`, `IID_ITextDocument2`, `IID_ITextDocument2Old`, `IID_ITextFont`,
`IID_ITextFont2`, `IID_ITextPara`, `IID_ITextPara2`, `IID_ITextRange`, `IID_ITextRange2`,
`IID_ITextSelection`, `IID_ITextSelection2`, `IID_ITextStory`, `IID_ITextStoryRanges`,
`IID_ITextStoryRanges2`, `IID_ITextStrings`, `IID_ITextRow`, `IID_ITextDisplays` and
`IID_ITextMsgFilter` are string constants holding each interface's identifier in its
`"{...}"` text form. Turn one into an `IID` with `GetGuid` from `sys/win/com` before passing it
to `QueryInterface`, as the example does. `IID_ITextDisplays` holds the same text as
`IID_ITextRange2`.

## CTextObjectBase

`CTextObjectBase` is the base class of [CRichEditCtx](CRichEditCtx) and of every TOM class on
this page. It holds one field, `m_Result`, the `HRESULT` of the last call, which the derived
classes set after each interface method or message.

| Member | Does |
| --- | --- |
| [Constructor](#constructor) | Starts with a last result of 0. |
| [Destructor](#destructor) | Does nothing. |
| [GetLastResult](#getlastresult) | Returns the result of the last call. |
| [SetResult](#setresult) | Stores a result code. |
| [GetErrorInfo](#geterrorinfo) | Describes a result code in words. |

### Constructor

```freebasic
constructor
```

Makes the object with `m_Result` 0 (`S_OK`). A derived class's constructor runs it first.

**Example**

```freebasic
dim b as CTextObjectBase
print b.GetLastResult()       ' 0
```

### Destructor

```freebasic
destructor
```

Does nothing; the derived classes release their own pointers.

**Example**

```freebasic
scope
    dim b as CTextObjectBase
    b.SetResult( E_FAIL )
end scope
```

### GetLastResult

```freebasic
function GetLastResult() as long
```

Returns the `HRESULT` the last call left: `S_OK` (0), `S_FALSE` (1) for a call that did
nothing, or an error such as `E_NOTIMPL` (`&h80004001`) or `E_INVALIDARG` (`&h80070057`). A
member that returns a value, not the `HRESULT`, says how the call went only through this.

**Returns** the result code.

**Example**

```freebasic
dim story as CTextStory = CRichEditCtxPtr( hCtrl )->MainStory()
dim pDisplay as IUnknown ptr = story.GetDisplay()
print hex( story.GetLastResult() )                   ' 80004001
```

### SetResult

```freebasic
function SetResult( byval Result as long ) as long
```

Stores `Result` as the last result, for code that extends one of the classes.

| Parameter | Meaning |
| --- | --- |
| `Result` | The result code to store. |

**Returns** `Result`.

**Example**

```freebasic
dim b as CTextObjectBase
b.SetResult( E_FAIL )
print hex( b.GetLastResult() )                       ' 80004005
```

### GetErrorInfo

```freebasic
function GetErrorInfo( byval dwError as long = -1 ) as ustring
```

Returns the Windows description of a result code: `"Error &h"`, the code in hexadecimal and a
carriage return and line feed, then the system's message, which itself ends in a carriage
return and line feed. For 0 the text is the message alone, `"The operation completed
successfully."`. A code Windows has no message for gives only the first line.

| Parameter | Meaning |
| --- | --- |
| `dwError` | The code to describe; -1, the default, means the last result. |

**Returns** the description.

**Example**

```freebasic
dim b as CTextObjectBase
print b.GetErrorInfo( E_NOTIMPL )                    ' Error &h80004001, then Not implemented
```

Microsoft Learn: [FormatMessageW](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-formatmessagew)

## See also

- [sys/win/richedit](SysWin-RichEdit)
- [CRichEditCtx: document](CRichEditCtx-Document) for the members that return TOM objects
- [CTextRange2](CTextRange2), [CTextSelection2](CTextSelection2), [CTextFont2](CTextFont2),
  [CTextPara2](CTextPara2), [CTextRow](CTextRow) and [CTextStory](CTextStory)
- [CRichEditOleCallback](CRichEditOleCallback) for pasting pictures and objects
- [COM procedures](SysWin-Com-Procedures) for `GetGuid`
- Microsoft Learn: [Text Object Model](https://learn.microsoft.com/en-us/windows/win32/controls/text-object-model)
