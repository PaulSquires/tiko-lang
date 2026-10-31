[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gui](SysWin-Gui) › **TabCtl**

# TabCtl

Adds, selects, renames and removes the tabs of a tab control, and manages its tab pages.

A tab control is a row of tabs over a display area; the program shows a different set of
controls in the display area for each tab. Create one with `CWindow.AddControl( "Tab", ... )`.
Every function here takes the control's handle first and is written with the namespace:
`TabCtl.GetCurSel( hTab )`. Tabs are numbered from 0, left to right; rectangles are client
coordinates of the tab control.

The control itself only draws the tabs. The usual way to give each tab its contents is a
[CTabPage](CTabPage): a child window that `CTabPage.InsertPage` creates in the display area and
whose address it stores in the tab's `lParam`. The last three functions on this page,
[ResizePages](#resizepages), [DestroyPage](#destroypage) and
[DestroyAllPages](#destroyallpages), work on such pages; `CTabPagePtr( hTab, i )` returns the
page of tab `i` (`-1` for the selected tab). Pages created with `new` must be destroyed, and
[DestroyAllPages](#destroyallpages) in `WM_DESTROY` does it for all of them.

A tab's attributes travel in a `TCITEMW`, whose `mask` says which members are meant
(`TCIF_TEXT`, `TCIF_IMAGE`, `TCIF_PARAM`, `TCIF_STATE`). The image list is the program's to
destroy.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui
```

## Example

A tab control with three pages, each holding a label. Changing tabs hides the old page, shows
the new one and puts the tab's text in the caption; the pages are destroyed with the window.

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

const IDC_TAB = 1001

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
declare function PageProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "TabDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Tab control", @WndProc )
    pWindow.SetClientSize( 420, 260 )
    pWindow.Center()
    dim hTab as HWND = pWindow.AddControl( "Tab", hWin, IDC_TAB, "", 10, 10, 400, 240 )
    for i as long = 0 to 2
        dim wszTitle as wstring * 32 = "Page " & ( i + 1 )
        dim pPage as CTabPage ptr = new CTabPage
        pPage->InsertPage( hTab, i, wszTitle, -1, @PageProc )
        pPage->AddControl( "Label", pPage->hTabPage, -1, "This is " & wszTitle, 20, 20, 200, 20 )
    next
    ShowWindow( CTabPagePtr( hTab, 0 )->hTabPage, SW_SHOW )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_NOTIFY
            dim pnmh as NMHDR ptr = cast( NMHDR ptr, lParam )
            if pnmh->idFrom = IDC_TAB then
                dim pPage as CTabPage ptr = CTabPagePtr( pnmh->hwndFrom, -1 )
                select case pnmh->code
                    case TCN_SELCHANGING
                        if pPage then ShowWindow( pPage->hTabPage, SW_HIDE )
                    case TCN_SELCHANGE
                        if pPage then ShowWindow( pPage->hTabPage, SW_SHOW )
                        SetWindowText( hwnd, TabCtl.GetText( pnmh->hwndFrom, TabCtl.GetCurSel( pnmh->hwndFrom ) ) )
                end select
            end if
            return 0
        case WM_DESTROY
            TabCtl.DestroyAllPages( GetDlgItem( hwnd, IDC_TAB ) )
            PostQuitMessage( 0 )
            return 0
    end select
    return DefWindowProcW( hwnd, uMsg, wParam, lParam )
end function

function PageProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    return DefWindowProcW( hwnd, uMsg, wParam, lParam )
end function

end main()
```

## Functions

| Function | Does |
| --- | --- |
| [AddTab](#addtab) | Adds a tab after the last one. |
| [InsertTab](#inserttab) | Inserts a tab with a text, an image and a value. |
| [InsertItem](#insertitem) | Inserts a tab from a `TCITEMW`. |
| [DeleteItem](#deleteitem) | Removes a tab. |
| [DeleteAllItems](#deleteallitems) | Removes every tab. |
| [GetItemCount](#getitemcount) | Returns the number of tabs. |
| [GetItem](#getitem) | Reads a tab's attributes into a `TCITEMW`. |
| [SetItem](#setitem) | Sets a tab's attributes from a `TCITEMW`. |
| [GetText](#gettext) | Returns or reads a tab's text. |
| [SetText](#settext) | Changes a tab's text. |
| [GetCurSel](#getcursel) | Returns the selected tab. |
| [SetCurSel](#setcursel) | Selects a tab. |
| [GetCurFocus](#getcurfocus) | Returns the tab with the keyboard focus. |
| [SetCurFocus](#setcurfocus) | Gives a tab the keyboard focus. |
| [DeselectAll](#deselectall) | Releases every pressed tab of a button-style tab control. |
| [HighlightItem](#highlightitem) | Highlights or unhighlights a tab. |
| [GetItemRect](#getitemrect) | Returns a tab's rectangle. |
| [AdjustRect](#adjustrect) | Converts between the control's rectangle and its display area. |
| [HitTest](#hittest) | Finds the tab at a point. |
| [GetRowCount](#getrowcount) | Returns the number of rows of tabs. |
| [SetItemSize](#setitemsize) | Sets the size of fixed-width tabs. |
| [SetMinTabWidth](#setmintabwidth) | Sets the smallest width a tab can have. |
| [SetPadding](#setpadding) | Sets the space around each tab's icon and text. |
| [SetItemExtra](#setitemextra) | Sets how many bytes of program data each tab holds. |
| [GetExtendedStyle](#getextendedstyle) | Returns the extended styles. |
| [SetExtendedStyle](#setextendedstyle) | Sets the extended styles. |
| [GetImageList](#getimagelist) | Returns the image list. |
| [SetImageList](#setimagelist) | Assigns an image list. |
| [GetImageIndex](#getimageindex) | Returns the image a tab shows. |
| [SetImageIndex](#setimageindex) | Sets the image a tab shows. |
| [RemoveImage](#removeimage) | Removes an image from the image list. |
| [GetToolTips](#gettooltips) | Returns the tooltip control. |
| [SetToolTips](#settooltips) | Assigns a tooltip control. |
| [ResizePages](#resizepages) | Fits every tab page to the display area. |
| [DestroyPage](#destroypage) | Destroys the tab page of one tab, and its tab. |
| [DestroyAllPages](#destroyallpages) | Destroys every tab page and its tab. |

## Reference

### AddTab

```freebasic
function AddTab( byval hTab as HWND, byval iImage as long, byval pwszText as wstring ptr, byval lParam as ..LPARAM = 0 ) as long
```

Adds a tab after the last one: [InsertTab](#inserttab) at the index `GetItemCount( hTab )`.

| Parameter | Meaning |
| --- | --- |
| `iImage` | The image in the control's image list, or -1 for none. |
| `pwszText` | The tab's text. `NULL` adds nothing. |
| `lParam` | A value the program keeps with the tab. |

**Returns** the index of the new tab, or -1 on failure or when `pwszText` is `NULL`.

**Example**

```freebasic
TabCtl.AddTab( hCtrl, -1, "General" )
TabCtl.AddTab( hCtrl, -1, "Advanced" )
```

Microsoft Learn: [TCM_INSERTITEM](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-insertitem)

### InsertTab

```freebasic
function InsertTab( byval hTab as HWND, byval nTabIndex as DWORD, byval iImage as long, byval pwszText as wstring ptr, byval lParam as ..LPARAM = 0 ) as long
```

Inserts a tab before the tab at `nTabIndex`; an index at or past the end adds it last. The text,
the image and `lParam` are all set. The tab is also marked for right-to-left reading
(`TCIF_RTLREADING`), which only changes anything on Hebrew and Arabic systems.

| Parameter | Meaning |
| --- | --- |
| `nTabIndex` | Where to insert it. |
| `iImage` | The image in the control's image list, or -1 for none. |
| `pwszText` | The tab's text. `NULL` inserts nothing. |
| `lParam` | A value the program keeps with the tab; read it back with [GetItem](#getitem) and `TCIF_PARAM`. |

**Returns** the index of the new tab, or -1 on failure or when `pwszText` is `NULL`.

**Example**

```freebasic
TabCtl.InsertTab( hCtrl, 0, -1, "Summary", 42 )   ' first, with 42 as its value
```

Microsoft Learn: [TCM_INSERTITEM](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-insertitem)

### InsertItem

```freebasic
function InsertItem overload( byval hTab as HWND, byval iItem as DWORD, byval pitem as TCITEMW ptr ) as long
function InsertItem overload( byval hTab as HWND, byval iItem as DWORD, byref item as TCITEMW ) as long
```

Inserts a tab before the tab at `iItem`, with the attributes the `TCITEMW` names in `mask`.

**Returns** the index of the new tab, or -1 on failure.

**Example**

```freebasic
dim wszText as wstring * 32 = "Colours"
dim tci as TCITEMW
tci.mask = TCIF_TEXT or TCIF_IMAGE : tci.pszText = @wszText : tci.iImage = -1
TabCtl.InsertItem( hCtrl, TabCtl.GetItemCount( hCtrl ), tci )
```

Microsoft Learn: [TCM_INSERTITEM](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-insertitem)

### DeleteItem

```freebasic
function DeleteItem( byval hTab as HWND, byval iItem as long ) as boolean
```

Removes tab `iItem`; the tabs after it move down one index. A [CTabPage](CTabPage) on that tab is
not destroyed: use [DestroyPage](#destroypage) for that.

**Returns** `true` on success.

**Example**

```freebasic
TabCtl.DeleteItem( hCtrl, TabCtl.GetItemCount( hCtrl ) - 1 )
```

Microsoft Learn: [TCM_DELETEITEM](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-deleteitem)

### DeleteAllItems

```freebasic
function DeleteAllItems( byval hTab as HWND ) as boolean
```

Removes every tab. Tab pages are left as they are; [DestroyAllPages](#destroyallpages) removes
the tabs and destroys their pages.

**Returns** `true` on success.

**Example**

```freebasic
TabCtl.DeleteAllItems( hCtrl )
```

Microsoft Learn: [TCM_DELETEALLITEMS](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-deleteallitems)

### GetItemCount

```freebasic
function GetItemCount( byval hTab as HWND ) as long
```

**Returns** the number of tabs.

**Example**

```freebasic
print TabCtl.GetItemCount( hCtrl ); " tabs"
```

Microsoft Learn: [TCM_GETITEMCOUNT](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-getitemcount)

### GetItem

```freebasic
function GetItem overload( byval hTab as HWND, byval iItem as DWORD, byref tcitem as TCITEMW ) as boolean
function GetItem overload( byval hTab as HWND, byval iItem as DWORD, byval ptcitem as TCITEMW ptr ) as boolean
```

Reads the attributes of tab `iItem` that `mask` asks for. For the text, point `pszText` at a
buffer and set `cchTextMax` to its size in characters; for the state, set `dwStateMask`.

**Returns** `true` on success.

**Example**

```freebasic
dim tci as TCITEMW
tci.mask = TCIF_PARAM
if TabCtl.GetItem( hCtrl, 0, tci ) then print "value of tab 0:"; tci.lParam
```

Microsoft Learn: [TCM_GETITEM](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-getitem)

### SetItem

```freebasic
function SetItem overload( byval hTab as HWND, byval iItem as long, byref pitem as TCITEMW ptr ) as long
function SetItem overload( byval hTab as HWND, byval iItem as long, byref item as TCITEMW ) as long
```

Changes the attributes of tab `iItem` that `mask` names; the others stay as they are. The first
form takes the pointer itself by reference, so pass a pointer variable or `@item`.

**Returns** nonzero on success, 0 on failure.

**Example**

```freebasic
dim tci as TCITEMW
tci.mask = TCIF_IMAGE : tci.iImage = 1
TabCtl.SetItem( hCtrl, 0, tci )
```

Microsoft Learn: [TCM_SETITEM](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-setitem)

### GetText

```freebasic
function GetText overload( byval hTab as HWND, byval nTabIndex as DWORD, byval pwszText as wstring ptr, byval cchTextMax as long ) as boolean
function GetText overload( byval hTab as HWND, byval nTabIndex as DWORD ) as ustring
```

The `ustring` form returns the text of tab `nTabIndex`, at most 259 characters, and sets
`GetLastError()` to 1 on success and 0 on failure (an empty string). The buffer form copies the
text into a buffer of `cchTextMax` characters, the terminating null included.

**Returns** the text, or `true` on success for the buffer form.

**Example**

```freebasic
print "selected: "; TabCtl.GetText( hCtrl, TabCtl.GetCurSel( hCtrl ) )
```

Microsoft Learn: [TCM_GETITEM](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-getitem)

### SetText

```freebasic
function SetText( byval hTab as HWND, byval nTabIndex as DWORD, byval pwszText as wstring ptr ) as boolean
```

Changes the text of tab `nTabIndex`. `pwszText` must not be `NULL`: the function measures it
before sending it.

**Returns** `true` on success.

**Example**

```freebasic
TabCtl.SetText( hCtrl, 0, "Summary (changed)" )
```

Microsoft Learn: [TCM_SETITEM](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-setitem)

### GetCurSel

```freebasic
function GetCurSel( byval hTab as HWND ) as long
```

**Returns** the index of the selected tab, or -1 when none is selected.

**Example**

```freebasic
dim i as long = TabCtl.GetCurSel( hCtrl )
if i >= 0 then print "tab"; i; " is selected"
```

Microsoft Learn: [TCM_GETCURSEL](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-getcursel)

### SetCurSel

```freebasic
function SetCurSel( byval hTab as HWND, byval iItem as long ) as long
```

Selects tab `iItem`. The control does not send `TCN_SELCHANGING` or `TCN_SELCHANGE`, so a
program that shows pages on those notifications hides and shows the pages itself.

**Returns** the index of the tab selected before, or -1 on failure.

**Example**

```freebasic
dim pOld as CTabPage ptr = CTabPagePtr( hCtrl, -1 )
if pOld then ShowWindow( pOld->hTabPage, SW_HIDE )
TabCtl.SetCurSel( hCtrl, 1 )
dim pNew as CTabPage ptr = CTabPagePtr( hCtrl, 1 )
if pNew then ShowWindow( pNew->hTabPage, SW_SHOW )
```

Microsoft Learn: [TCM_SETCURSEL](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-setcursel)

### GetCurFocus

```freebasic
function GetCurFocus( byval hTab as HWND ) as long
```

Returns the tab that has the keyboard focus. It is usually the selected tab; it differs while
the user moves between tabs with the arrow keys in a button-style control.

**Returns** the index of the tab with the focus.

**Example**

```freebasic
print "focus on tab"; TabCtl.GetCurFocus( hCtrl )
```

Microsoft Learn: [TCM_GETCURFOCUS](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-getcurfocus)

### SetCurFocus

```freebasic
sub SetCurFocus( byval hTab as HWND, byval iItem as long )
```

Gives tab `iItem` the keyboard focus. In a control with the `TCS_BUTTONS` style the tab only
gets the focus; in any other it is also selected, and the parent receives the selection
notifications.

**Example**

```freebasic
TabCtl.SetCurFocus( hCtrl, 0 )
```

Microsoft Learn: [TCM_SETCURFOCUS](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-setcurfocus)

### DeselectAll

```freebasic
sub DeselectAll( byval hTab as HWND, byval fExcludeFocus as boolean )
```

Releases the tabs of a `TCS_BUTTONS` control that are shown pressed (`TCIS_BUTTONPRESSED`).
With `fExcludeFocus` `true` the tab with the focus stays pressed.

**Example**

```freebasic
TabCtl.DeselectAll( hCtrl, true )
```

Microsoft Learn: [TCM_DESELECTALL](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-deselectall)

### HighlightItem

```freebasic
function HighlightItem( byval hTab as HWND, byval idItem as long, byval fHighlight as WORD ) as long
```

Draws tab `idItem` highlighted (`fHighlight` nonzero) or normally (0), by setting or clearing
its `TCIS_HIGHLIGHTED` state.

**Returns** nonzero on success.

**Example**

```freebasic
TabCtl.HighlightItem( hCtrl, 1, 1 )   ' draw attention to the second tab
```

Microsoft Learn: [TCM_HIGHLIGHTITEM](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-highlightitem)

### GetItemRect

```freebasic
function GetItemRect overload( byval hTab as HWND, byval iItem as DWORD, byval prc as RECT ptr ) as boolean
function GetItemRect overload( byval hTab as HWND, byval iItem as DWORD, byref rc as RECT ) as boolean
function GetItemRect overload( byval hTab as HWND, byval iItem as DWORD ) as ( long, long, long, long )
```

Reads the rectangle of tab `iItem`, in client coordinates of the tab control. The tuple form
returns `( left, top, right, bottom )` and sets `GetLastError()` to 1 on success and 0 on
failure.

**Returns** `true` on success, or the four edges.

**Example**

```freebasic
var (l, t, r, b) = TabCtl.GetItemRect( hCtrl, 0 )
if GetLastError() then print "first tab:"; r - l; " x"; b - t
```

Microsoft Learn: [TCM_GETITEMRECT](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-getitemrect)

### AdjustRect

```freebasic
sub AdjustRect overload( byval hTab as HWND, byval fLarger as boolean, byval prc as RECT ptr )
sub AdjustRect overload( byval hTab as HWND, byval fLarger as boolean, byref rc as RECT )
```

Converts a rectangle in place. With `fLarger` `false` the rectangle is the control's window
rectangle and becomes the display area under the tabs; with `true` it is a display area and
becomes the window rectangle the control needs around it.

**Example**

```freebasic
dim rc as RECT
GetClientRect( hCtrl, @rc )
TabCtl.AdjustRect( hCtrl, false, rc )   ' rc is now the area the pages fill
```

Microsoft Learn: [TCM_ADJUSTRECT](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-adjustrect)

### HitTest

```freebasic
function HitTest overload( byval hTab as HWND, byval pInfo as TCHITTESTINFO ptr ) as long
function HitTest overload( byval hTab as HWND, byref info as TCHITTESTINFO ) as long
```

Finds the tab at `pt`, given in client coordinates of the tab control. `flags` receives where
the point is: `TCHT_NOWHERE`, `TCHT_ONITEMICON`, `TCHT_ONITEMLABEL` or `TCHT_ONITEM` (both).

**Returns** the index of the tab, or -1 when there is none at the point.

**Example**

```freebasic
dim hti as TCHITTESTINFO
GetCursorPos( @hti.pt ) : ScreenToClient( hCtrl, @hti.pt )
print "under the mouse: tab"; TabCtl.HitTest( hCtrl, hti )
```

Microsoft Learn: [TCM_HITTEST](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-hittest)

### GetRowCount

```freebasic
function GetRowCount( byval hTab as HWND ) as long
```

**Returns** the number of rows of tabs. Only a control with the `TCS_MULTILINE` style has more
than one.

**Example**

```freebasic
print TabCtl.GetRowCount( hCtrl ); " row(s) of tabs"
```

Microsoft Learn: [TCM_GETROWCOUNT](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-getrowcount)

### SetItemSize

```freebasic
function SetItemSize( byval hTab as HWND, byval x as long, byval y as long ) as DWORD
```

Sets the width `x` and height `y` of the tabs, in pixels. The width is used by a control with
the `TCS_FIXEDWIDTH` or `TCS_OWNERDRAWFIXED` style; the height by every control.

**Returns** the previous size: the width in the low word, the height in the high word.

**Example**

```freebasic
TabCtl.SetItemSize( hCtrl, 90, 26 )
```

Microsoft Learn: [TCM_SETITEMSIZE](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-setitemsize)

### SetMinTabWidth

```freebasic
function SetMinTabWidth( byval hTab as HWND, byval cx as long ) as long
```

Sets the smallest width a tab is drawn with, in pixels. -1 restores the control's default.

**Returns** the previous minimum width.

**Example**

```freebasic
TabCtl.SetMinTabWidth( hCtrl, 80 )
```

Microsoft Learn: [TCM_SETMINTABWIDTH](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-setmintabwidth)

### SetPadding

```freebasic
sub SetPadding( byval hTab as HWND, byval cx as integer, byval cy as integer )
```

Sets the space, in pixels, between each tab's edge and its icon and text: `cx` across, `cy`
down.

**Example**

```freebasic
TabCtl.SetPadding( hCtrl, 12, 4 )
```

Microsoft Learn: [TCM_SETPADDING](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-setpadding)

### SetItemExtra

```freebasic
function SetItemExtra( byval hTab as HWND, byval cb as long ) as boolean
```

Sets how many bytes of program data each tab carries in place of the pointer-sized `lParam`.
It works only while the control has no tabs. [CTabPage](CTabPage) keeps its address in
`lParam`, so do not change this on a control that holds tab pages.

**Returns** `true` on success.

**Example**

```freebasic
TabCtl.SetItemExtra( hCtrl, 16 )   ' before the first tab is added
```

Microsoft Learn: [TCM_SETITEMEXTRA](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-setitemextra)

### GetExtendedStyle

```freebasic
function GetExtendedStyle( byval hTab as HWND ) as DWORD
```

**Returns** the extended styles in use: `TCS_EX_FLATSEPARATORS`, `TCS_EX_REGISTERDROP`.

**Example**

```freebasic
print "flat separators:"; ( TabCtl.GetExtendedStyle( hCtrl ) and TCS_EX_FLATSEPARATORS ) <> 0
```

Microsoft Learn: [TCM_GETEXTENDEDSTYLE](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-getextendedstyle)

### SetExtendedStyle

```freebasic
function SetExtendedStyle( byval hTab as HWND, byval dwExStyle as DWORD ) as DWORD
```

Replaces all the extended styles with `dwExStyle`: a style left out is turned off.
`TCS_EX_FLATSEPARATORS` affects only a control with the `TCS_BUTTONS` and `TCS_FLATBUTTONS`
styles.

**Returns** the previous extended styles.

**Example**

```freebasic
TabCtl.SetExtendedStyle( hCtrl, TabCtl.GetExtendedStyle( hCtrl ) or TCS_EX_FLATSEPARATORS )
```

Microsoft Learn: [TCM_SETEXTENDEDSTYLE](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-setextendedstyle)

### GetImageList

```freebasic
function GetImageList( byval hTab as HWND ) as HIMAGELIST
```

**Returns** the control's image list, or `NULL` when it has none.

**Example**

```freebasic
dim himl as HIMAGELIST = TabCtl.GetImageList( hCtrl )
if himl then print ImageList_GetImageCount( himl ); " images"
```

Microsoft Learn: [TCM_GETIMAGELIST](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-getimagelist)

### SetImageList

```freebasic
function SetImageList( byval hTab as HWND, byval himl as HIMAGELIST ) as boolean
```

Assigns the image list the tabs take their icons from; `NULL` removes it. The control does not
destroy image lists: destroy yours when the control is gone. The control's reply, the previous
image list, comes back only as `true` (there was one) or `false`, so read it with
[GetImageList](#getimagelist) first if it must be destroyed.

**Returns** `true` when the control had an image list before.

**Example**

```freebasic
dim himl as HIMAGELIST = ImageList_Create( 16, 16, ILC_COLOR32 or ILC_MASK, 4, 0 )
dim hOld as HIMAGELIST = TabCtl.GetImageList( hCtrl )
TabCtl.SetImageList( hCtrl, himl )
if hOld then ImageList_Destroy( hOld )
```

Microsoft Learn: [TCM_SETIMAGELIST](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-setimagelist)

### GetImageIndex

```freebasic
function GetImageIndex( byval hTab as HWND, byval iItem as DWORD ) as long
```

**Returns** the index in the image list of the image tab `iItem` shows: -1 when it shows none,
and -1 when the tab does not exist.

**Example**

```freebasic
print "tab 0 shows image"; TabCtl.GetImageIndex( hCtrl, 0 )
```

Microsoft Learn: [TCM_GETITEM](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-getitem)

### SetImageIndex

```freebasic
function SetImageIndex( byval hTab as HWND, byval iItem as long, byval iImage as long ) as boolean
```

Makes tab `iItem` show image `iImage` of the image list; -1 shows none.

**Returns** `true` on success.

**Example**

```freebasic
TabCtl.SetImageIndex( hCtrl, 0, 2 )
```

Microsoft Learn: [TCM_SETITEM](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-setitem)

### RemoveImage

```freebasic
sub RemoveImage( byval hTab as HWND, byval iImage as long )
```

Removes image `iImage` from the control's image list. Tabs that showed a later image are
renumbered so they keep showing it; a tab that showed the removed image shows none.

**Example**

```freebasic
TabCtl.RemoveImage( hCtrl, 0 )
```

Microsoft Learn: [TCM_REMOVEIMAGE](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-removeimage)

### GetToolTips

```freebasic
function GetToolTips( byval hTab as HWND ) as HWND
```

**Returns** the tooltip control of a tab control with the `TCS_TOOLTIPS` style, or `NULL`.

**Example**

```freebasic
dim hTip as HWND = TabCtl.GetToolTips( hCtrl )
if hTip = NULL then print "no tooltips"
```

Microsoft Learn: [TCM_GETTOOLTIPS](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-gettooltips)

### SetToolTips

```freebasic
sub SetToolTips( byval hTab as HWND, byval hwndTT as HWND )
```

Makes `hwndTT` the control's tooltip control.

**Example**

```freebasic
TabCtl.SetToolTips( hCtrl, CreateWindowExW( 0, TOOLTIPS_CLASSW, NULL, TTS_ALWAYSTIP, 0, 0, 0, 0, hwnd, NULL, NULL, NULL ) )
```

Microsoft Learn: [TCM_SETTOOLTIPS](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-settooltips)

### ResizePages

```freebasic
function ResizePages( byval hTab as HWND ) as boolean
```

Moves and sizes the [CTabPage](CTabPage) of every tab to fill the control's display area. Call
it after the tab control itself has been resized, typically in the parent's `WM_SIZE`. Tabs
whose `lParam` is 0 are skipped.

**Returns** `true` when it went through the tabs; `false` when `hTab` is `NULL` or the control
has no tabs.

**Example**

```freebasic
MoveWindow( hCtrl, 10, 10, 500, 300, true )
TabCtl.ResizePages( hCtrl )
```

### DestroyPage

```freebasic
function DestroyPage( byval hTab as HWND, byval idx as long ) as boolean
```

Deletes the [CTabPage](CTabPage) object of tab `idx` with `delete`; its destructor removes the
tab and destroys the page window. The page must have been created with `new`. The `lParam` of
the tab is taken to be the page's address, so call this only on tabs that
`CTabPage.InsertPage` added.

**Returns** `true` when a page was deleted; `false` when `hTab` is `NULL`, the tab does not
exist or its `lParam` is 0.

**Example**

```freebasic
TabCtl.DestroyPage( hCtrl, TabCtl.GetCurSel( hCtrl ) )
```

### DestroyAllPages

```freebasic
function DestroyAllPages( byval hTab as HWND ) as boolean
```

Deletes the [CTabPage](CTabPage) of the first tab, again and again, until the control has no
tabs left. Every tab must be one that `CTabPage.InsertPage` added: a tab whose `lParam` is 0 is
never removed, so the loop goes on for ever, and any other nonzero `lParam` is deleted as if it
were a page.

**Returns** `true` when at least one page was deleted; `false` when `hTab` is `NULL` or the
control had no tabs.

**Example**

```freebasic
TabCtl.DestroyAllPages( GetDlgItem( hwnd, 1001 ) )   ' in WM_DESTROY
```

## See also

- [sys/win/gui](SysWin-Gui)
- [CTabPage](CTabPage) for the pages and `CTabPagePtr`
- [CWindow](CWindow) for `AddControl( "Tab", ... )`
- [PropSheet](SysWin-Gui-PropSheet)
- [gui macros and helpers](SysWin-Gui-Procedures) for reading `WM_NOTIFY`
