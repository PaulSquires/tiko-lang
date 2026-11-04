[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/webview2](SysWin-WebView2) › **CWebView2**

# CWebView2
Hosts a Microsoft Edge browser in a window and drives it from tiko code.

<!-- scope: CWebView2 -->
<!-- scope: CWebView2NewWindowRequestedEventHandlerInternal -->
<!-- scope: CWebView2WebMessageReceivedEventHandlerInternal -->
<!-- scope: CWebView2CreateCoreWebView2EnvironmentCompletedHandlerInternal -->
<!-- scope: CWebView2CreateCoreWebView2ControllerCompletedHandlerInternal -->

Hosts a Microsoft Edge browser in a window and drives it from tiko code.

`CWebView2` puts a WebView2 control, the Chromium-based Edge engine, inside a window or control
of your program: it shows web pages, HTML you build as a string and local files, runs
JavaScript in them and exchanges messages with them. One object owns the three COM objects the
browser is made of: the **environment** (the browser processes and the profile folder), the
**controller** (the control in your window: size, visibility, focus, zoom) and the **WebView**
itself (navigation, scripts, events). The raw interfaces are there too, for everything the class
does not wrap; see [WebView2 interfaces](SysWin-WebView2-Interfaces).

**What it needs at run time.** Two things must be on the machine that runs the program:

- the **WebView2 Runtime**, the shared Edge engine. Windows 11 has it built in; on Windows 10
  it is installed with Edge or on its own. [GetAvailableCoreWebView2BrowserVersionString](#getavailablecorewebview2browserversionstring)
  says whether, and which version, is there.
- **`WebView2Loader.dll`**, the small loader that finds the runtime. Nothing links against it:
  each call that needs it loads it by name, with the normal DLL search (the program's own folder
  first, then the folders on `PATH`), calls it and frees it again. Ship a copy next to your
  `.exe`; the toolchain has one in `examples/win64/WebView2 Examples/`. When it is missing, those
  calls return `E_POINTER` and the browser never starts.

**Creation is asynchronous.** The constructor only asks for the environment; the runtime
answers later through callbacks, while the thread pumps messages, and only then do the
controller and the WebView exist. Call [IsReady](#isready) after the constructor: it pumps
messages until the browser is there. Until then every method that checks returns `E_POINTER`;
the ones marked *needs a ready WebView* below do not check and must not be called before.

**The host window.** The constructor stores the object's address in the host window's
`GWLP_USERDATA` slot, which is how [CWebView2Ptr](#cwebview2ptr) finds it again in a window
procedure; do not use that slot for anything else. The browser is created visible and as large
as the host's client area at that moment; resize it on `WM_SIZE` with [SetBounds](#getbounds-setbounds).
Bounds are in the host's client coordinates, in pixels.

**Lifetime.** The object must outlive the window: declare it in `main` before `DoEvents`, as the
example does, never in a procedure that returns. The constructor initialises COM on the thread
(single-threaded apartment); the destructor closes the browser, releases the three objects and
uninitialises COM.

**Results.** Each wrapper returns the `HRESULT` of the call it makes and stores it, so
[GetLastResult](#getlastresult) and [GetErrorInfo](#geterrorinfo) can tell what went wrong,
including after the methods that return a value. Text that the runtime returns is copied into a
`ustring` and its memory freed for you.

The three interface pointers and the stored values are public fields: `m_Result`, `m_hWnd`,
`m_pEnv`, `m_pController`, `m_pCoreWebView2` and `m_BrowserVersion`.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/webview2"
using win, webview2
```

A program that creates its window with [CWindow](CWindow) imports `sys/win/gui` too.

## Example

A window that shows a page built from a string, with a button whose click the page posts back
to the program, which puts it in the caption:

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/webview2"
using win, gui, webview2

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

' Shows each string the page posts in the window caption
type MessageHandler extends CWebView2WebMessageReceivedEventHandler
    declare function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2WebMessageReceivedEventArgs ptr ) as HRESULT
    m_hwnd as HWND
end type

function MessageHandler.Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2WebMessageReceivedEventArgs ptr ) as HRESULT
    dim pwszMsg as LPWSTR
    if args->TryGetWebMessageAsString( @pwszMsg ) = S_OK then
        SetWindowTextW( m_hwnd, pwszMsg )
        CoTaskMemFree( pwszMsg )
    end if
    return S_OK
end function

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "WebView2Demo"
    dim hWin as HWND = pWindow.Create( NULL, "CWebView2", @WndProc )
    pWindow.SetClientSize( 640, 400 )
    pWindow.Center

    ' the browser fills the client area of hWin; its profile goes to a folder of its own
    dim pWebView2 as CWebView2 = CWebView2( hWin, GetTempPath() & "WebView2Demo" )
    if pWebView2.IsReady( 10000 ) = false then
        MessageBoxW( hWin, "The WebView2 Runtime did not start.", "CWebView2", MB_ICONERROR )
        return 1
    end if

    dim pHandler as MessageHandler ptr = new MessageHandler
    pHandler->m_hwnd = hWin
    dim token as EventRegistrationToken
    pWebView2.AddWebMessageReceived( cast( any ptr, pHandler ), @token )
    pWebView2.AreDefaultContextMenusEnabled( false )

    pWebView2.NavigateToString( _
        "<body style='font: 16px Segoe UI'><h2>Hello from tiko</h2>" & _
        "<button onclick=""window.chrome.webview.postMessage('Clicked at ' + new Date().toLocaleTimeString())"">" & _
        "Post a message</button></body>" )
    pWebView2.MoveFocus( COREWEBVIEW2_MOVE_FOCUS_REASON_PROGRAMMATIC )

    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_SIZE
            ' keep the browser the size of the client area
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

Put `WebView2Loader.dll` next to the program before running it. The handler is created with
`new` and never deleted by the program: the WebView holds a reference to it and the object
deletes itself when the WebView lets it go. More programs (images, video, maps, charts, SVG) are
in the toolchain's `examples/win64/WebView2 Examples/` folder.

## Members

| Member | Does |
| --- | --- |
| [Constructor](#constructor) | Starts creating a browser in a window, with the default or a separate profile. |
| [Destructor](#destructor) | Closes the browser and releases it. |
| [IsReady](#isready) | Pumps messages until the browser exists, or a time-out passes. |
| [GetHWnd](#gethwnd) | Returns the host window. |
| [GetTopLevelWindow](#gettoplevelwindow) | Returns the top-level window the host belongs to. |
| [GetBrowserVersion](#getbrowserversion) | Returns the version of the runtime in use. |
| [GetLastResult](#getlastresult) | Returns the stored result code. |
| [SetResult](#setresult) | Stores a result code. |
| [GetErrorInfo](#geterrorinfo) | Describes a result code in words. |
| [GetWebViewPtr](#getwebviewptr) | Returns the `ICoreWebView2` interface. |
| [GetControllerPtr](#getcontrollerptr) | Returns the `ICoreWebView2Controller` interface. |
| [GetEnvironmentPtr](#getenvironmentptr) | Returns the `ICoreWebView2Environment` interface. |
| [GetCoreWebView2](#getcorewebview2) | Returns the `ICoreWebView2` interface with a reference added. |
| [LoadFileAsJSInlineScript](#loadfileasjsinlinescript) | Turns a script file into a JavaScript expression that yields a data URL. |
| [LoadImageAsDataURL](#loadimageasdataurl) | Turns an image file into a `data:` URL. |
| [LoadImageAsUint8Array](#loadimageasuint8array) | Turns a file into JavaScript `Uint8Array` source text. |
| [Navigate](#navigate) | Loads a URL. |
| [NavigateToString](#navigatetostring) | Shows HTML given as a string. |
| [Stop](#stop) | Stops loading. |
| [Reload](#reload) | Loads the current page again. |
| [GoBack](#goback) | Goes back in the history. |
| [GoForward](#goforward) | Goes forward in the history. |
| [CanGoBack](#cangoback) | Says whether there is a page to go back to. |
| [CanGoForward](#cangoforward) | Says whether there is a page to go forward to. |
| [GetSource](#getsource) | Returns the URL of the current page. |
| [GetBrowserProcessId](#getbrowserprocessid) | Returns the process id of the browser process. |
| [GetIsVisible, SetIsVisible](#getisvisible-setisvisible) | Read or set whether the browser is shown. |
| [GetBounds, SetBounds](#getbounds-setbounds) | Read or set where the browser is in the host window. |
| [GetZoomFactor, SetZoomFactor](#getzoomfactor-setzoomfactor) | Read or set the zoom. |
| [GetParentWindow, SetParentWindow](#getparentwindow-setparentwindow) | Read or change the host window. |
| [MoveFocus](#movefocus) | Gives the keyboard focus to the page. |
| [NotifyParentWindowPositionChanged](#notifyparentwindowpositionchanged) | Tells the browser that the host window moved. |
| [Close](#close) | Closes the browser now. |
| [ExecuteScript](#executescript) | Runs JavaScript in the current page. |
| [PostWebMessageAsJson](#postwebmessageasjson) | Sends a JSON message to the page. |
| [PostWebMessageAsString](#postwebmessageasstring) | Sends a string message to the page. |
| [AddScriptToExecuteOnDocumentCreated](#addscripttoexecuteondocumentcreated) | Runs a script at the start of every page loaded from now on. |
| [RemoveScriptToExecuteOnDocumentCreated](#removescripttoexecuteondocumentcreated) | Stops running such a script. |
| [AddHostObjectToScript](#addhostobjecttoscript) | Makes a COM object of the program visible to the page's JavaScript. |
| [RemoveHostObjectFromScript](#removehostobjectfromscript) | Withdraws such an object. |
| [CapturePreview](#capturepreview) | Saves an image of what the browser shows. |
| [OpenDevToolsWindow](#opendevtoolswindow) | Opens the developer tools. |
| [CallDevToolsProtocolMethod](#calldevtoolsprotocolmethod) | Runs a DevTools Protocol method. |
| [GetDevToolsProtocolEventReceiver](#getdevtoolsprotocoleventreceiver) | Returns a receiver for a DevTools Protocol event. |
| [GetContainsFullScreenElement](#getcontainsfullscreenelement) | Says whether an element of the page is full screen. |
| [AddWebResourceRequestedFilter, RemoveWebResourceRequestedFilter](#addwebresourcerequestedfilter-removewebresourcerequestedfilter) | Choose which requests raise WebResourceRequested. |
| [GetSettings](#getsettings) | Returns the `ICoreWebView2Settings` interface. |
| [IsScriptEnabled](#isscriptenabled) | Reads or sets whether pages run JavaScript. |
| [IsWebMessageEnabled](#iswebmessageenabled) | Reads or sets whether messages pass between page and program. |
| [AreDefaultScriptDialogsEnabled](#aredefaultscriptdialogsenabled) | Reads or sets whether `alert`, `confirm` and `prompt` show their own dialogs. |
| [IsStatusBarEnabled](#isstatusbarenabled) | Reads or sets whether link targets show in a status bar. |
| [AreDevToolsEnabled](#aredevtoolsenabled) | Reads or sets whether the user can open the developer tools. |
| [AreDefaultContextMenusEnabled](#aredefaultcontextmenusenabled) | Reads or sets whether the right-click menu appears. |
| [AreHostObjectsAllowed](#arehostobjectsallowed) | Reads or sets whether pages can reach host objects. |
| [IsZoomControlEnabled](#iszoomcontrolenabled) | Reads or sets whether the user can zoom. |
| [IsBuiltInErrorPageEnabled](#isbuiltinerrorpageenabled) | Reads or sets whether failed loads show the built-in error page. |
| [AddNavigationStarting, RemoveNavigationStarting](#addnavigationstarting-removenavigationstarting) | Handle the start of each top-level navigation. |
| [AddNavigationCompleted, RemoveNavigationCompleted](#addnavigationcompleted-removenavigationcompleted) | Handle the end of each top-level navigation. |
| [AddFrameNavigationStarting, RemoveFrameNavigationStarting](#addframenavigationstarting-removeframenavigationstarting) | Handle the start of a navigation in a frame. |
| [AddFrameNavigationCompleted, RemoveFrameNavigationCompleted](#addframenavigationcompleted-removeframenavigationcompleted) | Handle the end of a navigation in a frame. |
| [AddContentLoading, RemoveContentLoading](#addcontentloading-removecontentloading) | Handle the start of loading a new document. |
| [AddSourceChanged, RemoveSourceChanged](#addsourcechanged-removesourcechanged) | Handle a change of the current URL. |
| [AddHistoryChanged, RemoveHistoryChanged](#addhistorychanged-removehistorychanged) | Register a SourceChanged handler (see the entry). |
| [AddScriptDialogOpening, RemoveScriptDialogOpening](#addscriptdialogopening-removescriptdialogopening) | Handle `alert`, `confirm`, `prompt` and `beforeunload` dialogs. |
| [AddPermissionRequested, RemovePermissionRequested](#addpermissionrequested-removepermissionrequested) | Answer a page's requests for the camera, location and so on. |
| [AddProcessFailed, RemoveProcessFailed](#addprocessfailed-removeprocessfailed) | Handle a crashed or ended browser process. |
| [AddWebMessageReceived, RemoveWebMessageReceived](#addwebmessagereceived-removewebmessagereceived) | Receive the messages the page posts. |
| [AddNewWindowRequested, RemoveNewWindowRequested](#addnewwindowrequested-removenewwindowrequested) | Handle a page opening a new window. |
| [AddDocumentTitleChanged, RemoveDocumentTitleChanged](#adddocumenttitlechanged-removedocumenttitlechanged) | Handle a change of the page title. |
| [AddContainsFullScreenElementChanged, RemoveContainsFullScreenElementChanged](#addcontainsfullscreenelementchanged-removecontainsfullscreenelementchanged) | Handle an element entering or leaving full screen. |
| [AddWebResourceRequested, RemoveWebResourceRequested](#addwebresourcerequested-removewebresourcerequested) | Inspect or answer the requests that match a filter. |
| [AddWindowCloseRequested, RemoveWindowCloseRequested](#addwindowcloserequested-removewindowcloserequested) | Handle `window.close()` in the page. |
| [AddZoomFactorChanged, RemoveZoomFactorChanged](#addzoomfactorchanged-removezoomfactorchanged) | Handle a change of zoom. |
| [AddMoveFocusRequested, RemoveMoveFocusRequested](#addmovefocusrequested-removemovefocusrequested) | Handle Tab or Shift+Tab leaving the page. |
| [AddGotFocus, RemoveGotFocus](#addgotfocus-removegotfocus) | Handle the browser getting the focus. |
| [AddLostFocus, RemoveLostFocus](#addlostfocus-removelostfocus) | Handle the browser losing the focus. |
| [AddAcceleratorKeyPressed, RemoveAcceleratorKeyPressed](#addacceleratorkeypressed-removeacceleratorkeypressed) | See shortcut keys before the page does. |

## Reference

### Constructor

```freebasic
constructor()
constructor( byval hWin as HWND, byval pUserDataFolder as wstring ptr = NULL )
constructor( byval hWin as HWND, byref ustrUserDataFolder as ustring )
```

Initialises COM on the thread, stores the object's address in `hWin`'s `GWLP_USERDATA` slot and
asks the runtime for an environment. The call returns at once; the browser appears in `hWin`
once the runtime has answered, which [IsReady](#isready) waits for. Its result, the `HRESULT` of
the request, is stored for [GetLastResult](#getlastresult): `E_POINTER` when `hWin` is `NULL`
(nothing else happens then) or when `WebView2Loader.dll` cannot be loaded.

- `dim pWebView2 as CWebView2 = hWin`, or a `NULL` folder, uses the default profile: a folder
  named after the program with `.WebView2` added (`MyApp.exe.WebView2`), next to the `.exe`.
  Creation fails when the program cannot create that folder, for example under
  `Program Files`.
- A folder gives the browser a separate profile there: its own cookies, cache and storage.
  The `ustring` form always passes the folder on, even an empty string.

The default constructor does nothing: no COM, no window, no browser. It exists for the helper
methods, such as [LoadImageAsDataURL](#loadimageasdataurl), that need no browser.

| Parameter | Meaning |
| --- | --- |
| `hWin` | The host: a window or control whose client area the browser fills. |
| `pUserDataFolder`, `ustrUserDataFolder` | The profile folder, absolute or relative to the program's folder; created if it does not exist. |

**Example**

```freebasic
dim pWebView2 as CWebView2 = CWebView2( hwnd, GetTempPath() & "MyAppWebView2" )
if pWebView2.IsReady( 10000 ) then pWebView2.Navigate( "https://example.com" )
```

Microsoft Learn: [CreateCoreWebView2EnvironmentWithOptions](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl#createcorewebview2environmentwithoptions), [user data folders](https://learn.microsoft.com/en-us/microsoft-edge/webview2/concepts/user-data-folder)

### Destructor

```freebasic
destructor()
```

Releases the WebView, closes and releases the controller, releases the environment and
uninitialises COM on the thread. Closing ends the browser processes this object started once no
other WebView uses them.

The destructor calls `CoUninitialize` whichever constructor ran, including the default one,
which did not initialise COM.

**Example**

```freebasic
scope
    dim pWebView2 as CWebView2 = hwnd
    if pWebView2.IsReady( 5000 ) then pWebView2.Navigate( "https://example.com" )
end scope   ' the browser closes here
```

Microsoft Learn: [ICoreWebView2Controller::Close](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2controller#close)

### IsReady

```freebasic
function IsReady( byval dwMaxWaitMilliseconds as long = -1 ) as boolean
```

Waits until the browser exists: it pumps the thread's messages, so that the runtime's callbacks
can run, every 50 ms or whenever a message arrives, until the controller has been created or
`dwMaxWaitMilliseconds` have passed. When the browser is already there it returns after that
first wait of at most 50 ms.

With the default `-1` it waits without limit, and when creation fails (no runtime, no loader, a
profile folder that cannot be created) the callbacks never deliver a controller, so it never
returns: pass a time-out. Messages it dispatches go to their windows as usual; a `WM_QUIT` it
meets is removed and lost.

| Parameter | Meaning |
| --- | --- |
| `dwMaxWaitMilliseconds` | The most milliseconds to wait, or -1 for no limit. |

**Returns** `true` when the browser is ready, `false` when the time ran out.

**Example**

```freebasic
dim pWebView2 as CWebView2 = hwnd
if pWebView2.IsReady( 10000 ) = false then print "no WebView2 Runtime?"
```

Microsoft Learn: [MsgWaitForMultipleObjects](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-msgwaitformultipleobjects)

### GetHWnd

```freebasic
function GetHWnd() as HWND
```

**Returns** the host window given to the constructor or to [SetParentWindow](#getparentwindow-setparentwindow),
or `NULL`.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
InvalidateRect( pWebView2->GetHWnd(), NULL, true )
```

### GetTopLevelWindow

```freebasic
function GetTopLevelWindow() as HWND
```

Goes up from the host window, through parents for child windows and owners for the others,
until a window has neither.

**Returns** that window, the host itself when it is a top-level window, or `NULL` when the host
is not a window.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hCtrl )
SetWindowTextW( pWebView2->GetTopLevelWindow(), "Loaded" )
```

### GetBrowserVersion

```freebasic
function GetBrowserVersion() as ustring
```

**Returns** the version of the WebView2 Runtime the environment uses, such as `156.0.4314.58`,
read when the environment was created; `""` before that.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
print "runtime "; pWebView2->GetBrowserVersion()
```

Microsoft Learn: [ICoreWebView2Environment::get_BrowserVersionString](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2environment#get_browserversionstring)

### GetLastResult

```freebasic
function GetLastResult() as HRESULT
```

**Returns** the result code of the last wrapper called: `S_OK` (0) on success, `E_POINTER`
(`&h80004003`) for a call made before the browser was ready, otherwise the runtime's error.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim nZoom as double = pWebView2->GetZoomFactor()
if pWebView2->GetLastResult() <> S_OK then print pWebView2->GetErrorInfo()
```

### SetResult

```freebasic
function SetResult( byval Result as HRESULT ) as HRESULT
```

Stores `Result` as the last result code, for code that calls the raw interfaces itself and wants
[GetLastResult](#getlastresult) and [GetErrorInfo](#geterrorinfo) to report it.

**Returns** `Result`.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
pWebView2->SetResult( pWebView2->GetWebViewPtr()->Reload() )
```

### GetErrorInfo

```freebasic
function GetErrorInfo( byval nError as long = -1 ) as ustring
```

Describes a result code in the language of Windows. For a code other than 0 the text starts with
`Error &h` and the code in hexadecimal, then a line break and the description; each part ends
with a line break.

| Parameter | Meaning |
| --- | --- |
| `nError` | The code to describe; -1 (the default) describes the last result code. |

**Returns** the text; for `E_FAIL` that is `Error &h80004005`, a line break, `Unspecified error`
and a line break. An unknown code gives the first line only.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
if pWebView2->Navigate( "https://example.com" ) <> S_OK then print pWebView2->GetErrorInfo()
```

Microsoft Learn: [FormatMessageW](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-formatmessagew)

### GetWebViewPtr

```freebasic
function GetWebViewPtr() as ICoreWebView2 ptr
```

**Returns** the object's own `ICoreWebView2` pointer, or `NULL` before the browser is ready. No
reference is added: do not release it. Use it for what the class does not wrap; its later
versions (`ICoreWebView2_2` …) are reached with `QueryInterface`.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim pCore as ICoreWebView2 ptr = pWebView2->GetWebViewPtr()
if pCore then pCore->OpenDevToolsWindow()
```

Microsoft Learn: [ICoreWebView2](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2)

### GetControllerPtr

```freebasic
function GetControllerPtr() as ICoreWebView2Controller ptr
```

**Returns** the object's own `ICoreWebView2Controller` pointer, or `NULL` before the browser is
ready. No reference is added: do not release it.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim pCtl as ICoreWebView2Controller ptr = pWebView2->GetControllerPtr()
if pCtl then pCtl->put_ZoomFactor( 1.25 )
```

Microsoft Learn: [ICoreWebView2Controller](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2controller)

### GetEnvironmentPtr

```freebasic
function GetEnvironmentPtr() as ICoreWebView2Environment ptr
```

**Returns** the object's own `ICoreWebView2Environment` pointer, or `NULL` before the runtime has
answered. No reference is added: do not release it.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim pEnv as ICoreWebView2Environment ptr = pWebView2->GetEnvironmentPtr()
if pEnv = NULL then print "the environment has not been created"
```

Microsoft Learn: [ICoreWebView2Environment](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2environment)

### GetCoreWebView2

```freebasic
function GetCoreWebView2() as ICoreWebView2 ptr
```

Asks the controller for its WebView. *Needs a ready WebView.*

**Returns** an `ICoreWebView2` pointer with a reference added, which you release, or `NULL` when
the call fails.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim pCore as ICoreWebView2 ptr = pWebView2->GetCoreWebView2()
if pCore then pCore->Reload() : pCore->Release()
```

Microsoft Learn: [ICoreWebView2Controller::get_CoreWebView2](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2controller#get_corewebview2)

### LoadFileAsJSInlineScript

```freebasic
function LoadFileAsJSInlineScript( byref ustrPath as ustring ) as string
```

Reads a file, makes a `data:application/javascript;base64,…` URL of it and returns JavaScript
source text that rebuilds that URL as a string:
`new TextDecoder('latin1').decode(Uint8Array.from([100,97,116,97,…]))`, the bytes of the URL as
decimal numbers. The base64 part keeps the line breaks the encoder puts after every 64
characters, and the decoded string ends with a carriage return, a line feed and a NUL character.
Needs no browser.

| Parameter | Meaning |
| --- | --- |
| `ustrPath` | The file. |

**Returns** the expression, or `""` when the file cannot be opened or read.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim s as string = pWebView2->LoadFileAsJSInlineScript( "chart.umd.min.js" )
pWebView2->ExecuteScript( "var src = " & s & ";" )
```

### LoadImageAsDataURL

```freebasic
function LoadImageAsDataURL( byref ustrPath as ustring ) as string
```

Reads a file and returns it as a `data:` URL, `data:image/png;base64,…`, ready for the `src` of an
`<img>`. The type comes from the extension: `.jpg` and `.jpeg`, `.png`, `.gif`, `.bmp` and
`.webp`; any other leaves it empty (`data:;base64,…`). The base64 text has no line breaks; the
string ends with a NUL character. Needs no browser.

**Returns** the URL, or `""` when the file cannot be opened or read or is empty. A three-byte
file `small.png` holding `ABC` gives `data:image/png;base64,QUJD` and the NUL, 27 characters.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim s as string = pWebView2->LoadImageAsDataURL( "photo.jpg" )
pWebView2->NavigateToString( "<img src='" & s & "'>" )
```

Microsoft Learn: [CryptBinaryToStringA](https://learn.microsoft.com/en-us/windows/win32/api/wincrypt/nf-wincrypt-cryptbinarytostringa)

### LoadImageAsUint8Array

```freebasic
function LoadImageAsUint8Array( byref ustrPath as ustring ) as string
```

Reads a file and returns JavaScript source text that builds a `Uint8Array` of its bytes:
`new Uint8Array([65,66,67])` for a file holding `ABC`. Any kind of file works; needs no browser.
A read error is not checked. An empty file gives `new Uint8Array([`, without the closing
brackets.

**Returns** the expression, or `""` when the file cannot be opened.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim s as string = pWebView2->LoadImageAsUint8Array( "photo.png" )
pWebView2->ExecuteScript( "const bytes = " & s & "; console.log(bytes.length);" )
```

### Navigate

```freebasic
function Navigate( byval uri as LPCWSTR ) as HRESULT
```

Starts loading `uri` in the browser: an `https://`, `http://` or `file:///` URL. The call returns
before the page has loaded; [AddNavigationCompleted](#addnavigationcompleted-removenavigationcompleted)
tells when it has.

**Returns** `S_OK` when the navigation started; `E_INVALIDARG` for a URL that is not well
formed; `E_POINTER` before the browser is ready.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
pWebView2->Navigate( "https://learn.microsoft.com/en-us/microsoft-edge/webview2/" )
```

Microsoft Learn: [ICoreWebView2::Navigate](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#navigate)

### NavigateToString

```freebasic
function NavigateToString( byval htmlContent as LPCWSTR ) as HRESULT
```

Shows `htmlContent` as a new document. The runtime limits the HTML to about 2 MB; for more, save
it with [SaveTempHtmlFile](#savetemphtmlfile) and [Navigate](#navigate) to the file.

**Returns** the `HRESULT`; `E_POINTER` before the browser is ready.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
pWebView2->NavigateToString( "<h1>Hello</h1><p>From a string.</p>" )
```

Microsoft Learn: [ICoreWebView2::NavigateToString](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#navigatetostring)

### Stop

```freebasic
function Stop() as HRESULT
```

Stops every navigation and resource download in progress. Scripts keep running.

**Returns** the `HRESULT`; `E_POINTER` before the browser is ready.

**Example**

```freebasic
CWebView2Ptr( hwnd )->Stop()
```

Microsoft Learn: [ICoreWebView2::Stop](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#stop)

### Reload

```freebasic
function Reload() as HRESULT
```

Loads the current page again.

**Returns** the `HRESULT`; `E_POINTER` before the browser is ready.

**Example**

```freebasic
CWebView2Ptr( hwnd )->Reload()
```

Microsoft Learn: [ICoreWebView2::Reload](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#reload)

### GoBack

```freebasic
function GoBack() as HRESULT
```

Goes to the previous page of the history; nothing happens when there is none.

**Returns** the `HRESULT`; `E_POINTER` before the browser is ready.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
if pWebView2->CanGoBack() then pWebView2->GoBack()
```

Microsoft Learn: [ICoreWebView2::GoBack](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#goback)

### GoForward

```freebasic
function GoForward() as HRESULT
```

Goes to the next page of the history; nothing happens when there is none.

**Returns** the `HRESULT`; `E_POINTER` before the browser is ready.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
if pWebView2->CanGoForward() then pWebView2->GoForward()
```

Microsoft Learn: [ICoreWebView2::GoForward](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#goforward)

### CanGoBack

```freebasic
function CanGoBack() as boolean
```

**Returns** `true` when there is a previous page in the history; `false` otherwise and before the
browser is ready.

**Example**

```freebasic
EnableWindow( hCtrl, CWebView2Ptr( hwnd )->CanGoBack() )
```

Microsoft Learn: [ICoreWebView2::get_CanGoBack](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#get_cangoback)

### CanGoForward

```freebasic
function CanGoForward() as boolean
```

**Returns** `true` when there is a next page in the history; `false` otherwise and before the
browser is ready.

**Example**

```freebasic
EnableWindow( hCtrl, CWebView2Ptr( hwnd )->CanGoForward() )
```

Microsoft Learn: [ICoreWebView2::get_CanGoForward](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#get_cangoforward)

### GetSource

```freebasic
function GetSource() as ustring
```

**Returns** the URL of the current top-level document, or `""` before the browser is ready.

**Example**

```freebasic
SetWindowTextW( hwnd, CWebView2Ptr( hwnd )->GetSource() )
```

Microsoft Learn: [ICoreWebView2::get_Source](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#get_source)

### GetBrowserProcessId

```freebasic
function GetBrowserProcessId() as UINT32
```

**Returns** the process id of the browser process behind this WebView, or 0 before the browser
is ready.

**Example**

```freebasic
print "browser process"; CWebView2Ptr( hwnd )->GetBrowserProcessId()
```

Microsoft Learn: [ICoreWebView2::get_BrowserProcessId](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#get_browserprocessid)

### GetIsVisible, SetIsVisible

```freebasic
function GetIsVisible() as boolean
function SetIsVisible( byval isVisible as boolean ) as HRESULT
```

Read or set whether the browser is shown. A hidden browser does not paint and uses less
processor time; the constructor shows it. Hide it, for instance, while the host window is
minimised.

**Returns** `GetIsVisible`: `true` when shown, `false` when hidden or before the browser is
ready. `SetIsVisible`: the `HRESULT`, `E_POINTER` before the browser is ready.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
pWebView2->SetIsVisible( not pWebView2->GetIsVisible() )
```

Microsoft Learn: [ICoreWebView2Controller::put_IsVisible](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2controller#put_isvisible)

### GetBounds, SetBounds

```freebasic
function GetBounds() as RECT
function SetBounds( byval bounds as RECT ) as HRESULT
```

Read or set the rectangle the browser takes up in the host window, in the host's client
coordinates, in pixels. The constructor sets it to the host's client area; call `SetBounds` on
`WM_SIZE` to keep it so.

**Returns** `GetBounds`: the rectangle, all zeros before the browser is ready. `SetBounds`: the
`HRESULT`, `E_POINTER` before the browser is ready.

**Example**

```freebasic
dim rc as RECT
GetClientRect( hwnd, @rc )
rc.top += 40                          ' leave room for a toolbar
CWebView2Ptr( hwnd )->SetBounds( rc )
```

Microsoft Learn: [ICoreWebView2Controller::put_Bounds](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2controller#put_bounds)

### GetZoomFactor, SetZoomFactor

```freebasic
function GetZoomFactor() as double
function SetZoomFactor( byval zoomFactor as double ) as HRESULT
```

Read or set the zoom of the page, 1.0 for 100 %. It applies to this browser only and stays in
force across navigations.

**Returns** `GetZoomFactor`: the zoom, 0 before the browser is ready. `SetZoomFactor`: the
`HRESULT`, `E_POINTER` before the browser is ready.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
pWebView2->SetZoomFactor( pWebView2->GetZoomFactor() * 1.1 )
```

Microsoft Learn: [ICoreWebView2Controller::put_ZoomFactor](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2controller#put_zoomfactor)

### GetParentWindow, SetParentWindow

```freebasic
function GetParentWindow() as HWND
function SetParentWindow( byval parentWindow as HWND ) as HRESULT
```

Read the window the browser draws in, or move the browser to another window. On success
`SetParentWindow` also stores the object's address in the new window's `GWLP_USERDATA` slot and
makes it the host that [GetHWnd](#gethwnd) returns; the old window's slot keeps the address. Set
the bounds again afterwards: they are kept as they were, now relative to the new window.

**Returns** `GetParentWindow`: the window, or `NULL` before the browser is ready.
`SetParentWindow`: the `HRESULT`, `E_POINTER` before the browser is ready.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
if pWebView2->SetParentWindow( hCtrl ) = S_OK then SetWindowLongPtrW( hwnd, GWLP_USERDATA, 0 )
```

Microsoft Learn: [ICoreWebView2Controller::put_ParentWindow](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2controller#put_parentwindow)

### MoveFocus

```freebasic
function MoveFocus( byval reason as COREWEBVIEW2_MOVE_FOCUS_REASON ) as HRESULT
```

Gives the keyboard focus to the browser. `COREWEBVIEW2_MOVE_FOCUS_REASON_PROGRAMMATIC` puts it
back where it was in the page; `…_NEXT` and `…_PREVIOUS` put it on the first or last element, as
Tab and Shift+Tab arriving from outside would.

**Returns** the `HRESULT`; `E_POINTER` before the browser is ready.

**Example**

```freebasic
CWebView2Ptr( hwnd )->MoveFocus( COREWEBVIEW2_MOVE_FOCUS_REASON_PROGRAMMATIC )
```

Microsoft Learn: [ICoreWebView2Controller::MoveFocus](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2controller#movefocus)

### NotifyParentWindowPositionChanged

```freebasic
function NotifyParentWindowPositionChanged() as HRESULT
```

Tells the browser that the host window, or one of its ancestors, has moved on the screen, so
that pop-ups such as drop-down lists open in the right place. Call it on `WM_MOVE` and
`WM_MOVING` of the top-level window.

**Returns** the `HRESULT`; `E_POINTER` before the browser is ready.

**Example**

```freebasic
CWebView2Ptr( hwnd )->NotifyParentWindowPositionChanged()
```

Microsoft Learn: [ICoreWebView2Controller::NotifyParentWindowPositionChanged](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2controller#notifyparentwindowpositionchanged)

### Close

```freebasic
function Close() as HRESULT
```

Closes the browser now, ending its processes once no other WebView uses them. Afterwards the
controller's and the WebView's methods fail; the destructor still releases the objects.

**Returns** the `HRESULT`; `E_POINTER` before the browser is ready.

**Example**

```freebasic
CWebView2Ptr( hwnd )->Close()
```

Microsoft Learn: [ICoreWebView2Controller::Close](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2controller#close)

### ExecuteScript

```freebasic
function ExecuteScript( byval javaScript as LPCWSTR, byval handler as ICoreWebView2ExecuteScriptCompletedHandler ptr = NULL ) as HRESULT
```

Runs `javaScript` in the current top-level document. It runs later, after the call returns;
when `handler` is given, its `Invoke` receives the error code and the value of the script's last
expression as JSON (`null` for `undefined`).

| Parameter | Meaning |
| --- | --- |
| `javaScript` | The script. |
| `handler` | Optional: an object derived from `CWebView2ExecuteScriptCompletedHandler`, passed as `cast( any ptr, p )`. |

**Returns** the `HRESULT` of starting the script; `E_POINTER` before the browser is ready.

**Example**

```freebasic
CWebView2Ptr( hwnd )->ExecuteScript( "document.body.style.background = 'lightyellow';" )
```

Microsoft Learn: [ICoreWebView2::ExecuteScript](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#executescript)

### PostWebMessageAsJson

```freebasic
function PostWebMessageAsJson( byval webMessageAsJson as LPCWSTR ) as HRESULT
```

Sends a message to the top-level document. The page receives it as a `message` event on
`window.chrome.webview`, with `event.data` the JSON already parsed into a JavaScript value.
Needs [IsWebMessageEnabled](#iswebmessageenabled), the default.

**Returns** the `HRESULT`; `E_POINTER` before the browser is ready.

**Example**

```freebasic
CWebView2Ptr( hwnd )->PostWebMessageAsJson( "{""count"": 3, ""name"": ""tiko""}" )
```

Microsoft Learn: [ICoreWebView2::PostWebMessageAsJson](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#postwebmessageasjson)

### PostWebMessageAsString

```freebasic
function PostWebMessageAsString( byval webMessageAsString as LPCWSTR ) as HRESULT
```

Sends a plain string to the top-level document: `event.data` is that string.

**Returns** the `HRESULT`; `E_POINTER` before the browser is ready.

**Example**

```freebasic
CWebView2Ptr( hwnd )->PostWebMessageAsString( "refresh" )
```

Microsoft Learn: [ICoreWebView2::PostWebMessageAsString](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#postwebmessageasstring)

### AddScriptToExecuteOnDocumentCreated

```freebasic
function AddScriptToExecuteOnDocumentCreated( byval javaScript as LPCWSTR, byval handler as ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler ptr ) as HRESULT
```

Adds a script that runs in every document loaded from now on, top-level and frames, before the
document's own scripts. The handler's `Invoke` receives the script's id, which
[RemoveScriptToExecuteOnDocumentCreated](#removescripttoexecuteondocumentcreated) takes.

| Parameter | Meaning |
| --- | --- |
| `javaScript` | The script. |
| `handler` | An object derived from `CWebView2AddScriptToExecuteOnDocumentCreatedCompleteHandler`, passed as `cast( any ptr, p )`. |

**Returns** the `HRESULT`; `E_POINTER` before the browser is ready.

**Example**

```freebasic
dim pHandler as CWebView2AddScriptToExecuteOnDocumentCreatedCompleteHandler ptr = new CWebView2AddScriptToExecuteOnDocumentCreatedCompleteHandler
CWebView2Ptr( hwnd )->AddScriptToExecuteOnDocumentCreated( "window.isHosted = true;", cast( any ptr, pHandler ) )
```

Microsoft Learn: [ICoreWebView2::AddScriptToExecuteOnDocumentCreated](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#addscripttoexecuteondocumentcreated)

### RemoveScriptToExecuteOnDocumentCreated

```freebasic
function RemoveScriptToExecuteOnDocumentCreated( byval id as LPCWSTR ) as HRESULT
```

Stops running the script with id `id` in documents loaded from now on.

**Returns** the `HRESULT`; `E_POINTER` before the browser is ready.

**Example**

```freebasic
dim ustrScriptId as ustring = "1"     ' the id the completion handler received
CWebView2Ptr( hwnd )->RemoveScriptToExecuteOnDocumentCreated( ustrScriptId )
```

Microsoft Learn: [ICoreWebView2::RemoveScriptToExecuteOnDocumentCreated](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#removescripttoexecuteondocumentcreated)

### AddHostObjectToScript

```freebasic
function AddHostObjectToScript( byval _name as LPCWSTR, byval _object as VARIANT ptr ) as HRESULT
```

Makes `_object`, normally an `IDispatch` object of the program in a `VARIANT`, reachable from the
page's JavaScript as `chrome.webview.hostObjects.<name>` (asynchronous proxies) and
`chrome.webview.hostObjects.sync.<name>`. Needs [AreHostObjectsAllowed](#arehostobjectsallowed),
the default. *Needs a ready WebView.*

**Returns** the `HRESULT`.

**Example**

```freebasic
dim v as VARIANT
v.vt = VT_I4 : v.lVal = 42
CWebView2Ptr( hwnd )->AddHostObjectToScript( "answer", @v )
```

Microsoft Learn: [ICoreWebView2::AddHostObjectToScript](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#addhostobjecttoscript)

### RemoveHostObjectFromScript

```freebasic
function RemoveHostObjectFromScript( byval _name as LPCWSTR ) as HRESULT
```

Withdraws the host object `_name`: new script calls to it fail. *Needs a ready WebView.*

**Returns** the `HRESULT`.

**Example**

```freebasic
CWebView2Ptr( hwnd )->RemoveHostObjectFromScript( "answer" )
```

Microsoft Learn: [ICoreWebView2::RemoveHostObjectFromScript](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#removehostobjectfromscript)

### CapturePreview

```freebasic
function CapturePreview( byval imageFormat as COREWEBVIEW2_CAPTURE_PREVIEW_IMAGE_FORMAT, byval imageStream as IStream ptr, byval handler as ICoreWebView2CapturePreviewCompletedHandler ptr ) as HRESULT
```

Writes an image of what the browser shows, as PNG (`COREWEBVIEW2_CAPTURE_PREVIEW_IMAGE_FORMAT_PNG`)
or JPEG (`…_JPEG`), to `imageStream`. The image is written later; the handler's `Invoke` says
when, with the error code.

| Parameter | Meaning |
| --- | --- |
| `imageFormat` | PNG or JPEG. |
| `imageStream` | The stream to write to, such as one from `SHCreateStreamOnFileEx` or `CreateStreamOnHGlobal`. |
| `handler` | An object derived from `CWebView2AddCapturePreviewCompletedHandler`, passed as `cast( any ptr, p )`. |

**Returns** the `HRESULT` of starting the capture; `E_POINTER` before the browser is ready.

**Example**

```freebasic
dim pStream as IStream ptr
SHCreateStreamOnFileEx( "page.png", STGM_CREATE or STGM_WRITE, FILE_ATTRIBUTE_NORMAL, true, NULL, @pStream )
dim pHandler as CWebView2AddCapturePreviewCompletedHandler ptr = new CWebView2AddCapturePreviewCompletedHandler
CWebView2Ptr( hwnd )->CapturePreview( COREWEBVIEW2_CAPTURE_PREVIEW_IMAGE_FORMAT_PNG, pStream, cast( any ptr, pHandler ) )
```

Microsoft Learn: [ICoreWebView2::CapturePreview](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#capturepreview)

### OpenDevToolsWindow

```freebasic
function OpenDevToolsWindow() as HRESULT
```

Opens the developer tools window for the current document, even when
[AreDevToolsEnabled](#aredevtoolsenabled) keeps the user from opening it.

**Returns** the `HRESULT`; `E_POINTER` before the browser is ready.

**Example**

```freebasic
CWebView2Ptr( hwnd )->OpenDevToolsWindow()
```

Microsoft Learn: [ICoreWebView2::OpenDevToolsWindow](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#opendevtoolswindow)

### CallDevToolsProtocolMethod

```freebasic
function CallDevToolsProtocolMethod( byval methodName as LPCWSTR, byval parametersAsJson as LPCWSTR, byval handler as ICoreWebView2CallDevToolsProtocolMethodCompletedHandler ptr ) as HRESULT
```

Runs a method of the Chrome DevTools Protocol, such as `Network.clearBrowserCache` or
`Emulation.setDeviceMetricsOverride`, with its parameters as a JSON object. The handler's
`Invoke` receives the error code and the method's result as JSON. *Needs a ready WebView.*

**Returns** the `HRESULT` of starting the call.

**Example**

```freebasic
dim pHandler as CWebView2CallDevToolsProtocolMethodCompletedHandler ptr = new CWebView2CallDevToolsProtocolMethodCompletedHandler
CWebView2Ptr( hwnd )->CallDevToolsProtocolMethod( "Network.clearBrowserCache", "{}", cast( any ptr, pHandler ) )
```

Microsoft Learn: [ICoreWebView2::CallDevToolsProtocolMethod](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#calldevtoolsprotocolmethod)

### GetDevToolsProtocolEventReceiver

```freebasic
function GetDevToolsProtocolEventReceiver( byval eventName as LPCWSTR, byval receiver as ICoreWebView2DevToolsProtocolEventReceiver ptr ptr ) as HRESULT
```

Gets the receiver for one DevTools Protocol event, such as `Runtime.consoleAPICalled`. Add a
`CWebView2DevToolsProtocolEventReceivedEventHandler` to it with its `add_DevToolsProtocolEventReceived`,
and turn the event on with [CallDevToolsProtocolMethod](#calldevtoolsprotocolmethod) (for this one
`Runtime.enable`). Release the receiver when done. *Needs a ready WebView.*

**Returns** the `HRESULT`.

**Example**

```freebasic
dim pReceiver as ICoreWebView2DevToolsProtocolEventReceiver ptr
if CWebView2Ptr( hwnd )->GetDevToolsProtocolEventReceiver( "Runtime.consoleAPICalled", @pReceiver ) = S_OK then
    pReceiver->Release()
end if
```

Microsoft Learn: [ICoreWebView2::GetDevToolsProtocolEventReceiver](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#getdevtoolsprotocoleventreceiver)

### GetContainsFullScreenElement

```freebasic
function GetContainsFullScreenElement( byval ContainsFullScreenElement as long ptr ) as HRESULT
function GetContainsFullScreenElement() as long
```

Says whether an element of the page, such as a video, has asked to go full screen. The browser
does not resize itself: a program that wants full screen handles
[AddContainsFullScreenElementChanged](#addcontainsfullscreenelementchanged-removecontainsfullscreenelementchanged)
and makes the host window fill the screen. *Needs a ready WebView.*

**Returns** the first form: the `HRESULT`, with the answer (nonzero for yes) in the variable.
The second: the answer, with the `HRESULT` kept for [GetLastResult](#getlastresult).

**Example**

```freebasic
if CWebView2Ptr( hwnd )->GetContainsFullScreenElement() then print "full screen"
```

Microsoft Learn: [ICoreWebView2::get_ContainsFullScreenElement](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#get_containsfullscreenelement)

### AddWebResourceRequestedFilter, RemoveWebResourceRequestedFilter

```freebasic
function AddWebResourceRequestedFilter( byval uri as LPCWSTR, byval ResourceContext as COREWEBVIEW2_WEB_RESOURCE_CONTEXT ) as HRESULT
function RemoveWebResourceRequestedFilter( byval uri as LPCWSTR, byval ResourceContext as COREWEBVIEW2_WEB_RESOURCE_CONTEXT ) as HRESULT
```

Add or remove a filter: requests whose URL matches `uri` (`*` matches any run of characters) and
whose kind is `ResourceContext` (`COREWEBVIEW2_WEB_RESOURCE_CONTEXT_IMAGE`, `…_DOCUMENT`, `…_ALL`
…) raise the WebResourceRequested event, where the program can inspect them or answer them
itself. These forms do not reach requests made from frames; the runtime's later interface has
forms that do. *Needs a ready WebView.*

**Returns** the `HRESULT`.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
pWebView2->AddWebResourceRequestedFilter( "*.png", COREWEBVIEW2_WEB_RESOURCE_CONTEXT_IMAGE )
pWebView2->RemoveWebResourceRequestedFilter( "*.png", COREWEBVIEW2_WEB_RESOURCE_CONTEXT_IMAGE )
```

Microsoft Learn: [ICoreWebView2::AddWebResourceRequestedFilter](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#addwebresourcerequestedfilter)

### GetSettings

```freebasic
function GetSettings() as ICoreWebView2Settings ptr
```

Gets the settings object of the browser, for settings that have no property below.

**Returns** an `ICoreWebView2Settings` pointer with a reference added, which you release, or
`NULL` before the browser is ready.

**Example**

```freebasic
dim pSettings as ICoreWebView2Settings ptr = CWebView2Ptr( hwnd )->GetSettings()
if pSettings then pSettings->put_IsStatusBarEnabled( false ) : pSettings->Release()
```

Microsoft Learn: [ICoreWebView2Settings](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2settings)

### IsScriptEnabled

```freebasic
property IsScriptEnabled() as boolean
property IsScriptEnabled( byval enabled as boolean ) as HRESULT
```

The settings below are properties, each with a getter and a setter. **Call the setter with the
value in parentheses**, `IsScriptEnabled( false )`: it returns the `HRESULT`. Before the browser
is ready the getter returns `false` and the setter `E_POINTER`.

`IsScriptEnabled` is whether pages run JavaScript, `true` by default. A change applies from the
next navigation; [ExecuteScript](#executescript) runs scripts either way.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
if pWebView2->IsScriptEnabled then pWebView2->IsScriptEnabled( false )
```

Microsoft Learn: [ICoreWebView2Settings::put_IsScriptEnabled](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2settings#put_isscriptenabled)

### IsWebMessageEnabled

```freebasic
property IsWebMessageEnabled() as boolean
property IsWebMessageEnabled( byval enabled as boolean ) as HRESULT
```

Whether messages pass between the program and the page in both directions
([PostWebMessageAsJson](#postwebmessageasjson) and `window.chrome.webview.postMessage`), `true` by
default. A change applies from the next navigation.

**Example**

```freebasic
CWebView2Ptr( hwnd )->IsWebMessageEnabled( true )
```

Microsoft Learn: [ICoreWebView2Settings::put_IsWebMessageEnabled](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2settings#put_iswebmessageenabled)

### AreDefaultScriptDialogsEnabled

```freebasic
property AreDefaultScriptDialogsEnabled() as boolean
property AreDefaultScriptDialogsEnabled( byval enabled as boolean ) as HRESULT
```

Whether `alert`, `confirm`, `prompt` and `beforeunload` show the browser's own dialogs, `true`
by default. With `false`, nothing is shown and the program answers them in a
[ScriptDialogOpening](#addscriptdialogopening-removescriptdialogopening) handler.

**Example**

```freebasic
CWebView2Ptr( hwnd )->AreDefaultScriptDialogsEnabled( false )
```

Microsoft Learn: [ICoreWebView2Settings::put_AreDefaultScriptDialogsEnabled](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2settings#put_aredefaultscriptdialogsenabled)

### IsStatusBarEnabled

```freebasic
property IsStatusBarEnabled() as boolean
property IsStatusBarEnabled( byval enabled as boolean ) as HRESULT
```

Whether the address of a link under the mouse shows in a small bar at the bottom left, `true` by
default.

**Example**

```freebasic
CWebView2Ptr( hwnd )->IsStatusBarEnabled( false )
```

Microsoft Learn: [ICoreWebView2Settings::put_IsStatusBarEnabled](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2settings#put_isstatusbarenabled)

### AreDevToolsEnabled

```freebasic
property AreDevToolsEnabled() as boolean
property AreDevToolsEnabled( byval enabled as boolean ) as HRESULT
```

Whether the user can open the developer tools with F12, Ctrl+Shift+I or the context menu, `true`
by default. [OpenDevToolsWindow](#opendevtoolswindow) works either way.

**Example**

```freebasic
CWebView2Ptr( hwnd )->AreDevToolsEnabled( false )
```

Microsoft Learn: [ICoreWebView2Settings::put_AreDevToolsEnabled](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2settings#put_aredevtoolsenabled)

### AreDefaultContextMenusEnabled

```freebasic
property AreDefaultContextMenusEnabled() as boolean
property AreDefaultContextMenusEnabled( byval enabled as boolean ) as HRESULT
```

Whether right-clicking shows the browser's context menu, `true` by default.

**Example**

```freebasic
CWebView2Ptr( hwnd )->AreDefaultContextMenusEnabled( false )
```

Microsoft Learn: [ICoreWebView2Settings::put_AreDefaultContextMenusEnabled](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2settings#put_aredefaultcontextmenusenabled)

### AreHostObjectsAllowed

```freebasic
property AreHostObjectsAllowed() as boolean
property AreHostObjectsAllowed( byval allowed as boolean ) as HRESULT
```

Whether pages can reach the objects of [AddHostObjectToScript](#addhostobjecttoscript), `true` by
default.

**Example**

```freebasic
CWebView2Ptr( hwnd )->AreHostObjectsAllowed( false )
```

Microsoft Learn: [ICoreWebView2Settings::put_AreHostObjectsAllowed](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2settings#put_arehostobjectsallowed)

### IsZoomControlEnabled

```freebasic
property IsZoomControlEnabled() as boolean
property IsZoomControlEnabled( byval allowed as boolean ) as HRESULT
```

Whether the user can zoom with Ctrl and the mouse wheel or Ctrl with `+` and `-`, `true` by
default. [SetZoomFactor](#getzoomfactor-setzoomfactor) works either way.

**Example**

```freebasic
CWebView2Ptr( hwnd )->IsZoomControlEnabled( false )
```

Microsoft Learn: [ICoreWebView2Settings::put_IsZoomControlEnabled](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2settings#put_iszoomcontrolenabled)

### IsBuiltInErrorPageEnabled

```freebasic
property IsBuiltInErrorPageEnabled() as boolean
property IsBuiltInErrorPageEnabled( byval allowed as boolean ) as HRESULT
```

Whether a failed navigation, or a crashed page, shows the browser's error page, `true` by
default. With `false` the page stays blank and the program can show its own.

**Example**

```freebasic
CWebView2Ptr( hwnd )->IsBuiltInErrorPageEnabled( false )
```

Microsoft Learn: [ICoreWebView2Settings::put_IsBuiltInErrorPageEnabled](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2settings#put_isbuiltinerrorpageenabled)

### AddNavigationStarting, RemoveNavigationStarting

```freebasic
function AddNavigationStarting( byval eventHandler as ICoreWebView2NavigationStartingEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemoveNavigationStarting( byval token as EventRegistrationToken ) as HRESULT
```

The event methods all work the same way. `Add…` registers a handler object and fills `token`,
which `Remove…` takes to unregister it. The handler is an object of a type derived from the
matching class of [WebView2 event handlers](SysWin-WebView2-Events), with its `Invoke` written
for the program, created with `new` and passed as `cast( any ptr, p )`; the WebView keeps a
reference to it and the object deletes itself when that is released. Several handlers can be
registered for one event. The snippets pass the base classes, whose `Invoke` does nothing. These
methods do not check for a browser: *each needs a ready WebView.*

**Returns** the `HRESULT`.

NavigationStarting is raised before each top-level navigation; the handler can read the URL and
cancel it.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim token as EventRegistrationToken
pWebView2->AddNavigationStarting( cast( any ptr, new CWebView2NavigationStartingdEventHandler ), @token )
pWebView2->RemoveNavigationStarting( token )
```

Microsoft Learn: [ICoreWebView2::add_NavigationStarting](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#add_navigationstarting)

### AddNavigationCompleted, RemoveNavigationCompleted

```freebasic
function AddNavigationCompleted( byval eventHandler as ICoreWebView2NavigationCompletedEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemoveNavigationCompleted( byval token as EventRegistrationToken ) as HRESULT
```

NavigationCompleted is raised when a top-level document has loaded, or failed to: the arguments
tell whether it succeeded and, if not, why.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim token as EventRegistrationToken
pWebView2->AddNavigationCompleted( cast( any ptr, new CWebView2NavigationCompletedEventHandler ), @token )
pWebView2->RemoveNavigationCompleted( token )
```

Microsoft Learn: [ICoreWebView2::add_NavigationCompleted](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#add_navigationcompleted)

### AddFrameNavigationStarting, RemoveFrameNavigationStarting

```freebasic
function AddFrameNavigationStarting( byval eventHandler as ICoreWebView2NavigationStartingEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemoveFrameNavigationStarting( byval token as EventRegistrationToken ) as HRESULT
```

FrameNavigationStarting is NavigationStarting for a navigation inside a frame (`<iframe>`); it
takes the same kind of handler.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim token as EventRegistrationToken
pWebView2->AddFrameNavigationStarting( cast( any ptr, new CWebView2NavigationStartingdEventHandler ), @token )
pWebView2->RemoveFrameNavigationStarting( token )
```

Microsoft Learn: [ICoreWebView2::add_FrameNavigationStarting](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#add_framenavigationstarting)

### AddFrameNavigationCompleted, RemoveFrameNavigationCompleted

```freebasic
function AddFrameNavigationCompleted( byval eventHandler as ICoreWebView2NavigationCompletedEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemoveFrameNavigationCompleted( byval token as EventRegistrationToken ) as HRESULT
```

FrameNavigationCompleted is NavigationCompleted for a frame; it takes the same kind of handler.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim token as EventRegistrationToken
pWebView2->AddFrameNavigationCompleted( cast( any ptr, new CWebView2NavigationCompletedEventHandler ), @token )
pWebView2->RemoveFrameNavigationCompleted( token )
```

Microsoft Learn: [ICoreWebView2::add_FrameNavigationCompleted](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#add_framenavigationcompleted)

### AddContentLoading, RemoveContentLoading

```freebasic
function AddContentLoading( byval eventHandler as ICoreWebView2ContentLoadingEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemoveContentLoading( byval token as EventRegistrationToken ) as HRESULT
```

ContentLoading is raised when the new document starts loading, before any of its content has
been shown.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim token as EventRegistrationToken
pWebView2->AddContentLoading( cast( any ptr, new CWebView2ContentLoadingEventHandler ), @token )
pWebView2->RemoveContentLoading( token )
```

Microsoft Learn: [ICoreWebView2::add_ContentLoading](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#add_contentloading)

### AddSourceChanged, RemoveSourceChanged

```freebasic
function AddSourceChanged( byval eventHandler as ICoreWebView2SourceChangedEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemoveSourceChanged( byval token as EventRegistrationToken ) as HRESULT
```

SourceChanged is raised when the URL of the top-level document changes, including a jump to an
anchor in the same page; [GetSource](#getsource) returns the new one. An address bar is kept up
to date from it.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim token as EventRegistrationToken
pWebView2->AddSourceChanged( cast( any ptr, new CWebView2SourceChangedEventHandler ), @token )
pWebView2->RemoveSourceChanged( token )
```

Microsoft Learn: [ICoreWebView2::add_SourceChanged](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#add_sourcechanged)

### AddHistoryChanged, RemoveHistoryChanged

```freebasic
function AddHistoryChanged( byval eventHandler as ICoreWebView2SourceChangedEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemoveHistoryChanged( byval token as EventRegistrationToken ) as HRESULT
```

These two register and unregister a handler for the **SourceChanged** event, exactly as
[AddSourceChanged](#addsourcechanged-removesourcechanged) and `RemoveSourceChanged` do, and their
handler type is the SourceChanged one. The HistoryChanged event itself, raised when the history
changes (which is when [CanGoBack](#cangoback) and [CanGoForward](#cangoforward) may have
changed), is registered on the raw interface: `GetWebViewPtr()->add_HistoryChanged( … )`.

**Example**

```freebasic
dim pCore as ICoreWebView2 ptr = CWebView2Ptr( hwnd )->GetWebViewPtr()
dim token as EventRegistrationToken
pCore->add_HistoryChanged( cast( any ptr, new CWebView2HistoryChangedEventHandler ), @token )
pCore->remove_HistoryChanged( token )
```

Microsoft Learn: [ICoreWebView2::add_HistoryChanged](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#add_historychanged)

### AddScriptDialogOpening, RemoveScriptDialogOpening

```freebasic
function AddScriptDialogOpening( byval eventHandler as ICoreWebView2ScriptDialogOpeningEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemoveScriptDialogOpening( byval token as EventRegistrationToken ) as HRESULT
```

ScriptDialogOpening is raised when the page calls `alert`, `confirm` or `prompt`, or asks before
unloading, and [AreDefaultScriptDialogsEnabled](#aredefaultscriptdialogsenabled) is `false`; the
handler shows a dialog of its own and gives the answer.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim token as EventRegistrationToken
pWebView2->AddScriptDialogOpening( cast( any ptr, new CWebView2ScriptDialogOpeningEventHandler ), @token )
pWebView2->RemoveScriptDialogOpening( token )
```

Microsoft Learn: [ICoreWebView2::add_ScriptDialogOpening](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#add_scriptdialogopening)

### AddPermissionRequested, RemovePermissionRequested

```freebasic
function AddPermissionRequested( byval eventHandler as ICoreWebView2PermissionRequestedEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemovePermissionRequested( byval token as EventRegistrationToken ) as HRESULT
```

PermissionRequested is raised when a page asks for the microphone, camera, location,
notifications, the clipboard and so on; the handler allows or denies it, or leaves the browser
to ask the user.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim token as EventRegistrationToken
pWebView2->AddPermissionRequested( cast( any ptr, new CWebView2PermissionRequestedEventHandler ), @token )
pWebView2->RemovePermissionRequested( token )
```

Microsoft Learn: [ICoreWebView2::add_PermissionRequested](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#add_permissionrequested)

### AddProcessFailed, RemoveProcessFailed

```freebasic
function AddProcessFailed( byval eventHandler as ICoreWebView2ProcessFailedEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemoveProcessFailed( byval token as EventRegistrationToken ) as HRESULT
```

ProcessFailed is raised when one of the browser's processes crashes, hangs or ends; the
arguments say which kind. When the browser process itself has gone, the program must create a
new `CWebView2`.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim token as EventRegistrationToken
pWebView2->AddProcessFailed( cast( any ptr, new CWebView2ProcessFailedEventHandler ), @token )
pWebView2->RemoveProcessFailed( token )
```

Microsoft Learn: [ICoreWebView2::add_ProcessFailed](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#add_processfailed)

### AddWebMessageReceived, RemoveWebMessageReceived

```freebasic
function AddWebMessageReceived( byval eventHandler as ICoreWebView2WebMessageReceivedEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemoveWebMessageReceived( byval token as EventRegistrationToken ) as HRESULT
```

WebMessageReceived is raised when the top-level document calls
`window.chrome.webview.postMessage( value )`; the handler reads the value as a string or as JSON,
as the [Example](#example) does. Needs [IsWebMessageEnabled](#iswebmessageenabled).

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim token as EventRegistrationToken
pWebView2->AddWebMessageReceived( cast( any ptr, new CWebView2WebMessageReceivedEventHandler ), @token )
pWebView2->RemoveWebMessageReceived( token )
```

Microsoft Learn: [ICoreWebView2::add_WebMessageReceived](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#add_webmessagereceived)

### AddNewWindowRequested, RemoveNewWindowRequested

```freebasic
function AddNewWindowRequested( byval eventHandler as ICoreWebView2NewWindowRequestedEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemoveNewWindowRequested( byval token as EventRegistrationToken ) as HRESULT
```

NewWindowRequested is raised when the page opens a new window: `window.open`, a link with
`target="_blank"`, or the user's "open in new window". Unhandled, the browser opens its own
pop-up window. [CWebView2NewWindowRequestedEventHandlerInternal](#cwebview2newwindowrequestedeventhandlerinternal)
is a ready-made handler that loads the page in the same browser instead.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim token as EventRegistrationToken
pWebView2->AddNewWindowRequested( cast( any ptr, new CWebView2NewWindowRequestedEventHandler ), @token )
pWebView2->RemoveNewWindowRequested( token )
```

Microsoft Learn: [ICoreWebView2::add_NewWindowRequested](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#add_newwindowrequested)

### AddDocumentTitleChanged, RemoveDocumentTitleChanged

```freebasic
function AddDocumentTitleChanged( byval eventHandler as ICoreWebView2DocumentTitleChangedEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemoveDocumentTitleChanged( byval token as EventRegistrationToken ) as HRESULT
```

DocumentTitleChanged is raised when the title of the top-level document changes; the handler
reads it with the sender's `get_DocumentTitle`, for instance to put it in the caption.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim token as EventRegistrationToken
pWebView2->AddDocumentTitleChanged( cast( any ptr, new CWebView2DocumentTitleChangedEventHandler ), @token )
pWebView2->RemoveDocumentTitleChanged( token )
```

Microsoft Learn: [ICoreWebView2::add_DocumentTitleChanged](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#add_documenttitlechanged)

### AddContainsFullScreenElementChanged, RemoveContainsFullScreenElementChanged

```freebasic
function AddContainsFullScreenElementChanged( byval eventHandler as ICoreWebView2ContainsFullScreenElementChangedEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemoveContainsFullScreenElementChanged( byval token as EventRegistrationToken ) as HRESULT
```

ContainsFullScreenElementChanged is raised when an element of the page enters or leaves full
screen; [GetContainsFullScreenElement](#getcontainsfullscreenelement) says which.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim token as EventRegistrationToken
pWebView2->AddContainsFullScreenElementChanged( cast( any ptr, new CWebView2ContainsFullScreenElementChangedEventHandler ), @token )
pWebView2->RemoveContainsFullScreenElementChanged( token )
```

Microsoft Learn: [ICoreWebView2::add_ContainsFullScreenElementChanged](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#add_containsfullscreenelementchanged)

### AddWebResourceRequested, RemoveWebResourceRequested

```freebasic
function AddWebResourceRequested( byval eventHandler as ICoreWebView2WebResourceRequestedEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemoveWebResourceRequested( byval token as EventRegistrationToken ) as HRESULT
```

WebResourceRequested is raised for each request that matches a filter of
[AddWebResourceRequestedFilter](#addwebresourcerequestedfilter-removewebresourcerequestedfilter);
the handler can read the request, change it, or give the response itself.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim token as EventRegistrationToken
pWebView2->AddWebResourceRequested( cast( any ptr, new CWebView2WebResourceRequestedEventHandler ), @token )
pWebView2->RemoveWebResourceRequested( token )
```

Microsoft Learn: [ICoreWebView2::add_WebResourceRequested](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#add_webresourcerequested)

### AddWindowCloseRequested, RemoveWindowCloseRequested

```freebasic
function AddWindowCloseRequested( byval eventHandler as ICoreWebView2WindowCloseRequestedEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemoveWindowCloseRequested( byval token as EventRegistrationToken ) as HRESULT
```

WindowCloseRequested is raised when the page calls `window.close()`; the browser does not close
by itself, so the handler closes it or its window.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim token as EventRegistrationToken
pWebView2->AddWindowCloseRequested( cast( any ptr, new CWebView2WindowCloseRequestedEventHandler ), @token )
pWebView2->RemoveWindowCloseRequested( token )
```

Microsoft Learn: [ICoreWebView2::add_WindowCloseRequested](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2#add_windowcloserequested)

### AddZoomFactorChanged, RemoveZoomFactorChanged

```freebasic
function AddZoomFactorChanged( byval eventHandler as ICoreWebView2ZoomFactorChangedEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemoveZoomFactorChanged( byval token as EventRegistrationToken ) as HRESULT
```

ZoomFactorChanged is raised when the zoom changes, by the user or by
[SetZoomFactor](#getzoomfactor-setzoomfactor). This event and the four below belong to the
controller: their handler's `Invoke` receives an `ICoreWebView2Controller` as the sender.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim token as EventRegistrationToken
pWebView2->AddZoomFactorChanged( cast( any ptr, new CWebView2ZoomFactorChangedEventHandler ), @token )
pWebView2->RemoveZoomFactorChanged( token )
```

Microsoft Learn: [ICoreWebView2Controller::add_ZoomFactorChanged](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2controller#add_zoomfactorchanged)

### AddMoveFocusRequested, RemoveMoveFocusRequested

```freebasic
function AddMoveFocusRequested( byval eventHandler as ICoreWebView2MoveFocusRequestedEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemoveMoveFocusRequested( byval token as EventRegistrationToken ) as HRESULT
```

MoveFocusRequested is raised when Tab or Shift+Tab would take the focus out of the page; the
handler moves it to the next control of the window.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim token as EventRegistrationToken
pWebView2->AddMoveFocusRequested( cast( any ptr, new CWebView2MoveFocusRequestedEventHandler ), @token )
pWebView2->RemoveMoveFocusRequested( token )
```

Microsoft Learn: [ICoreWebView2Controller::add_MoveFocusRequested](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2controller#add_movefocusrequested)

### AddGotFocus, RemoveGotFocus

```freebasic
function AddGotFocus( byval eventHandler as ICoreWebView2FocusChangedEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemoveGotFocus( byval token as EventRegistrationToken ) as HRESULT
```

GotFocus is raised when the browser gets the keyboard focus.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim token as EventRegistrationToken
pWebView2->AddGotFocus( cast( any ptr, new CWebView2FocusChangedEventHandler ), @token )
pWebView2->RemoveGotFocus( token )
```

Microsoft Learn: [ICoreWebView2Controller::add_GotFocus](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2controller#add_gotfocus)

### AddLostFocus, RemoveLostFocus

```freebasic
function AddLostFocus( byval eventHandler as ICoreWebView2FocusChangedEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemoveLostFocus( byval token as EventRegistrationToken ) as HRESULT
```

LostFocus is raised when the browser loses the keyboard focus.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim token as EventRegistrationToken
pWebView2->AddLostFocus( cast( any ptr, new CWebView2FocusChangedEventHandler ), @token )
pWebView2->RemoveLostFocus( token )
```

Microsoft Learn: [ICoreWebView2Controller::add_LostFocus](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2controller#add_lostfocus)

### AddAcceleratorKeyPressed, RemoveAcceleratorKeyPressed

```freebasic
function AddAcceleratorKeyPressed( byval eventHandler as ICoreWebView2AcceleratorKeyPressedEventHandler ptr, byval token as EventRegistrationToken ptr ) as HRESULT
function RemoveAcceleratorKeyPressed( byval token as EventRegistrationToken ) as HRESULT
```

AcceleratorKeyPressed is raised, while the browser has the focus, for keys and combinations the
host may want for itself: function keys, Ctrl or Alt combinations, Esc and so on. The handler can
act on the key and mark it handled so that the page never sees it.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim token as EventRegistrationToken
pWebView2->AddAcceleratorKeyPressed( cast( any ptr, new CWebView2AcceleratorKeyPressedEventHandler ), @token )
pWebView2->RemoveAcceleratorKeyPressed( token )
```

Microsoft Learn: [ICoreWebView2Controller::add_AcceleratorKeyPressed](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2controller#add_acceleratorkeypressed)

## Related functions

| Function | Does |
| --- | --- |
| [CWebView2Ptr](#cwebview2ptr) | Returns the `CWebView2` that a host window holds. |
| [SaveTempHtmlFile](#savetemphtmlfile) | Saves HTML as a UTF-8 file in the temporary folder. |
| [CreateCoreWebView2Environment](#createcorewebview2environment) | Starts creating an environment with the default runtime and profile. |
| [CreateCoreWebView2EnvironmentWithOptions](#createcorewebview2environmentwithoptions) | Starts creating an environment with a chosen runtime, profile and options. |
| [CreateCoreWebView2EnvironmentWithDetails](#createcorewebview2environmentwithdetails) | The older form, with browser arguments as a string. |
| [GetAvailableCoreWebView2BrowserVersionString](#getavailablecorewebview2browserversionstring) | Returns the version of the runtime that would be used. |
| [CompareBrowserVersions](#comparebrowserversions) | Compares two version strings. |

The five functions that create environments or read versions are those of `WebView2Loader.dll`:
each loads the DLL, calls its function of the same name and frees the DLL again, and returns
`E_POINTER` when the DLL or the function cannot be found.

### CWebView2Ptr

```freebasic
function CWebView2Ptr( byval hWin as HWND ) as CWebView2 ptr
```

Returns the `CWebView2` whose address the constructor (or [SetParentWindow](#getparentwindow-setparentwindow))
stored in `hWin`'s `GWLP_USERDATA` slot, so that a window procedure needs no global. Pass the
window that hosts the browser: for one created in a control, that control. It returns whatever
the slot holds, so it is only meaningful for a host window.

**Returns** the object, or `NULL` when `hWin` is not a window or holds no address yet. It is a
plain pointer: nothing to release.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
if pWebView2 then pWebView2->Reload()
```

### SaveTempHtmlFile

```freebasic
function SaveTempHtmlFile( byval pwszBuffer as wstring ptr ) as ustring
```

Writes the text in `pwszBuffer` to a new file in the user's temporary folder, as UTF-8 with a
byte-order mark and a carriage return and line feed added at the end, and gives it the extension
`.html` (`TMP2D4A.html`). Use it for pages too large for
[NavigateToString](#navigatetostring), or whose relative links and scripts must load: navigate
to `"file:///" & name`. The program deletes the file when done.

**Returns** the full path of the file; the `.tmp` name it was created with when the rename
failed; `""` when it could not be created.

**Example**

```freebasic
dim ustrFile as ustring = SaveTempHtmlFile( "<h1>Report</h1>" )
CWebView2Ptr( hwnd )->Navigate( "file:///" & ustrFile )
```

Microsoft Learn: [GetTempFileNameW](https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-gettempfilenamew)

### CreateCoreWebView2Environment

```freebasic
function CreateCoreWebView2Environment( byval environment_created_handler as ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler ptr ) as HRESULT
```

Starts creating an environment with the installed runtime and the default profile folder, as
[CreateCoreWebView2EnvironmentWithOptions](#createcorewebview2environmentwithoptions) does with
`NULL` for everything. The environment arrives later, in the handler's `Invoke`. The
`CWebView2` constructor calls it without a profile folder; call it yourself to build the
browser step by step.

| Parameter | Meaning |
| --- | --- |
| `environment_created_handler` | An object derived from `CWebView2CreateCoreWebView2EnvironmentCompletedHandler`, passed as `cast( any ptr, p )`. |

**Returns** `S_OK` when creation started; `E_POINTER` without the loader DLL; otherwise the
loader's error.

**Example**

```freebasic
dim pHandler as CWebView2CreateCoreWebView2EnvironmentCompletedHandler ptr = new CWebView2CreateCoreWebView2EnvironmentCompletedHandler
if CreateCoreWebView2Environment( cast( any ptr, pHandler ) ) <> S_OK then print "no loader"
```

Microsoft Learn: [CreateCoreWebView2Environment](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl#createcorewebview2environment)

### CreateCoreWebView2EnvironmentWithOptions

```freebasic
function CreateCoreWebView2EnvironmentWithOptions( byval browserExecutableFolder as PCWSTR, byval userDataFolder as PCWSTR, byval environmentOptions as ICoreWebView2EnvironmentOptions ptr, byval environment_created_handler as ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler ptr ) as HRESULT
```

Starts creating an environment, choosing the runtime, the profile folder and the options.

| Parameter | Meaning |
| --- | --- |
| `browserExecutableFolder` | A folder holding a fixed-version runtime shipped with the program, or `NULL` for the installed one. |
| `userDataFolder` | The profile folder, or `NULL` for `<program>.exe.WebView2` next to the program. |
| `environmentOptions` | An object implementing `ICoreWebView2EnvironmentOptions` (browser arguments, language, …), or `NULL`. |
| `environment_created_handler` | The handler that receives the environment, passed as `cast( any ptr, p )`. |

The runtime also reads overrides from environment variables such as
`WEBVIEW2_USER_DATA_FOLDER` and `WEBVIEW2_ADDITIONAL_BROWSER_ARGUMENTS`. A second environment
in the same process must use the same folder and options as the first, or creation fails.

**Returns** `S_OK` when creation started; `E_POINTER` without the loader DLL; otherwise the
loader's error.

**Example**

```freebasic
dim pHandler as CWebView2CreateCoreWebView2EnvironmentCompletedHandler ptr = new CWebView2CreateCoreWebView2EnvironmentCompletedHandler
CreateCoreWebView2EnvironmentWithOptions( NULL, GetTempPath() & "MyAppWebView2", NULL, cast( any ptr, pHandler ) )
```

Microsoft Learn: [CreateCoreWebView2EnvironmentWithOptions](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl#createcorewebview2environmentwithoptions)

### CreateCoreWebView2EnvironmentWithDetails

```freebasic
function CreateCoreWebView2EnvironmentWithDetails( byval browserExecutableFolder as PCWSTR, byval userDataFolder as PCWSTR, byval additionalBrowserArguments as PCWSTR, byval environment_created_handler as ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler ptr ) as HRESULT
```

The early form of [CreateCoreWebView2EnvironmentWithOptions](#createcorewebview2environmentwithoptions),
with the browser's command-line switches as a string. The loader has dropped it: the
`WebView2Loader.dll` the toolchain ships does not export it, so with that DLL it always returns
`E_POINTER`. Use `…WithOptions`.

**Returns** `S_OK` when creation started; `E_POINTER` without the loader DLL or the function.

**Example**

```freebasic
dim pHandler as CWebView2CreateCoreWebView2EnvironmentCompletedHandler ptr = new CWebView2CreateCoreWebView2EnvironmentCompletedHandler
if CreateCoreWebView2EnvironmentWithDetails( NULL, NULL, "--disable-gpu", cast( any ptr, pHandler ) ) = E_POINTER then print "not available"
```

### GetAvailableCoreWebView2BrowserVersionString

```freebasic
function GetAvailableCoreWebView2BrowserVersionString( byval browserExecutableFolder as PCWSTR, byval versionInfo as LPWSTR ptr ) as HRESULT
```

Finds the runtime that an environment would use, without creating anything, and returns its
version: the installed one for a `NULL` folder, otherwise the fixed-version runtime in that
folder. A channel name follows the number for a preview build of Edge (`beta`, `dev`,
`canary`). Use it at start-up to tell the user the runtime is missing.

| Parameter | Meaning |
| --- | --- |
| `browserExecutableFolder` | A fixed-version runtime folder, or `NULL`. |
| `versionInfo` | Receives the version text, which you free with `CoTaskMemFree`. |

**Returns** `S_OK` with the version; `E_POINTER` without the loader DLL; otherwise the loader's
error, such as when no runtime is installed. On a machine with the runtime installed the example printed `WebView2 Runtime 156.0.4314.58`.

**Example**

```freebasic
dim pVersion as LPWSTR
if GetAvailableCoreWebView2BrowserVersionString( NULL, @pVersion ) = S_OK andalso pVersion <> NULL then
    print "WebView2 Runtime "; *cast( wstring ptr, pVersion )
    CoTaskMemFree( pVersion )
end if
```

Microsoft Learn: [GetAvailableCoreWebView2BrowserVersionString](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl#getavailablecorewebview2browserversionstring)

### CompareBrowserVersions

```freebasic
function CompareBrowserVersions( byval version1 as PCWSTR, byval version2 as PCWSTR, byval result as INT_ ptr ) as HRESULT
```

Compares two runtime version strings number by number, ignoring a channel name after them, so
that a program can check that the installed runtime is new enough.

| Parameter | Meaning |
| --- | --- |
| `version1`, `version2` | The versions, such as `120.0.2210.91`. |
| `result` | Receives -1 when `version1` is older, 0 when they are the same, 1 when it is newer. |

**Returns** `S_OK`; `E_INVALIDARG` (`&h80070057`) when a string is not a version;
`E_POINTER` without the loader DLL. `"120.0.2210.91"` against `"119.0.2151.97"` gives 1, the
other way round -1, and `"100.0.1.0"` against `"100.0.1.0 beta"` 0.

**Example**

```freebasic
dim r as long
if CompareBrowserVersions( "120.0.2210.91", "119.0.2151.97", @r ) = S_OK then print r    ' 1
```

Microsoft Learn: [CompareBrowserVersions](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl#comparebrowserversions)

## Related types

The module's own handlers. The two creation handlers are what the constructor uses; the other
two are ready-made event handlers a program can create.

| Type | Does |
| --- | --- |
| [CWebView2NewWindowRequestedEventHandlerInternal](#cwebview2newwindowrequestedeventhandlerinternal) | Loads pages that would open a new window in the same browser. |
| [CWebView2WebMessageReceivedEventHandlerInternal](#cwebview2webmessagereceivedeventhandlerinternal) | Turns the page message `image-ready` into a `WM_NOTIFY`. |
| [CWebView2CreateCoreWebView2EnvironmentCompletedHandlerInternal](#cwebview2createcorewebview2environmentcompletedhandlerinternal) | Receives the environment and asks for the controller. |
| [CWebView2CreateCoreWebView2ControllerCompletedHandlerInternal](#cwebview2createcorewebview2controllercompletedhandlerinternal) | Receives the controller and shows the browser. |

Each is created with `new` and is not deleted by the program: the runtime holds a reference to
it, and its `Release` deletes it when the count falls back to 0.

### CWebView2NewWindowRequestedEventHandlerInternal

```freebasic
type CWebView2NewWindowRequestedEventHandlerInternal extends CWebView2NewWindowRequestedEventHandler
    function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2NewWindowRequestedEventArgs ptr ) as HRESULT
    constructor( byval pWebView2 as CWebView2 ptr, byval useNewWindow as boolean = false )
    destructor()
    m_pWebView2 as CWebView2 ptr
    m_token as EventRegistrationToken
    m_useNewWindow as boolean
    m_hParentWindow as HWND
end type
```

A NewWindowRequested handler that registers itself. While it is registered, a page that opens a
new window (`window.open`, `target="_blank"`) has that page loaded in the same browser instead:
the request is marked handled and its URL navigated to.

#### Constructor

Registers the handler on `pWebView2` with [AddNewWindowRequested](#addnewwindowrequested-removenewwindowrequested),
keeping the token in `m_token`. `pWebView2` must be ready; with `NULL` nothing is registered.
With `useNewWindow` `true` the handler does nothing and the browser opens its own window as
usual. `m_hParentWindow` is not used.

| Parameter | Meaning |
| --- | --- |
| `pWebView2` | The browser to watch. |
| `useNewWindow` | `false` (the default) loads new windows in place; `true` leaves them alone. |

**Example**

```freebasic
dim pHandler as CWebView2NewWindowRequestedEventHandlerInternal ptr
pHandler = new CWebView2NewWindowRequestedEventHandlerInternal( CWebView2Ptr( hwnd ) )
```

#### Destructor

Unregisters the handler with [RemoveNewWindowRequested](#addnewwindowrequested-removenewwindowrequested).
It runs when the object deletes itself.

**Example**

```freebasic
dim pHandler as CWebView2NewWindowRequestedEventHandlerInternal ptr = new CWebView2NewWindowRequestedEventHandlerInternal( NULL )
pHandler->AddRef() : pHandler->Release()    ' the count falls to 0: the destructor runs
```

#### Invoke

Called by the browser for each request. With `useNewWindow` `false` it marks the request handled
and navigates the sender to its URL.

**Returns** `S_OK`.

**Example**

```freebasic
dim pHandler as CWebView2NewWindowRequestedEventHandlerInternal ptr = new CWebView2NewWindowRequestedEventHandlerInternal( CWebView2Ptr( hwnd ), false )
if pHandler->m_useNewWindow = false then print "new windows open in place"
```

Microsoft Learn: [ICoreWebView2NewWindowRequestedEventHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2newwindowrequestedeventhandler)

### CWebView2WebMessageReceivedEventHandlerInternal

```freebasic
type CWebView2WebMessageReceivedEventHandlerInternal extends CWebView2WebMessageReceivedEventHandler
    virtual function Invoke( byval sender as ICoreWebView2 ptr, byval args as ICoreWebView2WebMessageReceivedEventArgs ptr ) as HRESULT
    constructor( byval pWebView2 as CWebView2 ptr )
    virtual destructor()
    refCount as ULONG = 0
    m_pWebView2 as CWebView2 ptr
    m_token as EventRegistrationToken
    m_hdr as NMHDR
end type
```

A WebMessageReceived handler that registers itself and passes one message on to the window
procedure: when the page posts the string `image-ready`
(`window.chrome.webview.postMessage('image-ready')`, for instance from an image's `onload`), it
posts a `WM_NOTIFY` to the host's top-level window. Other messages are ignored.

#### Constructor

Registers the handler on `pWebView2` with [AddWebMessageReceived](#addwebmessagereceived-removewebmessagereceived),
keeping the token in `m_token`. `pWebView2` must be ready; with `NULL` nothing is registered.

**Example**

```freebasic
dim pHandler as CWebView2WebMessageReceivedEventHandlerInternal ptr
pHandler = new CWebView2WebMessageReceivedEventHandlerInternal( CWebView2Ptr( hCtrl ) )
```

#### Destructor

Unregisters the handler with [RemoveWebMessageReceived](#addwebmessagereceived-removewebmessagereceived).
It runs when the object deletes itself.

**Example**

```freebasic
dim pHandler as CWebView2WebMessageReceivedEventHandlerInternal ptr = new CWebView2WebMessageReceivedEventHandlerInternal( NULL )
pHandler->AddRef() : pHandler->Release()    ' the count falls to 0: the destructor runs
```

#### Invoke

Called by the browser for each message. It reads the message as a string; for `image-ready` it
fills `m_hdr` and posts the notification described above.

**Returns** `S_OK`.

**Example**

```freebasic
function IsImageReady( byval wParam as WPARAM, byval lParam as LPARAM ) as boolean
    ' for WM_NOTIFY in the top-level window's procedure
    dim pnmh as NMHDR ptr = cast( NMHDR ptr, wParam )
    return pnmh->code = &hFFFFFFFF andalso CWebView2Ptr( pnmh->hwndFrom ) = cast( CWebView2 ptr, lParam )
end function
```

Microsoft Learn: [WM_NOTIFY](https://learn.microsoft.com/en-us/windows/win32/controls/wm-notify)

### CWebView2CreateCoreWebView2EnvironmentCompletedHandlerInternal

```freebasic
type CWebView2CreateCoreWebView2EnvironmentCompletedHandlerInternal extends object
    virtual function QueryInterface( byval riid as REFIID, byval ppvObject as LPVOID ptr ) as HRESULT
    virtual function AddRef() as ULONG
    virtual function Release() as ULONG
    virtual function Invoke( byval errorCode as HRESULT, byval createdEnvironment as ICoreWebView2Environment ptr ) as HRESULT
    constructor( byval pWebView2 as CWebView2 ptr )
    destructor()
    refCount as ULONG = 0
    m_pWebView2 as CWebView2 ptr
end type
```

The handler the constructor passes when it asks for the environment. Its virtual members are in
the order of the COM interface it stands for.

#### Constructor, Destructor

The constructor stores `pWebView2`, the object to fill; the destructor does nothing.

**Example**

```freebasic
dim pHandler as CWebView2CreateCoreWebView2EnvironmentCompletedHandlerInternal ptr
pHandler = new CWebView2CreateCoreWebView2EnvironmentCompletedHandlerInternal( CWebView2Ptr( hwnd ) )
CreateCoreWebView2Environment( cast( any ptr, pHandler ) )
```

#### QueryInterface, AddRef, Release

`AddRef` and `Release` count references from 0; `Release` deletes the object when the count gets
back to 0. `QueryInterface` returns `S_OK` for any interface and leaves `ppvObject` as it is.

**Returns** `AddRef` and `Release`: the new count. `QueryInterface`: `S_OK`.

**Example**

```freebasic
dim pHandler as CWebView2CreateCoreWebView2EnvironmentCompletedHandlerInternal ptr = new CWebView2CreateCoreWebView2EnvironmentCompletedHandlerInternal( NULL )
print pHandler->AddRef()     ' 1
print pHandler->Release()    ' 0, and the object is gone
```

#### Invoke

Called by the runtime with the result. On success it keeps the environment in the `CWebView2`
(adding a reference), asks it for a controller in the host window with a
[CWebView2CreateCoreWebView2ControllerCompletedHandlerInternal](#cwebview2createcorewebview2controllercompletedhandlerinternal),
and stores the runtime's version for [GetBrowserVersion](#getbrowserversion). On failure it does
nothing: the error is not stored, and [IsReady](#isready) never sees a controller.

**Returns** `S_OK`.

**Example**

```freebasic
dim pHandler as CWebView2CreateCoreWebView2EnvironmentCompletedHandlerInternal ptr = new CWebView2CreateCoreWebView2EnvironmentCompletedHandlerInternal( NULL )
pHandler->Invoke( E_FAIL, NULL )     ' a failed creation: nothing happens
```

Microsoft Learn: [ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2createcorewebview2environmentcompletedhandler)

### CWebView2CreateCoreWebView2ControllerCompletedHandlerInternal

```freebasic
type CWebView2CreateCoreWebView2ControllerCompletedHandlerInternal extends object
    virtual function QueryInterface( byval riid as REFIID, byval ppvObject as LPVOID ptr ) as HRESULT
    virtual function AddRef() as ULONG
    virtual function Release() as ULONG
    virtual function Invoke( byval errorCode as HRESULT, byval createdController as ICoreWebView2Controller ptr ) as HRESULT
    constructor( byval pWebView2 as CWebView2 ptr )
    destructor()
    refCount as ULONG = 0
    m_pWebView2 as CWebView2 ptr
end type
```

The handler the environment handler passes when it asks for the controller.

#### Constructor, Destructor

The constructor stores `pWebView2`, the object to fill; the destructor does nothing.

**Example**

```freebasic
dim pWebView2 as CWebView2 ptr = CWebView2Ptr( hwnd )
dim pHandler as CWebView2CreateCoreWebView2ControllerCompletedHandlerInternal ptr = new CWebView2CreateCoreWebView2ControllerCompletedHandlerInternal( pWebView2 )
pWebView2->GetEnvironmentPtr()->CreateCoreWebView2Controller( hwnd, cast( any ptr, pHandler ) )
```

#### QueryInterface, AddRef, Release

As for the environment handler: a count from 0, deletion at 0, and a `QueryInterface` that
returns `S_OK` without filling `ppvObject`.

**Returns** `AddRef` and `Release`: the new count. `QueryInterface`: `S_OK`.

**Example**

```freebasic
dim pHandler as CWebView2CreateCoreWebView2ControllerCompletedHandlerInternal ptr = new CWebView2CreateCoreWebView2ControllerCompletedHandlerInternal( NULL )
print pHandler->AddRef()     ' 1
print pHandler->Release()    ' 0, and the object is gone
```

#### Invoke

Called by the runtime with the result. On success it keeps the controller in the `CWebView2`
(adding a reference) and its WebView, makes the browser visible and sizes it to the host's client
area. That is the moment [IsReady](#isready) waits for. On failure it does nothing.

**Returns** `S_OK`.

**Example**

```freebasic
dim pHandler as CWebView2CreateCoreWebView2ControllerCompletedHandlerInternal ptr = new CWebView2CreateCoreWebView2ControllerCompletedHandlerInternal( NULL )
pHandler->Invoke( E_FAIL, NULL )     ' a failed creation: nothing happens
```

Microsoft Learn: [ICoreWebView2CreateCoreWebView2ControllerCompletedHandler](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2createcorewebview2controllercompletedhandler)

## See also

- [sys/win/webview2](SysWin-WebView2), the module
- [WebView2 event handlers](SysWin-WebView2-Events), the classes to derive event handlers from
- [WebView2 interfaces](SysWin-WebView2-Interfaces), the raw `ICoreWebView2*` interfaces, enumerations and types
- [CWindow](CWindow), the window that hosts the browser
- [Microsoft Learn: WebView2 distribution](https://learn.microsoft.com/en-us/microsoft-edge/webview2/concepts/distribution), about the runtime
