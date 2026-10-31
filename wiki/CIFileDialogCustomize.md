[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gui](SysWin-Gui) › **CIFileDialogCustomize**

# CIFileDialogCustomize

Adds check boxes, lists, buttons and other controls to an open or save dialog.

The Open and Save dialogs of [File dialogs](SysWin-Gui-File-Dialogs) have room under the file
name box for controls of the program's own. `CIFileDialogCustomize` wraps the dialog's
`IFileDialogCustomize` interface, which adds them. The dialog lays the controls out itself: a
program says what to add and in what order, never where.

**Identifiers.** Every control has an ID, a `DWORD` of your choice that is unique in the dialog;
adding a second control with an ID in use fails. Combo boxes, radio-button lists, menus and the
drop-down on the Open button are containers: their items are added with
[AddControlItem](#addcontrolitem) and have item IDs of their own, unique within the container.

**When.** Add the controls before `ShowOpen` or `ShowSave`. Read what the user did afterwards,
with [GetCheckButtonState](#getcheckbuttonstate), [GetSelectedControlItem](#getselectedcontrolitem)
and [GetEditBoxText](#geteditboxtext), or while the dialog is open, from the handlers of
[CIFileDialogControlEvents](SysWin-Gui-File-Dialog-Events#cifiledialogcontrolevents).

**Lifetime.** The object holds one reference to the dialog's interface and releases it in its
destructor; the controls belong to the dialog and stay when the object goes. Like the dialog
classes, the constructors call `CoInitialize` and the destructor `CoUninitialize`.

**States.** A control or item is enabled, visible, both or neither: `CDCS_ENABLED` (1),
`CDCS_VISIBLE` (2), `CDCS_ENABLEDVISIBLE` (3, the state every new control and item has) and
`CDCS_INACTIVE` (0).

**Results.** Members that change something return the `HRESULT`. Members that read a value
return it and leave the `HRESULT` in `GetLastError()`.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui
```

## Example

An Open dialog with an *Open as read-only* check box and an *Encoding* list. After the dialog
closes, the window's caption shows the file and the two choices.

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

const IDC_OPEN     = 101
const IDC_READONLY = 1
const IDC_ENCLABEL = 2
const IDC_ENCODING = 3
const ENC_UTF8 = 1, ENC_UTF16 = 2, ENC_ANSI = 3

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "CustomizeDemo"
    dim hWin as HWND = pWindow.Create( NULL, "CIFileDialogCustomize", @WndProc )
    pWindow.SetClientSize( 420, 120 )
    pWindow.Center()
    pWindow.AddControl( "Button", hWin, IDC_OPEN, "&Open...", 160, 45, 100, 30 )
    return pWindow.DoEvents( SW_NORMAL )
end function

sub PickFile( byval hwnd as HWND )
    dim pofd as CIOpenFileDialog
    pofd.AddFileType( "Text files", "*.txt" )
    pofd.AddFileType( "All files", "*.*" )
    pofd.SetFileTypes()
    dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
    cust.AddCheckButton( IDC_READONLY, "Open as &read-only" )
    cust.AddText( IDC_ENCLABEL, "Encoding:" )
    cust.AddComboBox( IDC_ENCODING )
    cust.AddControlItem( IDC_ENCODING, ENC_UTF8, "UTF-8" )
    cust.AddControlItem( IDC_ENCODING, ENC_UTF16, "UTF-16" )
    cust.AddControlItem( IDC_ENCODING, ENC_ANSI, "ANSI" )
    cust.SetSelectedControlItem( IDC_ENCODING, ENC_UTF8 )
    if pofd.ShowOpen( hwnd ) <> S_OK then exit sub
    dim ustrEnc as ustring
    select case cust.GetSelectedControlItem( IDC_ENCODING )
        case ENC_UTF16 : ustrEnc = "UTF-16"
        case ENC_ANSI  : ustrEnc = "ANSI"
        case else      : ustrEnc = "UTF-8"
    end select
    dim ustrMode as ustring = iif( cust.GetCheckButtonState( IDC_READONLY ), "read-only", "read-write" )
    SetWindowText( hwnd, pofd.GetResultString() & ", " & ustrEnc & ", " & ustrMode )
end sub

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_COMMAND
            if CBCTL( wParam, lParam ) = IDC_OPEN andalso CBCTLMSG( wParam, lParam ) = BN_CLICKED then PickFile( hwnd )
            return 0
        case WM_DESTROY
            PostQuitMessage( 0 )
            return 0
    end select
    return DefWindowProcW( hwnd, uMsg, wParam, lParam )
end function

end main()
```

`IFileOpenDialog` extends `IFileDialog`, so `cast( IFileDialog ptr, pofd.GetPtr() )` gives the
constructor the pointer it takes without a reference to release; `pofd.GetIFileDialogPtr()`
does the same with a reference that must be released.

## Members

| Member | Does |
| --- | --- |
| [Constructor](#constructor) | Wraps a dialog's `IFileDialogCustomize` interface. |
| [Destructor](#destructor) | Releases the interface and stops COM. |
| [GetPtr](#getptr) | Returns the `IFileDialogCustomize` pointer. |
| [AddCheckButton](#addcheckbutton) | Adds a check box. |
| [AddComboBox](#addcombobox) | Adds a drop-down list. |
| [AddControlItem](#addcontrolitem) | Adds an item to a combo box, radio-button list, menu or Open drop-down. |
| [AddEditBox](#addeditbox) | Adds an edit box. |
| [AddMenu](#addmenu) | Adds a menu button. |
| [AddPushButton](#addpushbutton) | Adds a push button. |
| [AddRadioButtonList](#addradiobuttonlist) | Adds a group of radio buttons. |
| [AddSeparator](#addseparator) | Adds a separating line. |
| [AddText](#addtext) | Adds a text label. |
| [EnableOpenDropDown](#enableopendropdown) | Turns the Open or Save button into a split button with a list. |
| [EndVisualGroup](#endvisualgroup) | Ends the current visual group. |
| [GetCheckButtonState](#getcheckbuttonstate) | Returns whether a check box is checked. |
| [GetControlItemState](#getcontrolitemstate) | Returns whether an item is enabled and visible. |
| [GetControlState](#getcontrolstate) | Returns whether a control is enabled and visible. |
| [GetEditBoxText](#geteditboxtext) | Returns the text of an edit box. |
| [GetSelectedControlItem](#getselectedcontrolitem) | Returns the ID of the selected item of a container. |
| [MakeProminent](#makeprominent) | Moves a control next to the Open and Cancel buttons. |
| [RemoveControlItem](#removecontrolitem) | Removes an item from a container. |
| [SetCheckButtonState](#setcheckbuttonstate) | Checks or clears a check box. |
| [SetControlItemState](#setcontrolitemstate) | Enables, disables, shows or hides an item. |
| [SetControlItemText](#setcontrolitemtext) | Changes the text of an item. |
| [SetControlLabel](#setcontrollabel) | Changes the text of a control. |
| [SetControlState](#setcontrolstate) | Enables, disables, shows or hides a control. |
| [SetEditBoxText](#seteditboxtext) | Sets the text of an edit box. |
| [SetSelectedControlItem](#setselectedcontrolitem) | Selects an item of a combo box or radio-button list. |
| [StartVisualGroup](#startvisualgroup) | Adds a text label with an ID. |

## Reference

### Constructor

```freebasic
constructor( byval pIFileDialogCustomize as IFileDialogCustomize ptr, byval fAddRef as boolean = true )
constructor( byval pIFileDialog as IFileDialog ptr )
```

The second form, the usual one, asks a dialog for its `IFileDialogCustomize` interface: pass the
`IFileDialog` pointer of a [CIOpenFileDialog](SysWin-Gui-File-Dialogs#ciopenfiledialog) or
[CISaveFileDialog](SysWin-Gui-File-Dialogs#cisavefiledialog). The first wraps an
`IFileDialogCustomize` pointer you already have, such as the `pfdc` a control event handler
receives.

| Parameter | Meaning |
| --- | --- |
| `pIFileDialogCustomize` | The interface to wrap. |
| `fAddRef` | `true` (the default) takes a reference of its own; `false` takes over the caller's reference, which the destructor then releases. |
| `pIFileDialog` | The dialog. Its reference stays the caller's. |

With a `NULL` pointer, or a dialog that has no `IFileDialogCustomize`, [GetPtr](#getptr) returns
`NULL` and no other member may be called. COM is started only when the pointer is not `NULL`,
but the destructor stops it in every case.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
if cust.GetPtr() then cust.AddCheckButton( 1, "Open as read-only" )
```

Microsoft Learn: [IFileDialogCustomize](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nn-shobjidl_core-ifiledialogcustomize)

### Destructor

```freebasic
destructor
```

Releases the interface, if there is one, and calls `CoUninitialize`. The controls stay in the
dialog.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
scope
    dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
    cust.AddCheckButton( 1, "Open as read-only" )
end scope   ' the check box is still in the dialog
```

### GetPtr

```freebasic
function GetPtr() as IFileDialogCustomize ptr
```

Returns the wrapped interface, for a method the class does not wrap. The object keeps its
reference: do not release it.

**Returns** the pointer, or `NULL` when the constructor had nothing to wrap.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
dim pfdc as IFileDialogCustomize ptr = cust.GetPtr()
pfdc->lpVtbl->StartVisualGroup( pfdc, 20, "Options" )
```

### AddCheckButton

```freebasic
function AddCheckButton( byval dwIDCtl as DWORD, byval pwszLabel as wstring ptr, byval bChecked as boolean = false ) as HRESULT
```

Adds a check box with a label.

| Parameter | Meaning |
| --- | --- |
| `dwIDCtl` | The control's ID. |
| `pwszLabel` | The text beside the box; `&` marks the access key. |
| `bChecked` | `true` to start checked. |

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddCheckButton( 1, "Open as &read-only", true )
```

Microsoft Learn: [IFileDialogCustomize::AddCheckButton](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-addcheckbutton)

### AddComboBox

```freebasic
function AddComboBox( byval dwIDCtl as DWORD ) as HRESULT
```

Adds an empty drop-down list. Fill it with [AddControlItem](#addcontrolitem) and select an item
with [SetSelectedControlItem](#setselectedcontrolitem); until then nothing is selected. A combo
box has no label of its own: put an [AddText](#addtext) label before it.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddComboBox( 3 )
cust.AddControlItem( 3, 1, "UTF-8" )
cust.AddControlItem( 3, 2, "UTF-16" )
```

Microsoft Learn: [IFileDialogCustomize::AddComboBox](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-addcombobox)

### AddControlItem

```freebasic
function AddControlItem( byval dwIDCtl as DWORD, byval dwIDItem as DWORD, byval pwszLabel as wstring ptr ) as HRESULT
```

Adds an item to a container: a combo box, a radio-button list, a menu or the Open button's
drop-down. Items appear in the order they are added.

| Parameter | Meaning |
| --- | --- |
| `dwIDCtl` | The container's ID. |
| `dwIDItem` | The item's ID, unique within the container. |
| `pwszLabel` | The item's text. |

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddRadioButtonList( 5 )
cust.AddControlItem( 5, 1, "Windows (CRLF)" )
cust.AddControlItem( 5, 2, "Unix (LF)" )
```

Microsoft Learn: [IFileDialogCustomize::AddControlItem](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-addcontrolitem)

### AddEditBox

```freebasic
function AddEditBox( byval dwIDCtl as DWORD, byval pwszLabel as wstring ptr ) as HRESULT
```

Adds an edit box. In spite of the parameter's name, `pwszLabel` is the text the box starts
with, not a label beside it: [GetEditBoxText](#geteditboxtext) returns it until the user types.
Put an [AddText](#addtext) label before the box to name it.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddText( 6, "Tag:" )
cust.AddEditBox( 7, "draft" )
```

Microsoft Learn: [IFileDialogCustomize::AddEditBox](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-addeditbox)

### AddMenu

```freebasic
function AddMenu( byval dwIDCtl as DWORD, byval pwszLabel as wstring ptr ) as HRESULT
```

Adds a button that opens a menu, such as a *Tools* menu. Add its commands with
[AddControlItem](#addcontrolitem); choosing one calls the
[OnItemSelected](SysWin-Gui-File-Dialog-Events#onitemselected) handler.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddMenu( 8, "&Tools" )
cust.AddControlItem( 8, 1, "Map a network drive" )
```

Microsoft Learn: [IFileDialogCustomize::AddMenu](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-addmenu)

### AddPushButton

```freebasic
function AddPushButton( byval dwIDCtl as DWORD, byval pwszLabel as wstring ptr ) as HRESULT
```

Adds a push button. Clicking it calls the
[OnButtonClicked](SysWin-Gui-File-Dialog-Events#onbuttonclicked) handler; it does not close the
dialog.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddPushButton( 9, "&Preview" )
```

Microsoft Learn: [IFileDialogCustomize::AddPushButton](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-addpushbutton)

### AddRadioButtonList

```freebasic
function AddRadioButtonList( byval dwIDCtl as DWORD ) as HRESULT
```

Adds an empty group of radio buttons; each [AddControlItem](#addcontrolitem) adds one button.
Select one with [SetSelectedControlItem](#setselectedcontrolitem).

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddRadioButtonList( 5 )
cust.AddControlItem( 5, 1, "Whole file" ) : cust.AddControlItem( 5, 2, "First 1000 lines" )
cust.SetSelectedControlItem( 5, 1 )
```

Microsoft Learn: [IFileDialogCustomize::AddRadioButtonList](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-addradiobuttonlist)

### AddSeparator

```freebasic
function AddSeparator( byval dwIDCtl as DWORD ) as HRESULT
```

Adds a line between the controls added before it and those added after it. It takes an ID like
any control.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddCheckButton( 1, "Open as read-only" )
cust.AddSeparator( 10 )
cust.AddPushButton( 9, "&Preview" )
```

Microsoft Learn: [IFileDialogCustomize::AddSeparator](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-addseparator)

### AddText

```freebasic
function AddText( byval dwIDCtl as DWORD, byval pwszText as wstring ptr ) as HRESULT
```

Adds a line of text, as a label for the control that follows it or as a note to the user.
Change it later with [SetControlLabel](#setcontrollabel).

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddText( 2, "Encoding:" )
```

Microsoft Learn: [IFileDialogCustomize::AddText](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-addtext)

### EnableOpenDropDown

```freebasic
function EnableOpenDropDown( byval dwIDCtl as DWORD ) as HRESULT
```

Turns the Open (or Save) button into a split button whose arrow opens a list, as Explorer's
*Open* / *Open read-only*. `dwIDCtl` becomes the ID of that list: add its items with
[AddControlItem](#addcontrolitem). The first item is the button's default action; choosing an
item closes the dialog like the button, and [GetSelectedControlItem](#getselectedcontrolitem)
then tells which; the choice does not reach an `OnItemSelected` handler.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.EnableOpenDropDown( 30 )
cust.AddControlItem( 30, 1, "&Open" )
cust.AddControlItem( 30, 2, "Open &read-only" )
```

Microsoft Learn: [IFileDialogCustomize::EnableOpenDropDown](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-enableopendropdown)

### EndVisualGroup

```freebasic
function EndVisualGroup() as HRESULT
```

Ends the visual group the dialog's own `StartVisualGroup` opened, so that controls added after it
stand outside the group. Since this class's [StartVisualGroup](#startvisualgroup) does not open
a group, open one through [GetPtr](#getptr) as in the example; with no group open it returns
`E_UNEXPECTED`.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
dim pfdc as IFileDialogCustomize ptr = cust.GetPtr()
pfdc->lpVtbl->StartVisualGroup( pfdc, 20, "Line endings:" )
cust.AddRadioButtonList( 21 )
cust.EndVisualGroup()
```

Microsoft Learn: [IFileDialogCustomize::EndVisualGroup](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-endvisualgroup)

### GetCheckButtonState

```freebasic
function GetCheckButtonState( byval dwIDCtl as DWORD ) as boolean
```

Returns whether a check box is checked.

**Returns** `true` when checked; `false` when clear or on failure, with the `HRESULT` in
`GetLastError()`.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddCheckButton( 1, "Open as read-only", true )
print cust.GetCheckButtonState( 1 )   ' true
```

Microsoft Learn: [IFileDialogCustomize::GetCheckButtonState](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-getcheckbuttonstate)

### GetControlItemState

```freebasic
function GetControlItemState( byval dwIDCtl as DWORD, byval dwIDItem as DWORD ) as CDCONTROLSTATEF
```

Returns whether an item of a container is enabled and visible.

**Returns** a `CDCS_*` value, 3 (`CDCS_ENABLEDVISIBLE`) for a new item; 0 on failure, with the
`HRESULT` in `GetLastError()`.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddComboBox( 3 ) : cust.AddControlItem( 3, 1, "UTF-8" )
print cust.GetControlItemState( 3, 1 )   ' 3
```

Microsoft Learn: [IFileDialogCustomize::GetControlItemState](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-getcontrolitemstate)

### GetControlState

```freebasic
function GetControlState( byval dwIDCtl as DWORD ) as CDCONTROLSTATEF
```

Returns whether a control is enabled and visible.

**Returns** a `CDCS_*` value, 3 (`CDCS_ENABLEDVISIBLE`) for a new control; 0 on failure, with
the `HRESULT` in `GetLastError()`.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddPushButton( 9, "&Preview" )
if cust.GetControlState( 9 ) and CDCS_ENABLED then print "enabled"
```

Microsoft Learn: [IFileDialogCustomize::GetControlState](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-getcontrolstate)

### GetEditBoxText

```freebasic
function GetEditBoxText( byval dwIDCtl as DWORD ) as ustring
```

Returns the text of an edit box added with [AddEditBox](#addeditbox). The shell's copy of the
text is not freed.

**Returns** the text; an empty string on failure, with the `HRESULT` in `GetLastError()`
(`E_INVALIDARG` for an ID that is not an edit box).

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddEditBox( 7, "draft" )
print cust.GetEditBoxText( 7 )   ' draft
```

Microsoft Learn: [IFileDialogCustomize::GetEditBoxText](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-geteditboxtext)

### GetSelectedControlItem

```freebasic
function GetSelectedControlItem( byval dwIDCtl as DWORD ) as DWORD
```

Returns the ID of the selected item of a combo box, a radio-button list or the Open button's
drop-down. It can be called after the dialog has closed, to read the user's final choice; it
does not work on menus.

**Returns** the item ID; 0 when nothing is selected or on failure, with `E_FAIL` or another
`HRESULT` in `GetLastError()`.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddComboBox( 3 ) : cust.AddControlItem( 3, 10, "UTF-8" ) : cust.AddControlItem( 3, 11, "UTF-16" )
cust.SetSelectedControlItem( 3, 11 )
print cust.GetSelectedControlItem( 3 )   ' 11
```

Microsoft Learn: [IFileDialogCustomize::GetSelectedControlItem](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-getselectedcontrolitem)

### MakeProminent

```freebasic
function MakeProminent( byval dwIDCtl as DWORD ) as HRESULT
```

Moves one control out of the custom area to beside the Open and Cancel buttons. Only one control
can be prominent; a check box, combo box, push button, radio-button list or a visual group can.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddCheckButton( 1, "Open as read-only" )
cust.MakeProminent( 1 )
```

Microsoft Learn: [IFileDialogCustomize::MakeProminent](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-makeprominent)

### RemoveControlItem

```freebasic
function RemoveControlItem( byval dwIDCtl as DWORD, byval dwItem as DWORD ) as HRESULT
```

Removes an item from a container. There is no member that removes every item at once: the
interface's own method for that is not implemented by Windows.

**Returns** `S_OK`; `E_INVALIDARG` (`&h80070057`) for an item that is not there.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddComboBox( 3 ) : cust.AddControlItem( 3, 1, "UTF-8" ) : cust.AddControlItem( 3, 2, "ANSI" )
cust.RemoveControlItem( 3, 2 )
```

Microsoft Learn: [IFileDialogCustomize::RemoveControlItem](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-removecontrolitem)

### SetCheckButtonState

```freebasic
function SetCheckButtonState( byval dwIDCtl as DWORD, byval bCkecked as boolean ) as HRESULT
```

Checks (`true`) or clears (`false`) a check box.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddCheckButton( 1, "Open as read-only", true )
cust.SetCheckButtonState( 1, false )
```

Microsoft Learn: [IFileDialogCustomize::SetCheckButtonState](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-setcheckbuttonstate)

### SetControlItemState

```freebasic
function SetControlItemState( byval dwIDCtl as DWORD, byval dwIDItem as DWORD, byval dwState as CDCONTROLSTATEF ) as HRESULT
```

Enables, disables, shows or hides an item of a container, with a `CDCS_*` value.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddComboBox( 3 ) : cust.AddControlItem( 3, 1, "UTF-8" ) : cust.AddControlItem( 3, 2, "ANSI" )
cust.SetControlItemState( 3, 2, CDCS_VISIBLE )   ' shown but greyed
```

Microsoft Learn: [IFileDialogCustomize::SetControlItemState](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-setcontrolitemstate)

### SetControlItemText

```freebasic
function SetControlItemText( byval dwIDCtl as DWORD, byval dwIDItem as DWORD, byval pwszLabel as wstring ptr ) as HRESULT
```

Changes the text of an item, such as a radio button or a menu command. In a test it worked on
radio-button and menu items and returned `E_NOTIMPL` (`&h80004001`) for a combo-box item.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddRadioButtonList( 5 ) : cust.AddControlItem( 5, 1, "CRLF" )
cust.SetControlItemText( 5, 1, "Windows (CRLF)" )
```

Microsoft Learn: [IFileDialogCustomize::SetControlItemText](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-setcontrolitemtext)

### SetControlLabel

```freebasic
function SetControlLabel( byval dwIDCtl as DWORD, byval pwszLabel as wstring ptr ) as HRESULT
```

Changes the text of a control: a check box, push button, menu button, text label or visual
group.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddText( 2, "Encoding:" )
cust.SetControlLabel( 2, "Character set:" )
```

Microsoft Learn: [IFileDialogCustomize::SetControlLabel](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-setcontrollabel)

### SetControlState

```freebasic
function SetControlState( byval dwIDCtl as DWORD, byval dwState as CDCONTROLSTATEF ) as HRESULT
```

Enables, disables, shows or hides a control, with a `CDCS_*` value: `CDCS_VISIBLE` alone shows
it greyed, `CDCS_INACTIVE` hides it.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddPushButton( 9, "&Preview" )
cust.SetControlState( 9, CDCS_VISIBLE )   ' greyed until a file is selected
```

Microsoft Learn: [IFileDialogCustomize::SetControlState](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-setcontrolstate)

### SetEditBoxText

```freebasic
function SetEditBoxText( byval dwIDCtl as DWORD, byval pwszText as wstring ptr ) as HRESULT
```

Replaces the text of an edit box.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddEditBox( 7, "" )
cust.SetEditBoxText( 7, "final" )
```

Microsoft Learn: [IFileDialogCustomize::SetEditBoxText](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-seteditboxtext)

### SetSelectedControlItem

```freebasic
function SetSelectedControlItem( byval dwIDCtl as DWORD, byval dwIDItem as DWORD ) as HRESULT
```

Selects an item of a combo box or a radio-button list.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.AddComboBox( 3 ) : cust.AddControlItem( 3, 1, "UTF-8" ) : cust.AddControlItem( 3, 2, "ANSI" )
cust.SetSelectedControlItem( 3, 1 )
```

Microsoft Learn: [IFileDialogCustomize::SetSelectedControlItem](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-setselectedcontrolitem)

### StartVisualGroup

```freebasic
function StartVisualGroup( byval dwIDCtl as DWORD, byval pwszLabel as wstring ptr ) as HRESULT
```

Adds a text label with the ID `dwIDCtl`, exactly as [AddText](#addtext) does. It does **not**
open a visual group: controls added after it are not grouped under the label, and a following
[EndVisualGroup](#endvisualgroup) returns `E_UNEXPECTED`. To group controls, call the dialog's
own `StartVisualGroup` through [GetPtr](#getptr), as the `EndVisualGroup` example does.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
cust.StartVisualGroup( 20, "Options" )   ' a label, the same as AddText( 20, "Options" )
```

Microsoft Learn: [IFileDialogCustomize::StartVisualGroup](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-startvisualgroup)

## See also

- [File dialogs](SysWin-Gui-File-Dialogs) for the Open and Save dialogs these controls go into
- [File dialog events](SysWin-Gui-File-Dialog-Events) for handling clicks and selections in the
  added controls while the dialog is open
- [sys/win/gui](SysWin-Gui)
