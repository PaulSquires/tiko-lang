[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/richedit](SysWin-RichEdit) › **CTextPara2**

# CTextPara2
Reads and sets paragraph formatting in rich edit text: indents, spacing, tabs and lists.

<!-- scope: CTextPara2 -->

Reads and sets paragraph formatting in rich edit text: indents, spacing, tabs and lists.

`CTextPara2` wraps the Text Object Model's `ITextPara2` interface, the TOM's view of paragraph
formatting. A paragraph object belongs to a range, and its settings apply to **every paragraph
the range touches**, even partly: a range of one character formats the whole paragraph it is in.
You get one from:

| Source | Call | The paragraph object is |
| --- | --- | --- |
| A range of text | [CTextRange2](CTextRange2)`.GetPara()` | attached: every change applies to those paragraphs at once |
| The selection | [CTextSelection2](CTextSelection2)`.GetPara()` | attached to the selected paragraphs |
| The document default | [CRichEditCtx](CRichEditCtx-Document)`.GetDocumentPara()` | the document's default paragraph format |
| Another paragraph object | [GetDuplicate](#getduplicate) | a detached copy: changes go nowhere until applied |

**Ownership.** The constructor takes the `ITextPara2` pointer as it is, without adding a
reference (pass `true` as the second argument to add one), and the destructor releases it. So
`dim para as CTextPara2 = rng.GetPara()` takes over the pointer `GetPara` returned. The class has
no default constructor, no copy constructor and no assignment: declare it with its pointer, pass
it `byref`, and do not copy it (both copies would release the same pointer). The pointer is in
the public field `m_pTextPara2`, for calls into the interface the class does not wrap.

**Results.** Each `GetX()` returns the value and each `SetX( Value )` returns the `HRESULT`; both
store the `HRESULT`, which `GetLastResult()` returns, and `GetErrorInfo()` turns it into text.
These come from the base class `CTextObjectBase` (see [Text Object Model](SysWin-RichEdit-TOM)).
No member checks for a `NULL` pointer.

**Values.** On/off settings use `tomTrue` (-1) and `tomFalse` (0); `tomToggle` flips one when
setting. When the paragraphs of a range differ, a getter returns `tomUndefined` (-9999999).
Indents, spacing and tab positions are `single` values in **points**.

**Two setters call the wrong method.** [SetAlignment](#getalignment-setalignment) sets the
paragraph style and [SetListType](#getlisttype-setlisttype) sets the list tab; their entries
show how to reach the right methods through `m_pTextPara2`.

The examples assume `hCtrl` is a rich edit control made by [CRichEditCtx](CRichEditCtx) and
work on the paragraph that holds its first five characters.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/richedit"
using win, richedit
```

## Example

A rich edit control with a hanging-indented paragraph, double line spacing and a right-aligned,
dot-leader tab stop, all set through `CTextPara2`.

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/richedit"
using win, gui, richedit

const IDC_RICHEDIT = 101

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "ParaDemo"
    dim hWin as HWND = pWindow.Create( NULL, "CTextPara2", @WndProc )
    SetWindowClientSizeForDpi( hWin, 500, 260 )
    CenterWindow( hWin )
    dim pRichEdit as CRichEditCtx = CRichEditCtx( @pWindow, IDC_RICHEDIT, "", 10, 10, 480, 240 )
    pWindow.AnchorControl( IDC_RICHEDIT, ANCHOR_HEIGHT_WIDTH )
    pRichEdit.SetText( "A hanging indent: the first line starts at the margin and the lines " & _
                       "that follow are indented by half an inch, with double spacing." & chr( 13 ) & _
                       "Contents" & chr( 9 ) & "page 7" )
    scope
        dim rng as CTextRange2 = pRichEdit.Range( 0, 1 )       ' first paragraph
        dim para as CTextPara2 = rng.GetPara()
        para.SetIndents( -36, 36, 0 )                          ' first line -36 pt, others 36 pt
        para.SetLineSpacing( tomLineSpaceDouble, 0 )
        para.SetSpaceAfter( 12 )
    end scope
    scope
        dim n as long = len( pRichEdit.GetText() )
        dim rng as CTextRange2 = pRichEdit.Range( n, n )       ' last paragraph
        dim para as CTextPara2 = rng.GetPara()
        para.AddTab( 300, tomAlignRight, tomDots )
    end scope
    pRichEdit.SetModify( 0 )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
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
| [Constructor](#constructor) | Wraps an `ITextPara2` pointer. |
| [Destructor](#destructor) | Releases the pointer. |
| [GetDuplicate](#getduplicate) | Makes a detached copy of the formatting. |
| [SetDuplicate](#setduplicate) | Copies formatting from another paragraph object. |
| [CanChange](#canchange) | Tells whether the formatting can be changed. |
| [IsEqual](#isequal) | Compares the formatting with another paragraph object. |
| [Reset](#reset) | Resets the formatting to the defaults. |
| [GetStyle, SetStyle](#getstyle-setstyle) | The paragraph style. |
| [GetAlignment, SetAlignment](#getalignment-setalignment) | The alignment (the setter sets the style). |
| [GetHyphenation, SetHyphenation](#gethyphenation-sethyphenation) | Automatic hyphenation. |
| [GetFirstLineIndent](#getfirstlineindent) | The first-line indent. |
| [GetKeepTogether, SetKeepTogether](#getkeeptogether-setkeeptogether) | Whether a paragraph may break across pages. |
| [GetKeepWithNext, SetKeepWithNext](#getkeepwithnext-setkeepwithnext) | Whether a paragraph stays on the page of the next one. |
| [GetLeftIndent](#getleftindent) | The left indent. |
| [GetLineSpacing, GetLineSpacingRule](#getlinespacing-getlinespacingrule) | The line spacing and its rule. |
| [GetListAlignment, SetListAlignment](#getlistalignment-setlistalignment) | The alignment of bullets and numbers. |
| [GetListLevelIndex, SetListLevelIndex](#getlistlevelindex-setlistlevelindex) | The list level. |
| [GetListStart, SetListStart](#getliststart-setliststart) | The first number of a numbered list. |
| [GetListTab, SetListTab](#getlisttab-setlisttab) | The distance from the bullet to the text. |
| [GetListType, SetListType](#getlisttype-setlisttype) | The kind of list (the setter sets the list tab). |
| [GetNoLineNumber, SetNoLineNumber](#getnolinenumber-setnolinenumber) | Whether line numbering is suppressed. |
| [GetPageBreakBefore, SetPageBreakBefore](#getpagebreakbefore-setpagebreakbefore) | A page break before each paragraph. |
| [GetRightIndent, SetRightIndent](#getrightindent-setrightindent) | The right indent. |
| [SetIndents](#setindents) | Sets the first-line, left and right indents. |
| [SetLineSpacing](#setlinespacing) | Sets the line spacing and its rule. |
| [GetSpaceAfter, SetSpaceAfter](#getspaceafter-setspaceafter) | The space after a paragraph. |
| [GetSpaceBefore, SetSpaceBefore](#getspacebefore-setspacebefore) | The space before a paragraph. |
| [GetWidowControl, SetWidowControl](#getwidowcontrol-setwidowcontrol) | Widow and orphan control. |
| [GetTabCount](#gettabcount) | The number of tab stops. |
| [AddTab](#addtab) | Adds a tab stop. |
| [ClearAllTabs](#clearalltabs) | Removes every tab stop. |
| [DeleteTab](#deletetab) | Removes one tab stop. |
| [GetTab](#gettab) | Reads one tab stop. |
| [GetBorders](#getborders) | The borders collection (not implemented by the control). |
| [GetFontAlignment, SetFontAlignment](#getfontalignment-setfontalignment) | The vertical alignment of characters of different sizes. |
| [GetHangingPunctuation, SetHangingPunctuation](#gethangingpunctuation-sethangingpunctuation) | Punctuation hung past the right margin. |
| [GetSnapToGrid, SetSnapToGrid](#getsnaptogrid-setsnaptogrid) | Lines snapped to the document's grid. |
| [GetTrimPunctuationAtStart, SetTrimPunctuationAtStart](#gettrimpunctuationatstart-settrimpunctuationatstart) | Leading space trimmed from punctuation at a line start. |
| [GetEffects, SetEffects](#geteffects-seteffects) | The paragraph effect flags. |
| [GetProperty, SetProperty](#getproperty-setproperty) | An extra property by id. |

## Reference

### Constructor

```freebasic
constructor( byval pTextPara2 as ITextPara2 ptr, byval fAddRef as boolean = false )
```

Wraps an `ITextPara2` pointer. With `fAddRef` `false` (the default) the object takes over the
reference you hand it, which is right for the result of `GetPara`, `GetDuplicate` or
`GetDocumentPara`; with `true` it adds a reference of its own and you keep yours.

A `NULL` pointer leaves the object empty with `GetLastResult()` returning `E_INVALIDARG`
(`&h80070057`); every member calls through the pointer, so do not use an empty one.

| Parameter | Meaning |
| --- | --- |
| `pTextPara2` | The paragraph interface. |
| `fAddRef` | `true` to add a reference; `false` to take over the caller's. |

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
if para.GetLastResult() = S_OK then print "space after:"; para.GetSpaceAfter(); " pt"
```

### Destructor

```freebasic
destructor
```

Releases the `ITextPara2` pointer, if there is one. It runs when the variable goes out of scope.

**Example**

```freebasic
scope
    dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
    dim para as CTextPara2 = rng.GetPara()
    para.SetSpaceAfter( 6 )
end scope   ' para, then rng, released here
```

### GetDuplicate

```freebasic
function GetDuplicate() as ITextPara2 ptr
```

Returns a new paragraph object holding a copy of this one's formatting. The copy is attached to
no text: change it freely and apply it later. It calls the `ITextPara2` method
`GetDuplicate2`. The caller owns the returned pointer: wrap it in a `CTextPara2` or release it.

**Returns** the new paragraph object, or `NULL` on failure.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
dim copy as CTextPara2 = para.GetDuplicate()
print "copy: left indent"; copy.GetLeftIndent(); " pt"
```

Microsoft Learn: [ITextPara2::GetDuplicate2](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara2-getduplicate2)

### SetDuplicate

```freebasic
function SetDuplicate( byval pPara as ITextPara2 ptr ) as HRESULT
```

Copies the formatting of `pPara` into this object, by calling the `ITextPara2` method
`SetDuplicate2`. On the rich edit control of current Windows versions that method returns
`E_NOTIMPL` (`&h80004001`) and nothing changes. The `ITextPara` method `SetDuplicate`, reached
through `m_pTextPara2`, does apply the copy; values that are `tomUndefined` in `pPara` are left
as they are.

| Parameter | Meaning |
| --- | --- |
| `pPara` | The paragraph object to copy from. |

**Returns** the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
dim copy as CTextPara2 = para.GetDuplicate()
copy.SetSpaceBefore( 12 )
para.m_pTextPara2->lpVtbl->SetDuplicate( para.m_pTextPara2, copy.m_pTextPara2 )   ' applies it
```

Microsoft Learn: [ITextPara2::SetDuplicate2](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara2-setduplicate2), [ITextPara::SetDuplicate](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-setduplicate)

### CanChange

```freebasic
function CanChange( byval pPara as ITextPara2 ptr ) as long
```

Tells whether the paragraph formatting can be changed: it cannot when the text is protected or
the document is read-only. The `pPara` argument is not used; pass `NULL`.

**Returns** `tomTrue` if the formatting can be changed, otherwise `tomFalse`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
if para.CanChange( NULL ) = tomTrue then para.SetSpaceAfter( 6 )
```

Microsoft Learn: [ITextPara::CanChange](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-canchange)

### IsEqual

```freebasic
function IsEqual( byval pPara as ITextPara2 ptr ) as long
```

Compares this formatting with `pPara`, by calling the `ITextPara2` method `IsEqual2`. On the
rich edit control of current Windows versions that method returns `E_NOTIMPL` and the result
is `tomFalse` whatever the formatting. The `ITextPara` method `IsEqual`, through
`m_pTextPara2`, does compare: it returns `S_OK` with `tomTrue` when the two are the same and
`S_FALSE` (1) with `tomFalse` when they differ.

| Parameter | Meaning |
| --- | --- |
| `pPara` | The paragraph object to compare with. |

**Returns** `tomTrue` if equal, otherwise `tomFalse`. `GetLastResult()` holds the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
dim copy as CTextPara2 = para.GetDuplicate()
dim same as long
para.m_pTextPara2->lpVtbl->IsEqual( para.m_pTextPara2, copy.m_pTextPara2, @same )
```

Microsoft Learn: [ITextPara2::IsEqual2](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara2-isequal2)

### Reset

```freebasic
function Reset( byval Value as long = tomDefault ) as HRESULT
```

Resets the paragraph formatting. `tomDefault` (the default) gives the document's default
paragraph format. `tomUndefined`, which makes every attribute undefined, is only for a detached
copy from [GetDuplicate](#getduplicate); on attached formatting it returns `E_INVALIDARG`.

| Parameter | Meaning |
| --- | --- |
| `Value` | `tomDefault` or `tomUndefined`. |

**Returns** the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.Reset()
```

Microsoft Learn: [ITextPara::Reset](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-reset)

### GetStyle, SetStyle

```freebasic
function GetStyle() as long
function SetStyle( byval Value as long ) as HRESULT
```

The paragraph style of the paragraphs. The built-in styles are `tomParaStyleNormal` (-1) and
`tomParaStyleHeading1` (-2) to `tomParaStyleHeading9` (-10).

**Returns** `GetStyle`: the style handle. `SetStyle`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.SetStyle( tomParaStyleHeading1 )
```

Microsoft Learn: [ITextPara::GetStyle](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-getstyle), [ITextPara::SetStyle](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-setstyle)

### GetAlignment, SetAlignment

```freebasic
function GetAlignment() as long
function SetAlignment( byval Value as long ) as HRESULT
```

`GetAlignment` returns the alignment: `tomAlignLeft` (0), `tomAlignCenter` (1),
`tomAlignRight` (2) or `tomAlignJustify` (3).

`SetAlignment` passes `Value` to the interface's **`SetStyle`** method, not to
`SetAlignment`: the alignment stays as it was and the paragraph style becomes `Value`
(`SetAlignment( tomAlignCenter )` sets style 1). To align paragraphs, call the interface method
through `m_pTextPara2`, as the snippet does.

**Returns** `GetAlignment`: the alignment. `SetAlignment`: the `HRESULT` of `SetStyle`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.m_pTextPara2->lpVtbl->SetAlignment( para.m_pTextPara2, tomAlignCenter )
print "alignment:"; para.GetAlignment()
```

Microsoft Learn: [ITextPara::GetAlignment](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-getalignment), [ITextPara::SetAlignment](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-setalignment)

### GetHyphenation, SetHyphenation

```freebasic
function GetHyphenation() as long
function SetHyphenation( byval Value as long ) as HRESULT
```

Whether automatic hyphenation is on for the paragraphs: `tomTrue` or `tomFalse`.

**Returns** `GetHyphenation`: the setting. `SetHyphenation`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.SetHyphenation( tomTrue )
```

Microsoft Learn: [ITextPara::GetHyphenation](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-gethyphenation), [ITextPara::SetHyphenation](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-sethyphenation)

### GetFirstLineIndent

```freebasic
function GetFirstLineIndent() as single
```

Returns the indent of each paragraph's first line, in points, **relative to the left indent**:
a negative value makes a hanging indent. There is no setter of its own; use
[SetIndents](#setindents).

**Returns** the indent in points.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
print "first line:"; para.GetFirstLineIndent(); " pt"
```

Microsoft Learn: [ITextPara::GetFirstLineIndent](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-getfirstlineindent)

### GetKeepTogether, SetKeepTogether

```freebasic
function GetKeepTogether() as long
function SetKeepTogether( byval Value as long ) as HRESULT
```

Whether a page break may fall inside a paragraph: `tomTrue` keeps each paragraph on one page.

**Returns** `GetKeepTogether`: the setting. `SetKeepTogether`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.SetKeepTogether( tomTrue )
```

Microsoft Learn: [ITextPara::GetKeepTogether](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-getkeeptogether), [ITextPara::SetKeepTogether](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-setkeeptogether)

### GetKeepWithNext, SetKeepWithNext

```freebasic
function GetKeepWithNext() as long
function SetKeepWithNext( byval Value as long ) as HRESULT
```

Whether a page break may fall between a paragraph and the next one: `tomTrue` keeps them on the
same page, as a heading is kept with its text.

**Returns** `GetKeepWithNext`: the setting. `SetKeepWithNext`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.SetKeepWithNext( tomTrue )
```

Microsoft Learn: [ITextPara::GetKeepWithNext](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-getkeepwithnext), [ITextPara::SetKeepWithNext](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-setkeepwithnext)

### GetLeftIndent

```freebasic
function GetLeftIndent() as single
```

Returns the left indent of every line but the first, in points from the left margin. Set it
with [SetIndents](#setindents).

**Returns** the indent in points.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
print "left indent:"; para.GetLeftIndent(); " pt"
```

Microsoft Learn: [ITextPara::GetLeftIndent](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-getleftindent)

### GetLineSpacing, GetLineSpacingRule

```freebasic
function GetLineSpacing() as single
function GetLineSpacingRule() as long
```

Read the line spacing set with [SetLineSpacing](#setlinespacing). `GetLineSpacingRule` returns
the rule (`tomLineSpaceSingle`, `tomLineSpace1pt5`, `tomLineSpaceDouble`,
`tomLineSpaceAtLeast`, `tomLineSpaceExactly`, `tomLineSpaceMultiple`, `tomLineSpacePercent`);
`GetLineSpacing` returns the amount that goes with the rule.

**Returns** the spacing amount, or the rule.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
print "rule"; para.GetLineSpacingRule(); ", amount"; para.GetLineSpacing()
```

Microsoft Learn: [ITextPara::GetLineSpacing](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-getlinespacing), [ITextPara::GetLineSpacingRule](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-getlinespacingrule)

### GetListAlignment, SetListAlignment

```freebasic
function GetListAlignment() as long
function SetListAlignment( byval Value as long ) as HRESULT
```

How bullets and numbers are aligned in the space before the text: `tomAlignLeft`,
`tomAlignCenter` or `tomAlignRight`.

**Returns** `GetListAlignment`: the alignment. `SetListAlignment`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.SetListAlignment( tomAlignRight )
```

Microsoft Learn: [ITextPara::GetListAlignment](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-getlistalignment), [ITextPara::SetListAlignment](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-setlistalignment)

### GetListLevelIndex, SetListLevelIndex

```freebasic
function GetListLevelIndex() as long
function SetListLevelIndex( byval Value as long ) as HRESULT
```

The list level of the paragraphs: 0 for none, 1 for the top level, 2 for a sub-list and so on.

**Returns** `GetListLevelIndex`: the level. `SetListLevelIndex`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.SetListLevelIndex( 2 )
```

Microsoft Learn: [ITextPara::GetListLevelIndex](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-getlistlevelindex), [ITextPara::SetListLevelIndex](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-setlistlevelindex)

### GetListStart, SetListStart

```freebasic
function GetListStart() as long
function SetListStart( byval Value as long ) as HRESULT
```

The number (or, for a lettered list, the letter's position) the list starts at.

**Returns** `GetListStart`: the start value. `SetListStart`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.SetListStart( 5 )
```

Microsoft Learn: [ITextPara::GetListStart](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-getliststart), [ITextPara::SetListStart](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-setliststart)

### GetListTab, SetListTab

```freebasic
function GetListTab() as single
function SetListTab( byval Value as single ) as HRESULT
```

The list tab: the distance, in points, from the first-line indent to the start of the text
after the bullet or number.

**Returns** `GetListTab`: the distance in points. `SetListTab`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.SetListTab( 18 )
```

Microsoft Learn: [ITextPara::GetListTab](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-getlisttab), [ITextPara::SetListTab](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-setlisttab)

### GetListType, SetListType

```freebasic
function GetListType() as long
function SetListType( byval Value as long ) as HRESULT
```

`GetListType` returns the kind of list: `tomListNone` (0), `tomListBullet` (1),
`tomListNumberAsArabic` (2), `tomListNumberAsLCLetter`, `tomListNumberAsUCLetter`,
`tomListNumberAsLCRoman`, `tomListNumberAsUCRoman` and the others, with a style such as
`tomListParentheses` or `tomListPeriod` added.

`SetListType` passes `Value` to the interface's **`SetListTab`** method: the list type stays as
it was and the list tab becomes `Value` points (`SetListType( tomListBullet )` sets a 1-point
list tab). To make a list, call the interface method through `m_pTextPara2`, as the snippet
does.

**Returns** `GetListType`: the list type. `SetListType`: the `HRESULT` of `SetListTab`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.m_pTextPara2->lpVtbl->SetListType( para.m_pTextPara2, tomListBullet )
print "list type:"; para.GetListType()
```

Microsoft Learn: [ITextPara::GetListType](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-getlisttype), [ITextPara::SetListType](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-setlisttype)

### GetNoLineNumber, SetNoLineNumber

```freebasic
function GetNoLineNumber() as long
function SetNoLineNumber( byval Value as long ) as HRESULT
```

Whether line numbering is suppressed for the paragraphs: `tomTrue` leaves them unnumbered when
the document numbers its lines.

**Returns** `GetNoLineNumber`: the setting. `SetNoLineNumber`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.SetNoLineNumber( tomTrue )
```

Microsoft Learn: [ITextPara::GetNoLineNumber](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-getnolinenumber), [ITextPara::SetNoLineNumber](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-setnolinenumber)

### GetPageBreakBefore, SetPageBreakBefore

```freebasic
function GetPageBreakBefore() as long
function SetPageBreakBefore( byval Value as long ) as HRESULT
```

Whether each paragraph starts on a new page when printed: `tomTrue` or `tomFalse`.

**Returns** `GetPageBreakBefore`: the setting. `SetPageBreakBefore`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.SetPageBreakBefore( tomTrue )
```

Microsoft Learn: [ITextPara::GetPageBreakBefore](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-getpagebreakbefore), [ITextPara::SetPageBreakBefore](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-setpagebreakbefore)

### GetRightIndent, SetRightIndent

```freebasic
function GetRightIndent() as single
function SetRightIndent( byval Value as single ) as HRESULT
```

The right indent, in points from the right margin.

**Returns** `GetRightIndent`: the indent. `SetRightIndent`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.SetRightIndent( 36 )
```

Microsoft Learn: [ITextPara::GetRightIndent](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-getrightindent), [ITextPara::SetRightIndent](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-setrightindent)

### SetIndents

```freebasic
function SetIndents( byval First as single, byval Left as single, byval Right as single ) as HRESULT
```

Sets the three indents in one call, in points. `First` is relative to `Left`, so
`SetIndents( -36, 36, 0 )` starts the first line at the margin and the other lines half an inch
in.

| Parameter | Meaning |
| --- | --- |
| `First` | The first-line indent, relative to `Left`. |
| `Left` | The indent of the other lines, from the left margin. |
| `Right` | The right indent, from the right margin. |

**Returns** the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.SetIndents( -18, 36, 10 )
print para.GetFirstLineIndent(); para.GetLeftIndent(); para.GetRightIndent()   ' -18  36  10
```

Microsoft Learn: [ITextPara::SetIndents](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-setindents)

### SetLineSpacing

```freebasic
function SetLineSpacing( byval Rule as long, byval Spacing as single ) as HRESULT
```

Sets the line spacing. `Spacing` is ignored for the single, 1.5 and double rules; for
`tomLineSpaceAtLeast` and `tomLineSpaceExactly` it is in points, and for
`tomLineSpaceMultiple` it is a number of lines.

| Parameter | Meaning |
| --- | --- |
| `Rule` | A `tomLineSpace*` rule. |
| `Spacing` | The amount the rule needs. |

**Returns** the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.SetLineSpacing( tomLineSpaceMultiple, 1.5 )
```

Microsoft Learn: [ITextPara::SetLineSpacing](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-setlinespacing)

### GetSpaceAfter, SetSpaceAfter

```freebasic
function GetSpaceAfter() as single
function SetSpaceAfter( byval Value as single ) as HRESULT
```

The vertical space after each paragraph, in points.

**Returns** `GetSpaceAfter`: the space. `SetSpaceAfter`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.SetSpaceAfter( 6 )
```

Microsoft Learn: [ITextPara::GetSpaceAfter](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-getspaceafter), [ITextPara::SetSpaceAfter](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-setspaceafter)

### GetSpaceBefore, SetSpaceBefore

```freebasic
function GetSpaceBefore() as single
function SetSpaceBefore( byval Value as single ) as HRESULT
```

The vertical space before each paragraph, in points.

**Returns** `GetSpaceBefore`: the space. `SetSpaceBefore`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.SetSpaceBefore( 12 )
```

Microsoft Learn: [ITextPara::GetSpaceBefore](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-getspacebefore), [ITextPara::SetSpaceBefore](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-setspacebefore)

### GetWidowControl, SetWidowControl

```freebasic
function GetWidowControl() as long
function SetWidowControl( byval Value as long ) as HRESULT
```

Whether widow and orphan control is on: with `tomTrue` the first or last line of a paragraph is
never left alone at the top or bottom of a page.

**Returns** `GetWidowControl`: the setting. `SetWidowControl`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.SetWidowControl( tomTrue )
```

Microsoft Learn: [ITextPara::GetWidowControl](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-getwidowcontrol), [ITextPara::SetWidowControl](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-setwidowcontrol)

### GetTabCount

```freebasic
function GetTabCount() as long
```

Returns the number of explicit tab stops. With none, tabs fall at the document's default
spacing.

**Returns** the count.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
print para.GetTabCount(); " tab stops"
```

Microsoft Learn: [ITextPara::GetTabCount](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-gettabcount)

### AddTab

```freebasic
function AddTab( byval tbPos as single, byval tbAlign as long = tomALignLeft, byval tbLeader as long = tomSpaces ) as HRESULT
```

Adds a tab stop `tbPos` points from the left margin.

| Parameter | Meaning |
| --- | --- |
| `tbPos` | The position in points. |
| `tbAlign` | `tomAlignLeft` (the default), `tomAlignCenter`, `tomAlignRight`, `tomAlignDecimal` or `tomAlignBar`. |
| `tbLeader` | What fills the space before the stop: `tomSpaces` (the default), `tomDots`, `tomDashes`, `tomLines`, `tomThickLines` or `tomEquals`. |

**Returns** the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.AddTab( 72 )
para.AddTab( 300, tomAlignRight, tomDots )
```

Microsoft Learn: [ITextPara::AddTab](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-addtab)

### ClearAllTabs

```freebasic
function ClearAllTabs() as HRESULT
```

Removes every tab stop, so tabs fall at the document's default spacing again.

**Returns** the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.ClearAllTabs()
```

Microsoft Learn: [ITextPara::ClearAllTabs](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-clearalltabs)

### DeleteTab

```freebasic
function DeleteTab( byval tbPos as single ) as HRESULT
```

Removes the tab stop at `tbPos` points.

**Returns** the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.DeleteTab( 72 )
```

Microsoft Learn: [ITextPara::DeleteTab](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-deletetab)

### GetTab

```freebasic
function GetTab( byval iTab as long, byval ptbPos as single ptr, byval ptbAlign as long ptr, byval ptbLeader as long ptr ) as HRESULT
```

Reads a tab stop into three variables. `iTab` is the stop's index from 0, or `tomTabHere`,
`tomTabNext` or `tomTabBack` to take the stop at, after or before the position already in
`*ptbPos`.

| Parameter | Meaning |
| --- | --- |
| `iTab` | The index, or a `tomTab*` value. |
| `ptbPos` | Receives the position in points. |
| `ptbAlign` | Receives the `tomAlign*` alignment. |
| `ptbLeader` | Receives the `tom*` leader style. |

**Returns** `S_OK`, or `E_INVALIDARG` (`&h80070057`) when there is no such stop.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
dim as single tabPos
dim as long align, leader
if para.GetTab( 0, @tabPos, @align, @leader ) = S_OK then print "first stop at"; tabPos; " pt"
```

Microsoft Learn: [ITextPara::GetTab](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara-gettab)

### GetBorders

```freebasic
function GetBorders() as IUnknown ptr
```

Asks for the paragraphs' borders collection. The rich edit control does not implement it:
the result is `NULL` and `GetLastResult()` is `E_NOTIMPL` (`&h80004001`).

**Returns** the collection, or `NULL`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
if para.GetBorders() = NULL then print para.GetErrorInfo()
```

Microsoft Learn: [ITextPara2::GetBorders](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara2-getborders)

### GetFontAlignment, SetFontAlignment

```freebasic
function GetFontAlignment() as long
function SetFontAlignment( byval Value as long ) as HRESULT
```

How characters of different heights on one line line up, mainly for East Asian text:
`tomFontAlignmentAuto` (0), `tomFontAlignmentTop`, `tomFontAlignmentBaseline`,
`tomFontAlignmentBottom` or `tomFontAlignmentCenter`.

**Returns** `GetFontAlignment`: the setting. `SetFontAlignment`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.SetFontAlignment( tomFontAlignmentBaseline )
```

Microsoft Learn: [ITextPara2::GetFontAlignment](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara2-getfontalignment), [ITextPara2::SetFontAlignment](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara2-setfontalignment)

### GetHangingPunctuation, SetHangingPunctuation

```freebasic
function GetHangingPunctuation() as long
function SetHangingPunctuation( byval Value as long ) as HRESULT
```

Whether punctuation at the end of a line of a justified paragraph may hang past the right
margin: `tomTrue` or `tomFalse`.

**Returns** `GetHangingPunctuation`: the setting. `SetHangingPunctuation`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.SetHangingPunctuation( tomTrue )
```

Microsoft Learn: [ITextPara2::GetHangingPunctuation](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara2-gethangingpunctuation), [ITextPara2::SetHangingPunctuation](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara2-sethangingpunctuation)

### GetSnapToGrid, SetSnapToGrid

```freebasic
function GetSnapToGrid() as long
function SetSnapToGrid( byval Value as long ) as HRESULT
```

Whether the lines of the paragraphs snap to a vertical grid the document may define: `tomTrue`
or `tomFalse`.

**Returns** `GetSnapToGrid`: the setting. `SetSnapToGrid`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.SetSnapToGrid( tomFalse )
```

Microsoft Learn: [ITextPara2::GetSnapToGrid](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara2-getsnaptogrid), [ITextPara2::SetSnapToGrid](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara2-setsnaptogrid)

### GetTrimPunctuationAtStart, SetTrimPunctuationAtStart

```freebasic
function GetTrimPunctuationAtStart() as long
function SetTrimPunctuationAtStart( byval Value as long ) as HRESULT
```

Whether the leading space of a punctuation mark that starts a line is trimmed, for East Asian
text. On the control tested, `SetTrimPunctuationAtStart( tomTrue )` returned `S_OK` but the
value read back was still `tomFalse`.

**Returns** `GetTrimPunctuationAtStart`: the setting. `SetTrimPunctuationAtStart`: the
`HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
print "trim:"; para.GetTrimPunctuationAtStart()
```

Microsoft Learn: [ITextPara2::GetTrimPunctuationAtStart](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara2-gettrimpunctuationatstart), [ITextPara2::SetTrimPunctuationAtStart](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara2-settrimpunctuationatstart)

### GetEffects, SetEffects

```freebasic
function GetEffects( byval pValue as long ptr, byval pMask as long ptr ) as HRESULT
function SetEffects( byval Value as long, byval Mask as long ) as HRESULT
```

The paragraph effects as `tomParaEffect*` bit flags: `tomParaEffectRTL` (right to left),
`tomParaEffectKeep`, `tomParaEffectKeepNext`, `tomParaEffectPageBreakBefore`,
`tomParaEffectNoLineNumber`, `tomParaEffectNoWidowControl`, `tomParaEffectDoNotHyphen` and
others. `SetEffects` changes the bits set in `Mask` to their values in `Value`; `GetEffects`
reads the effects and a mask of the bits that are the same across the range.

| Parameter | Meaning |
| --- | --- |
| `pValue`, `pMask` | Receive the effects and the mask of defined bits. |
| `Value`, `Mask` | The new effects and the bits to change. |

**Returns** the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
para.SetEffects( tomParaEffectRTL, tomParaEffectRTL )
dim as long v, m
para.GetEffects( @v, @m )
```

Microsoft Learn: [ITextPara2::GetEffects](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara2-geteffects), [ITextPara2::SetEffects](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara2-seteffects)

### GetProperty, SetProperty

```freebasic
function GetProperty( byval nType as long ) as long
function SetProperty( byval nType as long, byval Value as long ) as HRESULT
```

Reads or sets an extra paragraph property by its id. An id the control does not know gives
`E_INVALIDARG` (`&h80070057`) in `GetLastResult()`, and `GetProperty` then returns 0.

| Parameter | Meaning |
| --- | --- |
| `nType` | The property id. |
| `Value` | The new value. |

**Returns** `GetProperty`: the value. `SetProperty`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 5 )
dim para as CTextPara2 = rng.GetPara()
dim v as long = para.GetProperty( 0 )
if para.GetLastResult() <> S_OK then print para.GetErrorInfo()
```

Microsoft Learn: [ITextPara2::GetProperty](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara2-getproperty), [ITextPara2::SetProperty](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextpara2-setproperty)

## See also

- [sys/win/richedit](SysWin-RichEdit)
- [CTextRange2](CTextRange2) and [CTextSelection2](CTextSelection2), where paragraph objects come from
- [CTextFont2](CTextFont2) for character formatting
- [Text Object Model](SysWin-RichEdit-TOM) for the `tom*` constants and the base class
- [CRichEditCtx](CRichEditCtx) for paragraph formatting through `PARAFORMAT2` messages
