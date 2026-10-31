[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gui](SysWin-Gui) › **File dialog events**

# File dialog events
Handles the events of an open or save dialog and of the controls added to it.

<!-- scope: CIFileDialogEvents -->
<!-- scope: CIFileDialogControlEvents -->

Handles the events of an open or save dialog and of the controls added to it.

While an Open or Save dialog of [File dialogs](SysWin-Gui-File-Dialogs) is open, it calls back
into the program: when the user changes folder, selects a file, picks another file type or
presses Open, and when the user uses a control added with
[CIFileDialogCustomize](CIFileDialogCustomize). `CIFileDialogEvents` implements the dialog's
`IFileDialogEvents` callback interface and `CIFileDialogControlEvents` the
`IFileDialogControlEvents` one. In both, every handler does nothing and returns `S_OK`.

**Handling an event.** Extend the type and declare, with the same signature, the handlers you
need; they are virtual, so yours are the ones the dialog calls. Create the object with `new` and
attach it with [SetEvents](SysWin-Gui-File-Dialogs#setevents) or
[Advise](SysWin-Gui-File-Dialogs#advise), through an `any ptr`:

```freebasic
dim pfde as any ptr = new MyEvents
pofd.SetEvents( pfde )
```

**Lifetime.** The objects are reference counted the COM way. `refCount` starts at 0; the dialog
takes a reference when the handler is attached and gives it back when it is detached or the
dialog goes, and [Release](#release) deletes the object when the count reaches 0. So never `dim`
one on the stack and never `delete` one yourself, and keep nothing in it that must outlive the
dialog: copy results out from the handler, into shared variables for instance.

**Control events.** The dialog finds the handler for its added controls by asking the events
object for `IFileDialogControlEvents` through [QueryInterface](#queryinterface). The base
`CIFileDialogEvents` answers with a new plain `CIFileDialogControlEvents`, whose handlers do
nothing. To receive control events, declare `QueryInterface` in your extended events type too,
answer that request with a new object of your extended control-events type, and pass every other
request to `base.QueryInterface`, as the example does.

**In a handler.** `pfd` is the dialog's `IFileDialog` interface and `pfdc` its
`IFileDialogCustomize` interface: call their methods through `->lpVtbl`, and do not release them.
Wrapping `pfdc` in a [CIFileDialogCustomize](CIFileDialogCustomize) object gives the class's
members; it takes and gives back a reference of its own. For a message box, take the dialog's
window from its `IOleWindow` interface, as the example does. A handler runs while `ShowOpen` or
`ShowSave` is waiting, on the same thread.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui
```

## Example

An Open dialog with a *Desktop* button that jumps to the desktop, and which refuses file names
that contain a comma.

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

const IDC_OPEN    = 101
const IDC_DESKTOP = 1

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

' // The handler for the added button
type MyControlEvents extends CIFileDialogControlEvents
    declare function OnButtonClicked( byval pfdc as IFileDialogCustomize ptr, byval dwIDCtl as DWORD ) as HRESULT
end type

function MyControlEvents.OnButtonClicked( byval pfdc as IFileDialogCustomize ptr, byval dwIDCtl as DWORD ) as HRESULT
    if dwIDCtl <> IDC_DESKTOP then return S_OK
    dim pfd as IFileDialog ptr
    if pfdc->lpVtbl->QueryInterface( pfdc, @IID_IFileDialog, @pfd ) = S_OK then
        dim psi as IShellItem ptr
        if SHGetKnownFolderItem( @FOLDERID_Desktop, 0, NULL, @IID_IShellItem, @psi ) = S_OK then
            pfd->lpVtbl->SetFolder( pfd, psi )
            psi->lpVtbl->Release( psi )
        end if
        pfd->lpVtbl->Release( pfd )
    end if
    return S_OK
end function

' // The handler for the dialog's own events
type MyEvents extends CIFileDialogEvents
    declare function QueryInterface( byval riid as REFIID, byval ppvObj as LPVOID ptr ) as HRESULT
    declare function OnFileOk( byval pfd as IFileDialog ptr ) as HRESULT
end type

function MyEvents.QueryInterface( byval riid as REFIID, byval ppvObj as LPVOID ptr ) as HRESULT
    if ppvObj = NULL then return E_INVALIDARG
    if IsEqualIID( riid, @IID_IFileDialogControlEvents ) then
        dim pce as MyControlEvents ptr = new MyControlEvents
        pce->AddRef()
        *ppvObj = cast( any ptr, pce )
        return S_OK
    end if
    return base.QueryInterface( riid, ppvObj )
end function

function MyEvents.OnFileOk( byval pfd as IFileDialog ptr ) as HRESULT
    dim pwszName as wstring ptr
    if pfd->lpVtbl->GetFileName( pfd, @pwszName ) <> S_OK then return S_OK
    dim bComma as boolean = ( instr( *pwszName, "," ) > 0 )
    CoTaskMemFree( pwszName )
    if bComma = false then return S_OK
    dim pow as IOleWindow ptr, hDlgWnd as HWND
    if pfd->lpVtbl->QueryInterface( pfd, @IID_IOleWindow, @pow ) = S_OK then
        pow->lpVtbl->GetWindow( pow, @hDlgWnd )
        pow->lpVtbl->Release( pow )
    end if
    MessageBoxW( hDlgWnd, "File names with a comma are not accepted.", "Open", MB_OK or MB_ICONWARNING )
    return S_FALSE                                   ' keep the dialog open
end function

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "EventsDemo"
    dim hWin as HWND = pWindow.Create( NULL, "File dialog events", @WndProc )
    pWindow.SetClientSize( 420, 120 )
    pWindow.Center()
    pWindow.AddControl( "Button", hWin, IDC_OPEN, "&Open...", 160, 45, 100, 30 )
    return pWindow.DoEvents( SW_NORMAL )
end function

sub PickFile( byval hwnd as HWND )
    dim pofd as CIOpenFileDialog
    dim cust as CIFileDialogCustomize = cast( IFileDialog ptr, pofd.GetPtr() )
    cust.AddPushButton( IDC_DESKTOP, "&Desktop" )
    dim pfde as any ptr = new MyEvents
    pofd.SetEvents( pfde )
    if pofd.ShowOpen( hwnd ) = S_OK then SetWindowText( hwnd, pofd.GetResultString( SIGDN_FILESYSPATH ) )
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

## Members

**CIFileDialogEvents**

| Member | Does |
| --- | --- |
| [Constructor](#constructor) | Creates the object with a reference count of 0. |
| [Destructor](#destructor) | Runs when the last reference is released. |
| [QueryInterface](#queryinterface) | Answers the dialog's requests for interfaces. |
| [AddRef](#addref) | Adds a reference. |
| [Release](#release) | Removes a reference and deletes the object at 0. |
| [OnFileOk](#onfileok) | Called when the user accepts a choice; can keep the dialog open. |
| [OnFolderChanging](#onfolderchanging) | Called before the dialog changes folder; can stop it. |
| [OnFolderChange](#onfolderchange) | Called after the dialog has changed folder, and when it opens. |
| [OnSelectionChange](#onselectionchange) | Called when the selection in the view changes. |
| [OnShareViolation](#onshareviolation) | Called when the chosen file is in use by another program. |
| [OnTypeChange](#ontypechange) | Called when the dialog opens and when the user picks another file type. |
| [OnOverwrite](#onoverwrite) | Called when the user of a Save dialog picks an existing file. |

**CIFileDialogControlEvents**

| Member | Does |
| --- | --- |
| [Constructor](#constructor-1) | Creates the object with a reference count of 0. |
| [Destructor](#destructor-1) | Runs when the last reference is released. |
| [QueryInterface](#queryinterface-1) | Answers requests for `IFileDialogControlEvents` and `IUnknown`. |
| [AddRef](#addref-1) | Adds a reference. |
| [Release](#release-1) | Removes a reference and deletes the object at 0. |
| [OnItemSelected](#onitemselected) | Called when the user picks an item of an added combo box, radio list or menu. |
| [OnButtonClicked](#onbuttonclicked) | Called when the user clicks an added push button. |
| [OnCheckButtonToggled](#oncheckbuttontoggled) | Called when the user checks or clears an added check box. |
| [OnControlActivating](#oncontrolactivating) | Called just before an added menu or the Open drop-down opens. |

## CIFileDialogEvents

### Constructor

```freebasic
constructor
```

Creates the object; it does nothing else. The reference count, the public field
`refCount as ULONG`, starts at 0. Create the object with `new`.

**Example**

```freebasic
dim pofd as CIOpenFileDialog
dim pfde as any ptr = new CIFileDialogEvents
pofd.SetEvents( pfde )
```

### Destructor

```freebasic
virtual destructor
```

Does nothing; an extended type can declare its own to clean up. It runs when
[Release](#release) brings the count to 0.

**Example**

```freebasic
dim pfde as CIFileDialogEvents ptr = new CIFileDialogEvents
pfde->AddRef()
pfde->Release()   ' the count reaches 0: the destructor runs and the object is freed
```

### QueryInterface

```freebasic
virtual function QueryInterface( byval riid as REFIID, byval ppvObject as LPVOID ptr ) as HRESULT
```

Answers a request for an interface:

| `riid` | Answer |
| --- | --- |
| `IID_IUnknown`, `IID_IFileOpenDialog`, `IID_IFileSaveDialog` | the object itself, with a reference added |
| `IID_IFileDialogControlEvents` | a **new** `CIFileDialogControlEvents`, with a reference of 1 |
| anything else, `IID_IFileDialogEvents` included | `E_NOINTERFACE` |

Each request for `IID_IFileDialogControlEvents` makes another object. Declare `QueryInterface`
in an extended type to answer that request with your own control-events type.

**Returns** `S_OK`; `E_NOINTERFACE`; `E_INVALIDARG` when `ppvObject` is `NULL`.

**Example**

```freebasic
dim pfde as CIFileDialogEvents ptr = new CIFileDialogEvents
dim pUnk as IUnknown ptr
if pfde->QueryInterface( @IID_IUnknown, @pUnk ) = S_OK then pUnk->lpVtbl->Release( pUnk )
```

Microsoft Learn: [IUnknown::QueryInterface](https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nf-unknwn-iunknown-queryinterface%28refiid_void%29)

### AddRef

```freebasic
virtual function AddRef() as ULONG
```

Adds one to `refCount`. The dialog calls it; a program calls it only for a pointer it keeps.

**Returns** the new count.

**Example**

```freebasic
dim pfde as CIFileDialogEvents ptr = new CIFileDialogEvents
print pfde->AddRef()   ' 1
pfde->Release()
```

Microsoft Learn: [IUnknown::AddRef](https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nf-unknwn-iunknown-addref)

### Release

```freebasic
virtual function Release() as ULONG
```

Takes one from `refCount` and, when it reaches 0, deletes the object. The count it returns is
read from the object after that `delete`, so at 0 it comes from freed memory.

**Returns** the new count.

**Example**

```freebasic
dim pfde as CIFileDialogEvents ptr = new CIFileDialogEvents
pfde->AddRef() : pfde->AddRef()
print pfde->Release()   ' 1
pfde->Release()         ' deleted
```

Microsoft Learn: [IUnknown::Release](https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nf-unknwn-iunknown-release)

### OnFileOk

```freebasic
virtual function OnFileOk( byval pfd as IFileDialog ptr ) as HRESULT
```

Called when the user presses Open or Save, before the dialog closes. The choice can be read here
with the dialog's `GetResult` (or, for an Open dialog, `GetResults`). This is the place to
validate it: return `S_FALSE` to keep the dialog open, after telling the user why.

| Parameter | Meaning |
| --- | --- |
| `pfd` | The dialog. |

**Returns** `S_OK` to accept the choice and close the dialog; `S_FALSE` to keep it open.

**Example**

```freebasic
type NoCommaEvents extends CIFileDialogEvents
    declare function OnFileOk( byval pfd as IFileDialog ptr ) as HRESULT
end type
function NoCommaEvents.OnFileOk( byval pfd as IFileDialog ptr ) as HRESULT
    dim pwszName as wstring ptr
    if pfd->lpVtbl->GetFileName( pfd, @pwszName ) <> S_OK then return S_OK
    dim bComma as boolean = ( instr( *pwszName, "," ) > 0 )
    CoTaskMemFree( pwszName )
    if bComma then return S_FALSE else return S_OK
end function
```

Microsoft Learn: [IFileDialogEvents::OnFileOk](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogevents-onfileok)

### OnFolderChanging

```freebasic
virtual function OnFolderChanging( byval pfd as IFileDialog ptr, byval psiFolder as IShellItem ptr ) as HRESULT
```

Called before the dialog moves to another folder, which lets the program stop it.

| Parameter | Meaning |
| --- | --- |
| `pfd` | The dialog. |
| `psiFolder` | The folder the dialog is about to show. Do not release it. |

**Returns** `S_OK` (or `E_NOTIMPL`) to let the dialog move; an error code to stop it.

**Example**

```freebasic
type FileSystemOnly extends CIFileDialogEvents
    declare function OnFolderChanging( byval pfd as IFileDialog ptr, byval psiFolder as IShellItem ptr ) as HRESULT
end type
function FileSystemOnly.OnFolderChanging( byval pfd as IFileDialog ptr, byval psiFolder as IShellItem ptr ) as HRESULT
    dim pwszPath as wstring ptr
    if psiFolder->lpVtbl->GetDisplayName( psiFolder, SIGDN_FILESYSPATH, @pwszPath ) <> S_OK then return E_ACCESSDENIED
    CoTaskMemFree( pwszPath )
    return S_OK
end function
```

Microsoft Learn: [IFileDialogEvents::OnFolderChanging](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogevents-onfolderchanging)

### OnFolderChange

```freebasic
virtual function OnFolderChange( byval pfd as IFileDialog ptr ) as HRESULT
```

Called when the dialog has moved to another folder, and once when it opens. Read the folder with
the dialog's `GetFolder`.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
type FolderTrace extends CIFileDialogEvents
    declare function OnFolderChange( byval pfd as IFileDialog ptr ) as HRESULT
end type
function FolderTrace.OnFolderChange( byval pfd as IFileDialog ptr ) as HRESULT
    dim psi as IShellItem ptr, pwszPath as wstring ptr
    if pfd->lpVtbl->GetFolder( pfd, @psi ) <> S_OK then return S_OK
    if psi->lpVtbl->GetDisplayName( psi, SIGDN_FILESYSPATH, @pwszPath ) = S_OK then OutputDebugStringW( pwszPath ) : CoTaskMemFree( pwszPath )
    psi->lpVtbl->Release( psi )
    return S_OK
end function
```

Microsoft Learn: [IFileDialogEvents::OnFolderChange](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogevents-onfolderchange)

### OnSelectionChange

```freebasic
virtual function OnSelectionChange( byval pfd as IFileDialog ptr ) as HRESULT
```

Called when the user selects other items in the dialog's view. Read the selection with the
dialog's `GetCurrentSelection`.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
const IDC_PREVIEW = 9
type PreviewEvents extends CIFileDialogEvents
    declare function OnSelectionChange( byval pfd as IFileDialog ptr ) as HRESULT
end type
function PreviewEvents.OnSelectionChange( byval pfd as IFileDialog ptr ) as HRESULT
    dim cust as CIFileDialogCustomize = pfd
    dim psi as IShellItem ptr
    if pfd->lpVtbl->GetCurrentSelection( pfd, @psi ) = S_OK then
        psi->lpVtbl->Release( psi )
        cust.SetControlState( IDC_PREVIEW, CDCS_ENABLEDVISIBLE )
    else
        cust.SetControlState( IDC_PREVIEW, CDCS_VISIBLE )   ' greyed
    end if
    return S_OK
end function
```

Microsoft Learn: [IFileDialogEvents::OnSelectionChange](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogevents-onselectionchange)

### OnShareViolation

```freebasic
virtual function OnShareViolation( byval pfd as IFileDialog ptr, byval psi as IShellItem ptr, byval pResponse as FDE_SHAREVIOLATION_RESPONSE ptr ) as HRESULT
```

Called when the chosen file is open in another program in a way that conflicts with opening or
saving it. The handler answers through `*pResponse`: `FDESVR_ACCEPT` to take the file anyway,
`FDESVR_REFUSE` to refuse it, `FDESVR_DEFAULT` to let the dialog tell the user. The base handler
leaves `*pResponse` as it is.

| Parameter | Meaning |
| --- | --- |
| `pfd` | The dialog. |
| `psi` | The file. |
| `pResponse` | Receives the answer. |

**Returns** `S_OK`, or `E_NOTIMPL` when the handler leaves the event to the dialog.

**Example**

```freebasic
type ReadAnyway extends CIFileDialogEvents
    declare function OnShareViolation( byval pfd as IFileDialog ptr, byval psi as IShellItem ptr, byval pResponse as FDE_SHAREVIOLATION_RESPONSE ptr ) as HRESULT
end type
function ReadAnyway.OnShareViolation( byval pfd as IFileDialog ptr, byval psi as IShellItem ptr, byval pResponse as FDE_SHAREVIOLATION_RESPONSE ptr ) as HRESULT
    *pResponse = FDESVR_ACCEPT   ' the program only reads the file
    return S_OK
end function
```

Microsoft Learn: [IFileDialogEvents::OnShareViolation](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogevents-onshareviolation)

### OnTypeChange

```freebasic
virtual function OnTypeChange( byval pfd as IFileDialog ptr ) as HRESULT
```

Called when the dialog opens, with the initial file type, and whenever the user picks another
type. Read the one-based type index with the dialog's `GetFileTypeIndex`.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
type ExtensionEvents extends CIFileDialogEvents
    declare function OnTypeChange( byval pfd as IFileDialog ptr ) as HRESULT
end type
function ExtensionEvents.OnTypeChange( byval pfd as IFileDialog ptr ) as HRESULT
    dim iType as UINT
    pfd->lpVtbl->GetFileTypeIndex( pfd, @iType )
    if iType = 2 then pfd->lpVtbl->SetDefaultExtension( pfd, "csv" ) else pfd->lpVtbl->SetDefaultExtension( pfd, "txt" )
    return S_OK
end function
```

Microsoft Learn: [IFileDialogEvents::OnTypeChange](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogevents-ontypechange)

### OnOverwrite

```freebasic
virtual function OnOverwrite( byval pfd as IFileDialog ptr, byval psi as IShellItem ptr, byval pResponse as FDE_OVERWRITE_RESPONSE ptr ) as HRESULT
```

Called by a Save dialog when the user picks a file that already exists. The handler answers
through `*pResponse`: `FDEOR_ACCEPT` to overwrite it, `FDEOR_REFUSE` to refuse it,
`FDEOR_DEFAULT` to let the dialog ask the user. The base handler leaves `*pResponse` as it is.

| Parameter | Meaning |
| --- | --- |
| `pfd` | The dialog. |
| `psi` | The existing file. |
| `pResponse` | Receives the answer. |

**Returns** `S_OK`, or `E_NOTIMPL` when the handler leaves the event to the dialog.

**Example**

```freebasic
type KeepOriginals extends CIFileDialogEvents
    declare function OnOverwrite( byval pfd as IFileDialog ptr, byval psi as IShellItem ptr, byval pResponse as FDE_OVERWRITE_RESPONSE ptr ) as HRESULT
end type
function KeepOriginals.OnOverwrite( byval pfd as IFileDialog ptr, byval psi as IShellItem ptr, byval pResponse as FDE_OVERWRITE_RESPONSE ptr ) as HRESULT
    *pResponse = FDEOR_REFUSE   ' never save over an existing file
    return S_OK
end function
```

Microsoft Learn: [IFileDialogEvents::OnOverwrite](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogevents-onoverwrite)

## CIFileDialogControlEvents

The control handlers receive `pfdc`, the dialog's `IFileDialogCustomize` interface, and the ID
the control was added with.

### Constructor

```freebasic
constructor
```

Creates the object, with `refCount` at 0. Create it with `new`, in the `QueryInterface` of an
extended `CIFileDialogEvents`, and add the reference the caller receives.

**Example**

```freebasic
dim pce as CIFileDialogControlEvents ptr = new CIFileDialogControlEvents
pce->AddRef()   ' the reference handed to the dialog
pce->Release()
```

### Destructor

```freebasic
virtual destructor
```

Does nothing; it runs when [Release](#release-1) brings the count to 0.

**Example**

```freebasic
dim pce as CIFileDialogControlEvents ptr = new CIFileDialogControlEvents
pce->AddRef()
pce->Release()   ' deleted here
```

### QueryInterface

```freebasic
virtual function QueryInterface( byval riid as REFIID, byval ppvObject as LPVOID ptr ) as HRESULT
```

Answers `IID_IFileDialogControlEvents` and `IID_IUnknown` with the object itself, adding a
reference.

**Returns** `S_OK`; `E_NOINTERFACE` for any other interface; `E_INVALIDARG` when `ppvObject` is
`NULL`.

**Example**

```freebasic
dim pce as CIFileDialogControlEvents ptr = new CIFileDialogControlEvents
dim pUnk as IUnknown ptr
if pce->QueryInterface( @IID_IFileDialogControlEvents, @pUnk ) = S_OK then pUnk->lpVtbl->Release( pUnk )
```

Microsoft Learn: [IUnknown::QueryInterface](https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nf-unknwn-iunknown-queryinterface%28refiid_void%29)

### AddRef

```freebasic
virtual function AddRef() as ULONG
```

Adds one to `refCount` and returns the new count.

**Example**

```freebasic
dim pce as CIFileDialogControlEvents ptr = new CIFileDialogControlEvents
print pce->AddRef()   ' 1
pce->Release()
```

### Release

```freebasic
virtual function Release() as ULONG
```

Takes one from `refCount` and deletes the object at 0. As with
[CIFileDialogEvents.Release](#release), the count returned at 0 is read after the `delete`.

**Example**

```freebasic
dim pce as CIFileDialogControlEvents ptr = new CIFileDialogControlEvents
pce->AddRef()
pce->Release()   ' deleted
```

### OnItemSelected

```freebasic
virtual function OnItemSelected( byval pfdc as IFileDialogCustomize ptr, byval dwIDCtl as DWORD, byval dwIDItem as DWORD ) as HRESULT
```

Called when the user selects an item in an added combo box, clicks a radio button, or chooses a
command from an added menu. It is not called for the Open button's drop-down: read that choice
with [GetSelectedControlItem](CIFileDialogCustomize#getselectedcontrolitem) after the dialog
closes.

| Parameter | Meaning |
| --- | --- |
| `pfdc` | The dialog's customization interface. |
| `dwIDCtl` | The ID of the container. |
| `dwIDItem` | The ID of the item. |

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
type EncodingEvents extends CIFileDialogControlEvents
    declare function OnItemSelected( byval pfdc as IFileDialogCustomize ptr, byval dwIDCtl as DWORD, byval dwIDItem as DWORD ) as HRESULT
end type
function EncodingEvents.OnItemSelected( byval pfdc as IFileDialogCustomize ptr, byval dwIDCtl as DWORD, byval dwIDItem as DWORD ) as HRESULT
    if dwIDCtl <> 3 then return S_OK
    dim cust as CIFileDialogCustomize = pfdc
    if dwIDItem = 1 then cust.SetControlState( 4, CDCS_ENABLEDVISIBLE ) else cust.SetControlState( 4, CDCS_VISIBLE )
    return S_OK
end function
```

Microsoft Learn: [IFileDialogControlEvents::OnItemSelected](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl/nf-shobjidl-ifiledialogcontrolevents-onitemselected)

### OnButtonClicked

```freebasic
virtual function OnButtonClicked( byval pfdc as IFileDialogCustomize ptr, byval dwIDCtl as DWORD ) as HRESULT
```

Called when the user clicks a push button added with
[AddPushButton](CIFileDialogCustomize#addpushbutton). The dialog stays open.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
type ClearEvents extends CIFileDialogControlEvents
    declare function OnButtonClicked( byval pfdc as IFileDialogCustomize ptr, byval dwIDCtl as DWORD ) as HRESULT
end type
function ClearEvents.OnButtonClicked( byval pfdc as IFileDialogCustomize ptr, byval dwIDCtl as DWORD ) as HRESULT
    dim cust as CIFileDialogCustomize = pfdc
    if dwIDCtl = 9 then cust.SetEditBoxText( 7, "" )   ' the Clear button empties the tag box
    return S_OK
end function
```

Microsoft Learn: [IFileDialogControlEvents::OnButtonClicked](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl/nf-shobjidl-ifiledialogcontrolevents-onbuttonclicked)

### OnCheckButtonToggled

```freebasic
virtual function OnCheckButtonToggled( byval pfdc as IFileDialogCustomize ptr, byval dwIDCtl as DWORD, byval bChecked as WINBOOL ) as HRESULT
```

Called when the user checks or clears a check box added with
[AddCheckButton](CIFileDialogCustomize#addcheckbutton). `bChecked` is the new state.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
type ToggleEvents extends CIFileDialogControlEvents
    declare function OnCheckButtonToggled( byval pfdc as IFileDialogCustomize ptr, byval dwIDCtl as DWORD, byval bChecked as WINBOOL ) as HRESULT
end type
function ToggleEvents.OnCheckButtonToggled( byval pfdc as IFileDialogCustomize ptr, byval dwIDCtl as DWORD, byval bChecked as WINBOOL ) as HRESULT
    dim cust as CIFileDialogCustomize = pfdc
    if dwIDCtl = 1 then cust.SetControlState( 3, iif( bChecked, CDCS_INACTIVE, CDCS_ENABLEDVISIBLE ) )
    return S_OK
end function
```

Microsoft Learn: [IFileDialogControlEvents::OnCheckButtonToggled](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl/nf-shobjidl-ifiledialogcontrolevents-oncheckbuttontoggled)

### OnControlActivating

```freebasic
virtual function OnControlActivating( byval pfdc as IFileDialogCustomize ptr, byval dwIDCtl as DWORD ) as HRESULT
```

Called just before an added menu, or the Open button's drop-down, shows its items: the moment
to enable, disable or rename them.

**Returns** `S_OK`, or an error code.

**Example**

```freebasic
type MenuEvents extends CIFileDialogControlEvents
    declare function OnControlActivating( byval pfdc as IFileDialogCustomize ptr, byval dwIDCtl as DWORD ) as HRESULT
end type
function MenuEvents.OnControlActivating( byval pfdc as IFileDialogCustomize ptr, byval dwIDCtl as DWORD ) as HRESULT
    dim cust as CIFileDialogCustomize = pfdc
    if dwIDCtl = 8 then cust.SetControlItemState( 8, 2, iif( IsClipboardFormatAvailable( CF_HDROP ), CDCS_ENABLEDVISIBLE, CDCS_VISIBLE ) )
    return S_OK
end function
```

Microsoft Learn: [IFileDialogControlEvents::OnControlActivating](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl/nf-shobjidl-ifiledialogcontrolevents-oncontrolactivating)

## See also

- [File dialogs](SysWin-Gui-File-Dialogs) for showing the dialogs and attaching these handlers
- [CIFileDialogCustomize](CIFileDialogCustomize) for adding the controls whose events
  `CIFileDialogControlEvents` receives
- [sys/win/gui](SysWin-Gui)
