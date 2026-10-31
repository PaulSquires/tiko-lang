[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/richedit](SysWin-RichEdit) › **CRichEditOleCallback**

# CRichEditOleCallback

Answers a rich edit control's OLE questions, so that pictures and objects can be pasted.

A rich edit control asks its program, through an `IRichEditOleCallback` object, for storage
whenever a picture or other embedded object is pasted, dropped or read from RTF, and for a
context menu on a right-click. Without such an object it refuses embedded objects. Give it one
with [CRichEditCtx](CRichEditCtx-Editing)`.SetOleCallback`.

`CRichEditOleCallback` is a ready-made implementation. [GetNewStorage](#getnewstorage) supplies
storage in memory, [QueryInsertObject](#queryinsertobject) and [DeleteObject](#deleteobject)
accept everything, and the other methods return `E_NOTIMPL`, which leaves the control to its
own default behaviour. Its methods are `virtual`: to change one, derive a type from it and
`override` that method (see [GetContextMenu](#getcontextmenu)).

**Lifetime.** The object counts its references, starting from 0, and **deletes itself** when the
count returns to 0. The control adds a reference when it is given the object and releases it
when it is destroyed. So create the object with `new` and hand it over; do not keep or delete it
yourself:

```freebasic
pRichEdit.SetOleCallback( new CRichEditOleCallback )
```

An object declared with `dim` (on the stack or `static`) is deleted with `delete` when the
control lets it go, which it must not be.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/richedit"
using win, richedit
```

## Example

A rich edit control that accepts pictures: copy an image in another program and paste it with
Ctrl+V.

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/richedit"
using win, gui, richedit

const IDC_RICHEDIT = 101

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "OleDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Paste a picture", @WndProc )
    SetWindowClientSizeForDpi( hWin, 500, 300 )
    CenterWindow( hWin )
    dim pRichEdit as CRichEditCtx = CRichEditCtx( @pWindow, IDC_RICHEDIT, "", 10, 10, 480, 280 )
    pWindow.AnchorControl( IDC_RICHEDIT, ANCHOR_HEIGHT_WIDTH )
    pRichEdit.SetOleCallback( new CRichEditOleCallback )   ' the control releases it when it is destroyed
    pRichEdit.SetText( "Paste a picture here: " )
    SetFocus( pRichEdit.hRichEdit )
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
| [Constructor](#constructor) | Makes the object with a reference count of 0. |
| [Destructor](#destructor) | Runs when the object deletes itself. |
| [QueryInterface](#queryinterface) | Hands out the object as `IRichEditOleCallback` or `IUnknown`. |
| [AddRef](#addref) | Adds a reference. |
| [Release](#release) | Removes a reference; deletes the object at 0. |
| [GetNewStorage](#getnewstorage) | Makes storage in memory for a new embedded object. |
| [GetInPlaceContext](#getinplacecontext) | In-place activation support (not implemented). |
| [ShowContainerUI](#showcontainerui) | Shows or hides the container's interface (not implemented). |
| [QueryInsertObject](#queryinsertobject) | Lets every object be inserted. |
| [DeleteObject](#deleteobject) | Is told an object is being deleted. |
| [QueryAcceptData](#queryacceptdata) | Decides whether pasted or dropped data is taken (not implemented). |
| [ContextSensitiveHelp](#contextsensitivehelp) | Context-sensitive help mode (not implemented). |
| [GetClipboardData](#getclipboarddata) | Supplies the clipboard data for a copy or cut (not implemented). |
| [GetDragDropEffect](#getdragdropeffect) | Decides the effect of a drag and drop (not implemented). |
| [GetContextMenu](#getcontextmenu) | Supplies a context menu for a right-click (not implemented). |

## Reference

### Constructor

```freebasic
constructor
```

Makes the object with a reference count of 0. Create it with `new`; the control's first
`AddRef` takes the count to 1.

**Example**

```freebasic
dim pCallback as CRichEditOleCallback ptr = new CRichEditOleCallback
CRichEditCtxPtr( hCtrl )->SetOleCallback( pCallback )
```

Microsoft Learn: [EM_SETOLECALLBACK](https://learn.microsoft.com/en-us/windows/win32/controls/em-setolecallback)

### Destructor

```freebasic
destructor
```

Does nothing of its own; it runs when [Release](#release) takes the count to 0 and the object
deletes itself.

**Example**

```freebasic
dim pCallback as CRichEditOleCallback ptr = new CRichEditOleCallback
pCallback->AddRef()
pCallback->Release()          ' the count is 0 again: the object is deleted
```

### QueryInterface

```freebasic
virtual function QueryInterface( byval as REFIID, byval as PVOID ptr ) as HRESULT
```

Writes the object's own address to the second argument when the first is
`IID_IRichEditOleCallback`, `IID_IUnknown` or `IID_IDispatch`, and returns `S_OK`; any other
interface gets `E_NOINTERFACE`, and a `NULL` second argument `E_INVALIDARG`.

Two things differ from the usual rule: the reference count is **not** increased for the
pointer handed out, and `IID_IDispatch` is answered although the object has no `IDispatch`
methods. Call [AddRef](#addref) yourself if you keep the pointer.

| Parameter | Meaning |
| --- | --- |
| first | The interface asked for. |
| second | Receives the pointer. |

**Returns** `S_OK`, `E_NOINTERFACE` or `E_INVALIDARG`.

**Example**

```freebasic
dim pCallback as CRichEditOleCallback ptr = new CRichEditOleCallback
dim iid as IID = IID_IUnknown
dim pUnk as any ptr
if pCallback->QueryInterface( @iid, @pUnk ) = S_OK then pCallback->AddRef()
pCallback->Release()
```

Microsoft Learn: [IUnknown::QueryInterface](https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nf-unknwn-iunknown-queryinterface%28refiid_void%29)

### AddRef

```freebasic
virtual function AddRef() as ULONG
```

Adds a reference to the object.

**Returns** the new count.

**Example**

```freebasic
dim pCallback as CRichEditOleCallback ptr = new CRichEditOleCallback
print pCallback->AddRef()     ' 1
pCallback->Release()
```

Microsoft Learn: [IUnknown::AddRef](https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nf-unknwn-iunknown-addref)

### Release

```freebasic
virtual function Release() as ULONG
```

Removes a reference. When the count reaches 0 the object deletes itself with `delete`, so it
must have been made with `new`, and must not be used afterwards.

**Returns** the count left; 0 means the object is gone.

**Example**

```freebasic
dim pCallback as CRichEditOleCallback ptr = new CRichEditOleCallback
CRichEditCtxPtr( hCtrl )->SetOleCallback( pCallback )
print pCallback->AddRef()     ' 2: the control holds the other reference
print pCallback->Release()    ' 1
```

Microsoft Learn: [IUnknown::Release](https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nf-unknwn-iunknown-release)

### GetNewStorage

```freebasic
virtual function GetNewStorage( byval lplpstg as LPSTORAGE ptr ) as HRESULT
```

Called by the control when it needs storage for a new embedded object (a pasted or dropped
picture, or an object read from RTF). It creates a compound-file storage on a block of memory
and writes its `IStorage` pointer to `lplpstg`; the control owns it. Without this method no
embedded object can be pasted or dropped.

| Parameter | Meaning |
| --- | --- |
| `lplpstg` | Receives the new storage. |

**Returns** `S_OK`, or the failing `HRESULT` (`E_OUTOFMEMORY`, `E_INVALIDARG` …).

**Example**

```freebasic
dim pCallback as CRichEditOleCallback ptr = new CRichEditOleCallback
dim pStorage as LPSTORAGE
if pCallback->GetNewStorage( @pStorage ) = S_OK then pStorage->lpVtbl->Release( pStorage )
delete pCallback              ' never handed to a control
```

Microsoft Learn: [IRichEditOleCallback::GetNewStorage](https://learn.microsoft.com/en-us/windows/win32/api/richole/nf-richole-iricheditolecallback-getnewstorage), [StgCreateDocfileOnILockBytes](https://learn.microsoft.com/en-us/windows/win32/api/coml2api/nf-coml2api-stgcreatedocfileonilockbytes)

### GetInPlaceContext

```freebasic
virtual function GetInPlaceContext( byval lplpFrame as LPOLEINPLACEFRAME ptr, byval lplpDoc as LPOLEINPLACEUIWINDOW ptr, byval lpFrameInfo as LPOLEINPLACEFRAMEINFO ) as HRESULT
```

Called when an embedded object is to be activated in place, to get the frame and document
windows it would use. Not implemented, so objects are not activated in place.

| Parameter | Meaning |
| --- | --- |
| `lplpFrame` | Receives the frame window interface. |
| `lplpDoc` | Receives the document window interface. |
| `lpFrameInfo` | Receives information about the frame. |

**Returns** `E_NOTIMPL`.

**Example**

```freebasic
dim pCallback as CRichEditOleCallback ptr = new CRichEditOleCallback
dim info as OLEINPLACEFRAMEINFO
print hex( pCallback->GetInPlaceContext( NULL, NULL, @info ) )
delete pCallback
```

Microsoft Learn: [IRichEditOleCallback::GetInPlaceContext](https://learn.microsoft.com/en-us/windows/win32/api/richole/nf-richole-iricheditolecallback-getinplacecontext)

### ShowContainerUI

```freebasic
virtual function ShowContainerUI( byval fShow as WINBOOL ) as HRESULT
```

Called to show or hide the container's own menus and toolbars while an object is active. Not
implemented.

| Parameter | Meaning |
| --- | --- |
| `fShow` | `TRUE` to show them, `FALSE` to hide them. |

**Returns** `E_NOTIMPL`.

**Example**

```freebasic
dim pCallback as CRichEditOleCallback ptr = new CRichEditOleCallback
print hex( pCallback->ShowContainerUI( TRUE ) )
delete pCallback
```

Microsoft Learn: [IRichEditOleCallback::ShowContainerUI](https://learn.microsoft.com/en-us/windows/win32/api/richole/nf-richole-iricheditolecallback-showcontainerui)

### QueryInsertObject

```freebasic
virtual function QueryInsertObject( byval lpclsid as LPCLSID, byval lpstg as LPSTORAGE, byval cp as LONG ) as HRESULT
```

Called before an object is inserted by a paste or from RTF, to ask whether it may be. This one
allows every object; override it to refuse some, by class or by position.

| Parameter | Meaning |
| --- | --- |
| `lpclsid` | The class of the object. |
| `lpstg` | The object's storage. |
| `cp` | The character position it would be inserted at. |

**Returns** `S_OK`: insert it.

**Example**

```freebasic
dim pCallback as CRichEditOleCallback ptr = new CRichEditOleCallback
print hex( pCallback->QueryInsertObject( NULL, NULL, 0 ) )   ' 0
delete pCallback
```

Microsoft Learn: [IRichEditOleCallback::QueryInsertObject](https://learn.microsoft.com/en-us/windows/win32/api/richole/nf-richole-iricheditolecallback-queryinsertobject)

### DeleteObject

```freebasic
virtual function DeleteObject( byval lpoleobj as LPOLEOBJECT ) as HRESULT
```

Called when an object is about to be removed from the text (it may stay alive elsewhere, on the
undo stack for example). This one does nothing.

| Parameter | Meaning |
| --- | --- |
| `lpoleobj` | The object. |

**Returns** `S_OK`.

**Example**

```freebasic
dim pCallback as CRichEditOleCallback ptr = new CRichEditOleCallback
print hex( pCallback->DeleteObject( NULL ) )               ' 0
delete pCallback
```

Microsoft Learn: [IRichEditOleCallback::DeleteObject](https://learn.microsoft.com/en-us/windows/win32/api/richole/nf-richole-iricheditolecallback-deleteobject)

### QueryAcceptData

```freebasic
virtual function QueryAcceptData( byval lpdataobj as LPDATAOBJECT, byval lpcfFormat as CLIPFORMAT ptr, byval reco as DWORD, byval fReally as WINBOOL, byval hMetaPict as HGLOBAL ) as HRESULT
```

Called during a paste or a drop, and by `EM_CANPASTE`, to ask whether the data should be taken.
Not implemented: the control takes `E_NOTIMPL` as no objection and checks the data itself
(`EM_CANPASTE` gives the same answer with and without this object). Override it to restrict
what can be pasted; a failure code there refuses the data.

| Parameter | Meaning |
| --- | --- |
| `lpdataobj` | The data being pasted or dropped. |
| `lpcfFormat` | The clipboard format to be used; 0 for the best one available. |
| `reco` | `RECO_PASTE` or `RECO_DROP`. |
| `fReally` | `FALSE` when the control is only asking, as for `EM_CANPASTE`. |
| `hMetaPict` | An icon metafile, for a paste-special as an icon. |

**Returns** `E_NOTIMPL`.

**Example**

```freebasic
dim pCallback as CRichEditOleCallback ptr = new CRichEditOleCallback
print hex( pCallback->QueryAcceptData( NULL, NULL, RECO_PASTE, FALSE, NULL ) )   ' 80004001
delete pCallback
```

Microsoft Learn: [IRichEditOleCallback::QueryAcceptData](https://learn.microsoft.com/en-us/windows/win32/api/richole/nf-richole-iricheditolecallback-queryacceptdata)

### ContextSensitiveHelp

```freebasic
virtual function ContextSensitiveHelp( byval fEnterMode as WINBOOL ) as HRESULT
```

Called to enter or leave context-sensitive help mode (Shift+F1). Not implemented.

| Parameter | Meaning |
| --- | --- |
| `fEnterMode` | `TRUE` to enter the mode, `FALSE` to leave it. |

**Returns** `E_NOTIMPL`.

**Example**

```freebasic
dim pCallback as CRichEditOleCallback ptr = new CRichEditOleCallback
print hex( pCallback->ContextSensitiveHelp( TRUE ) )
delete pCallback
```

Microsoft Learn: [IRichEditOleCallback::ContextSensitiveHelp](https://learn.microsoft.com/en-us/windows/win32/api/richole/nf-richole-iricheditolecallback-contextsensitivehelp)

### GetClipboardData

```freebasic
virtual function GetClipboardData( byval lpchrg as CHARRANGE ptr, byval reco as DWORD, byval lplpdataobj as LPDATAOBJECT ptr ) as HRESULT
```

Called on a copy, cut or drag so that the program can supply its own data object for the
selected text. Not implemented, so the control builds the data itself.

| Parameter | Meaning |
| --- | --- |
| `lpchrg` | The characters being copied. |
| `reco` | `RECO_COPY`, `RECO_CUT` or `RECO_DRAG`. |
| `lplpdataobj` | Receives the data object. |

**Returns** `E_NOTIMPL`.

**Example**

```freebasic
dim pCallback as CRichEditOleCallback ptr = new CRichEditOleCallback
dim chrg as CHARRANGE = ( 0, 5 )
dim pData as LPDATAOBJECT
print hex( pCallback->GetClipboardData( @chrg, RECO_COPY, @pData ) )
delete pCallback
```

Microsoft Learn: [IRichEditOleCallback::GetClipboardData](https://learn.microsoft.com/en-us/windows/win32/api/richole/nf-richole-iricheditolecallback-getclipboarddata)

### GetDragDropEffect

```freebasic
virtual function GetDragDropEffect( byval fDrag as WINBOOL, byval grfKeyState as DWORD, byval pdwEffect as LPDWORD ) as HRESULT
```

Called during a drag and drop to let the program choose the effect (copy, move, none). Not
implemented, so the control decides.

| Parameter | Meaning |
| --- | --- |
| `fDrag` | `TRUE` while dragging, `FALSE` at the drop. |
| `grfKeyState` | The state of the mouse buttons and modifier keys. |
| `pdwEffect` | The effect, `DROPEFFECT_*`, to read and change. |

**Returns** `E_NOTIMPL`.

**Example**

```freebasic
dim pCallback as CRichEditOleCallback ptr = new CRichEditOleCallback
dim dwEffect as DWORD = DROPEFFECT_COPY
print hex( pCallback->GetDragDropEffect( TRUE, 0, @dwEffect ) )
delete pCallback
```

Microsoft Learn: [IRichEditOleCallback::GetDragDropEffect](https://learn.microsoft.com/en-us/windows/win32/api/richole/nf-richole-iricheditolecallback-getdragdropeffect)

### GetContextMenu

```freebasic
virtual function GetContextMenu( byval seltype as WORD, byval lpoleobj as LPOLEOBJECT, byval lpchrg as CHARRANGE ptr, byval lphmenu as HMENU ptr ) as HRESULT
```

Called on a right-click to get a context menu to show. Not implemented, so the control shows
none. To have one, override it in a derived type: create a popup menu and store it in
`*lphmenu`. The control shows it, sends the chosen command to its parent window as
`WM_COMMAND`, and destroys the menu afterwards.

| Parameter | Meaning |
| --- | --- |
| `seltype` | What is selected: `SEL_EMPTY`, `SEL_TEXT`, `SEL_OBJECT`, `SEL_MULTICHAR`, `SEL_MULTIOBJECT`, or `GCM_RIGHTMOUSEDROP` for a right-button drop. |
| `lpoleobj` | The first selected object, or `NULL`. |
| `lpchrg` | The selection. |
| `lphmenu` | Receives the menu. |

**Returns** `E_NOTIMPL`.

**Example**

```freebasic
type MenuCallback extends CRichEditOleCallback
    declare function GetContextMenu( byval seltype as WORD, byval lpoleobj as LPOLEOBJECT, byval lpchrg as CHARRANGE ptr, byval lphmenu as HMENU ptr ) as HRESULT override
end type

function MenuCallback.GetContextMenu( byval seltype as WORD, byval lpoleobj as LPOLEOBJECT, byval lpchrg as CHARRANGE ptr, byval lphmenu as HMENU ptr ) as HRESULT
    dim hMenu as HMENU = CreatePopupMenu()
    AppendMenuW( hMenu, MF_STRING, WM_COPY, "&Copy" )
    AppendMenuW( hMenu, MF_STRING, WM_PASTE, "&Paste" )
    *lphmenu = hMenu              ' the control destroys it
    return S_OK
end function
```

Give the control `new MenuCallback` in place of `new CRichEditOleCallback`.

Microsoft Learn: [IRichEditOleCallback::GetContextMenu](https://learn.microsoft.com/en-us/windows/win32/api/richole/nf-richole-iricheditolecallback-getcontextmenu)

## See also

- [sys/win/richedit](SysWin-RichEdit)
- [CRichEditCtx: editing](CRichEditCtx-Editing) for `SetOleCallback`
- [CRichEditCtx](CRichEditCtx) for the control itself
- [Text Object Model](SysWin-RichEdit-TOM)
