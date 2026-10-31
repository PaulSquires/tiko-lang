[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/richedit](SysWin-RichEdit) › **CTextRow**

# CTextRow

Inserts table rows into rich edit text and reads and changes row and cell properties.

`CTextRow` wraps the Text Object Model's `ITextRow` interface. A row object is a **template**:
it starts out holding the properties of the table row at the active end of the range it came
from (or no cells at all, outside a table), and nothing you set on it reaches the document until
you call [Insert](#insert), which adds new rows with those properties, or [Apply](#apply), which
writes them over existing rows. [Reset](#reset) throws pending changes away and reads the row
again.

Some properties belong to the whole row (alignment, height, indent, cell margin, cell count).
The others belong to the **active cell**, the one chosen with
[SetCellIndex](#getcellindex-setcellindex): pick a cell, set its width, colours or borders, pick
the next. Widths, heights, indents, margins and border widths are in **twips** (1440 to the
inch); colours are `COLORREF` values.

You get a row from [CTextRange2](CTextRange2)`.GetRow()` or [CTextSelection2](CTextSelection2)`.GetRow()`.

**Ownership.** The constructor takes the `ITextRow` pointer as it is, without adding a
reference (pass `true` as the second argument to add one), and the destructor releases it, so
`dim row as CTextRow = rng.GetRow()` takes over the pointer `GetRow` returned. The pointer is
in the public field `m_pTextRow`. Do not copy one `CTextRow` into another: both copies would
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

A rich edit control holding a three-column table: a shaded header row and two plain rows.

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/richedit"
using win, gui, richedit

const IDC_RICHEDIT = 101

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

sub SetColumns( byref row as CTextRow )
    row.SetCellCount( 3 )
    for i as long = 0 to 2
        row.SetCellIndex( i )
        row.SetCellWidth( 2000 )                     ' twips
        row.SetCellBorderWidths( 15, 15, 15, 15 )
    next
end sub

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "RowDemo"
    dim hWin as HWND = pWindow.Create( NULL, "CTextRow", @WndProc )
    SetWindowClientSizeForDpi( hWin, 500, 260 )
    CenterWindow( hWin )
    dim pRichEdit as CRichEditCtx = CRichEditCtx( @pWindow, IDC_RICHEDIT, "", 10, 10, 480, 240 )
    pWindow.AnchorControl( IDC_RICHEDIT, ANCHOR_HEIGHT_WIDTH )
    scope
        dim rng as CTextRange2 = pRichEdit.Range( 0, 0 )
        dim row as CTextRow = rng.GetRow()
        SetColumns( row )
        row.Insert( 2 )                              ' two plain rows
    end scope
    scope
        dim rng as CTextRange2 = pRichEdit.Range( 0, 0 )
        dim row as CTextRow = rng.GetRow()
        SetColumns( row )
        for i as long = 0 to 2
            row.SetCellIndex( i )
            row.SetCellColorBack( BGR( 200, 220, 255 ) )
        next
        row.Insert( 1 )                              ' the header, above them
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
| [Constructor](#constructor) | Makes an empty object or wraps an `ITextRow` pointer. |
| [Destructor](#destructor) | Releases the pointer. |
| [Let, Cast](#let-cast) | Takes over a pointer; reads the pointer back. |
| [TextRowPtr](#textrowptr) | Returns the `ITextRow` pointer. |
| [Attach](#attach) | Replaces the pointer the object holds. |
| [Detach](#detach) | Gives up the pointer without releasing it. |
| [GetAlignment, SetAlignment](#getalignment-setalignment) | The horizontal alignment of the row. |
| [GetCellCount, SetCellCount](#getcellcount-setcellcount) | The number of cells in the row. |
| [GetCellCountCache, SetCellCountCache](#getcellcountcache-setcellcountcache) | The number of cells whose properties are stored. |
| [GetCellIndex, SetCellIndex](#getcellindex-setcellindex) | The active cell. |
| [GetCellMargin, SetCellMargin](#getcellmargin-setcellmargin) | The space between a cell's border and its text. |
| [GetHeight, SetHeight](#getheight-setheight) | The height of the row. |
| [GetIndent, SetIndent](#getindent-setindent) | The indent of the row. |
| [GetKeepTogether, SetKeepTogether](#getkeeptogether-setkeeptogether) | Whether the row may break across pages. |
| [GetKeepWithNext, SetKeepWithNext](#getkeepwithnext-setkeepwithnext) | Whether the row stays on the page of the next one. |
| [GetNestLevel](#getnestlevel) | How deep the table is nested. |
| [GetRTL, SetRTL](#getrtl-setrtl) | Right-to-left row order. |
| [GetCellAlignment, SetCellAlignment](#getcellalignment-setcellalignment) | The vertical alignment of the active cell. |
| [GetCellColorBack, SetCellColorBack](#getcellcolorback-setcellcolorback) | The background colour of the active cell. |
| [GetCellColorFore, SetCellColorFore](#getcellcolorfore-setcellcolorfore) | The foreground (shading) colour of the active cell. |
| [GetCellMergeFlags, SetCellMergeFlags](#getcellmergeflags-setcellmergeflags) | How the active cell merges with its neighbours. |
| [GetCellShading, SetCellShading](#getcellshading-setcellshading) | The mix of foreground and background colour. |
| [GetCellVerticalText, SetCellVerticalText](#getcellverticaltext-setcellverticaltext) | Vertical text in the active cell. |
| [GetCellWidth, SetCellWidth](#getcellwidth-setcellwidth) | The width of the active cell. |
| [GetCellBorderColors, SetCellBorderColors](#getcellbordercolors-setcellbordercolors) | The four border colours of the active cell. |
| [GetCellBorderWidths, SetCellBorderWidths](#getcellborderwidths-setcellborderwidths) | The four border widths of the active cell. |
| [Apply](#apply) | Writes the properties over existing rows. |
| [CanChange](#canchange) | Tells whether the row can be changed. |
| [GetProperty, SetProperty](#getproperty-setproperty) | A row property by id. |
| [Insert](#insert) | Inserts new rows with these properties. |
| [IsEqual](#isequal) | Compares the properties with another row. |
| [Reset](#reset) | Reads the row's properties again, dropping pending changes. |

## Reference

### Constructor

```freebasic
constructor
constructor( byval pTextRow as ITextRow ptr, byval fAddRef as boolean = false )
```

The first form makes an empty object, to be filled later with [Let](#let-cast) or
[Attach](#attach). The second wraps an `ITextRow` pointer: with `fAddRef` `false` (the default)
the object takes over the reference you hand it, which is right for the result of `GetRow`; with
`true` it adds a reference of its own and you keep yours.

A `NULL` pointer leaves the object empty with `GetLastResult()` returning `E_INVALIDARG`. Every
member calls through the pointer, so do not use an empty object.

| Parameter | Meaning |
| --- | --- |
| `pTextRow` | The row interface. |
| `fAddRef` | `true` to add a reference; `false` to take over the caller's. |

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
print "cells:"; row.GetCellCount()
```

### Destructor

```freebasic
destructor
```

Releases the `ITextRow` pointer, if there is one, when the variable goes out of scope.

**Example**

```freebasic
scope
    dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
    dim row as CTextRow = rng.GetRow()
    row.Insert( 1 )
end scope   ' row, then rng, released here
```

### Let, Cast

```freebasic
operator let( byval pTextRow as ITextRow ptr )
operator cast() as ITextRow ptr
```

`Let` releases the pointer the object holds and takes over the one assigned, without adding a
reference. Assigning `NULL` is refused: the object keeps its pointer and `GetLastResult()` is
`E_INVALIDARG`. `Cast` returns the pointer, so the object can be passed where an
`ITextRow ptr` is wanted; the reference stays with the object.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow
row = rng.GetRow()
dim pRow as ITextRow ptr = row
```

### TextRowPtr

```freebasic
function TextRowPtr() as ITextRow ptr
```

Returns the `ITextRow` pointer the object holds, or `NULL`, without adding a reference.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
if row.TextRowPtr() = NULL then print "no row"
```

### Attach

```freebasic
function Attach( byval pTextRow as ITextRow ptr, byval fAddRef as boolean = false ) as HRESULT
```

Releases the pointer the object holds, if any, and stores `pTextRow`, adding a reference when
`fAddRef` is `true`. A `NULL` pointer is refused with `E_INVALIDARG`.

**Returns** `E_INVALIDARG` for `NULL`. Otherwise not an `HRESULT`: when the object held a
pointer, the reference count that pointer was left with after its release (also stored as the
last result); when it was empty, the last result as it was.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim pRow as ITextRow ptr = rng.GetRow()
dim row as CTextRow
row.Attach( pRow )            ' row now owns pRow
```

### Detach

```freebasic
function Detach() as ITextRow ptr
```

Returns the pointer and empties the object without releasing it; you release it yourself.

**Returns** the pointer, or `NULL`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
dim pRow as ITextRow ptr = row.Detach()
pRow->lpVtbl->Release( pRow )
```

### GetAlignment, SetAlignment

```freebasic
function GetAlignment() as long
function SetAlignment( byval Value as long ) as HRESULT
```

The horizontal alignment of the row in the page: `tomAlignLeft`, `tomAlignCenter` or
`tomAlignRight`.

**Returns** `GetAlignment`: the alignment. `SetAlignment`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
row.SetAlignment( tomAlignCenter )
row.Apply( 1, tomRowApplyDefault )
```

Microsoft Learn: [ITextRow::GetAlignment](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getalignment), [ITextRow::SetAlignment](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-setalignment)

### GetCellCount, SetCellCount

```freebasic
function GetCellCount() as long
function SetCellCount( byval Value as long ) as HRESULT
```

The number of cells in the row. A row taken outside a table has 0 cells; set a count before
[Insert](#insert) to make a new table.

**Returns** `GetCellCount`: the count. `SetCellCount`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
if row.GetCellCount() = 0 then row.SetCellCount( 4 ) : row.Insert( 1 )
```

Microsoft Learn: [ITextRow::GetCellCount](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getcellcount), [ITextRow::SetCellCount](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-setcellcount)

### GetCellCountCache, SetCellCountCache

```freebasic
function GetCellCountCache() as long
function SetCellCountCache( byval Value as long ) as HRESULT
```

The number of cells whose properties the row stores. When it is less than the cell count, the
cells past it take the properties of the last stored cell, so a row of identical cells needs only
cell 0 described and a cache of 1.

**Returns** `GetCellCountCache`: the count. `SetCellCountCache`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
row.SetCellCount( 5 ) : row.SetCellCountCache( 1 )
row.SetCellIndex( 0 ) : row.SetCellWidth( 1440 )   ' all five cells one inch wide
row.Insert( 1 )
```

Microsoft Learn: [ITextRow::GetCellCountCache](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getcellcountcache), [ITextRow::SetCellCountCache](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-setcellcountcache)

### GetCellIndex, SetCellIndex

```freebasic
function GetCellIndex() as long
function SetCellIndex( byval Value as long ) as HRESULT
```

The active cell, counted from 0: the cell that the `GetCell...` and `SetCell...` members read and
change (all but `GetCellCount`, `GetCellCountCache` and `GetCellMargin` and their setters).

**Returns** `GetCellIndex`: the index. `SetCellIndex`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
row.SetCellIndex( 1 )
print "second cell width:"; row.GetCellWidth(); " twips"
```

Microsoft Learn: [ITextRow::GetCellIndex](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getcellindex), [ITextRow::SetCellIndex](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-setcellindex)

### GetCellMargin, SetCellMargin

```freebasic
function GetCellMargin() as long
function SetCellMargin( byval Value as long ) as HRESULT
```

The space between the border of each cell in the row and its text, in twips.

**Returns** `GetCellMargin`: the margin. `SetCellMargin`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
row.SetCellMargin( 108 ) : row.Apply( 1, tomRowApplyDefault )
```

Microsoft Learn: [ITextRow::GetCellMargin](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getcellmargin), [ITextRow::SetCellMargin](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-setcellmargin)

### GetHeight, SetHeight

```freebasic
function GetHeight() as long
function SetHeight( byval Value as long ) as HRESULT
```

The height of the row in twips.

**Returns** `GetHeight`: the height. `SetHeight`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
row.SetHeight( 600 ) : row.Apply( 1, tomRowApplyDefault )
```

Microsoft Learn: [ITextRow::GetHeight](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getheight), [ITextRow::SetHeight](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-setheight)

### GetIndent, SetIndent

```freebasic
function GetIndent() as long
function SetIndent( byval Value as long ) as HRESULT
```

How far the row starts from the left margin, in twips. Rows of one table may have different
indents.

**Returns** `GetIndent`: the indent. `SetIndent`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
row.SetIndent( 720 ) : row.Apply( 1, tomRowApplyDefault )
```

Microsoft Learn: [ITextRow::GetIndent](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getindent), [ITextRow::SetIndent](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-setindent)

### GetKeepTogether, SetKeepTogether

```freebasic
function GetKeepTogether() as long
function SetKeepTogether( byval Value as long ) as HRESULT
```

Whether the row is kept whole rather than broken across two pages: `tomTrue` or `tomFalse`.

**Returns** `GetKeepTogether`: the setting. `SetKeepTogether`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
row.SetKeepTogether( tomTrue )
```

Microsoft Learn: [ITextRow::GetKeepTogether](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getkeeptogether), [ITextRow::SetKeepTogether](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-setkeeptogether)

### GetKeepWithNext, SetKeepWithNext

```freebasic
function GetKeepWithNext() as long
function SetKeepWithNext( byval Value as long ) as HRESULT
```

Whether the row is kept on the same page as the row after it: `tomTrue` or `tomFalse`. Set it
on a header row so that it never ends a page alone.

**Returns** `GetKeepWithNext`: the setting. `SetKeepWithNext`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
row.SetKeepWithNext( tomTrue )
```

Microsoft Learn: [ITextRow::GetKeepWithNext](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getkeepwithnext), [ITextRow::SetKeepWithNext](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-setkeepwithnext)

### GetNestLevel

```freebasic
function GetNestLevel() as long
```

How deep the row's table is nested: 0 outside a table, 1 for a table in plain text, 2 for a
table inside a cell of another, up to 15.

**Returns** the level.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
if row.GetNestLevel() = 0 then print "not in a table"
```

Microsoft Learn: [ITextRow::GetNestLevel](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getnestlevel)

### GetRTL, SetRTL

```freebasic
function GetRTL() as long
function SetRTL( byval Value as long ) as HRESULT
```

Whether the cells run from right to left: `tomTrue` or `tomFalse`.

**Returns** `GetRTL`: the setting. `SetRTL`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
row.SetRTL( tomTrue ) : row.Apply( 1, tomRowApplyDefault )
```

Microsoft Learn: [ITextRow::GetRTL](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getrtl), [ITextRow::SetRTL](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-setrtl)

### GetCellAlignment, SetCellAlignment

```freebasic
function GetCellAlignment() as long
function SetCellAlignment( byval Value as long ) as HRESULT
```

The vertical alignment of the text in the active cell: 0 at the top, 1 (`tomAlignCenter`) in the
middle, 2 at the bottom.

**Returns** `GetCellAlignment`: the alignment. `SetCellAlignment`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
row.SetCellIndex( 0 ) : row.SetCellAlignment( tomAlignCenter )
row.Apply( 1, tomRowApplyDefault )
```

Microsoft Learn: [ITextRow::GetCellAlignment](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getcellalignment), [ITextRow::SetCellAlignment](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-setcellalignment)

### GetCellColorBack, SetCellColorBack

```freebasic
function GetCellColorBack() as long
function SetCellColorBack( byval Value as long ) as HRESULT
```

The background colour of the active cell, a `COLORREF`.

**Returns** `GetCellColorBack`: the colour. `SetCellColorBack`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
row.SetCellIndex( 0 ) : row.SetCellColorBack( BGR( 255, 255, 0 ) )
row.Apply( 1, tomRowApplyDefault )
```

Microsoft Learn: [ITextRow::GetCellColorBack](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getcellcolorback), [ITextRow::SetCellColorBack](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-setcellcolorback)

### GetCellColorFore, SetCellColorFore

```freebasic
function GetCellColorFore() as long
function SetCellColorFore( byval Value as long ) as HRESULT
```

The foreground colour of the active cell, a `COLORREF`. It is not the text colour: it is mixed
into the cell's background by [SetCellShading](#getcellshading-setcellshading).

**Returns** `GetCellColorFore`: the colour. `SetCellColorFore`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
row.SetCellIndex( 0 ) : row.SetCellColorFore( BGR( 0, 0, 128 ) )
```

Microsoft Learn: [ITextRow::GetCellColorFore](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getcellcolorfore), [ITextRow::SetCellColorFore](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-setcellcolorfore)

### GetCellMergeFlags, SetCellMergeFlags

```freebasic
function GetCellMergeFlags() as long
function SetCellMergeFlags( byval Value as long ) as HRESULT
```

How the active cell merges with its neighbours: `tomHStartCell` starts a horizontal merge and
`tomHContCell` continues it; `tomVTopCell` starts a vertical merge and `tomVLowCell` continues it
in the rows below. 0 is a cell on its own.

**Returns** `GetCellMergeFlags`: the flags. `SetCellMergeFlags`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
row.SetCellIndex( 0 ) : row.SetCellMergeFlags( tomHStartCell )
row.SetCellIndex( 1 ) : row.SetCellMergeFlags( tomHContCell )
row.Apply( 1, tomRowApplyDefault )
```

Microsoft Learn: [ITextRow::GetCellMergeFlags](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getcellmergeflags), [ITextRow::SetCellMergeFlags](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-setcellmergeflags)

### GetCellShading, SetCellShading

```freebasic
function GetCellShading() as long
function SetCellShading( byval Value as long ) as HRESULT
```

How much of the active cell's foreground colour is mixed into its background, in hundredths of a
percent: 0 shows the background colour alone, 10000 the foreground colour alone, 5000 half and
half.

**Returns** `GetCellShading`: the shading. `SetCellShading`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
row.SetCellIndex( 0 ) : row.SetCellShading( 2500 )   ' 25 %
```

Microsoft Learn: [ITextRow::GetCellShading](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getcellshading), [ITextRow::SetCellShading](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-setcellshading)

### GetCellVerticalText, SetCellVerticalText

```freebasic
function GetCellVerticalText() as long
function SetCellVerticalText( byval Value as long ) as HRESULT
```

Whether the text of the active cell runs vertically: `tomTrue` or `tomFalse`.

**Returns** `GetCellVerticalText`: the setting. `SetCellVerticalText`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
row.SetCellIndex( 0 ) : row.SetCellVerticalText( tomTrue )
```

Microsoft Learn: [ITextRow::GetCellVerticalText](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getcellverticaltext), [ITextRow::SetCellVerticalText](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-setcellverticaltext)

### GetCellWidth, SetCellWidth

```freebasic
function GetCellWidth() as long
function SetCellWidth( byval Value as long ) as HRESULT
```

The width of the active cell in twips.

**Returns** `GetCellWidth`: the width. `SetCellWidth`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
row.SetCellIndex( 0 ) : row.SetCellWidth( 2880 )     ' two inches
row.Apply( 1, tomCellStructureChangeOnly )
```

Microsoft Learn: [ITextRow::GetCellWidth](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getcellwidth), [ITextRow::SetCellWidth](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-setcellwidth)

### GetCellBorderColors, SetCellBorderColors

```freebasic
function GetCellBorderColors( byval pcrLeft as long ptr, byval pcrTop as long ptr, byval pcrRight as long ptr, byval pcrBottom as long ptr ) as HRESULT
function SetCellBorderColors( byval crLeft as long, byval crTop as long, byval crRight as long, byval crBottom as long ) as HRESULT
```

The colours of the four borders of the active cell, as `COLORREF` values. `GetCellBorderColors`
writes them through the four pointers.

| Parameter | Meaning |
| --- | --- |
| `pcrLeft` … `pcrBottom` | Receive the left, top, right and bottom colours. |
| `crLeft` … `crBottom` | The left, top, right and bottom colours to set. |

**Returns** the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
dim as long l, t, r, b
row.SetCellIndex( 0 )
if row.GetCellBorderColors( @l, @t, @r, @b ) = S_OK then print hex( l ), hex( t ), hex( r ), hex( b )
```

Microsoft Learn: [ITextRow::GetCellBorderColors](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getcellbordercolors), [ITextRow::SetCellBorderColors](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-setcellbordercolors)

### GetCellBorderWidths, SetCellBorderWidths

```freebasic
function GetCellBorderWidths( byval pduLeft as long ptr, byval pduTop as long ptr, byval pduRight as long ptr, byval pduBottom as long ptr ) as HRESULT
function SetCellBorderWidths( byval duLeft as long, byval duTop as long, byval duRight as long, byval duBottom as long ) as HRESULT
```

The widths of the four borders of the active cell, in twips; 0 is no border.

| Parameter | Meaning |
| --- | --- |
| `pduLeft` … `pduBottom` | Receive the left, top, right and bottom widths. |
| `duLeft` … `duBottom` | The left, top, right and bottom widths to set. |

**Returns** the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
row.SetCellIndex( 0 ) : row.SetCellBorderWidths( 15, 15, 15, 15 )
row.Apply( 1, tomRowApplyDefault )
```

Microsoft Learn: [ITextRow::GetCellBorderWidths](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getcellborderwidths), [ITextRow::SetCellBorderWidths](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-setcellborderwidths)

### Apply

```freebasic
function Apply( byval cRow as long, byval Flags as long ) as HRESULT
```

Writes the row object's properties over `cRow` existing rows, starting with the row of the range
it came from. Until `Apply` (or [Insert](#insert)) the document is unchanged.

| Parameter | Meaning |
| --- | --- |
| `cRow` | The number of rows to change. |
| `Flags` | `tomRowApplyDefault` (0) writes every property; `tomCellStructureChangeOnly` (1) writes only the cell count and widths, keeping borders, colours and the rest. |

**Returns** the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
row.SetHeight( 400 )
row.Apply( 3, tomRowApplyDefault )                   ' this row and the two below it
```

Microsoft Learn: [ITextRow::Apply](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-apply)

### CanChange

```freebasic
function CanChange() as long
```

Tells whether the row can be changed: it cannot when the text is protected or the control is
read-only.

**Returns** `tomTrue` if it can, otherwise `tomFalse`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
if row.CanChange() = tomTrue then row.Insert( 1 )
```

Microsoft Learn: [ITextRow::CanChange](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-canchange)

### GetProperty, SetProperty

```freebasic
function GetProperty( byval nType as long ) as long
function SetProperty( byval nType as long, byval Value as long ) as HRESULT
```

Reads or sets a row property by its id, for properties that have no member of their own. An id
the row does not take is refused with `E_INVALIDARG`, and `GetProperty` returns 0.

| Parameter | Meaning |
| --- | --- |
| `nType` | The property id. |
| `Value` | The new value. |

**Returns** `GetProperty`: the value. `SetProperty`: the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
dim v as long = row.GetProperty( tomRowHeightActual )
if row.GetLastResult() <> S_OK then print row.GetErrorInfo()
```

Microsoft Learn: [ITextRow::GetProperty](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-getproperty), [ITextRow::SetProperty](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-setproperty)

### Insert

```freebasic
function Insert( byval cRow as long ) as HRESULT
```

Inserts `cRow` identical rows with the row object's properties at the position of the range it
came from. A row taken outside a table needs a cell count first; it then makes a new table.
For rows that differ, set the properties and call `Insert` once for each kind.

| Parameter | Meaning |
| --- | --- |
| `cRow` | The number of rows to insert. |

**Returns** the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
row.SetCellCount( 2 )
row.SetCellIndex( 0 ) : row.SetCellWidth( 1440 )
row.SetCellIndex( 1 ) : row.SetCellWidth( 2880 )
row.Insert( 3 )                                      ' a 3 x 2 table
```

Microsoft Learn: [ITextRow::Insert](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-insert)

### IsEqual

```freebasic
function IsEqual( byval pRow as ITextRow ptr ) as long
```

Compares the properties of this row object with those of another, pending changes included.

| Parameter | Meaning |
| --- | --- |
| `pRow` | The other row. |

**Returns** `tomTrue` if every property is the same, otherwise `tomFalse`.

**Example**

```freebasic
dim r1 as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim a as CTextRow = r1.GetRow()
dim b as CTextRow = r1.GetRow()
print a.IsEqual( b )                                 ' -1 until one of them changes
```

Microsoft Learn: [ITextRow::IsEqual](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-isequal)

### Reset

```freebasic
function Reset( byval Value as long = tomRowUpdate ) as HRESULT
```

Reads the properties of the row at the range's position again. Changes set but not applied are
lost, and changes another row object has applied become visible.

| Parameter | Meaning |
| --- | --- |
| `Value` | `tomRowUpdate`, the default. |

**Returns** the `HRESULT`.

**Example**

```freebasic
dim rng as CTextRange2 = CRichEditCtxPtr( hCtrl )->Range( 0, 0 )
dim row as CTextRow = rng.GetRow()
row.SetHeight( 800 )
row.Reset()                                          ' the height is the row's own again
```

Microsoft Learn: [ITextRow::Reset](https://learn.microsoft.com/en-us/windows/win32/api/tom/nf-tom-itextrow-reset)

## See also

- [sys/win/richedit](SysWin-RichEdit)
- [CTextRange2](CTextRange2) and [CTextSelection2](CTextSelection2), where row objects come from
- [CTextPara2](CTextPara2) for the paragraphs inside the cells
- [Text Object Model](SysWin-RichEdit-TOM) for the `tom*` constants and the base class
- [CRichEditCtx: editing](CRichEditCtx-Editing) for `InsertTable`, tables through the `EM_INSERTTABLE` message
