[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/webview2](SysWin-WebView2) › **WebView2 event handlers**

# WebView2 event handlers
Implements the WebView2 callback interfaces as classes to extend, one per event or result.

<!-- scope: CWebView2CreateCoreWebView2EnvironmentCompletedHandler -->
<!-- scope: CWebView2CreateCoreWebView2ControllerCompletedHandler -->
<!-- scope: CWebView2NavigationStartingdEventHandler -->
<!-- scope: CWebView2NavigationCompletedEventHandler -->
<!-- scope: CWebView2ContentLoadingEventHandler -->
<!-- scope: CWebView2SourceChangedEventHandler -->
<!-- scope: CWebView2HistoryChangedEventHandler -->
<!-- scope: CWebView2ScriptDialogOpeningEventHandler -->
<!-- scope: CWebView2PermissionRequestedEventHandler -->
<!-- scope: CWebView2ProcessFailedEventHandler -->
<!-- scope: CWebView2WebMessageReceivedEventHandler -->
<!-- scope: CWebView2NewWindowRequestedEventHandler -->
<!-- scope: CWebView2DocumentTitleChangedEventHandler -->
<!-- scope: CWebView2ContainsFullScreenElementChangedEventHandler -->
<!-- scope: CWebView2WebResourceRequestedEventHandler -->
<!-- scope: CWebView2WindowCloseRequestedEventHandler -->
<!-- scope: CWebView2ExecuteScriptCompletedHandler -->
<!-- scope: CWebView2AddScriptToExecuteOnDocumentCreatedCompleteHandler -->
<!-- scope: CWebView2AddCapturePreviewCompletedHandler -->
<!-- scope: CWebView2DevToolsProtocolEventReceivedEventHandler -->
<!-- scope: CWebView2ZoomFactorChangedEventHandler -->
<!-- scope: CWebView2MoveFocusRequestedEventHandler -->
<!-- scope: CWebView2FocusChangedEventHandler -->
<!-- scope: CWebView2AcceleratorKeyPressedEventHandler -->
<!-- scope: CWebView2NewBrowserVersionAvailableEventHandler -->
<!-- scope: CWebView2CallDevToolsProtocolMethodCompletedHandler -->
<!-- scope: CWebView2ExecuteScriptWithResultCompletedHandler -->

Implements the WebView2 callback interfaces as classes to extend, one per event or result.

WebView2 reports events (a navigation finished, the title changed, the page posted a message)
and the results of asynchronous calls (a script ran, the environment is ready) by calling back
into the program through small COM interfaces. Each class here implements one of them. In every
class `Invoke` does nothing and returns `S_OK`, so an object of the class itself receives the
event and ignores it.

**Handling an event.** Extend the class and declare `Invoke` again with exactly the same
parameter types; it is virtual, so yours is the one WebView2 calls. Create the object with `new`
and pass it, cast to `any ptr`, to the [CWebView2](CWebView2) method that attaches it, such as
[AddDocumentTitleChanged](CWebView2#adddocumenttitlechanged-removedocumenttitlechanged), or to the interface method that
takes it. The classes extend `OBJECT`, not the interface types, which is why the cast is needed;
their virtual methods are laid out as the interface expects. An `Invoke` declared with other
parameter types is a different method, and WebView2 keeps calling the one that does nothing.

**Lifetime.** The objects are reference counted the COM way, in the public field
`refCount as ULONG`. It starts at 0 (at 1 in
[CWebView2ExecuteScriptWithResultCompletedHandler](#cwebview2executescriptwithresultcompletedhandler)).
WebView2 takes a reference when the handler is attached or the call is made, and gives it back
when the handler is removed, once a one-time result has been delivered, or when the web view
closes; [Release](#queryinterface-addref-release) deletes the object when the count reaches 0.
So never `dim` one on the stack and never `delete` one that WebView2 has accepted. If attaching
fails, nothing holds the object: `delete` it yourself.

**In Invoke.** `Invoke` runs on the thread that created the web view, while it dispatches
messages: in [DoEvents](CWindow#doevents) or in [IsReady](CWebView2#isready). `sender` and `args`
are borrowed for the call; call `AddRef` on one to keep it longer. A string read from them is the
handler's to free with `CoTaskMemFree`. `args` has methods of its own (`get_uri`, `put_Cancel` …),
listed with each class and on [WebView2 interfaces and types](SysWin-WebView2-Interfaces).

**Removing a handler.** The `Add` methods fill in an `EventRegistrationToken`. Keep it to detach
the handler later with the matching `Remove` method; WebView2 then gives back its reference.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/webview2"
using win, webview2
```

## Example

A browser window whose caption follows the page title and says when a navigation fails. Like
every WebView2 program it needs `WebView2Loader.dll` beside the executable; the WebView2 examples
in the toolchain's `examples/win64/` folder come with one.

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/webview2"
using win, gui, webview2

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

' // Puts the page title in the caption
type TitleHandler extends CWebView2DocumentTitleChangedEventHandler
    declare constructor( byval hWin as HWND )
    declare function Invoke( byval sender as ICoreWebView2 ptr, byval args as IUnknown ptr ) as HRESULT
    m_hWin as HWND
end type

constructor TitleHandler( byval hWin as HWND )
    m_hWin = hWin
end constructor

function TitleHandler.Invoke( byval sender as ICoreWebView2 ptr, byval args as IUnknown ptr ) as HRESULT
    dim pwszTitle as LPWSTR
    if sender->get_DocumentTitle( @pwszTitle ) = S_OK then
        SetWindowTextW( m_hWin, pwszTitle )
        CoTaskMemFree( pwszTitle )
    end if
    return S_OK
end function

' // Reports a failed navigation in the caption
type NavHandler extends CWebView2NavigationCompletedEventHandler
    declare constructor( byval hWin as HWND )
    declare function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2NavigationCompletedEventArgs ptr ) as HRESULT
    m_hWin as HWND
end type

constructor NavHandler( byval hWin as HWND )
    m_hWin = hWin
end constructor

function NavHandler.Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2NavigationCompletedEventArgs ptr ) as HRESULT
    dim bSuccess as LONG, nStatus as COREWEBVIEW2_WEB_ERROR_STATUS
    args->get_IsSuccess( @bSuccess )
    args->get_WebErrorStatus( @nStatus )
    if bSuccess = 0 then SetWindowText( m_hWin, "Navigation failed, status " & nStatus )
    return S_OK
end function

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "WebView2Events"
    dim hWin as HWND = pWindow.Create( NULL, "WebView2 events", @WndProc )
    pWindow.SetClientSize( 900, 600 )
    pWindow.Center()
    dim ustrFolder as ustring = GetTempPath() & "tkWebView2"
    dim pWebView2 as CWebView2 = CWebView2( hWin, ustrFolder )
    if pWebView2.IsReady( 10000 ) then
        dim as EventRegistrationToken tokTitle, tokNav
        dim pTitle as TitleHandler ptr = new TitleHandler( hWin )
        if pWebView2.AddDocumentTitleChanged( cast( any ptr, pTitle ), @tokTitle ) <> S_OK then delete pTitle
        dim pNav as NavHandler ptr = new NavHandler( hWin )
        if pWebView2.AddNavigationCompleted( cast( any ptr, pNav ), @tokNav ) <> S_OK then delete pNav
        pWebView2.Navigate( "https://learn.microsoft.com/" )
    end if
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_SIZE
            dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
            if pWebView2 then
                dim rc as RECT
                GetClientRect( hwnd, @rc )
                pWebView2->SetBounds( rc )
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

The handlers are never deleted by the program: WebView2 releases them when the web view closes,
as `main` ends, and they delete themselves.

## Members

Every class has the same [QueryInterface, AddRef, Release](#queryinterface-addref-release), a
[Constructor, Destructor](#constructor-destructor) entry and an `Invoke` that does nothing and
returns `S_OK`. What `Invoke` receives:

| Class | Implements | Invoke receives |
| --- | --- | --- |
| [CWebView2CreateCoreWebView2EnvironmentCompletedHandler](#cwebview2createcorewebview2environmentcompletedhandler) | `ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler` | [the new environment](#invoke) |
| [CWebView2CreateCoreWebView2ControllerCompletedHandler](#cwebview2createcorewebview2controllercompletedhandler) | `ICoreWebView2CreateCoreWebView2ControllerCompletedHandler` | [the new controller](#invoke-1) |
| [CWebView2NavigationStartingdEventHandler](#cwebview2navigationstartingdeventhandler) | `ICoreWebView2NavigationStartingEventHandler` | [the start of a navigation](#invoke-2) |
| [CWebView2NavigationCompletedEventHandler](#cwebview2navigationcompletedeventhandler) | `ICoreWebView2NavigationCompletedEventHandler` | [the end of a navigation](#invoke-3) |
| [CWebView2ContentLoadingEventHandler](#cwebview2contentloadingeventhandler) | `ICoreWebView2ContentLoadingEventHandler` | [the start of loading of a new document](#invoke-4) |
| [CWebView2SourceChangedEventHandler](#cwebview2sourcechangedeventhandler) | `ICoreWebView2SourceChangedEventHandler` | [a change of the address](#invoke-5) |
| [CWebView2HistoryChangedEventHandler](#cwebview2historychangedeventhandler) | `ICoreWebView2HistoryChangedEventHandler` | [a change of the back and forward history](#invoke-6) |
| [CWebView2ScriptDialogOpeningEventHandler](#cwebview2scriptdialogopeningeventhandler) | `ICoreWebView2ScriptDialogOpeningEventHandler` | [a JavaScript `alert`, `confirm`, `prompt` or `beforeunload` dialog](#invoke-7) |
| [CWebView2PermissionRequestedEventHandler](#cwebview2permissionrequestedeventhandler) | `ICoreWebView2PermissionRequestedEventHandler` | [a request for a permission](#invoke-8) |
| [CWebView2ProcessFailedEventHandler](#cwebview2processfailedeventhandler) | `ICoreWebView2ProcessFailedEventHandler` | [the failure of a browser process](#invoke-9) |
| [CWebView2WebMessageReceivedEventHandler](#cwebview2webmessagereceivedeventhandler) | `ICoreWebView2WebMessageReceivedEventHandler` | [a message posted by the page](#invoke-10) |
| [CWebView2NewWindowRequestedEventHandler](#cwebview2newwindowrequestedeventhandler) | `ICoreWebView2NewWindowRequestedEventHandler` | [a request to open a new window](#invoke-11) |
| [CWebView2DocumentTitleChangedEventHandler](#cwebview2documenttitlechangedeventhandler) | `ICoreWebView2DocumentTitleChangedEventHandler` | [a change of the page title](#invoke-12) |
| [CWebView2ContainsFullScreenElementChangedEventHandler](#cwebview2containsfullscreenelementchangedeventhandler) | `ICoreWebView2ContainsFullScreenElementChangedEventHandler` | [an element entering or leaving full screen](#invoke-13) |
| [CWebView2WebResourceRequestedEventHandler](#cwebview2webresourcerequestedeventhandler) | `ICoreWebView2WebResourceRequestedEventHandler` | [a request for a resource that matches a filter](#invoke-14) |
| [CWebView2WindowCloseRequestedEventHandler](#cwebview2windowcloserequestedeventhandler) | `ICoreWebView2WindowCloseRequestedEventHandler` | [a request from the page to close the window](#invoke-15) |
| [CWebView2ExecuteScriptCompletedHandler](#cwebview2executescriptcompletedhandler) | `ICoreWebView2ExecuteScriptCompletedHandler` | [the result of a script](#invoke-16) |
| [CWebView2AddScriptToExecuteOnDocumentCreatedCompleteHandler](#cwebview2addscripttoexecuteondocumentcreatedcompletehandler) | `ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler` | [the id of a script added to every document](#invoke-17) |
| [CWebView2AddCapturePreviewCompletedHandler](#cwebview2addcapturepreviewcompletedhandler) | `ICoreWebView2CapturePreviewCompletedHandler` | [the end of a screenshot of the page](#invoke-18) |
| [CWebView2DevToolsProtocolEventReceivedEventHandler](#cwebview2devtoolsprotocoleventreceivedeventhandler) | `ICoreWebView2DevToolsProtocolEventReceivedEventHandler` | [a DevTools Protocol event](#invoke-19) |
| [CWebView2ZoomFactorChangedEventHandler](#cwebview2zoomfactorchangedeventhandler) | `ICoreWebView2ZoomFactorChangedEventHandler` | [a change of the zoom factor](#invoke-20) |
| [CWebView2MoveFocusRequestedEventHandler](#cwebview2movefocusrequestedeventhandler) | `ICoreWebView2MoveFocusRequestedEventHandler` | [a request to move the focus out of the web view](#invoke-21) |
| [CWebView2FocusChangedEventHandler](#cwebview2focuschangedeventhandler) | `ICoreWebView2FocusChangedEventHandler` | [the web view gaining or losing the focus](#invoke-22) |
| [CWebView2AcceleratorKeyPressedEventHandler](#cwebview2acceleratorkeypressedeventhandler) | `ICoreWebView2AcceleratorKeyPressedEventHandler` | [a shortcut key pressed in the web view](#invoke-23) |
| [CWebView2NewBrowserVersionAvailableEventHandler](#cwebview2newbrowserversionavailableeventhandler) | `ICoreWebView2NewBrowserVersionAvailableEventHandler` | [the installation of a newer WebView2 runtime](#invoke-24) |
| [CWebView2CallDevToolsProtocolMethodCompletedHandler](#cwebview2calldevtoolsprotocolmethodcompletedhandler) | `ICoreWebView2CallDevToolsProtocolMethodCompletedHandler` | [the result of a DevTools Protocol method](#invoke-25) |
| [CWebView2ExecuteScriptWithResultCompletedHandler](#cwebview2executescriptwithresultcompletedhandler) | `ICoreWebView2ExecuteScriptWithResultCompletedHandler` | [the result of a script, with any exception](#invoke-26) |

## Common members

### QueryInterface, AddRef, Release

```freebasic
virtual function QueryInterface( byval riid as REFIID, byval ppvObject as LPVOID ptr ) as HRESULT
virtual function AddRef() as ULONG
virtual function Release() as ULONG
```

The `IUnknown` methods, the same in all 27 classes. WebView2 calls them; a program rarely
does.

- `QueryInterface` returns `S_OK` whatever interface is asked for, and writes nothing to
  `ppvObject`. WebView2 does not call it on a handler.
- `AddRef` adds 1 to `refCount` and returns the new count.
- `Release` takes 1 from `refCount` and, when that leaves 0, deletes the object, running the
  destructors of your type and of the class. It returns the count; once the object has deleted
  itself that value is read from the deleted object, so do not rely on it, and do not touch the
  object again.

| Parameter | Meaning |
| --- | --- |
| `riid` | The identifier of the interface asked for. |
| `ppvObject` | Where the interface pointer would go; left as it is. |

**Returns** `S_OK` (`QueryInterface`); the new reference count (`AddRef`, `Release`).

**Example**

```freebasic
dim pHandler as CWebView2DocumentTitleChangedEventHandler ptr = new CWebView2DocumentTitleChangedEventHandler
print pHandler->AddRef()      ' 1
pHandler->Release()           ' the count is 0 again: the object deletes itself
```

Microsoft Learn: [IUnknown](https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nn-unknwn-iunknown)

## CWebView2CreateCoreWebView2EnvironmentCompletedHandler

Implements `ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler`: the new environment.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim hr as HRESULT = CreateCoreWebView2Environment( cast( any ptr, new CWebView2CreateCoreWebView2EnvironmentCompletedHandler ) )
```

### Invoke

```freebasic
virtual function Invoke( byval errorCode as HRESULT, byval createdEnvironment as ICoreWebView2Environment ptr ) as HRESULT
```

Called once when an environment requested with `CreateCoreWebView2Environment` or
`CreateCoreWebView2EnvironmentWithOptions` has been created, or has failed. [CWebView2](CWebView2)
does this step itself with a handler of its own; use this class to drive WebView2 without it. The
usual next step is `CreateCoreWebView2Controller` on the environment. To keep the environment after
`Invoke` returns, call its `AddRef`.

| Parameter | Meaning |
| --- | --- |
| `errorCode` | `S_OK`, or why the environment could not be created. |
| `createdEnvironment` | The environment, borrowed for the call; `NULL` on failure. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type EnvironmentReady extends CWebView2CreateCoreWebView2EnvironmentCompletedHandler
    declare function Invoke( byval errorCode as HRESULT, byval createdEnvironment as ICoreWebView2Environment ptr ) as HRESULT
end type
function EnvironmentReady.Invoke( byval errorCode as HRESULT, byval createdEnvironment as ICoreWebView2Environment ptr ) as HRESULT
    if errorCode <> S_OK then return S_OK
    ' // ask for the controller of a web view in the window
    createdEnvironment->CreateCoreWebView2Controller( hwnd, cast( any ptr, new CWebView2CreateCoreWebView2ControllerCompletedHandler ) )
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2createcorewebview2environmentcompletedhandler)

## CWebView2CreateCoreWebView2ControllerCompletedHandler

Implements `ICoreWebView2CreateCoreWebView2ControllerCompletedHandler`: the new controller.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim pEnv as ICoreWebView2Environment ptr = CWebView2Ptr( hwnd )->GetEnvironmentPtr()
pEnv->CreateCoreWebView2Controller( hwnd, cast( any ptr, new CWebView2CreateCoreWebView2ControllerCompletedHandler ) )
```

### Invoke

```freebasic
virtual function Invoke( byval errorCode as HRESULT, byval createdController as ICoreWebView2Controller ptr ) as HRESULT
```

Called once when a controller requested with the environment's `CreateCoreWebView2Controller` has
been created, or has failed. The controller gives the `ICoreWebView2` through `get_CoreWebView2`.
Call `AddRef` on it to keep it; until a controller is kept, the web view goes away when the call
returns.

| Parameter | Meaning |
| --- | --- |
| `errorCode` | `S_OK`, or why the controller could not be created. |
| `createdController` | The controller, borrowed for the call; `NULL` on failure. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
dim shared g_pController as ICoreWebView2Controller ptr
type ControllerReady extends CWebView2CreateCoreWebView2ControllerCompletedHandler
    declare function Invoke( byval errorCode as HRESULT, byval createdController as ICoreWebView2Controller ptr ) as HRESULT
end type
function ControllerReady.Invoke( byval errorCode as HRESULT, byval createdController as ICoreWebView2Controller ptr ) as HRESULT
    if errorCode = S_OK then
        g_pController = createdController
        g_pController->AddRef()
    end if
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2CreateCoreWebView2ControllerCompletedHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2createcorewebview2controllercompletedhandler)

## CWebView2NavigationStartingdEventHandler

Implements `ICoreWebView2NavigationStartingEventHandler`: the start of a navigation.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim token as EventRegistrationToken
CWebView2Ptr( hwnd )->AddNavigationStarting( cast( any ptr, new CWebView2NavigationStartingdEventHandler ), @token )
```

### Invoke

```freebasic
virtual function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2NavigationCompletedEventArgs ptr ) as HRESULT
```

Called before the web view navigates to a new document, and before each redirect, while the
navigation can still be cancelled. Attach it with
[AddNavigationStarting](CWebView2#addnavigationstarting-removenavigationstarting) (the main
document) or
[AddFrameNavigationStarting](CWebView2#addframenavigationstarting-removeframenavigationstarting)
(iframes).

The class name has a `d` before `EventHandler`, and `args` is declared as
`ICoreWebView2NavigationCompletedEventArgs ptr` although WebView2 passes an
`ICoreWebView2NavigationStartingEventArgs`. Declare your `Invoke` with the declared types, or it
does not replace this one (the base `Invoke` keeps being called), and cast `args` to
`ICoreWebView2NavigationStartingEventArgs ptr` to read it, as the example does.

| Parameter | Meaning |
| --- | --- |
| `sender` | The web view. |
| `args` | The navigation: `get_uri`, `get_IsUserInitiated`, `get_IsRedirected`, `get_RequestHeaders`, `put_Cancel`, `get_NavigationId`. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type NavStarting extends CWebView2NavigationStartingdEventHandler
    declare function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2NavigationCompletedEventArgs ptr ) as HRESULT
end type
function NavStarting.Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2NavigationCompletedEventArgs ptr ) as HRESULT
    dim pArgs as ICoreWebView2NavigationStartingEventArgs ptr = cast( any ptr, args )
    dim pwszUri as LPWSTR
    if pArgs->get_uri( @pwszUri ) = S_OK then
        if instr( *pwszUri, "example.org" ) then pArgs->put_Cancel( TRUE )
        CoTaskMemFree( pwszUri )
    end if
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2NavigationStartingEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2navigationstartingeventhandler)

## CWebView2NavigationCompletedEventHandler

Implements `ICoreWebView2NavigationCompletedEventHandler`: the end of a navigation.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim token as EventRegistrationToken
CWebView2Ptr( hwnd )->AddNavigationCompleted( cast( any ptr, new CWebView2NavigationCompletedEventHandler ), @token )
```

### Invoke

```freebasic
virtual function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2NavigationCompletedEventArgs ptr ) as HRESULT
```

Called when a navigation has finished, whether it succeeded or failed. Attach it with
[AddNavigationCompleted](CWebView2#addnavigationcompleted-removenavigationcompleted) or
[AddFrameNavigationCompleted](CWebView2#addframenavigationcompleted-removeframenavigationcompleted).

| Parameter | Meaning |
| --- | --- |
| `sender` | The web view. |
| `args` | `get_IsSuccess`, `get_WebErrorStatus` (a `COREWEBVIEW2_WEB_ERROR_STATUS`) and `get_NavigationId`. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type NavCompleted extends CWebView2NavigationCompletedEventHandler
    declare function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2NavigationCompletedEventArgs ptr ) as HRESULT
end type
function NavCompleted.Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2NavigationCompletedEventArgs ptr ) as HRESULT
    dim bSuccess as LONG, nStatus as COREWEBVIEW2_WEB_ERROR_STATUS
    args->get_IsSuccess( @bSuccess )
    args->get_WebErrorStatus( @nStatus )
    if bSuccess = 0 then SetWindowText( hwnd, "Navigation failed: status " & nStatus )
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2NavigationCompletedEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2navigationcompletedeventhandler)

## CWebView2ContentLoadingEventHandler

Implements `ICoreWebView2ContentLoadingEventHandler`: the start of loading of a new document.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim token as EventRegistrationToken
CWebView2Ptr( hwnd )->AddContentLoading( cast( any ptr, new CWebView2ContentLoadingEventHandler ), @token )
```

### Invoke

```freebasic
virtual function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2ContentLoadingEventArgs ptr ) as HRESULT
```

Called when the web view begins loading the content of a new document, after `NavigationStarting`
and before `NavigationCompleted`. Attach it with
[AddContentLoading](CWebView2#addcontentloading-removecontentloading).

| Parameter | Meaning |
| --- | --- |
| `sender` | The web view. |
| `args` | `get_IsErrorPage`, nonzero when the content is the built-in error page, and `get_NavigationId`. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type ContentLoading extends CWebView2ContentLoadingEventHandler
    declare function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2ContentLoadingEventArgs ptr ) as HRESULT
end type
function ContentLoading.Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2ContentLoadingEventArgs ptr ) as HRESULT
    dim bErrorPage as LONG
    args->get_IsErrorPage( @bErrorPage )
    SetWindowText( hwnd, iif( bErrorPage, "Error page", "Loading..." ) )
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2ContentLoadingEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2contentloadingeventhandler)

## CWebView2SourceChangedEventHandler

Implements `ICoreWebView2SourceChangedEventHandler`: a change of the address.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim token as EventRegistrationToken
CWebView2Ptr( hwnd )->AddSourceChanged( cast( any ptr, new CWebView2SourceChangedEventHandler ), @token )
```

### Invoke

```freebasic
virtual function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2SourceChangedEventArgs ptr ) as HRESULT
```

Called when the web view's source URI changes: on a navigation to a new document, and on a change
within the same document such as a fragment. Attach it with
[AddSourceChanged](CWebView2#addsourcechanged-removesourcechanged).

| Parameter | Meaning |
| --- | --- |
| `sender` | The web view; `get_Source` gives the new address. |
| `args` | `get_IsNewDocument`, nonzero when the change loads a new document. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type SourceChanged extends CWebView2SourceChangedEventHandler
    declare function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2SourceChangedEventArgs ptr ) as HRESULT
end type
function SourceChanged.Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2SourceChangedEventArgs ptr ) as HRESULT
    dim pwszUri as LPWSTR
    if sender->get_Source( @pwszUri ) = S_OK then
        SetWindowTextW( hwnd, pwszUri )
        CoTaskMemFree( pwszUri )
    end if
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2SourceChangedEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2sourcechangedeventhandler)

## CWebView2HistoryChangedEventHandler

Implements `ICoreWebView2HistoryChangedEventHandler`: a change of the back and forward history.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim token as EventRegistrationToken
CWebView2Ptr( hwnd )->GetWebViewPtr()->add_HistoryChanged( cast( any ptr, new CWebView2HistoryChangedEventHandler ), @token )
```

### Invoke

```freebasic
virtual function Invoke( byval sender as ICoreWebView2 ptr, byval args as IUnknown ptr ) as HRESULT
```

Called when the navigation history changes, the moment to update Back and Forward buttons.
[AddHistoryChanged](CWebView2#addhistorychanged-removehistorychanged) of `CWebView2` attaches the
handler to the `SourceChanged` event, not to `HistoryChanged`; to receive `HistoryChanged` itself,
attach it through the interface with `add_HistoryChanged`, as the registration example does.

| Parameter | Meaning |
| --- | --- |
| `sender` | The web view; `get_CanGoBack` and `get_CanGoForward` give the new state. |
| `args` | `args` is not used by this event; WebView2 passes `NULL`. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type HistoryChanged extends CWebView2HistoryChangedEventHandler
    declare function Invoke( byval sender as ICoreWebView2 ptr, byval args as IUnknown ptr ) as HRESULT
end type
function HistoryChanged.Invoke( byval sender as ICoreWebView2 ptr, byval args as IUnknown ptr ) as HRESULT
    dim bBack as WINBOOL, bForward as WINBOOL
    sender->get_CanGoBack( @bBack )
    sender->get_CanGoForward( @bForward )
    EnableWindow( GetDlgItem( hwnd, 101 ), bBack )
    EnableWindow( GetDlgItem( hwnd, 102 ), bForward )
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2HistoryChangedEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2historychangedeventhandler)

## CWebView2ScriptDialogOpeningEventHandler

Implements `ICoreWebView2ScriptDialogOpeningEventHandler`: a JavaScript `alert`, `confirm`, `prompt` or `beforeunload` dialog.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim token as EventRegistrationToken
CWebView2Ptr( hwnd )->AreDefaultScriptDialogsEnabled = false
CWebView2Ptr( hwnd )->AddScriptDialogOpening( cast( any ptr, new CWebView2ScriptDialogOpeningEventHandler ), @token )
```

### Invoke

```freebasic
virtual function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2ScriptDialogOpeningEventArgs ptr ) as HRESULT
```

Called when the page opens a JavaScript dialog, so that the program can show its own. The event is
raised only once the built-in dialogs are turned off with
[AreDefaultScriptDialogsEnabled](CWebView2#aredefaultscriptdialogsenabled). Call `Accept` to answer
OK (and `put_ResultText` first for a `prompt`); return without it to answer Cancel. Attach it with
[AddScriptDialogOpening](CWebView2#addscriptdialogopening-removescriptdialogopening).

| Parameter | Meaning |
| --- | --- |
| `sender` | The web view. |
| `args` | `get_Kind` (a `COREWEBVIEW2_SCRIPT_DIALOG_KIND`), `get_Message`, `get_DefaultText`, `put_ResultText`, `Accept`, `GetDeferral`. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type ScriptDialog extends CWebView2ScriptDialogOpeningEventHandler
    declare function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2ScriptDialogOpeningEventArgs ptr ) as HRESULT
end type
function ScriptDialog.Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2ScriptDialogOpeningEventArgs ptr ) as HRESULT
    dim pwszMessage as LPWSTR
    if args->get_Message( @pwszMessage ) = S_OK then
        if MessageBoxW( hwnd, pwszMessage, "The page says", MB_OKCANCEL ) = IDOK then args->Accept()
        CoTaskMemFree( pwszMessage )
    end if
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2ScriptDialogOpeningEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2scriptdialogopeningeventhandler)

## CWebView2PermissionRequestedEventHandler

Implements `ICoreWebView2PermissionRequestedEventHandler`: a request for a permission.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim token as EventRegistrationToken
CWebView2Ptr( hwnd )->AddPermissionRequested( cast( any ptr, new CWebView2PermissionRequestedEventHandler ), @token )
```

### Invoke

```freebasic
virtual function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2PermissionRequestedEventArgs ptr ) as HRESULT
```

Called when the page asks for a permission such as the location, the camera or the microphone. Set
the answer with `put_State`; leaving it at `COREWEBVIEW2_PERMISSION_STATE_DEFAULT` lets WebView2
decide, which usually means asking the user. Attach it with
[AddPermissionRequested](CWebView2#addpermissionrequested-removepermissionrequested).

| Parameter | Meaning |
| --- | --- |
| `sender` | The web view. |
| `args` | `get_uri`, `get_PermissionKind` (a `COREWEBVIEW2_PERMISSION_KIND`), `get_IsUserInitiated`, `put_State`, `GetDeferral`. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type PermissionAsked extends CWebView2PermissionRequestedEventHandler
    declare function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2PermissionRequestedEventArgs ptr ) as HRESULT
end type
function PermissionAsked.Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2PermissionRequestedEventArgs ptr ) as HRESULT
    dim nKind as COREWEBVIEW2_PERMISSION_KIND
    args->get_PermissionKind( @nKind )
    if nKind = COREWEBVIEW2_PERMISSION_KIND_GEOLOCATION then args->put_State( COREWEBVIEW2_PERMISSION_STATE_DENY )
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2PermissionRequestedEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2permissionrequestedeventhandler)

## CWebView2ProcessFailedEventHandler

Implements `ICoreWebView2ProcessFailedEventHandler`: the failure of a browser process.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim token as EventRegistrationToken
CWebView2Ptr( hwnd )->AddProcessFailed( cast( any ptr, new CWebView2ProcessFailedEventHandler ), @token )
```

### Invoke

```freebasic
virtual function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2ProcessFailedEventArgs ptr ) as HRESULT
```

Called when one of the browser processes behind the web view exits unexpectedly or stops responding.
A failed render process leaves the page blank until it is reloaded; a failed browser process ends
the web view, which then has to be created again. Attach it with
[AddProcessFailed](CWebView2#addprocessfailed-removeprocessfailed).

| Parameter | Meaning |
| --- | --- |
| `sender` | The web view. |
| `args` | `get_ProcessFailedKind`, a `COREWEBVIEW2_PROCESS_FAILED_KIND`. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type ProcessFailed extends CWebView2ProcessFailedEventHandler
    declare function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2ProcessFailedEventArgs ptr ) as HRESULT
end type
function ProcessFailed.Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2ProcessFailedEventArgs ptr ) as HRESULT
    dim nKind as COREWEBVIEW2_PROCESS_FAILED_KIND
    args->get_ProcessFailedKind( @nKind )
    if nKind = COREWEBVIEW2_PROCESS_FAILED_KIND_RENDER_PROCESS_EXITED then sender->Reload()
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2ProcessFailedEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2processfailedeventhandler)

## CWebView2WebMessageReceivedEventHandler

Implements `ICoreWebView2WebMessageReceivedEventHandler`: a message posted by the page.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim token as EventRegistrationToken
CWebView2Ptr( hwnd )->AddWebMessageReceived( cast( any ptr, new CWebView2WebMessageReceivedEventHandler ), @token )
```

### Invoke

```freebasic
virtual function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2WebMessageReceivedEventArgs ptr ) as HRESULT
```

Called when the page's script calls `window.chrome.webview.postMessage`. It is the page's way of
talking to the program; the other direction is
[PostWebMessageAsString](CWebView2#postwebmessageasstring) and
[PostWebMessageAsJson](CWebView2#postwebmessageasjson). Web messages must be enabled, which they are
by default. Attach it with
[AddWebMessageReceived](CWebView2#addwebmessagereceived-removewebmessagereceived).

| Parameter | Meaning |
| --- | --- |
| `sender` | The web view. |
| `args` | `get_Source` (the address of the page that sent it), `get_webMessageAsJson`, and `TryGetWebMessageAsString`, which fails unless the message is a string. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type MessageReceived extends CWebView2WebMessageReceivedEventHandler
    declare function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2WebMessageReceivedEventArgs ptr ) as HRESULT
end type
function MessageReceived.Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2WebMessageReceivedEventArgs ptr ) as HRESULT
    dim pwszMessage as LPWSTR
    if args->TryGetWebMessageAsString( @pwszMessage ) = S_OK then
        SetWindowTextW( hwnd, pwszMessage )
        CoTaskMemFree( pwszMessage )
    end if
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2WebMessageReceivedEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2webmessagereceivedeventhandler)

## CWebView2NewWindowRequestedEventHandler

Implements `ICoreWebView2NewWindowRequestedEventHandler`: a request to open a new window.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim token as EventRegistrationToken
CWebView2Ptr( hwnd )->AddNewWindowRequested( cast( any ptr, new CWebView2NewWindowRequestedEventHandler ), @token )
```

### Invoke

```freebasic
virtual function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2NewWindowRequestedEventArgs ptr ) as HRESULT
```

Called when the page asks for a new window: `window.open`, a link with `target="_blank"`, or the
user choosing to open a link in a new window. Unless the handler sets `put_Handled` or supplies a
web view with `put_NewWindow`, WebView2 opens a separate browser window. Attach it with
[AddNewWindowRequested](CWebView2#addnewwindowrequested-removenewwindowrequested).

| Parameter | Meaning |
| --- | --- |
| `sender` | The web view. |
| `args` | `get_uri`, `put_NewWindow`, `put_Handled`, `get_IsUserInitiated`, `GetDeferral`, `get_WindowFeatures`. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type NewWindow extends CWebView2NewWindowRequestedEventHandler
    declare function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2NewWindowRequestedEventArgs ptr ) as HRESULT
end type
function NewWindow.Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2NewWindowRequestedEventArgs ptr ) as HRESULT
    ' // open the page in this web view instead
    dim pwszUri as LPWSTR
    if args->get_uri( @pwszUri ) = S_OK then
        args->put_Handled( TRUE )
        sender->Navigate( pwszUri )
        CoTaskMemFree( pwszUri )
    end if
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2NewWindowRequestedEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2newwindowrequestedeventhandler)

## CWebView2DocumentTitleChangedEventHandler

Implements `ICoreWebView2DocumentTitleChangedEventHandler`: a change of the page title.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim token as EventRegistrationToken
CWebView2Ptr( hwnd )->AddDocumentTitleChanged( cast( any ptr, new CWebView2DocumentTitleChangedEventHandler ), @token )
```

### Invoke

```freebasic
virtual function Invoke( byval sender as ICoreWebView2 ptr, byval args as IUnknown ptr ) as HRESULT
```

Called when the title of the top-level document changes. Attach it with
[AddDocumentTitleChanged](CWebView2#adddocumenttitlechanged-removedocumenttitlechanged).

| Parameter | Meaning |
| --- | --- |
| `sender` | The web view; `get_DocumentTitle` gives the new title. |
| `args` | `args` is not used by this event; WebView2 passes `NULL`. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type TitleChanged extends CWebView2DocumentTitleChangedEventHandler
    declare function Invoke( byval sender as ICoreWebView2 ptr, byval args as IUnknown ptr ) as HRESULT
end type
function TitleChanged.Invoke( byval sender as ICoreWebView2 ptr, byval args as IUnknown ptr ) as HRESULT
    dim pwszTitle as LPWSTR
    if sender->get_DocumentTitle( @pwszTitle ) = S_OK then
        SetWindowTextW( hwnd, pwszTitle )
        CoTaskMemFree( pwszTitle )
    end if
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2DocumentTitleChangedEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2documenttitlechangedeventhandler)

## CWebView2ContainsFullScreenElementChangedEventHandler

Implements `ICoreWebView2ContainsFullScreenElementChangedEventHandler`: an element entering or leaving full screen.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim token as EventRegistrationToken
CWebView2Ptr( hwnd )->AddContainsFullScreenElementChanged( cast( any ptr, new CWebView2ContainsFullScreenElementChangedEventHandler ), @token )
```

### Invoke

```freebasic
virtual function Invoke( byval sender as ICoreWebView2 ptr, byval args as IUnknown ptr ) as HRESULT
```

Called when an element of the page, typically a video, enters or leaves full-screen mode. WebView2
only fills the web view's own bounds; making the window cover the screen is the program's job.
Attach it with
[AddContainsFullScreenElementChanged](CWebView2#addcontainsfullscreenelementchanged-removecontainsfullscreenelementchanged).

| Parameter | Meaning |
| --- | --- |
| `sender` | The web view; `get_ContainsFullScreenElement` gives the new state. |
| `args` | `args` is not used by this event; WebView2 passes `NULL`. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type FullScreenChanged extends CWebView2ContainsFullScreenElementChangedEventHandler
    declare function Invoke( byval sender as ICoreWebView2 ptr, byval args as IUnknown ptr ) as HRESULT
end type
function FullScreenChanged.Invoke( byval sender as ICoreWebView2 ptr, byval args as IUnknown ptr ) as HRESULT
    dim bFullScreen as LONG
    sender->get_ContainsFullScreenElement( @bFullScreen )
    ShowWindow( hwnd, iif( bFullScreen, SW_MAXIMIZE, SW_RESTORE ) )
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2ContainsFullScreenElementChangedEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2containsfullscreenelementchangedeventhandler)

## CWebView2WebResourceRequestedEventHandler

Implements `ICoreWebView2WebResourceRequestedEventHandler`: a request for a resource that matches a filter.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim token as EventRegistrationToken
CWebView2Ptr( hwnd )->AddWebResourceRequestedFilter( "*", COREWEBVIEW2_WEB_RESOURCE_CONTEXT_IMAGE )
CWebView2Ptr( hwnd )->AddWebResourceRequested( cast( any ptr, new CWebView2WebResourceRequestedEventHandler ), @token )
```

### Invoke

```freebasic
virtual function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2WebResourceRequestedEventArgs ptr ) as HRESULT
```

Called for each request the page makes that matches a filter added with
[AddWebResourceRequestedFilter](CWebView2#addwebresourcerequestedfilter-removewebresourcerequestedfilter);
with no filter it is never called. The handler can read or change the request, or answer it itself
with `put_Response` and a response made by the environment's `CreateWebResourceResponse`. Attach it
with [AddWebResourceRequested](CWebView2#addwebresourcerequested-removewebresourcerequested).

| Parameter | Meaning |
| --- | --- |
| `sender` | The web view. |
| `args` | `get_Request`, `put_Response`, `GetDeferral`, `get_ResourceContext` (a `COREWEBVIEW2_WEB_RESOURCE_CONTEXT`). |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type ResourceRequested extends CWebView2WebResourceRequestedEventHandler
    declare function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2WebResourceRequestedEventArgs ptr ) as HRESULT
end type
function ResourceRequested.Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2WebResourceRequestedEventArgs ptr ) as HRESULT
    ' // answer every filtered request with 403, so no image is loaded
    dim pResponse as ICoreWebView2WebResourceResponse ptr
    dim pEnv as ICoreWebView2Environment ptr = CWebView2Ptr( hwnd )->GetEnvironmentPtr()
    if pEnv->CreateWebResourceResponse( NULL, 403, "Blocked", "", @pResponse ) = S_OK then
        args->put_Response( pResponse )
        pResponse->Release()
    end if
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2WebResourceRequestedEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2webresourcerequestedeventhandler)

## CWebView2WindowCloseRequestedEventHandler

Implements `ICoreWebView2WindowCloseRequestedEventHandler`: a request from the page to close the window.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim token as EventRegistrationToken
CWebView2Ptr( hwnd )->AddWindowCloseRequested( cast( any ptr, new CWebView2WindowCloseRequestedEventHandler ), @token )
```

### Invoke

```freebasic
virtual function Invoke( byval sender as ICoreWebView2 ptr, byval args as IUnknown ptr ) as HRESULT
```

Called when the page's script calls `window.close`. WebView2 does not close anything itself; the
program decides. Attach it with
[AddWindowCloseRequested](CWebView2#addwindowcloserequested-removewindowcloserequested).

| Parameter | Meaning |
| --- | --- |
| `sender` | The web view. |
| `args` | `args` is not used by this event; WebView2 passes `NULL`. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type CloseRequested extends CWebView2WindowCloseRequestedEventHandler
    declare function Invoke( byval sender as ICoreWebView2 ptr, byval args as IUnknown ptr ) as HRESULT
end type
function CloseRequested.Invoke( byval sender as ICoreWebView2 ptr, byval args as IUnknown ptr ) as HRESULT
    PostMessageW( hwnd, WM_CLOSE, 0, 0 )
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2WindowCloseRequestedEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2windowcloserequestedeventhandler)

## CWebView2ExecuteScriptCompletedHandler

Implements `ICoreWebView2ExecuteScriptCompletedHandler`: the result of a script.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
CWebView2Ptr( hwnd )->ExecuteScript( "document.title", cast( any ptr, new CWebView2ExecuteScriptCompletedHandler ) )
```

### Invoke

```freebasic
virtual function Invoke( byval errorCode as HRESULT, byval resultObjectAsJson as LPCWSTR ) as HRESULT
```

Called once when a script run with [ExecuteScript](CWebView2#executescript) has finished. The result
is the value of the script's last expression, as JSON: a string comes back in quotes (`"My page"`),
a number as its digits, and `undefined` or an error as `null`.

| Parameter | Meaning |
| --- | --- |
| `errorCode` | `S_OK`, or why the script could not run. |
| `resultObjectAsJson` | The result as JSON, valid during the call only. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type ScriptDone extends CWebView2ExecuteScriptCompletedHandler
    declare function Invoke( byval errorCode as HRESULT, byval resultObjectAsJson as LPCWSTR ) as HRESULT
end type
function ScriptDone.Invoke( byval errorCode as HRESULT, byval resultObjectAsJson as LPCWSTR ) as HRESULT
    if errorCode = S_OK then SetWindowTextW( hwnd, resultObjectAsJson )
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2ExecuteScriptCompletedHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2executescriptcompletedhandler)

## CWebView2AddScriptToExecuteOnDocumentCreatedCompleteHandler

Implements `ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler`: the id of a script added to every document.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
CWebView2Ptr( hwnd )->AddScriptToExecuteOnDocumentCreated( "window.fromHost = true;", cast( any ptr, new CWebView2AddScriptToExecuteOnDocumentCreatedCompleteHandler ) )
```

### Invoke

```freebasic
virtual function Invoke( byval errorCode as HRESULT, byval resultObjectAsJson as LPCWSTR ) as HRESULT
```

Called once when a script given to
[AddScriptToExecuteOnDocumentCreated](CWebView2#addscripttoexecuteondocumentcreated) has been
registered. Despite its name, the second parameter is not JSON: it is the id of the added script,
the value [RemoveScriptToExecuteOnDocumentCreated](CWebView2#removescripttoexecuteondocumentcreated)
takes to remove it again. The class name ends in `CompleteHandler`, without the `d` of the interface
name.

| Parameter | Meaning |
| --- | --- |
| `errorCode` | `S_OK`, or why the script could not be added. |
| `resultObjectAsJson` | The id of the script, valid during the call only. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
dim shared g_ustrScriptId as ustring
type ScriptAdded extends CWebView2AddScriptToExecuteOnDocumentCreatedCompleteHandler
    declare function Invoke( byval errorCode as HRESULT, byval resultObjectAsJson as LPCWSTR ) as HRESULT
end type
function ScriptAdded.Invoke( byval errorCode as HRESULT, byval resultObjectAsJson as LPCWSTR ) as HRESULT
    if errorCode = S_OK then g_ustrScriptId = *resultObjectAsJson
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2addscripttoexecuteondocumentcreatedcompletedhandler)

## CWebView2AddCapturePreviewCompletedHandler

Implements `ICoreWebView2CapturePreviewCompletedHandler`: the end of a screenshot of the page.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim pStream as IStream ptr
if CreateStreamOnHGlobal( NULL, TRUE, @pStream ) = S_OK then
    CWebView2Ptr( hwnd )->CapturePreview( COREWEBVIEW2_CAPTURE_PREVIEW_IMAGE_FORMAT_PNG, pStream, cast( any ptr, new CWebView2AddCapturePreviewCompletedHandler ) )
    pStream->lpVtbl->Release( pStream )
end if
```

### Invoke

```freebasic
virtual function Invoke( byval errorCode as HRESULT ) as HRESULT
```

Called once when [CapturePreview](CWebView2#capturepreview) has written the image of the visible
page to the stream it was given. The class name starts with `Add`, which the interface name does not
have.

| Parameter | Meaning |
| --- | --- |
| `errorCode` | `S_OK` when the image has been written to the stream. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type Captured extends CWebView2AddCapturePreviewCompletedHandler
    declare function Invoke( byval errorCode as HRESULT ) as HRESULT
end type
function Captured.Invoke( byval errorCode as HRESULT ) as HRESULT
    SetWindowText( hwnd, iif( errorCode = S_OK, "Page captured", "Capture failed" ) )
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2CapturePreviewCompletedHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2capturepreviewcompletedhandler)

## CWebView2DevToolsProtocolEventReceivedEventHandler

Implements `ICoreWebView2DevToolsProtocolEventReceivedEventHandler`: a DevTools Protocol event.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim pReceiver as ICoreWebView2DevToolsProtocolEventReceiver ptr
dim token as EventRegistrationToken
if CWebView2Ptr( hwnd )->GetDevToolsProtocolEventReceiver( "Log.entryAdded", @pReceiver ) = S_OK then
    pReceiver->add_DevToolsProtocolEventReceived( cast( any ptr, new CWebView2DevToolsProtocolEventReceivedEventHandler ), @token )
end if
```

### Invoke

```freebasic
virtual function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2DevToolsProtocolEventReceivedEventArgs ptr ) as HRESULT
```

Called each time the DevTools Protocol event it is attached to is raised. Get the receiver for one
event name with [GetDevToolsProtocolEventReceiver](CWebView2#getdevtoolsprotocoleventreceiver),
attach the handler with the receiver's `add_DevToolsProtocolEventReceived`, and turn the event's
domain on with [CallDevToolsProtocolMethod](CWebView2#calldevtoolsprotocolmethod) (for example
`Log.enable`). Keep the receiver to remove the handler later.

| Parameter | Meaning |
| --- | --- |
| `sender` | The web view. |
| `args` | `get_ParameterObjectAsJson`, the event's parameters as JSON. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type DevToolsEvent extends CWebView2DevToolsProtocolEventReceivedEventHandler
    declare function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2DevToolsProtocolEventReceivedEventArgs ptr ) as HRESULT
end type
function DevToolsEvent.Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2DevToolsProtocolEventReceivedEventArgs ptr ) as HRESULT
    dim pwszJson as LPWSTR
    if args->get_ParameterObjectAsJson( @pwszJson ) = S_OK then
        OutputDebugStringW( pwszJson )
        CoTaskMemFree( pwszJson )
    end if
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2DevToolsProtocolEventReceivedEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2devtoolsprotocoleventreceivedeventhandler)

## CWebView2ZoomFactorChangedEventHandler

Implements `ICoreWebView2ZoomFactorChangedEventHandler`: a change of the zoom factor.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim token as EventRegistrationToken
CWebView2Ptr( hwnd )->AddZoomFactorChanged( cast( any ptr, new CWebView2ZoomFactorChangedEventHandler ), @token )
```

### Invoke

```freebasic
virtual function Invoke( byval sender as ICoreWebView2Controller ptr, byval args as IUnknown ptr ) as HRESULT
```

Called when the zoom factor of the web view changes, whether the user zoomed with Ctrl and the mouse
wheel or the program set it. The sender is the controller, not the web view. Attach it with
[AddZoomFactorChanged](CWebView2#addzoomfactorchanged-removezoomfactorchanged).

| Parameter | Meaning |
| --- | --- |
| `sender` | The controller; `get_ZoomFactor` gives the new factor (1 is 100 %). |
| `args` | `args` is not used by this event; WebView2 passes `NULL`. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type ZoomChanged extends CWebView2ZoomFactorChangedEventHandler
    declare function Invoke( byval sender as ICoreWebView2Controller ptr, byval args as IUnknown ptr ) as HRESULT
end type
function ZoomChanged.Invoke( byval sender as ICoreWebView2Controller ptr, byval args as IUnknown ptr ) as HRESULT
    dim dZoom as double
    sender->get_ZoomFactor( @dZoom )
    SetWindowText( hwnd, "Zoom " & int( dZoom * 100 + 0.5 ) & " %" )
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2ZoomFactorChangedEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2zoomfactorchangedeventhandler)

## CWebView2MoveFocusRequestedEventHandler

Implements `ICoreWebView2MoveFocusRequestedEventHandler`: a request to move the focus out of the web view.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim token as EventRegistrationToken
CWebView2Ptr( hwnd )->AddMoveFocusRequested( cast( any ptr, new CWebView2MoveFocusRequestedEventHandler ), @token )
```

### Invoke

```freebasic
virtual function Invoke( byval sender as ICoreWebView2Controller ptr, byval args as ICoreWebView2MoveFocusRequestedEventArgs ptr ) as HRESULT
```

Called when the user tabs out of the last element of the page (or Shift+Tabs out of the first), so
that the program can give the focus to its next control. Set `put_Handled` once the focus has been
moved. Attach it with
[AddMoveFocusRequested](CWebView2#addmovefocusrequested-removemovefocusrequested).

| Parameter | Meaning |
| --- | --- |
| `sender` | The controller. |
| `args` | `get_reason` (a `COREWEBVIEW2_MOVE_FOCUS_REASON`) and `put_Handled`. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type FocusOut extends CWebView2MoveFocusRequestedEventHandler
    declare function Invoke( byval sender as ICoreWebView2Controller ptr, byval args as ICoreWebView2MoveFocusRequestedEventArgs ptr ) as HRESULT
end type
function FocusOut.Invoke( byval sender as ICoreWebView2Controller ptr, byval args as ICoreWebView2MoveFocusRequestedEventArgs ptr ) as HRESULT
    dim nReason as COREWEBVIEW2_MOVE_FOCUS_REASON
    args->get_reason( @nReason )
    if nReason = COREWEBVIEW2_MOVE_FOCUS_REASON_NEXT then
        SetFocus( GetDlgItem( hwnd, 101 ) )
        args->put_Handled( TRUE )
    end if
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2MoveFocusRequestedEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2movefocusrequestedeventhandler)

## CWebView2FocusChangedEventHandler

Implements `ICoreWebView2FocusChangedEventHandler`: the web view gaining or losing the focus.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim as EventRegistrationToken tokGot, tokLost
CWebView2Ptr( hwnd )->AddGotFocus( cast( any ptr, new CWebView2FocusChangedEventHandler ), @tokGot )
CWebView2Ptr( hwnd )->AddLostFocus( cast( any ptr, new CWebView2FocusChangedEventHandler ), @tokLost )
```

### Invoke

```freebasic
virtual function Invoke( byval sender as ICoreWebView2Controller ptr, byval args as IUnknown ptr ) as HRESULT
```

One class for two events: attach an object with [AddGotFocus](CWebView2#addgotfocus-removegotfocus)
and another with [AddLostFocus](CWebView2#addlostfocus-removelostfocus). `Invoke` is not told which
of the two it is answering, so give the type a field that says.

| Parameter | Meaning |
| --- | --- |
| `sender` | The controller. |
| `args` | `args` is not used by this event; WebView2 passes `NULL`. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type FocusChanged extends CWebView2FocusChangedEventHandler
    declare function Invoke( byval sender as ICoreWebView2Controller ptr, byval args as IUnknown ptr ) as HRESULT
    m_bGot as boolean
end type
function FocusChanged.Invoke( byval sender as ICoreWebView2Controller ptr, byval args as IUnknown ptr ) as HRESULT
    SetWindowText( hwnd, iif( m_bGot, "The page has the focus", "The page lost the focus" ) )
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2FocusChangedEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2focuschangedeventhandler)

## CWebView2AcceleratorKeyPressedEventHandler

Implements `ICoreWebView2AcceleratorKeyPressedEventHandler`: a shortcut key pressed in the web view.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim token as EventRegistrationToken
CWebView2Ptr( hwnd )->AddAcceleratorKeyPressed( cast( any ptr, new CWebView2AcceleratorKeyPressedEventHandler ), @token )
```

### Invoke

```freebasic
virtual function Invoke( byval sender as ICoreWebView2Controller ptr, byval args as ICoreWebView2AcceleratorKeyPressedEventArgs ptr ) as HRESULT
```

Called for keys that may be shortcuts (function keys, keys with Ctrl or Alt, Escape) while the web
view has the focus, for each key-down and key-up. Setting `put_Handled` keeps the key from the page
and from the browser's own shortcuts, such as F5 for reload. Attach it with
[AddAcceleratorKeyPressed](CWebView2#addacceleratorkeypressed-removeacceleratorkeypressed).

| Parameter | Meaning |
| --- | --- |
| `sender` | The controller. |
| `args` | `get_KeyEventKind` (a `COREWEBVIEW2_KEY_EVENT_KIND`), `get_VirtualKey`, `get_KeyEventLParam`, `get_PhysicalKeyStatus`, `put_Handled`. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type KeyPressed extends CWebView2AcceleratorKeyPressedEventHandler
    declare function Invoke( byval sender as ICoreWebView2Controller ptr, byval args as ICoreWebView2AcceleratorKeyPressedEventArgs ptr ) as HRESULT
end type
function KeyPressed.Invoke( byval sender as ICoreWebView2Controller ptr, byval args as ICoreWebView2AcceleratorKeyPressedEventArgs ptr ) as HRESULT
    dim nKind as COREWEBVIEW2_KEY_EVENT_KIND, nKey as UINT
    args->get_KeyEventKind( @nKind )
    args->get_VirtualKey( @nKey )
    if nKind = COREWEBVIEW2_KEY_EVENT_KIND_KEY_DOWN andalso nKey = VK_F5 then args->put_Handled( TRUE )   ' no reload
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2AcceleratorKeyPressedEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2acceleratorkeypressedeventhandler)

## CWebView2NewBrowserVersionAvailableEventHandler

Implements `ICoreWebView2NewBrowserVersionAvailableEventHandler`: the installation of a newer WebView2 runtime.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
dim token as EventRegistrationToken
CWebView2Ptr( hwnd )->GetEnvironmentPtr()->add_NewBrowserVersionAvailable( cast( any ptr, new CWebView2NewBrowserVersionAvailableEventHandler ), @token )
```

### Invoke

```freebasic
virtual function Invoke( byval webviewEnvironment as ICoreWebView2Environment ptr, byval args as IUNknown ptr ) as HRESULT
```

Called when a newer WebView2 runtime has been installed while the program runs. The web view goes on
using the old one until every web view of the environment is closed and a new environment is
created. `CWebView2` has no method for this event: attach the handler to the environment with
`add_NewBrowserVersionAvailable`.

| Parameter | Meaning |
| --- | --- |
| `webviewEnvironment` | The environment. |
| `args` | `args` is not used by this event; WebView2 passes `NULL`. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type NewRuntime extends CWebView2NewBrowserVersionAvailableEventHandler
    declare function Invoke( byval webviewEnvironment as ICoreWebView2Environment ptr, byval args as IUNknown ptr ) as HRESULT
end type
function NewRuntime.Invoke( byval webviewEnvironment as ICoreWebView2Environment ptr, byval args as IUNknown ptr ) as HRESULT
    dim pwszVersion as LPWSTR
    if webviewEnvironment->get_BrowserVersionString( @pwszVersion ) = S_OK then
        SetWindowText( hwnd, "Restart to use WebView2 " & *pwszVersion )
        CoTaskMemFree( pwszVersion )
    end if
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2NewBrowserVersionAvailableEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2newbrowserversionavailableeventhandler)

## CWebView2CallDevToolsProtocolMethodCompletedHandler

Implements `ICoreWebView2CallDevToolsProtocolMethodCompletedHandler`: the result of a DevTools Protocol method.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 0. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0, after WebView2 has let
go of the handler.

**Example**

```freebasic
CWebView2Ptr( hwnd )->CallDevToolsProtocolMethod( "Browser.getVersion", "{}", cast( any ptr, new CWebView2CallDevToolsProtocolMethodCompletedHandler ) )
```

### Invoke

```freebasic
virtual function Invoke( byval errorCode as HRESULT, byval returnObjectAsJson as LPCWSTR ) as HRESULT
```

Called once when a method run with
[CallDevToolsProtocolMethod](CWebView2#calldevtoolsprotocolmethod) has returned.

| Parameter | Meaning |
| --- | --- |
| `errorCode` | `S_OK`, or why the method failed. |
| `returnObjectAsJson` | What the method returned, as JSON, valid during the call only. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type DevToolsDone extends CWebView2CallDevToolsProtocolMethodCompletedHandler
    declare function Invoke( byval errorCode as HRESULT, byval returnObjectAsJson as LPCWSTR ) as HRESULT
end type
function DevToolsDone.Invoke( byval errorCode as HRESULT, byval returnObjectAsJson as LPCWSTR ) as HRESULT
    if errorCode = S_OK then SetWindowTextW( hwnd, returnObjectAsJson )
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2CallDevToolsProtocolMethodCompletedHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2calldevtoolsprotocolmethodcompletedhandler)

## CWebView2ExecuteScriptWithResultCompletedHandler

Implements `ICoreWebView2ExecuteScriptWithResultCompletedHandler`: the result of a script, with any exception.

### Constructor, Destructor

```freebasic
constructor
virtual destructor
```

Creates the handler with `refCount` set to 1. The destructor does nothing of its own; it runs
when [Release](#queryinterface-addref-release) brings the count to 0.

**Example**

```freebasic
dim p21 as ICoreWebView2_21 ptr
if CWebView2Ptr( hwnd )->GetWebViewPtr()->QueryInterface( @IID_ICoreWebView2_21, cast( any ptr ptr, @p21 ) ) = S_OK then
    p21->ExecuteScriptWithResult( "6 * 7", cast( any ptr, new CWebView2ExecuteScriptWithResultCompletedHandler ) )
    p21->Release()
end if
```

### Invoke

```freebasic
virtual function Invoke( byval errorCode as HRESULT, byval result as ICoreWebView2ExecuteScriptResult ptr ) as HRESULT
```

Called once when a script run with `ExecuteScriptWithResult` of `ICoreWebView2_21` has finished.
Unlike [ExecuteScript](CWebView2#executescript) it tells success from failure and gives the
exception a script threw. `CWebView2` has no method for it: ask the web view for `ICoreWebView2_21`.

This class is the one whose `refCount` starts at 1, not 0; the source notes that WebView2 does not
take a reference to this handler.

| Parameter | Meaning |
| --- | --- |
| `errorCode` | `S_OK`, or why the script could not run. |
| `result` | `get_Succeeded`, `get_ResultAsJson`, `TryGetResultAsString`, `get_Exception`; borrowed for the call. |

**Returns** `S_OK`. Return `S_OK` from your own `Invoke` as well.

**Example**

```freebasic
type ScriptResult extends CWebView2ExecuteScriptWithResultCompletedHandler
    declare function Invoke( byval errorCode as HRESULT, byval result as ICoreWebView2ExecuteScriptResult ptr ) as HRESULT
end type
function ScriptResult.Invoke( byval errorCode as HRESULT, byval result as ICoreWebView2ExecuteScriptResult ptr ) as HRESULT
    dim bSucceeded as LONG, pwszJson as LPWSTR
    result->get_Succeeded( @bSucceeded )
    if bSucceeded <> 0 andalso result->get_ResultAsJson( @pwszJson ) = S_OK then
        SetWindowTextW( hwnd, pwszJson )
        CoTaskMemFree( pwszJson )
    end if
    return S_OK
end function
```

Microsoft Learn: [ICoreWebView2ExecuteScriptWithResultCompletedHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2executescriptwithresultcompletedhandler)

## See also

- [sys/win/webview2](SysWin-WebView2)
- [CWebView2](CWebView2), whose `Add` and `Remove` methods attach and detach these handlers
- [WebView2 interfaces and types](SysWin-WebView2-Interfaces), the interfaces `sender` and `args` are, and every other handler interface
- [File dialog events](SysWin-Gui-File-Dialog-Events), the same pattern for the Open and Save dialogs
- [Microsoft Learn: WebView2 Win32 reference](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/)
