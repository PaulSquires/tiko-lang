[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gui](SysWin-Gui) › **Combo**

# Combo

Adds, finds, selects and reads the items of a combo box, and sets its list and edit box.

A combo box is a list with a selection field above it. With `CBS_DROPDOWN` the field is an edit
box the user can type into and the list drops down; with `CBS_DROPDOWNLIST` the field only shows
the selected item; with `CBS_SIMPLE` the list is always open. Every function here takes the
control's handle first and is written with the namespace: `Combo.AddString( hCombo, "Pear" )`.
`CWindow.AddControl( "ComboBox", ... )` creates a drop-down combo box whose list is sorted
(`CBS_DROPDOWN or CBS_SORT`); the height you give it is the height with the list dropped down.

Items are numbered from 0. An item has a text and a value of your own (its *item data*, a
`LONG_PTR`), which the control stores but never uses. Functions that fail return `CB_ERR` (-1);
those that add text return `CB_ERRSPACE` (-2) when memory runs out. The control owns its items
and frees them when they are deleted or the control is destroyed; what an item data value points
to is yours to free.

The cue banner functions need version 6 of the common controls, which a program selects with a
manifest or by calling `EnableVisualStyles()` before it creates the control. For a combo box with
an image beside each item, see [CBEx](SysWin-Gui-CBEx).

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui
```

## Example

A sorted drop-down list of fruit, each item carrying a price in cents. Choosing one puts its text
and price in the caption.

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

const IDC_FRUIT = 101

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    EnableVisualStyles()
    dim pWindow as CWindow = "ComboDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Combo", @WndProc )
    pWindow.SetClientSize( 300, 220 )
    pWindow.Center()
    dim hCombo as HWND = pWindow.AddControl( "ComboBox", hWin, IDC_FRUIT, "", 10, 10, 280, 200, _
                                             WS_CHILD or WS_VISIBLE or WS_VSCROLL or WS_TABSTOP or CBS_DROPDOWNLIST or CBS_HASSTRINGS or CBS_SORT )
    Combo.SetItemData( hCombo, Combo.AddString( hCombo, "Pear" ), 120 )
    Combo.SetItemData( hCombo, Combo.AddString( hCombo, "Apple" ), 95 )
    Combo.SetItemData( hCombo, Combo.AddString( hCombo, "Banana" ), 40 )
    Combo.SetItemData( hCombo, Combo.AddString( hCombo, "Cherry" ), 300 )
    Combo.SetCueBannerText( hCombo, "Choose a fruit" )
    Combo.SetMinVisible( hCombo, 4 )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_COMMAND
            if CBCTL( wParam, lParam ) = IDC_FRUIT andalso CBCTLMSG( wParam, lParam ) = CBN_SELCHANGE then
                dim hCombo as HWND = cast( HWND, lParam )
                SetWindowText( hwnd, Combo.GetLbText( hCombo, -1 ) & ": " & Combo.GetItemData( hCombo, -1 ) & " cents" )
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

## Functions

| Function | Does |
| --- | --- |
| [AddString](#addstring) | Adds an item, in sorted order or at the end. |
| [InsertString](#insertstring) | Inserts an item at a position. |
| [DeleteString](#deletestring) | Deletes an item. |
| [ResetContent](#resetcontent) | Deletes every item and clears the edit box. |
| [Dir](#dir) | Adds file, folder and drive names. |
| [GetCount](#getcount) | Returns the number of items. |
| [GetLbText](#getlbtext) | Returns the text of an item or of the selected item. |
| [GetLbTextLen](#getlbtextlen) | Returns the length of an item's text. |
| [GetText](#gettext) | Returns the text of the selection field or of an item. |
| [GetTextLength](#gettextlength) | Returns the length of the selection field's or an item's text. |
| [SetText](#settext) | Sets the text of the selection field or replaces an item. |
| [ReplaceText](#replacetext) | Replaces an item's text. |
| [GetItemData](#getitemdata) | Returns an item's value. |
| [SetItemData](#setitemdata) | Sets an item's value. |
| [FindString](#findstring) | Finds an item that begins with a text. |
| [FindStringExact](#findstringexact) | Finds an item whose whole text matches. |
| [SelectString](#selectstring) | Finds and selects an item that begins with a text. |
| [GetCurSel](#getcursel) | Returns the selected item. |
| [SetCurSel](#setcursel) | Selects an item. |
| [UnselectString](#unselectstring) | Clears the selection. |
| [GetState](#getstate) | Tells whether an item is the selected one. |
| [GetSelCount](#getselcount) | Returns 1 when an item is selected, 0 otherwise. |
| [GetEditSel](#geteditsel) | Reads the selection in the edit box. |
| [SetEditSel](#seteditsel) | Selects characters in the edit box. |
| [LimitText](#limittext) | Limits how much the user can type. |
| [GetCueBannerText](#getcuebannertext) | Returns or reads the cue banner text. |
| [SetCueBannerText](#setcuebannertext) | Sets the grey hint shown while nothing is chosen. |
| [ShowDropDown](#showdropdown) | Drops the list down. |
| [HideDropDown](#hidedropdown) | Closes the list. |
| [GetDroppedState](#getdroppedstate) | Tells whether the list is dropped down. |
| [GetDroppedControlRect](#getdroppedcontrolrect) | Returns the rectangle of the control with its list dropped down. |
| [GetDroppedWidth](#getdroppedwidth) | Returns the width of the list. |
| [SetDroppedWidth](#setdroppedwidth) | Sets the smallest width of the list. |
| [GetMinVisible](#getminvisible) | Returns how many items the list shows. |
| [SetMinVisible](#setminvisible) | Sets how many items the list shows. |
| [GetTopIndex](#gettopindex) | Returns the first visible item of the list. |
| [SetTopIndex](#settopindex) | Scrolls the list to an item. |
| [GetItemHeight](#getitemheight) | Returns the height of the list items. |
| [SetItemHeight](#setitemheight) | Sets the height of the list items or of the selection field. |
| [GetHorizontalExtent](#gethorizontalextent) | Returns how far the list scrolls sideways. |
| [SetHorizontalExtent](#sethorizontalextent) | Sets how far the list scrolls sideways. |
| [CalcHorizontalExtent](#calchorizontalextent) | Measures the widest item. |
| [GetExtendedUI](#getextendedui) | Tells whether the extended keyboard interface is on. |
| [SetExtendedUI](#setextendedui) | Turns the extended keyboard interface on or off. |
| [GetLocale](#getlocale) | Returns the locale used for sorting. |
| [SetLocale](#setlocale) | Sets the locale used for sorting. |
| [GetComboBoxInfo](#getcomboboxinfo) | Returns the parts of the combo box. |
| [GetEditBoxHandle](#geteditboxhandle) | Returns the edit box. |
| [GetListBoxHandle](#getlistboxhandle) | Returns the drop-down list. |
| [Enable](#enable) | Enables the control. |
| [Disable](#disable) | Disables the control. |
| [SetDarkMode](#setdarkmode) | Gives the control the dark theme. |
| [RemoveDarkMode](#removedarkmode) | Gives the control back its normal theme. |

## Reference

### AddString

```freebasic
function AddString( byval hCombo as HWND, byval pwszText as wstring ptr ) as long
```

Adds an item with the text `pwszText`. In a combo box with `CBS_SORT` it goes to its place in
the sorted list, otherwise to the end.

**Returns** the index of the new item, `CB_ERR` or `CB_ERRSPACE`.

**Example**

```freebasic
dim i as long = Combo.AddString( hCtrl, "Banana" )
Combo.SetItemData( hCtrl, i, 40 )
```

Microsoft Learn: [CB_ADDSTRING](https://learn.microsoft.com/en-us/windows/win32/controls/cb-addstring)

### InsertString

```freebasic
function InsertString( byval hCombo as HWND, byval index as long, byval pwszText as wstring ptr ) as long
```

Inserts an item at position `index`, or at the end with -1. The list is not sorted, even with
`CBS_SORT`.

**Returns** the index of the new item, `CB_ERR` or `CB_ERRSPACE`.

**Example**

```freebasic
Combo.InsertString( hCtrl, 0, "(none)" )
```

Microsoft Learn: [CB_INSERTSTRING](https://learn.microsoft.com/en-us/windows/win32/controls/cb-insertstring)

### DeleteString

```freebasic
function DeleteString( byval hCombo as HWND, byval index as long ) as long
```

Deletes the item at `index`. The items after it move up by one.

**Returns** the number of items left, or `CB_ERR` when `index` is out of range.

**Example**

```freebasic
if Combo.GetCurSel( hCtrl ) <> CB_ERR then Combo.DeleteString( hCtrl, Combo.GetCurSel( hCtrl ) )
```

Microsoft Learn: [CB_DELETESTRING](https://learn.microsoft.com/en-us/windows/win32/controls/cb-deletestring)

### ResetContent

```freebasic
sub ResetContent( byval hCombo as HWND )
```

Deletes every item and empties the edit box.

**Example**

```freebasic
Combo.ResetContent( hCtrl )
```

Microsoft Learn: [CB_RESETCONTENT](https://learn.microsoft.com/en-us/windows/win32/controls/cb-resetcontent)

### Dir

```freebasic
function Dir( byval hCombo as HWND, byval attr as UINT, byval pwszFileSpec as wstring ptr ) as long
```

Adds the names of the files and folders that match `pwszFileSpec` and have the attributes in
`attr`. Folder names are added in square brackets, drives as `[-c-]`.

| Parameter | Meaning |
| --- | --- |
| `hCombo` | The combo box. |
| `attr` | `DDL_READWRITE` for ordinary files, combined with `DDL_DIRECTORY`, `DDL_DRIVES`, `DDL_HIDDEN`, `DDL_SYSTEM`, `DDL_ARCHIVE`, `DDL_READONLY` or `DDL_EXCLUSIVE` (only the attributes given). |
| `pwszFileSpec` | A path with wildcards, such as `"C:\Windows\*.exe"`. |

**Returns** the index of the last name added, `CB_ERR` or `CB_ERRSPACE`.

**Example**

```freebasic
Combo.Dir( hCtrl, DDL_READWRITE or DDL_DIRECTORY, "*.tiko" )
```

Microsoft Learn: [CB_DIR](https://learn.microsoft.com/en-us/windows/win32/controls/cb-dir)

### GetCount

```freebasic
function GetCount( byval hCombo as HWND ) as long
```

Returns the number of items.

**Returns** the count, or `CB_ERR`.

**Example**

```freebasic
for i as long = 0 to Combo.GetCount( hCtrl ) - 1
    print Combo.GetLbText( hCtrl, i )
next
```

Microsoft Learn: [CB_GETCOUNT](https://learn.microsoft.com/en-us/windows/win32/controls/cb-getcount)

### GetLbText

```freebasic
function GetLbText( byval hCombo as HWND, byval index as long ) as ustring
```

Returns the text of the item at `index`, or of the selected item when `index` is negative. The
string is exactly the item's text.

**Returns** the text, or `""` when there is no such item (or no selection). `GetLastError()` is
the number of characters copied.

**Example**

```freebasic
print "chosen: "; Combo.GetLbText( hCtrl, -1 )
```

Microsoft Learn: [CB_GETLBTEXT](https://learn.microsoft.com/en-us/windows/win32/controls/cb-getlbtext)

### GetLbTextLen

```freebasic
function GetLbTextLen( byval hCombo as HWND, byval index as long ) as long
```

Returns the length of the text of the item at `index`.

**Returns** the length in characters, or `CB_ERR` when `index` is out of range.

**Example**

```freebasic
print Combo.GetLbTextLen( hCtrl, 0 )
```

Microsoft Learn: [CB_GETLBTEXTLEN](https://learn.microsoft.com/en-us/windows/win32/controls/cb-getlbtextlen)

### GetText

```freebasic
function GetText overload( byval hCombo as HWND ) as ustring
function GetText overload( byval hCombo as HWND, byval index as long ) as ustring
```

The first form returns the text of the selection field: what the user typed, or the selected
item. The second returns the text of the item at `index`. Both strings are one character longer
than the text: their last character is the null character that ends it, so `len()` is one more
than [GetTextLength](#gettextlength) and text joined after the string is lost when it is passed
back to Windows. Remove it with `rtrim( ..., chr(0) )`, or use [GetLbText](#getlbtext) for an
item.

**Returns** the text and its terminating null; for an `index` out of range, `""` with -1 in
`GetLastError()`.

**Example**

```freebasic
dim sTyped as ustring = rtrim( Combo.GetText( hCtrl ), chr(0) )
dim sFirst as ustring = rtrim( Combo.GetText( hCtrl, 0 ), chr(0) )
```

Microsoft Learn: [GetWindowTextW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindowtextw), [CB_GETLBTEXT](https://learn.microsoft.com/en-us/windows/win32/controls/cb-getlbtext)

### GetTextLength

```freebasic
function GetTextLength overload( byval hCombo as HWND ) as long
function GetTextLength overload( byval hCombo as HWND, byval index as long ) as long
```

The first form returns the length of the selection field's text; the second, the length of the
text of the item at `index`, as [GetLbTextLen](#getlbtextlen).

**Returns** the length in characters (`CB_ERR` for an `index` out of range).

**Example**

```freebasic
if Combo.GetTextLength( hCtrl ) = 0 then print "nothing typed"
```

Microsoft Learn: [GetWindowTextLengthW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindowtextlengthw)

### SetText

```freebasic
function SetText overload( byval hCombo as HWND, byval pwszText as wstring ptr ) as boolean
function SetText overload( byval hCombo as HWND, byval index as long, byval pwszText as wstring ptr ) as long
```

The first form sets the text of the edit box of a `CBS_DROPDOWN` or `CBS_SIMPLE` combo box. The
second replaces the item at `index` by deleting it and inserting a new one in its place, so the
item's value set with [SetItemData](#setitemdata) becomes 0, the selection is cleared if it was
on that item, and the list is not re-sorted.

**Returns** `true` on success (first form); the index of the new item, or `CB_ERR` when `index`
is out of range (second form).

**Example**

```freebasic
Combo.SetText( hCtrl, "typed text" )
Combo.SetText( hCtrl, 1, "Avocado" )
```

Microsoft Learn: [SetWindowTextW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setwindowtextw)

### ReplaceText

```freebasic
function ReplaceText( byval hCombo as HWND, byval index as long, byval pwszText as wstring ptr ) as long
```

Replaces the item at `index`: the same as the second form of [SetText](#settext), item value and
selection included.

**Returns** the index of the new item, or `CB_ERR` when `index` is out of range.

**Example**

```freebasic
dim nData as LONG_PTR = Combo.GetItemData( hCtrl, 2 )
Combo.ReplaceText( hCtrl, 2, "Blood orange" )
Combo.SetItemData( hCtrl, 2, nData )
```

### GetItemData

```freebasic
function GetItemData( byval hCombo as HWND, byval index as long ) as LONG_PTR
```

Returns the value stored with the item at `index`, or with the selected item when `index` is
negative.

**Returns** the value (0 when none was set), or `CB_ERR`.

**Example**

```freebasic
print "price"; Combo.GetItemData( hCtrl, -1 )
```

Microsoft Learn: [CB_GETITEMDATA](https://learn.microsoft.com/en-us/windows/win32/controls/cb-getitemdata)

### SetItemData

```freebasic
function SetItemData( byval hCombo as HWND, byval index as long, byval nData as LONG_PTR ) as long
```

Stores `nData` with the item at `index`: a number, or a pointer to data of your own, which the
control does not free.

**Returns** `CB_ERR` on failure.

**Example**

```freebasic
Combo.SetItemData( hCtrl, Combo.AddString( hCtrl, "Pear" ), 120 )
```

Microsoft Learn: [CB_SETITEMDATA](https://learn.microsoft.com/en-us/windows/win32/controls/cb-setitemdata)

### FindString

```freebasic
function FindString( byval hCombo as HWND, byval start as long, byval pwszText as wstring ptr ) as long
```

Finds the first item whose text begins with `pwszText`, ignoring case. The search starts after
item `start` (-1 searches from the top) and wraps round to the beginning.

**Returns** the index of the item found, or `CB_ERR`.

**Example**

```freebasic
print Combo.FindString( hCtrl, -1, "ba" )   ' finds "Banana"
```

Microsoft Learn: [CB_FINDSTRING](https://learn.microsoft.com/en-us/windows/win32/controls/cb-findstring)

### FindStringExact

```freebasic
function FindStringExact( byval hCombo as HWND, byval start as long, byval pwszText as wstring ptr ) as long
```

Finds the first item whose whole text is `pwszText`, ignoring case, searching as
[FindString](#findstring) does.

**Returns** the index of the item found, or `CB_ERR`.

**Example**

```freebasic
if Combo.FindStringExact( hCtrl, -1, "banana" ) = CB_ERR then Combo.AddString( hCtrl, "Banana" )
```

Microsoft Learn: [CB_FINDSTRINGEXACT](https://learn.microsoft.com/en-us/windows/win32/controls/cb-findstringexact)

### SelectString

```freebasic
function SelectString( byval hCombo as HWND, byval index as long, byval pwszText as wstring ptr ) as long
```

Finds the first item after `index` that begins with `pwszText`, as [FindString](#findstring)
does, selects it and shows its text in the selection field. Nothing changes when no item
matches.

**Returns** the index of the item selected, or `CB_ERR`.

**Example**

```freebasic
Combo.SelectString( hCtrl, -1, "pe" )   ' selects "Pear"
```

Microsoft Learn: [CB_SELECTSTRING](https://learn.microsoft.com/en-us/windows/win32/controls/cb-selectstring)

### GetCurSel

```freebasic
function GetCurSel( byval hCombo as HWND ) as long
```

Returns the selected item.

**Returns** its index, or `CB_ERR` when no item is selected.

**Example**

```freebasic
dim i as long = Combo.GetCurSel( hCtrl )
if i <> CB_ERR then print "item"; i
```

Microsoft Learn: [CB_GETCURSEL](https://learn.microsoft.com/en-us/windows/win32/controls/cb-getcursel)

### SetCurSel

```freebasic
function SetCurSel( byval hCombo as HWND, byval index as long ) as long
```

Selects the item at `index`, scrolls it into view and shows its text in the selection field; -1
clears the selection. The parent is not sent `CBN_SELCHANGE`.

**Returns** `index`, or `CB_ERR` when it is -1 or out of range.

**Example**

```freebasic
Combo.SetCurSel( hCtrl, 0 )
```

Microsoft Learn: [CB_SETCURSEL](https://learn.microsoft.com/en-us/windows/win32/controls/cb-setcursel)

### UnselectString

```freebasic
function UnselectString( byval hCombo as HWND ) as long
```

Clears the selection and the selection field: [SetCurSel](#setcursel) with -1.

**Returns** `CB_ERR`, always.

**Example**

```freebasic
Combo.UnselectString( hCtrl )
```

### GetState

```freebasic
function GetState( byval hCombo as HWND, byval item as long ) as boolean
```

Tells whether the item at `item` is the selected item.

**Returns** `true` when it is.

**Example**

```freebasic
if Combo.GetState( hCtrl, 0 ) then print "the first item is selected"
```

### GetSelCount

```freebasic
function GetSelCount( byval hCombo as HWND ) as long
```

Returns how many items are selected: a combo box has at most one.

**Returns** 1 when an item is selected, 0 otherwise.

**Example**

```freebasic
if Combo.GetSelCount( hCtrl ) = 0 then print "nothing chosen"
```

### GetEditSel

```freebasic
sub GetEditSel overload( byval hCombo as HWND, byref dwStart as DWORD, byref dwEnd as DWORD ) as DWORD
sub GetEditSel overload( byval hCombo as HWND, byval pdwStart as DWORD ptr, byval pdwEnd as DWORD ptr ) as DWORD
```

Reads the selection in the edit box: where it starts, and the first character after it. Although
it is declared `as DWORD`, it is a `sub`: it gives no value back, and using it in an expression
does not compile. Read the positions from the variables.

**Example**

```freebasic
dim as DWORD nStart, nEnd
Combo.GetEditSel( hCtrl, nStart, nEnd )
print nEnd - nStart; " characters selected"
```

Microsoft Learn: [CB_GETEDITSEL](https://learn.microsoft.com/en-us/windows/win32/controls/cb-geteditsel)

### SetEditSel

```freebasic
function SetEditSel( byval hCombo as HWND, byval nStart as short, byval nEnd as short ) as long
```

Selects the characters from `nStart` up to, not including, `nEnd` in the edit box. An `nStart` of
-1 removes the selection; an `nEnd` of -1 selects to the end.

**Returns** `TRUE` on success, `CB_ERR` for a `CBS_DROPDOWNLIST` combo box.

**Example**

```freebasic
Combo.SetEditSel( hCtrl, 0, -1 )   ' select all the typed text
```

Microsoft Learn: [CB_SETEDITSEL](https://learn.microsoft.com/en-us/windows/win32/controls/cb-seteditsel)

### LimitText

```freebasic
sub LimitText( byval hCombo as HWND, byval chLimit as long )
```

Sets the most characters the user can type into the edit box; 0 removes the limit. Text already
there is not cut. `GetLastError()` is 1 afterwards on success.

**Example**

```freebasic
Combo.LimitText( hCtrl, 20 )
```

Microsoft Learn: [CB_LIMITTEXT](https://learn.microsoft.com/en-us/windows/win32/controls/cb-limittext)

### GetCueBannerText

```freebasic
function GetCueBannerText overload( byval hCombo as HWND, byval pwszText as wstring ptr, byval cchText as DWORD ) as boolean
function GetCueBannerText overload( byval hCombo as HWND, byval cchText as DWORD = MAX_PATH ) as ustring
```

Reads the cue banner set with [SetCueBannerText](#setcuebannertext). The first form fills your
buffer of `cchText` characters. The second returns a string of `cchText + 1` characters (261 by
default): the hint, a null character and spaces to the end; cut it at the null.

**Returns** `true` on success (first form); the padded string, with the message's result in
`GetLastError()` (second form).

**Example**

```freebasic
dim sCue as ustring = Combo.GetCueBannerText( hCtrl )
print left( sCue, instr( sCue, chr(0) ) - 1 )
```

Microsoft Learn: [CB_GETCUEBANNER](https://learn.microsoft.com/en-us/windows/win32/controls/cb-getcuebanner)

### SetCueBannerText

```freebasic
function SetCueBannerText( byval hCombo as HWND, byval pwszText as wstring ptr ) as long
```

Sets a hint, drawn in grey in the selection field while it is empty, that tells the user what to
choose or type.

**Returns** 1 on success.

**Example**

```freebasic
Combo.SetCueBannerText( hCtrl, "Choose a fruit" )
```

Microsoft Learn: [CB_SETCUEBANNER](https://learn.microsoft.com/en-us/windows/win32/controls/cb-setcuebanner)

### ShowDropDown

```freebasic
sub ShowDropDown( byval hCombo as HWND )
```

Drops the list of a `CBS_DROPDOWN` or `CBS_DROPDOWNLIST` combo box down.

**Example**

```freebasic
SetFocus( hCtrl )
Combo.ShowDropDown( hCtrl )
```

Microsoft Learn: [CB_SHOWDROPDOWN](https://learn.microsoft.com/en-us/windows/win32/controls/cb-showdropdown)

### HideDropDown

```freebasic
sub HideDropDown( byval hCombo as HWND )
```

Closes the dropped-down list.

**Example**

```freebasic
if Combo.GetDroppedState( hCtrl ) then Combo.HideDropDown( hCtrl )
```

Microsoft Learn: [CB_SHOWDROPDOWN](https://learn.microsoft.com/en-us/windows/win32/controls/cb-showdropdown)

### GetDroppedState

```freebasic
function GetDroppedState( byval hCombo as HWND ) as boolean
```

Tells whether the list is dropped down.

**Returns** `true` while it is open.

**Example**

```freebasic
print "open: "; Combo.GetDroppedState( hCtrl )
```

Microsoft Learn: [CB_GETDROPPEDSTATE](https://learn.microsoft.com/en-us/windows/win32/controls/cb-getdroppedstate)

### GetDroppedControlRect

```freebasic
sub GetDroppedControlRect overload( byval hCombo as HWND, byval prc as RECT ptr )
sub GetDroppedControlRect overload( byval hCombo as HWND, byref rc as RECT )
function GetDroppedControlRect overload( byval hCombo as HWND ) as ( long, long, long, long )
```

Reads the rectangle, in screen coordinates, that the combo box covers with its list dropped
down, whether it is open or not. The first two forms fill your `RECT`; the third returns
`( left, top, right, bottom )`. Each sets `GetLastError()` to 1 on success.

**Returns** the four edges (third form).

**Example**

```freebasic
var (l, t, r, b) = Combo.GetDroppedControlRect( hCtrl )
if GetLastError() then print "dropped:"; r - l; " x"; b - t
```

Microsoft Learn: [CB_GETDROPPEDCONTROLRECT](https://learn.microsoft.com/en-us/windows/win32/controls/cb-getdroppedcontrolrect)

### GetDroppedWidth

```freebasic
function GetDroppedWidth( byval hCombo as HWND ) as long
```

Returns the width of the drop-down list in pixels: the width of the control unless
[SetDroppedWidth](#setdroppedwidth) made it wider.

**Returns** the width, or `CB_ERR`.

**Example**

```freebasic
print Combo.GetDroppedWidth( hCtrl )
```

Microsoft Learn: [CB_GETDROPPEDWIDTH](https://learn.microsoft.com/en-us/windows/win32/controls/cb-getdroppedwidth)

### SetDroppedWidth

```freebasic
function SetDroppedWidth( byval hCombo as HWND, byval nWidth as long ) as long
```

Sets the smallest width, in pixels, of the drop-down list of a `CBS_DROPDOWN` or
`CBS_DROPDOWNLIST` combo box. The list is never narrower than the control.

**Returns** the new width, or `CB_ERR`.

**Example**

```freebasic
Combo.SetDroppedWidth( hCtrl, Combo.CalcHorizontalExtent( hCtrl ) + 24 )
```

Microsoft Learn: [CB_SETDROPPEDWIDTH](https://learn.microsoft.com/en-us/windows/win32/controls/cb-setdroppedwidth)

### GetMinVisible

```freebasic
function GetMinVisible( byval hCombo as HWND ) as long
```

Returns how many items the drop-down list shows before it needs a scroll bar: 30 unless set.

**Returns** the number of items.

**Example**

```freebasic
print Combo.GetMinVisible( hCtrl )
```

Microsoft Learn: [CB_GETMINVISIBLE](https://learn.microsoft.com/en-us/windows/win32/controls/cb-getminvisible)

### SetMinVisible

```freebasic
function SetMinVisible( byval hCombo as HWND, byval iMinVisible as long ) as long
```

Sets how many items the drop-down list shows before it needs a scroll bar. The list is shorter
when there are fewer items.

**Returns** nonzero on success.

**Example**

```freebasic
Combo.SetMinVisible( hCtrl, 8 )
```

Microsoft Learn: [CB_SETMINVISIBLE](https://learn.microsoft.com/en-us/windows/win32/controls/cb-setminvisible)

### GetTopIndex

```freebasic
function GetTopIndex( byval hCombo as HWND ) as long
```

Returns the item at the top of the list, 0 until the list is scrolled.

**Returns** its index, or `CB_ERR`.

**Example**

```freebasic
print "first visible item"; Combo.GetTopIndex( hCtrl )
```

Microsoft Learn: [CB_GETTOPINDEX](https://learn.microsoft.com/en-us/windows/win32/controls/cb-gettopindex)

### SetTopIndex

```freebasic
function SetTopIndex( byval hCombo as HWND, byval index as long ) as long
```

Scrolls the list so that the item at `index` is at the top, or as near the top as the end of the
list allows.

**Returns** 0 on success, `CB_ERR` on failure.

**Example**

```freebasic
Combo.SetTopIndex( hCtrl, Combo.GetCount( hCtrl ) - 1 )
```

Microsoft Learn: [CB_SETTOPINDEX](https://learn.microsoft.com/en-us/windows/win32/controls/cb-settopindex)

### GetItemHeight

```freebasic
function GetItemHeight( byval hCombo as HWND ) as long
```

Returns the height of the items in the list, in pixels. (The height of the selection field,
which [SetItemHeight](#setitemheight) can set with index -1, is not read here.)

**Returns** the height, or `CB_ERR`.

**Example**

```freebasic
print "rows of"; Combo.GetItemHeight( hCtrl ); " pixels"
```

Microsoft Learn: [CB_GETITEMHEIGHT](https://learn.microsoft.com/en-us/windows/win32/controls/cb-getitemheight)

### SetItemHeight

```freebasic
function SetItemHeight( byval hCombo as HWND, byval index as long, byval nHeight as long ) as long
```

Sets the height, in pixels, of the items in the list (`index` 0), or of the selection field
(`index` -1). In an owner-drawn `CBS_OWNERDRAWVARIABLE` combo box, `index` is the item whose
height to set.

**Returns** `CB_ERR` when the height is invalid.

**Example**

```freebasic
Combo.SetItemHeight( hCtrl, 0, 20 )
Combo.SetItemHeight( hCtrl, -1, 24 )
```

Microsoft Learn: [CB_SETITEMHEIGHT](https://learn.microsoft.com/en-us/windows/win32/controls/cb-setitemheight)

### GetHorizontalExtent

```freebasic
function GetHorizontalExtent( byval hCombo as HWND ) as long
```

Returns how wide, in pixels, the list can be scrolled sideways: 0 unless set.

**Returns** the scrollable width.

**Example**

```freebasic
print Combo.GetHorizontalExtent( hCtrl )
```

Microsoft Learn: [CB_GETHORIZONTALEXTENT](https://learn.microsoft.com/en-us/windows/win32/controls/cb-gethorizontalextent)

### SetHorizontalExtent

```freebasic
sub SetHorizontalExtent( byval hCombo as HWND, byval nWidth as long )
```

Sets how wide, in pixels, the list can be scrolled sideways. When the list is narrower than
`nWidth` and has `WS_HSCROLL`, its horizontal scroll bar scrolls the items; otherwise the scroll
bar is hidden, or disabled with `CBS_DISABLENOSCROLL`.

**Example**

```freebasic
Combo.SetHorizontalExtent( hCtrl, Combo.CalcHorizontalExtent( hCtrl ) )
```

Microsoft Learn: [CB_SETHORIZONTALEXTENT](https://learn.microsoft.com/en-us/windows/win32/controls/cb-sethorizontalextent)

### CalcHorizontalExtent

```freebasic
function CalcHorizontalExtent( byval hCombo as HWND ) as long
```

Measures the text of every item and returns the width of the widest, in pixels, for
[SetHorizontalExtent](#sethorizontalextent) or [SetDroppedWidth](#setdroppedwidth).

It measures with the device context's default font, not the control's: a font set with
`WM_SETFONT` does not change the result. It also reads each item into a buffer one character
too short for the text and its terminating null, so each call writes two bytes past a heap block
per item; programs that call it have ended later at an unrelated point. Measure with
`GetTextExtentPoint32W` in a device context holding the control's font instead.

**Returns** the width of the widest item, 0 for an empty list.

**Example**

```freebasic
dim cx as long = Combo.CalcHorizontalExtent( hCtrl )
```

Microsoft Learn: [GetTextExtentPoint32W](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-gettextextentpoint32w)

### GetExtendedUI

```freebasic
function GetExtendedUI( byval hCombo as HWND ) as boolean
```

Tells whether the combo box uses the extended keyboard interface, in which `F4` and `Down` open
the list and the arrow keys do not change the selection of a closed `CBS_DROPDOWNLIST` combo
box.

**Returns** `true` for the extended interface.

**Example**

```freebasic
print Combo.GetExtendedUI( hCtrl )
```

Microsoft Learn: [CB_GETEXTENDEDUI](https://learn.microsoft.com/en-us/windows/win32/controls/cb-getextendedui)

### SetExtendedUI

```freebasic
function SetExtendedUI( byval hCombo as HWND, byval flag as boolean ) as long
```

Turns the extended keyboard interface of a `CBS_DROPDOWN` or `CBS_DROPDOWNLIST` combo box on
(`true`) or off.

**Returns** `CB_OKAY` (0) on success.

**Example**

```freebasic
Combo.SetExtendedUI( hCtrl, true )
```

Microsoft Learn: [CB_SETEXTENDEDUI](https://learn.microsoft.com/en-us/windows/win32/controls/cb-setextendedui)

### GetLocale

```freebasic
function GetLocale( byval hCombo as HWND ) as long
```

Returns the locale whose rules sort the items of a `CBS_SORT` combo box: the user's locale
unless set.

**Returns** the locale identifier.

**Example**

```freebasic
print hex( Combo.GetLocale( hCtrl ) )
```

Microsoft Learn: [CB_GETLOCALE](https://learn.microsoft.com/en-us/windows/win32/controls/cb-getlocale)

### SetLocale

```freebasic
function SetLocale( byval hCombo as HWND, byval lcid as long ) as long
```

Sets the locale whose rules sort the items that [AddString](#addstring) adds to a `CBS_SORT`
combo box. Items already in the list are not re-sorted.

**Returns** the previous locale, or `CB_ERR` when `lcid` is not installed (the locale is then
unchanged).

**Example**

```freebasic
Combo.SetLocale( hCtrl, &h40C )   ' French (France)
```

Microsoft Learn: [CB_SETLOCALE](https://learn.microsoft.com/en-us/windows/win32/controls/cb-setlocale)

### GetComboBoxInfo

```freebasic
function GetComboBoxInfo overload( byval hCombo as HWND, byval pcbi as COMBOBOXINFO ptr ) as boolean
function GetComboBoxInfo overload( byval hCombo as HWND, byref cbi as COMBOBOXINFO ) as boolean
function GetComboBoxInfo overload( byval hCombo as HWND ) as COMBOBOXINFO
```

Reads a `COMBOBOXINFO`: the rectangles of the selection field and of the drop-down button, the
button's state, and the handles of the combo box's edit box (`hwndItem`) and list (`hwndList`).
`cbSize` is set for you. The first two forms fill your structure (the pointer form returns
`false` for `NULL`); the third returns one, with 1 in `GetLastError()` on success.

**Returns** `true` on success (first two forms), or the structure (third form).

**Example**

```freebasic
dim cbi as COMBOBOXINFO = Combo.GetComboBoxInfo( hCtrl )
print "button"; cbi.rcButton.right - cbi.rcButton.left; " pixels wide"
```

Microsoft Learn: [CB_GETCOMBOBOXINFO](https://learn.microsoft.com/en-us/windows/win32/controls/cb-getcomboboxinfo)

### GetEditBoxHandle

```freebasic
function GetEditBoxHandle( byval hCombo as HWND ) as HWND
```

Returns the edit box inside a `CBS_DROPDOWN` or `CBS_SIMPLE` combo box, for the [Edit](SysWin-Gui-Edit)
functions or to subclass it. For a `CBS_DROPDOWNLIST` combo box, which has none, it returns the
combo box itself.

**Returns** the edit box.

**Example**

```freebasic
dim hEdit as HWND = Combo.GetEditBoxHandle( hCtrl )
Edit.SetSel( hEdit, 0, -1 )
```

Microsoft Learn: [COMBOBOXINFO](https://learn.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-comboboxinfo)

### GetListBoxHandle

```freebasic
function GetListBoxHandle( byval hCombo as HWND ) as HWND
```

Returns the list box that drops down, for the [ListBox](SysWin-Gui-ListBox) functions or to
subclass it.

**Returns** the list box.

**Example**

```freebasic
dim hList as HWND = Combo.GetListBoxHandle( hCtrl )
```

Microsoft Learn: [COMBOBOXINFO](https://learn.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-comboboxinfo)

### Enable

```freebasic
function Enable( byval hCombo as HWND ) as boolean
```

Lets the user use the combo box again.

**Returns** `true` when it was disabled, `false` when it was already enabled.

**Example**

```freebasic
Combo.Enable( hCtrl )
```

Microsoft Learn: [EnableWindow](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-enablewindow)

### Disable

```freebasic
function Disable( byval hCombo as HWND ) as boolean
```

Greys the combo box out: it cannot take the focus or input until [Enable](#enable) is called.

**Returns** `true` when it was enabled, `false` when it was already disabled.

**Example**

```freebasic
Combo.Disable( hCtrl )
```

Microsoft Learn: [EnableWindow](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-enablewindow)

### SetDarkMode

```freebasic
function SetDarkMode( byval hCombo as HWND ) as HRESULT
```

Gives the combo box the `DarkMode_CFD` visual style: a dark selection field, button and list.

**Returns** `S_OK` on success.

**Example**

```freebasic
if AppsUseDarkMode() then Combo.SetDarkMode( hCtrl )
```

Microsoft Learn: [SetWindowTheme](https://learn.microsoft.com/en-us/windows/win32/api/uxtheme/nf-uxtheme-setwindowtheme)

### RemoveDarkMode

```freebasic
function RemoveDarkMode( byval hCombo as HWND ) as HRESULT
```

Gives the combo box back its normal visual style.

**Returns** `S_OK` on success.

**Example**

```freebasic
Combo.RemoveDarkMode( hCtrl )
```

Microsoft Learn: [SetWindowTheme](https://learn.microsoft.com/en-us/windows/win32/api/uxtheme/nf-uxtheme-setwindowtheme)

## See also

- [sys/win/gui](SysWin-Gui)
- [CWindow](CWindow) for `AddControl( "ComboBox", ... )`
- [CBEx](SysWin-Gui-CBEx) for a combo box with images
- [ListBox](SysWin-Gui-ListBox), [Edit](SysWin-Gui-Edit)
- [gui macros and helpers](SysWin-Gui-Procedures) for reading `WM_COMMAND` in the window procedure
- [Dark mode](SysWin-Dark-Mode)
