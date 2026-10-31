[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › **sys/win/webview2**

# sys/win/webview2

Embeds Microsoft Edge in a window to show web pages, HTML and scripts from tiko code.

WebView2 is the browser control of Windows: the Chromium-based Edge engine, running in its own
processes and drawing into a window of your program. With it a program shows web pages, local
HTML files and HTML it builds as a string, runs JavaScript in them, and exchanges messages with
them, so a part of its interface can be written in HTML, CSS and JavaScript: charts, maps, video,
formatted reports.

The module has three layers:

- **[CWebView2](CWebView2)**, a class that creates the browser in a window or control and wraps
  the everyday calls: navigation, scripts, messages, size, zoom, settings and events. It also
  holds the helpers for local pages and images and the loader functions.
- **Event handler classes**, one per WebView2 event or completion callback, that a program
  derives from to be told when a page has loaded, a message has arrived and so on.
- **The raw COM interfaces** (`ICoreWebView2`, its controller, environment, settings and every
  later version), their enumerations and structures, for everything the class does not wrap.

**What it needs at run time.** The machine that runs the program needs the **WebView2
Runtime**, built into Windows 11 and installed with Edge or on its own on Windows 10, and the
program needs **`WebView2Loader.dll`**, which finds that runtime. The module loads the DLL by
name when it needs it, through the normal DLL search, so ship a copy next to the `.exe`; the
toolchain has one in `examples/win64/WebView2 Examples/`. Without it the browser does not start
and the calls that need it return `E_POINTER`.

**The model.** Creating a browser is asynchronous: the `CWebView2` constructor asks for it and
[IsReady](CWebView2#isready) pumps messages until it exists. The object then lives as long as
the window, its address kept in the host window so that [CWebView2Ptr](CWebView2#cwebview2ptr)
finds it in a window procedure. Event handlers are created with `new` and owned by the browser,
which releases them; text it returns is freed with `CoTaskMemFree`, or by the class for you.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/webview2"
using win, webview2
```

A program that creates its window with [CWindow](CWindow) imports `sys/win/gui` too, as the
example does.

## Example

A window that first checks that the runtime is there and puts its version in the caption, then
shows a page saved to a temporary file. The page's link asks for a new window; a ready-made
handler loads it in the same browser instead:

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/webview2"
using win, gui, webview2

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )

    ' is there a WebView2 Runtime, and which?
    dim pVersion as LPWSTR
    if GetAvailableCoreWebView2BrowserVersionString( NULL, @pVersion ) <> S_OK orelse pVersion = NULL then
        MessageBoxW( NULL, "Please install the Microsoft Edge WebView2 Runtime.", "WebView2", MB_ICONERROR )
        return 1
    end if
    dim ustrCaption as ustring = "WebView2 Runtime " & *cast( wstring ptr, pVersion )
    CoTaskMemFree( pVersion )

    dim pWindow as CWindow = "WebView2Module"
    dim hWin as HWND = pWindow.Create( NULL, ustrCaption, @WndProc )
    pWindow.SetClientSize( 720, 480 )
    pWindow.Center

    ' a local page; its link would open a new window
    dim ustrFile as ustring = SaveTempHtmlFile( _
        "<body style='font: 15px Segoe UI'><h2>sys/win/webview2</h2>" & _
        "<p><a href='https://learn.microsoft.com/en-us/microsoft-edge/webview2/' target='_blank'>" & _
        "WebView2 documentation</a> opens here, not in a pop-up.</p></body>" )

    dim pWebView2 as CWebView2 = CWebView2( hWin, GetTempPath() & "WebView2Module" )
    if pWebView2.IsReady( 10000 ) then
        ' load pages that ask for a new window in this browser instead
        dim pNewWindow as CWebView2NewWindowRequestedEventHandlerInternal ptr = new CWebView2NewWindowRequestedEventHandlerInternal( @pWebView2 )
        pWebView2.Navigate( "file:///" & ustrFile )
    end if

    dim nResult as long = pWindow.DoEvents( SW_NORMAL )
    DeleteFileW( ustrFile )
    return nResult
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

More programs, among them images, MP4 and WebM video, Google Maps, Chart.js and Google charts,
SVG shapes and CSS clipping, are in the toolchain's `examples/win64/WebView2 Examples/` folder.

## Pages

| Page | Covers |
| --- | --- |
| [CWebView2](CWebView2) | The browser in a window: creating it, navigation, scripts and messages, size, zoom and focus, settings, events; `CWebView2Ptr`, `SaveTempHtmlFile`, the loader functions that create environments and compare runtime versions, and the module's own creation, new-window and message handlers. |
| [WebView2 event handlers](SysWin-WebView2-Events) | The handler classes to derive from, one per event (navigation, content, messages, new windows, permissions, dialogs, focus, keys, zoom …) and per completion callback (environment and controller creation, scripts, previews, DevTools calls). |
| [WebView2 interfaces and types](SysWin-WebView2-Interfaces) | The raw COM interfaces, from `ICoreWebView2` and its later versions to the controller, environment, settings, event arguments, cookies, downloads and printing; their IIDs; the `COREWEBVIEW2_*` enumerations; `EventRegistrationToken` and the other structures. |

## See also

- [Category: sys/win](Category-Sys-Win)
- [CWindow](CWindow), the window that hosts the browser
- [sys/win/com](SysWin-Com), for `VARIANT` and `BSTR` helpers when working with host objects
- [Microsoft Learn: WebView2](https://learn.microsoft.com/en-us/microsoft-edge/webview2/)
