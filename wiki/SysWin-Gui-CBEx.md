[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gui](SysWin-Gui) › **CBEx**

# CBEx

Inserts, reads and changes the items of a ComboBoxEx control, a combo box with images.

A ComboBoxEx control wraps an ordinary combo box and draws an image from an image list beside
each item, indented if you like. Every function here takes the ComboBoxEx handle first and is
written with the namespace: `CBEx.InsertItem( hCbx, cbei )`. `CWindow.AddControl( "ComboBoxEx",
... )` creates one with the `CBS_DROPDOWNLIST` style; the height you give it is the height with
the list dropped down.

An item is described by a `COMBOBOXEXITEMW`: `mask` says which members count (`CBEIF_TEXT`,
`CBEIF_IMAGE`, `CBEIF_SELECTEDIMAGE`, `CBEIF_OVERLAY`, `CBEIF_INDENT`, `CBEIF_LPARAM`), `iItem` is
the zero-based position (-1 for the end when inserting), and `pszText`, `iImage`,
`iSelectedImage`, `iIndent` and `lParam` hold the values. The control copies the text, so the
buffer can go once the call returns.

The control sends the parent `WM_COMMAND` with the combo box notifications (`CBN_SELCHANGE` …)
under its own id, and takes the combo box messages, so the [Combo](SysWin-Gui-Combo) functions
that only send a `CB_*` message, such as `Combo.GetCurSel` and `Combo.SetCurSel`, work on it. For
the rest, use the inner combo box from [GetComboControl](#getcombocontrol). The image list is
yours: the control does not destroy it.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui
```

## Example

A drop-down list of three message kinds, each with the system icon that goes with it. Choosing
one puts its text and value in the caption.

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

const IDC_KIND = 101

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

sub AddKind( byval hCbx as HWND, byval pwszText as wstring ptr, byval iImage as long, byval nValue as LPARAM )
    dim cbei as COMBOBOXEXITEMW
    cbei.mask = CBEIF_TEXT or CBEIF_IMAGE or CBEIF_SELECTEDIMAGE or CBEIF_LPARAM
    cbei.iItem = -1
    cbei.pszText = pwszText
    cbei.iImage = iImage
    cbei.iSelectedImage = iImage
    cbei.lParam = nValue
    CBEx.InsertItem( hCbx, cbei )
end sub

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    EnableVisualStyles()
    dim pWindow as CWindow = "CBExDemo"
    dim hWin as HWND = pWindow.Create( NULL, "CBEx", @WndProc )
    pWindow.SetClientSize( 300, 200 )
    pWindow.Center()
    dim hCbx as HWND = pWindow.AddControl( "ComboBoxEx", hWin, IDC_KIND, "", 10, 10, 280, 150 )
    dim cx as long = GetSystemMetrics( SM_CXSMICON )
    dim himl as HIMAGELIST = ImageList_Create( cx, cx, ILC_COLOR32 or ILC_MASK, 3, 0 )
    ImageList_ReplaceIcon( himl, -1, LoadIconW( NULL, cast( wstring ptr, 32516 ) ) )   ' IDI_INFORMATION
    ImageList_ReplaceIcon( himl, -1, LoadIconW( NULL, cast( wstring ptr, 32515 ) ) )   ' IDI_WARNING
    ImageList_ReplaceIcon( himl, -1, LoadIconW( NULL, cast( wstring ptr, 32513 ) ) )   ' IDI_ERROR
    CBEx.SetImageList( hCbx, himl )
    AddKind( hCbx, "Information", 0, 1 )
    AddKind( hCbx, "Warning", 1, 2 )
    AddKind( hCbx, "Error", 2, 3 )
    Combo.SetCurSel( hCbx, 0 )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_COMMAND
            if CBCTL( wParam, lParam ) = IDC_KIND andalso CBCTLMSG( wParam, lParam ) = CBN_SELCHANGE then
                dim hCbx as HWND = cast( HWND, lParam )
                dim wszText as wstring * 64
                dim cbei as COMBOBOXEXITEMW
                cbei.mask = CBEIF_TEXT or CBEIF_LPARAM
                cbei.iItem = Combo.GetCurSel( hCbx )
                cbei.pszText = @wszText
                cbei.cchTextMax = 64
                if CBEx.GetItem( hCbx, cbei ) then SetWindowText( hwnd, wszText & ", value " & cbei.lParam )
            end if
            return 0
        case WM_DESTROY
            ImageList_Destroy( CBEx.GetImageList( GetDlgItem( hwnd, IDC_KIND ) ) )
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
| [InsertItem](#insertitem) | Inserts an item. |
| [DeleteItem](#deleteitem) | Deletes an item. |
| [GetItem](#getitem) | Reads an item's attributes. |
| [SetItem](#setitem) | Changes an item's attributes. |
| [GetImageList](#getimagelist) | Returns the image list. |
| [SetImageList](#setimagelist) | Sets the image list. |
| [GetExtendedStyle](#getextendedstyle) | Returns the extended styles. |
| [SetExtendedStyle](#setextendedstyle) | Sets some extended styles. |
| [GetComboControl](#getcombocontrol) | Returns the inner combo box. |
| [GetEditControl](#geteditcontrol) | Returns the edit box of a drop-down ComboBoxEx. |
| [HasEditChanged](#haseditchanged) | Tells whether the user has changed the typed text. |
| [SetWindowTheme](#setwindowtheme) | Sets the visual style of the control and its parts. |
| [SetDarkMode](#setdarkmode) | Gives the control the dark theme. |
| [RemoveDarkMode](#removedarkmode) | Gives the control back its normal theme. |

## Reference

### InsertItem

```freebasic
function InsertItem overload( byval hComboEx as HWND, byval pCBItem as COMBOBOXEXITEMW ptr ) as long
function InsertItem overload( byval hComboEx as HWND, byref CBItem as COMBOBOXEXITEMW ) as long
```

Inserts the item described by the `COMBOBOXEXITEMW` at position `iItem`, or at the end when
`iItem` is -1. The list is never sorted.

| Parameter | Meaning |
| --- | --- |
| `hComboEx` | The ComboBoxEx control. |
| `pCBItem`, `CBItem` | The item: `mask`, `iItem` and the members `mask` names. |

**Returns** the index of the new item, or -1 on failure.

**Example**

```freebasic
dim wszText as wstring * 32 = "Documents"
dim cbei as COMBOBOXEXITEMW
cbei.mask = CBEIF_TEXT or CBEIF_IMAGE or CBEIF_SELECTEDIMAGE
cbei.iItem = -1
cbei.pszText = @wszText
cbei.iImage = 0 : cbei.iSelectedImage = 0
dim i as long = CBEx.InsertItem( hCtrl, cbei )
```

Microsoft Learn: [CBEM_INSERTITEM](https://learn.microsoft.com/en-us/windows/win32/controls/cbem-insertitem)

### DeleteItem

```freebasic
function DeleteItem( byval hComboEx as HWND, byval iIndex as long ) as long
```

Deletes the item at `iIndex`. The items after it move up by one.

**Returns** the number of items left, or `CB_ERR` when `iIndex` is out of range.

**Example**

```freebasic
CBEx.DeleteItem( hCtrl, 0 )
```

Microsoft Learn: [CBEM_DELETEITEM](https://learn.microsoft.com/en-us/windows/win32/controls/cbem-deleteitem)

### GetItem

```freebasic
function GetItem overload( byval hComboEx as HWND, byval pCBItem as COMBOBOXEXITEMW ptr ) as boolean
function GetItem overload( byval hComboEx as HWND, byref CBItem as COMBOBOXEXITEMW ) as boolean
function GetItem overload( byval hComboEx as HWND ) as COMBOBOXEXITEMW
```

Reads the attributes of item `iItem` that `mask` names. For the text, point `pszText` at a buffer
and put its size in characters in `cchTextMax`. An `iItem` of -1 reads the item shown in the
selection field (the text typed into a drop-down ComboBoxEx).

The third form asks with an empty structure, `mask` 0, so it reads nothing: the item it returns
is all zeros and `GetLastError()` is 1. Use one of the first two forms.

**Returns** `true` on success (first two forms), or the structure (third form).

**Example**

```freebasic
dim wszText as wstring * 64
dim cbei as COMBOBOXEXITEMW
cbei.mask = CBEIF_TEXT or CBEIF_LPARAM
cbei.iItem = 1
cbei.pszText = @wszText : cbei.cchTextMax = 64
if CBEx.GetItem( hCtrl, cbei ) then print wszText; cbei.lParam
```

Microsoft Learn: [CBEM_GETITEM](https://learn.microsoft.com/en-us/windows/win32/controls/cbem-getitem)

### SetItem

```freebasic
function SetItem overload( byval hComboEx as HWND, byval pCBItem as COMBOBOXEXITEMW ptr ) as boolean
function SetItem overload( byval hComboEx as HWND, byref CBItem as COMBOBOXEXITEMW ) as boolean
```

Changes the attributes of item `iItem` that `mask` names; the others stay. The pointer form
returns `false` for `NULL`.

**Returns** `true` on success.

**Example**

```freebasic
dim wszText as wstring * 32 = "Blue"
dim cbei as COMBOBOXEXITEMW
cbei.mask = CBEIF_TEXT
cbei.iItem = 0
cbei.pszText = @wszText
CBEx.SetItem( hCtrl, cbei )
```

Microsoft Learn: [CBEM_SETITEM](https://learn.microsoft.com/en-us/windows/win32/controls/cbem-setitem)

### GetImageList

```freebasic
function GetImageList( byval hComboEx as HWND ) as HIMAGELIST
```

Returns the image list the item images come from.

**Returns** the image list, or `NULL` when none was set.

**Example**

```freebasic
ImageList_Destroy( CBEx.GetImageList( hCtrl ) )   ' when the window closes
```

Microsoft Learn: [CBEM_GETIMAGELIST](https://learn.microsoft.com/en-us/windows/win32/controls/cbem-getimagelist)

### SetImageList

```freebasic
function SetImageList( byval hComboEx as HWND, byval himl as HIMAGELIST ) as HIMAGELIST
```

Sets the image list the item images come from. The control does not destroy it, nor the one it
replaces: destroy each when it is no longer used.

**Returns** the previous image list, or `NULL` when there was none.

**Example**

```freebasic
dim himl as HIMAGELIST = ImageList_Create( 16, 16, ILC_COLOR32 or ILC_MASK, 4, 0 )
dim hOld as HIMAGELIST = CBEx.SetImageList( hCtrl, himl )
if hOld then ImageList_Destroy( hOld )
```

Microsoft Learn: [CBEM_SETIMAGELIST](https://learn.microsoft.com/en-us/windows/win32/controls/cbem-setimagelist)

### GetExtendedStyle

```freebasic
function GetExtendedStyle( byval hComboEx as HWND ) as DWORD
```

Returns the control's `CBES_EX_*` extended styles.

**Returns** the styles, 0 for a new control.

**Example**

```freebasic
if CBEx.GetExtendedStyle( hCtrl ) and CBES_EX_NOEDITIMAGE then print "no image in the field"
```

Microsoft Learn: [CBEM_GETEXTENDEDSTYLE](https://learn.microsoft.com/en-us/windows/win32/controls/cbem-getextendedstyle)

### SetExtendedStyle

```freebasic
function SetExtendedStyle( byval hComboEx as HWND, byval dwExMask as DWORD, byval dwExStyle as DWORD ) as DWORD
```

Sets the extended styles in `dwExMask` to their values in `dwExStyle`; with a mask of 0 every
style is set from `dwExStyle`. Note the order: the mask comes first (`Edit.SetExtendedStyle`
takes the styles first).

| Parameter | Meaning |
| --- | --- |
| `hComboEx` | The ComboBoxEx control. |
| `dwExMask` | The styles to change, or 0. |
| `dwExStyle` | The new values: `CBES_EX_CASESENSITIVE`, `CBES_EX_NOEDITIMAGE`, `CBES_EX_NOEDITIMAGEINDENT`, `CBES_EX_NOSIZELIMIT`, `CBES_EX_PATHWORDBREAKPROC`, `CBES_EX_TEXTENDELLIPSIS`. |

**Returns** the previous extended styles.

**Example**

```freebasic
CBEx.SetExtendedStyle( hCtrl, CBES_EX_CASESENSITIVE, CBES_EX_CASESENSITIVE )
```

Microsoft Learn: [CBEM_SETEXTENDEDSTYLE](https://learn.microsoft.com/en-us/windows/win32/controls/cbem-setextendedstyle)

### GetComboControl

```freebasic
function GetComboControl( byval hComboEx as HWND ) as HWND
```

Returns the combo box inside the ComboBoxEx control, for the [Combo](SysWin-Gui-Combo) functions
that need the combo box itself.

**Returns** the combo box.

**Example**

```freebasic
print Combo.GetCount( CBEx.GetComboControl( hCtrl ) ); " items"
```

Microsoft Learn: [CBEM_GETCOMBOCONTROL](https://learn.microsoft.com/en-us/windows/win32/controls/cbem-getcombocontrol)

### GetEditControl

```freebasic
function GetEditControl( byval hComboEx as HWND ) as HWND
```

Returns the edit box of a ComboBoxEx control with the `CBS_DROPDOWN` style.

**Returns** the edit box, or `NULL` for any other style.

**Example**

```freebasic
dim hEdit as HWND = CBEx.GetEditControl( hCtrl )
if hEdit then Edit.SetCueBannerText( hEdit, "Type a path" )
```

Microsoft Learn: [CBEM_GETEDITCONTROL](https://learn.microsoft.com/en-us/windows/win32/controls/cbem-geteditcontrol)

### HasEditChanged

```freebasic
function HasEditChanged( byval hComboEx as HWND ) as boolean
```

Tells whether the user has changed the text in the edit box of a `CBS_DROPDOWN` ComboBoxEx since
an item was last chosen.

**Returns** `true` when the text has been changed.

**Example**

```freebasic
if CBEx.HasEditChanged( hCtrl ) then print "new text typed"
```

Microsoft Learn: [CBEM_HASEDITCHANGED](https://learn.microsoft.com/en-us/windows/win32/controls/cbem-haseditchanged)

### SetWindowTheme

```freebasic
sub SetWindowTheme( byval hComboEx as HWND, byval pwszStyle as wstring ptr )
```

Sets the visual style of the ComboBoxEx control and of the controls inside it, such as
`"Explorer"`. It is the ComboBoxEx message; inside the `CBEx` namespace the name does not mean
the Windows function, which stays reachable as `..SetWindowTheme`.

**Example**

```freebasic
CBEx.SetWindowTheme( hCtrl, "Explorer" )
```

Microsoft Learn: [CBEM_SETWINDOWTHEME](https://learn.microsoft.com/en-us/windows/win32/controls/cbem-setwindowtheme)

### SetDarkMode

```freebasic
function SetDarkMode( byval hComboEx as HWND ) as HRESULT
```

Gives the ComboBoxEx window itself the `DarkMode_CFD` visual style, with the Windows
`SetWindowTheme` function. The style is not passed on to the combo box inside; give that one the
dark style too with `Combo.SetDarkMode( CBEx.GetComboControl( hCbx ) )`.

**Returns** `S_OK` on success.

**Example**

```freebasic
CBEx.SetDarkMode( hCtrl )
Combo.SetDarkMode( CBEx.GetComboControl( hCtrl ) )
```

Microsoft Learn: [SetWindowTheme](https://learn.microsoft.com/en-us/windows/win32/api/uxtheme/nf-uxtheme-setwindowtheme)

### RemoveDarkMode

```freebasic
function RemoveDarkMode( byval hComboEx as HWND ) as HRESULT
```

Gives the ComboBoxEx window back its normal visual style.

**Returns** `S_OK` on success.

**Example**

```freebasic
CBEx.RemoveDarkMode( hCtrl )
```

Microsoft Learn: [SetWindowTheme](https://learn.microsoft.com/en-us/windows/win32/api/uxtheme/nf-uxtheme-setwindowtheme)

## See also

- [sys/win/gui](SysWin-Gui)
- [CWindow](CWindow) for `AddControl( "ComboBoxEx", ... )`
- [Combo](SysWin-Gui-Combo) for the combo box messages it also takes
- [Edit](SysWin-Gui-Edit) for the edit box of a drop-down ComboBoxEx
- [Dark mode](SysWin-Dark-Mode)
