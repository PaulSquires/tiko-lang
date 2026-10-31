[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gui](SysWin-Gui) › **CTabPage**

# CTabPage

Creates a window that serves as one page of a tab control.

A tab control draws only the tabs; the page under each tab is a window of your own that you show
when its tab is selected. `CTabPage` is a [CWindow](CWindow) that makes such a page: `InsertPage`
adds a tab and creates the page window inside the tab control's display area. Being a `CWindow`,
each page has its own window procedure and everything `CWindow` offers: `AddControl`,
`AnchorControl`, `SetCtlColors`, `SetBackColor` and the rest work on the page and its controls.
The page's controls send their messages to the page's procedure, not to the main window's.

**Lifetime.** Allocate each page with `new`. The tab item keeps the object's address, which is how
[CTabPagePtr](#ctabpageptr) finds it again, so the object must live as long as its tab. Deleting
the object removes its tab and destroys its window; `TabCtl.DestroyAllPages` deletes every page of
a tab control at once, which is what a main window does in `WM_DESTROY`.

**Showing pages.** Pages are created hidden. Show the first one yourself, then in the main
window's `WM_NOTIFY` hide the current page on `TCN_SELCHANGING` and show the new one on
`TCN_SELCHANGE`. When the tab control changes size, [ResizePages](#resizepages) fits every page to
it again.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui
```

## Example

A tab control with two pages, stretched with the window. The first page has an edit box and a
button with its own window procedure; the second a list box.

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

const IDC_TAB    = 1001
const IDC_NAME   = 1002
const IDC_SUBMIT = 1003
const IDC_LIST   = 1004

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
declare function Page1Proc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "TabDemo"
    dim hWin as HWND = pWindow.Create( NULL, "CTabPage", @WndProc )
    pWindow.SetClientSize( 420, 260 )
    pWindow.Center()
    dim hTab as HWND = pWindow.AddControl( "Tab", hWin, IDC_TAB, "", 10, 10, 400, 240 )
    pWindow.AnchorControl( hTab, ANCHOR_HEIGHT_WIDTH )

    dim pPage1 as CTabPage ptr = new CTabPage
    dim hPage1 as HWND = pPage1->InsertPage( hTab, 0, "Name", -1, @Page1Proc )
    pPage1->AddControl( "Edit", hPage1, IDC_NAME, "", 15, 20, 250, 24 )
    pPage1->AddControl( "Button", hPage1, IDC_SUBMIT, "&Submit", 280, 19, 90, 26 )
    pPage1->AnchorControl( hPage1, IDC_NAME, ANCHOR_WIDTH )
    pPage1->AnchorControl( hPage1, IDC_SUBMIT, ANCHOR_RIGHT )

    dim pPage2 as CTabPage ptr = new CTabPage
    dim hPage2 as HWND = pPage2->InsertPage( hTab, 1, "List" )
    dim hList as HWND = pPage2->AddControl( "ListBox", hPage2, IDC_LIST, "", 15, 15, 200, 150 )
    pPage2->AnchorControl( hList, ANCHOR_HEIGHT_WIDTH )
    for i as long = 1 to 20
        ListBox.AddString( hList, "Item " & i )
    next

    ShowWindow( hPage1, SW_SHOW )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_SIZE
            dim pPage as CTabPage ptr = CTabPagePtr( GetDlgItem( hwnd, IDC_TAB ), -1 )
            if pPage then pPage->ResizePages()
            return 0
        case WM_NOTIFY
            dim pnmh as NMHDR ptr = CBNMHDR( wParam, lParam )
            if pnmh->idFrom = IDC_TAB then
                dim pPage as CTabPage ptr = CTabPagePtr( pnmh->hwndFrom, -1 )
                if pPage then
                    if pnmh->code = TCN_SELCHANGING then ShowWindow( pPage->hTabPage, SW_HIDE )
                    if pnmh->code = TCN_SELCHANGE then ShowWindow( pPage->hTabPage, SW_SHOW )
                end if
            end if
            return 0
        case WM_COMMAND
            if CBCTL( wParam, lParam ) = IDCANCEL then SendMessageW( hwnd, WM_CLOSE, 0, 0 )
            return 0
        case WM_DESTROY
            TabCtl.DestroyAllPages( GetDlgItem( hwnd, IDC_TAB ) )
            PostQuitMessage( 0 )
            return 0
    end select
    return DefWindowProcW( hwnd, uMsg, wParam, lParam )
end function

function Page1Proc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    if uMsg = WM_COMMAND andalso CBCTL( wParam, lParam ) = IDC_SUBMIT andalso CBCTLMSG( wParam, lParam ) = BN_CLICKED then
        SetWindowText( GetAncestor( hwnd, GA_ROOT ), "Hello, " & GetWindowText( GetDlgItem( hwnd, IDC_NAME ) ) )
        return 0
    end if
    return DefWindowProcW( hwnd, uMsg, wParam, lParam )
end function

end main()
```

## Members

`CTabPage` extends [CWindow](CWindow) and has all its members. These are its own:

| Member | Does |
| --- | --- |
| [Destructor](#destructor) | Removes the page's tab and destroys the page window. |
| [InsertPage](#insertpage) | Adds a tab and creates the page window for it. |
| [hTabPage](#htabpage) | The page window's handle. |
| [ResizePage](#resizepage) | Fits the selected tab's page to the tab control. |
| [ResizePages](#resizepages) | Fits every page of the tab control to it. |

## Reference

### Destructor

```freebasic
destructor
```

Finds the object's tab in the tab control, deletes the tab and destroys the page window, then
moves the focus to the first tab if any are left. A page that is not in a tab control just has its
window destroyed. The [CWindow destructor](CWindow#destructor) runs after it. The page window's
handle and its controls' handles are invalid afterwards.

**Example**

```freebasic
dim pPage as CTabPage ptr = CTabPagePtr( hCtrl, 1 )
if pPage then delete pPage   ' removes the second tab and its page
```

Microsoft Learn: [TCM_DELETEITEM](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-deleteitem)

### InsertPage

```freebasic
function InsertPage( byval hTab as HWND, byval nPage as long, byref wszTitle as wstring = "", byval nImage as long = -1, byval lpfnWndProc as WNDPROC = NULL, byval dwStyle as DWORD = WS_CLIPSIBLINGS or WS_CLIPCHILDREN, byval dwExStyle as DWORD = 0 ) as HWND
```

Inserts a tab at position `nPage` and creates the page window with [Create](CWindow#create) as a
child of the tab control, covering its display area, hidden. The tab item's `lParam` holds the
object's address, and it is set before the page window is made, so the page's `WM_CREATE` can
already call `CTabPagePtr( GetParent( hwnd ), nPage )` to reach the object and add controls.
`WS_CHILD` and `WS_EX_CONTROLPARENT` are always added to the styles. Each page registers a window
class of its own with a generated name.

| Parameter | Meaning |
| --- | --- |
| `hTab` | The tab control. |
| `nPage` | The zero-based position of the new tab; a position below 0 or past the end puts it last. |
| `wszTitle` | The text on the tab, also the page window's title. |
| `nImage` | The tab's image in the tab control's image list, or -1 for none. |
| `lpfnWndProc` | The page's window procedure. With `NULL` the page has none of its own and `DefWindowProcW` handles its messages. |
| `dwStyle` | The page window's styles. Add `WS_VISIBLE` to create it shown. |
| `dwExStyle` | The page window's extended styles. |

**Returns** the page window's handle, or `NULL` when `hTab` is not a window or the window could
not be created.

**Example**

```freebasic
dim pPage as CTabPage ptr = new CTabPage
dim hPage as HWND = pPage->InsertPage( hCtrl, 0, "General" )
pPage->AddControl( "CheckBox", hPage, 101, "Start with Windows", 15, 15, 200, 22 )
```

Microsoft Learn: [TCM_INSERTITEM](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-insertitem)

### hTabPage

```freebasic
property hTabPage() as HWND
```

**Returns** the page window's handle, the one `InsertPage` returned (the same as `hWindow`), or
`NULL` before `InsertPage`.

**Example**

```freebasic
dim pPage as CTabPage ptr = CTabPagePtr( hCtrl, -1 )
if pPage then ShowWindow( pPage->hTabPage, SW_SHOW )
```

### ResizePage

```freebasic
function ResizePage() as boolean
```

Fits the page of the tab control's **selected** tab, whichever page object it is called on, to the
tab control's display area.

**Returns** `true`; `false` when the page is not in a tab control.

**Example**

```freebasic
dim pPage as CTabPage ptr = CTabPagePtr( hCtrl, -1 )
if pPage then pPage->ResizePage()
```

Microsoft Learn: [TCM_ADJUSTRECT](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-adjustrect)

### ResizePages

```freebasic
function ResizePages() as boolean
```

Fits every page of the tab control the page belongs to, shown or hidden, to the tab control's
display area. Call it from the main window's `WM_SIZE` when the tab control is anchored or resized.
`TabCtl.ResizePages` does the same given only the tab control.

**Returns** `true`; `false` when the page is not in a tab control or the tab control has no tabs.

**Example**

```freebasic
dim pPage as CTabPage ptr = CTabPagePtr( hCtrl, 0 )
if pPage then pPage->ResizePages()
```

## Related functions

| Function | Does |
| --- | --- |
| [CTabPagePtr](#ctabpageptr) | Returns the `CTabPage` of a tab. |

### CTabPagePtr

```freebasic
function CTabPagePtr( byval hTab as HWND, byval idx as long ) as CTabPage ptr
```

Reads the object's address from tab `idx` of a tab control. Pass -1 for the selected tab; the
index has no default. The address is the tab item's `lParam`, so a tab added without
`InsertPage` gives `NULL` when its `lParam` is 0, and that value cast to a `CTabPage ptr`
otherwise.

| Parameter | Meaning |
| --- | --- |
| `hTab` | The tab control. |
| `idx` | The zero-based tab index, or -1 for the selected tab. |

**Returns** the page object, or `NULL` when there is no such tab, no tab is selected or the tab
has no page object.

**Example**

```freebasic
dim pPage as CTabPage ptr = CTabPagePtr( hCtrl, -1 )
if pPage then SetFocus( GetWindow( pPage->hTabPage, GW_CHILD ) )
```

Microsoft Learn: [TCM_GETITEM](https://learn.microsoft.com/en-us/windows/win32/controls/tcm-getitem)

## See also

- [CWindow](CWindow), whose members every page has
- [TabCtl](SysWin-Gui-TabCtl) for the tab control functions, including `TabCtl.DestroyPage`, `TabCtl.DestroyAllPages` and `TabCtl.ResizePages`
- [sys/win/gui](SysWin-Gui)
- [CDialog](CDialog) for tab pages in a dialog
