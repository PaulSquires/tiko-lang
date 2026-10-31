[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gui](SysWin-Gui) › **CXpButton**

# CXpButton

Creates a push button that draws itself, with images, toggle behaviour and custom colours.

`CXpButton` registers a window class of its own, `TK_XPBUTTON`, and paints the button itself
instead of using the Windows `Button` class. It looks like a normal push button and sends the
same `BN_CLICKED` notification, and adds:

- an image beside, above, below or instead of the text, with a different image for the hot
  (mouse over) and disabled states;
- **toggle** behaviour: each click flips the button between up and down;
- its own colours for the face and the text, in the **classic** drawing style.

**Two drawing styles.** When visual styles are active as the button is created, it is drawn with
the current theme (`IsThemed` is 1); [DisableTheming](#disabletheming) switches it to the classic
3-D look drawn with GDI. The face and text colours, the background brushes and `BS_FLAT` are used
**only in the classic style**: a themed button takes its colours from the theme.

**Clicks.** The parent receives `WM_COMMAND` with `BN_CLICKED` when the left button is released
over the button after being pressed on it, when Space or Enter is released while the button has
the focus, and for `BM_CLICK`. A double-click counts as a second press. The caption is the
window text: change it with `SetWindowText` and call [Redraw](#redraw).

**Setters and properties.** Every `SetXxx` method redraws the button only when its `fRedraw`
argument is nonzero; the matching property (`btn.TextMargin = 6`) always redraws.

**Ownership.** The button owns its images, its font and its background brushes, and deletes
them when the object is destroyed or when a new one replaces them. That includes any font given
to [SetFont](#font-getfont-setfont) or sent with `WM_SETFONT`, so never pass a font that
something else still uses. Images are released with `DeleteObject`, which frees bitmaps but not
icons. The cursor is not deleted by the destructor, but [SetCursor](#cursor-getcursor-setcursor)
destroys the previous one.

**Lifetime.** The window keeps the object's address, and destroying the object does not destroy
the window, so the object must live as long as the button: a local in `main` around `DoEvents`,
or an object made with `new`. Do not copy it. [CXpButtonPtr](#cxpbuttonptr) finds the object
from the button's handle.

**Sizes.** Position and size are 96-DPI units, as for [CWindow.AddControl](CWindow#addcontrol).
The image and text margins are multiplied by the parent window's scaling ratio when drawn; image
widths and heights are pixels.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui
```

## Example

Three buttons: one with an icon beside its text, a toggle button that reports its state in the
caption, and a coloured button in the classic style.

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

const IDC_INFO   = 1001
const IDC_TOGGLE = 1002
const IDC_COLOUR = 1003

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    EnableVisualStyles()
    dim pWindow as CWindow = "XpButtonDemo"
    dim hWin as HWND = pWindow.Create( NULL, "CXpButton", @WndProc )
    pWindow.SetClientSize( 220, 150 )
    pWindow.Center()

    dim btnInfo as CXpButton = CXpButton( @pWindow, IDC_INFO, "&Information", 30, 10, 160, 36 )
    btnInfo.SetIcon( LoadIconW( NULL, cast( LPCWSTR, IDI_INFORMATION ) ), XPBI_NORMAL )
    btnInfo.SetImageSize( 24, 24 )

    dim btnToggle as CXpButton = CXpButton( @pWindow, IDC_TOGGLE, "&Toggle", 30, 56, 160, 36 )
    btnToggle.SetToggle( true )

    dim btnColour as CXpButton = CXpButton( @pWindow, IDC_COLOUR, "&Coloured", 30, 102, 160, 36 )
    btnColour.DisableTheming()
    btnColour.SetButtonBkColor( BGR( 0, 0, 255 ) )
    btnColour.SetButtonBkColorDown( BGR( 255, 255, 0 ) )
    btnColour.SetTextForeColor( BGR( 255, 255, 0 ) )
    btnColour.SetTextForeColorHot( BGR( 255, 255, 255 ) )
    btnColour.SetTextBkColor( BGR( 0, 0, 255 ) )

    SetFocus( btnInfo.hWindow )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_COMMAND
            if CBCTL( wParam, lParam ) = IDC_TOGGLE andalso CBCTLMSG( wParam, lParam ) = BN_CLICKED then
                dim pBtn as CXpButton ptr = CXpButtonPtr( hwnd, IDC_TOGGLE )
                if pBtn->ToggleState then
                    SetWindowText( hwnd, "Toggle is down" )
                else
                    SetWindowText( hwnd, "Toggle is up" )
                end if
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

## Image positions

[SetImagePos](#imagepos-getimagepos-setimagepos) takes these values, combined with `or`:

| Constant | Value | Image |
| --- | --- | --- |
| `XPBI_NONE` | 0 | not drawn |
| `XPBI_LEFT` | 1 | at the left, after the image margin |
| `XPBI_RIGHT` | 2 | at the right, before the image margin |
| `XPBI_CENTER` | 4 | centred horizontally |
| `XPBI_VCENTER` | 8 | centred vertically (otherwise at the top) |
| `XPBI_TOP` | 16 | at the top |
| `XPBI_BOTTOM` | 32 | at the bottom |
| `XPBI_ABOVE` | `XPBI_TOP or XPBI_CENTER` | centred above the text |
| `XPBI_BELOW` | `XPBI_BOTTOM or XPBI_CENTER` | centred below the text |
| `XPBI_CENTERCENTER` | `XPBI_CENTER or XPBI_VCENTER` | in the middle, and **no text is drawn** |

The default is `XPBI_LEFT or XPBI_VCENTER`. The image states for [SetImage](#setimage) and
[GetImage](#getimage) are `XPBI_NORMAL` (1), `XPBI_HOT` (2) and `XPBI_DISABLED` (3).

## Members

| Member | Does |
| --- | --- |
| [Constructor](#constructor) | Creates the button. |
| [Destructor](#destructor) | Deletes the button's images, font and brushes. |
| [hWindow](#hwindow) | Returns the button's handle. |
| [Redraw](#redraw) | Repaints the button now. |
| [IsThemed](#isthemed) | Tells whether the button is drawn with the theme. |
| [EnableTheming](#enabletheming) | Draws the button with the theme. |
| [DisableTheming](#disabletheming) | Draws the button in the classic style. |
| [Font, GetFont, SetFont](#font-getfont-setfont) | The font of the caption. |
| [TextFormat, GetTextFormat, SetTextFormat](#textformat-gettextformat-settextformat) | How the caption is aligned and broken (`DT_*` flags). |
| [TextMargin, GetTextMargin, SetTextMargin](#textmargin-gettextmargin-settextmargin) | The space between the edge or image and the caption. |
| [Cursor, GetCursor, SetCursor](#cursor-getcursor-setcursor) | The mouse cursor over the button. |
| [Toggle, GetToggle, SetToggle](#toggle-gettoggle-settoggle) | Whether the button is a toggle button. |
| [ToggleState, GetToggleState, SetToggleState](#togglestate-gettogglestate-settogglestate) | Whether a toggle button is down. |
| [ButtonState, GetButtonState](#buttonstate-getbuttonstate) | Whether the button is being pressed. |
| [AllowFocusRect, GetAllowFocusRect, SetAllowFocusRect](#allowfocusrect-getallowfocusrect-setallowfocusrect) | Whether the focus rectangle is drawn. |
| [SetImage](#setimage) | Sets an icon or bitmap for one state. |
| [SetIcon](#seticon) | Sets an icon for one state. |
| [SetBitmap](#setbitmap) | Sets a bitmap for one state. |
| [SetIconFromFile](#seticonfromfile) | Loads an `.ico` file as the image of one state. |
| [SetBitmapFromFile](#setbitmapfromfile) | Loads a `.bmp` file as the image of one state. |
| [SetImageFromFile](#setimagefromfile) | Loads a PNG, JPEG or other image file as the image of one state. |
| [SetImageFromRes](#setimagefromres) | Loads an image resource as the image of one state. |
| [GetImage](#getimage) | Returns the image of one state. |
| [NormalImageHandle](#normalimagehandle) | Returns the normal image. |
| [HotImageHandle](#hotimagehandle) | Returns the hot image. |
| [DisabledImageHandle](#disabledimagehandle) | Returns the disabled image. |
| [ImageType, GetImageType](#imagetype-getimagetype) | Whether the images are drawn as icons or bitmaps. |
| [ImageWidth, GetImageWidth, SetImageWidth](#imagewidth-getimagewidth-setimagewidth) | The width of the image. |
| [ImageHeight, GetImageHeight, SetImageHeight](#imageheight-getimageheight-setimageheight) | The height of the image. |
| [SetImageSize](#setimagesize) | Sets the width and height of the image. |
| [ImagePos, GetImagePos, SetImagePos](#imagepos-getimagepos-setimagepos) | Where the image goes. |
| [ImageMargin, GetImageMargin, SetImageMargin](#imagemargin-getimagemargin-setimagemargin) | The space between the edge and the image. |
| [ButtonBkColor, GetButtonBkColor, SetButtonBkColor](#buttonbkcolor-getbuttonbkcolor-setbuttonbkcolor) | The face colour (classic style). |
| [ButtonBkColorDown, GetButtonBkColorDown, SetButtonBkColorDown](#buttonbkcolordown-getbuttonbkcolordown-setbuttonbkcolordown) | The face colour while down (classic style). |
| [ButtonBkColorHot, GetButtonBkColorHot, SetButtonBkColorHot](#buttonbkcolorhot-getbuttonbkcolorhot-setbuttonbkcolorhot) | The face colour under the mouse (classic style). |
| [BkBrush](#bkbrush) | Returns the brush of the face colour. |
| [BkBrushDown](#bkbrushdown) | Returns the brush of the face colour while down. |
| [BkBrushHot](#bkbrushhot) | Returns the brush of the face colour under the mouse. |
| [TextForeColor, GetTextForeColor, SetTextForeColor](#textforecolor-gettextforecolor-settextforecolor) | The caption colour (classic style). |
| [TextForeColorHot, GetTextForeColorHot, SetTextForeColorHot](#textforecolorhot-gettextforecolorhot-settextforecolorhot) | The caption colour under the mouse (classic style). |
| [TextForeColorDown, GetTextForeColorDown, SetTextForeColorDown](#textforecolordown-gettextforecolordown-settextforecolordown) | The caption colour while down (classic style). |
| [TextBkColor, GetTextBkColor, SetTextBkColor](#textbkcolor-gettextbkcolor-settextbkcolor) | The colour behind the caption (classic style). |
| [TextBkColorDown, GetTextBkColorDown, SetTextBkColorDown](#textbkcolordown-gettextbkcolordown-settextbkcolordown) | The colour behind the caption while down (classic style). |
| [UxDrawPushButton](#uxdrawpushbutton) | Draws the button on a device context. |
| [CXPButtonProc](#cxpbuttonproc) | The window procedure of the button class. |

## Reference

### Constructor

```freebasic
constructor( byval pWindow as CWindow ptr, byval cID as LONG_PTR, byref wszTitle as wstring = "", byval x as long = 0, byval y as long = 0, byval nWidth as long = 0, byval nHeight as long = 0, byval dwStyle as DWORD = 0, byval dwExStyle as DWORD = 0, byval lpParam as LONG_PTR = 0 )
```

Registers the `TK_XPBUTTON` window class the first time, then creates the button in `pWindow`'s
window with [CWindow.AddControl](CWindow#addcontrol). The button gets its own copy of the parent
window's font, centred single-line text, image and text margins of 4, the arrow cursor and the
system button colours. It is themed when visual styles are active at that moment.

| Parameter | Meaning |
| --- | --- |
| `pWindow` | The parent window's `CWindow`. Must not be `NULL`. |
| `cID` | The control identifier, sent with `BN_CLICKED`. |
| `wszTitle` | The caption; `&` marks the mnemonic letter. |
| `x`, `y` | The position in the parent's client area, in 96-DPI units. |
| `nWidth`, `nHeight` | The size, in 96-DPI units. |
| `dwStyle` | The window styles; 0 gives `WS_VISIBLE or WS_TABSTOP or BS_PUSHBUTTON or BS_CENTER or BS_VCENTER`. `WS_CHILD` is always added. `BS_FLAT` gives a flat classic button. |
| `dwExStyle` | The extended window styles. |
| `lpParam` | A value passed on to `CreateWindowExW`. |

**Example**

```freebasic
dim pWindow as CWindow ptr = CWindowPtr( hwnd )
dim pBtn as CXpButton ptr = new CXpButton( pWindow, 1001, "&Save", 10, 10, 100, 30 )
```

Microsoft Learn: [RegisterClassExW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-registerclassexw)

### Destructor

```freebasic
destructor
```

Deletes the three images, the three background brushes and the font. The button window itself
is left alone: destroy it, or let its parent destroy it, before the object goes.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
DestroyWindow( hCtrl )
delete pBtn
```

### hWindow

```freebasic
function hWindow() as HWND
```

**Returns** the button's window handle, or `NULL` when it could not be created.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
EnableWindow( pBtn->hWindow, false )
```

### Redraw

```freebasic
sub Redraw
```

Invalidates the whole button and repaints it at once, without waiting for the message loop.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
SetWindowText( pBtn->hWindow, "&Stop" )
pBtn->Redraw()
```

Microsoft Learn: [UpdateWindow](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-updatewindow)

### IsThemed

```freebasic
function IsThemed() as long
```

**Returns** 1 when the button is drawn with the current theme, 0 when it is drawn in the classic
style.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
if pBtn->IsThemed() then pBtn->DisableTheming()
```

Microsoft Learn: [IsAppThemed](https://learn.microsoft.com/en-us/windows/win32/api/uxtheme/nf-uxtheme-isappthemed)

### EnableTheming

```freebasic
sub EnableTheming
```

Draws the button with the current theme from now on and repaints it. If no theme can be opened
for the window, nothing is drawn.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->EnableTheming()
```

Microsoft Learn: [DrawThemeBackground](https://learn.microsoft.com/en-us/windows/win32/api/uxtheme/nf-uxtheme-drawthemebackground)

### DisableTheming

```freebasic
sub DisableTheming
```

Draws the button in the classic style from now on, with GDI, and repaints it. Call it before
setting colours: they are used only in this style.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->DisableTheming()
pBtn->SetButtonBkColor( BGR( 0, 128, 0 ), true )
```

Microsoft Learn: [DrawFrameControl](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-drawframecontrol)

### Font, GetFont, SetFont

```freebasic
property Font() as HFONT
property Font( byval hFont as HFONT )
function GetFont() as HFONT
sub SetFont( byval hFont as HFONT, byval fRedraw as long = false )
```

The font the caption is drawn with. Setting it **hands the font to the button**: the previous
font is deleted at once and the new one when the button is destroyed or replaced. A `NULL` font
is ignored. `WM_SETFONT` sent to the button does the same, with `lParam` as `fRedraw`.

**Returns** (`GetFont` and the property) the font handle.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->Font = CreateFontW( -16, 0, 0, 0, FW_BOLD, 0, 0, 0, DEFAULT_CHARSET, 0, 0, 0, 0, "Segoe UI" )
```

Microsoft Learn: [WM_SETFONT](https://learn.microsoft.com/en-us/windows/win32/winmsg/wm-setfont)

### TextFormat, GetTextFormat, SetTextFormat

```freebasic
property TextFormat() as DWORD
property TextFormat( byval dwTextFlags as DWORD )
function GetTextFormat() as DWORD
sub SetTextFormat( byval dwTextFlags as DWORD, byval fRedraw as long = false )
```

The `DT_*` flags the caption is drawn with, as for `DrawTextW`: `DT_LEFT`, `DT_CENTER` or
`DT_RIGHT`, `DT_TOP`, `DT_VCENTER` or `DT_BOTTOM`, `DT_SINGLELINE` or `DT_WORDBREAK`,
`DT_END_ELLIPSIS`, `DT_HIDEPREFIX` and so on. The default is
`DT_CENTER or DT_VCENTER or DT_SINGLELINE`. The `BS_LEFT`, `BS_RIGHT` and other alignment styles
of the window are not used.

**Returns** (`GetTextFormat` and the property) the flags.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->SetTextFormat( DT_LEFT or DT_VCENTER or DT_SINGLELINE, true )
```

Microsoft Learn: [DrawTextW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-drawtextw)

### TextMargin, GetTextMargin, SetTextMargin

```freebasic
property TextMargin() as long
property TextMargin( byval nMargin as long )
function GetTextMargin() as long
sub SetTextMargin( byval nMargin as long, byval fRedraw as long = false )
```

The space, in 96-DPI units, kept between the caption and the edge of the button (or the image)
when the caption is aligned left or right. Centred text ignores it. The default is 4.

**Returns** (`GetTextMargin` and the property) the margin.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->TextMargin = 8
```

### Cursor, GetCursor, SetCursor

```freebasic
property Cursor() as HCURSOR
property Cursor( byval hCursor as HCURSOR )
function GetCursor() as HCURSOR
sub SetCursor( byval hCursor as HCURSOR )
```

The cursor shown while the mouse is over the button; the standard arrow at first. Setting a new
one destroys the previous one with `DestroyCursor`. The property also repaints the button.

**Returns** (`GetCursor` and the property) the cursor handle.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->SetCursor( LoadCursorW( NULL, cast( LPCWSTR, IDC_HAND ) ) )
```

Microsoft Learn: [SetCursor](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setcursor)

### Toggle, GetToggle, SetToggle

```freebasic
property Toggle( byval fToggle as long )
property Toggle() as long
function GetToggle() as long
sub SetToggle( byval fState as long, byval fRedraw as long = false )
```

Whether the button is a toggle button: one that stays down after a click and comes up at the
next. Any nonzero value turns it on. The down state itself is
[ToggleState](#togglestate-gettogglestate-settogglestate). A toggle button still sends
`BN_CLICKED` for every click.

**Returns** (`GetToggle` and the property) 1 for a toggle button, 0 for a push button.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->SetToggle( true )
print pBtn->GetToggle()   ' 1
```

### ToggleState, GetToggleState, SetToggleState

```freebasic
property ToggleState() as long
property ToggleState( byval fState as long )
function GetToggleState() as long
sub SetToggleState( byval fToggle as long, byval fRedraw as long = false )
```

Whether a toggle button is down. Each click, Space or Enter press and `BM_CLICK` flips it before
`BN_CLICKED` is sent, so the parent reads the new state. Setting it does not send a
notification. While it is down the button is drawn pressed, and in the classic style the
[ButtonBkColorDown](#buttonbkcolordown-getbuttonbkcolordown-setbuttonbkcolordown) face is used.

**Returns** (`GetToggleState` and the property) -1 when down, 0 when up.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->ToggleState = true
if pBtn->GetToggleState() then print "down"
```

### ButtonState, GetButtonState

```freebasic
property ButtonState() as long
function GetButtonState() as long
```

**Returns** `BST_PUSHED` (4) while the button is held down by the mouse or a key, 0 otherwise.
Use [ToggleState](#togglestate-gettogglestate-settogglestate) for the down state of a toggle
button.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
if pBtn->ButtonState = BST_PUSHED then print "being pressed"
```

### AllowFocusRect, GetAllowFocusRect, SetAllowFocusRect

```freebasic
property AllowFocusRect() as boolean
property AllowFocusRect( byval bAllowFocusRect as boolean )
function GetAllowFocusRect() as boolean
sub SetAllowFocusRect( byval bAllowFocusRect as boolean, byval fRedraw as long = false )
```

Whether the dotted focus rectangle is drawn while the button has the keyboard focus; `true` by
default.

**Returns** (`GetAllowFocusRect` and the property) the setting.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->AllowFocusRect = false
```

Microsoft Learn: [DrawFocusRect](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-drawfocusrect)

### SetImage

```freebasic
sub SetImage( byval hImage as HANDLE, byval ImageType as long, byval ImageState as long, byval fRedraw as long = false )
```

Gives the button an icon or a bitmap for one state. The button owns it from then on; the image
it had for that state is deleted. The normal image is drawn whenever there is no hot or disabled
one, and no image at all is drawn without a normal one.

The image type and the image size belong to the button, not to each image: every call sets
[ImageType](#imagetype-getimagetype) to `ImageType` and the [width](#imagewidth-getimagewidth-setimagewidth)
and [height](#imageheight-getimageheight-setimageheight) to the size of this image (16 × 16
when it cannot be read). Give all three states images of the same type and size, and call
[SetImageSize](#setimagesize) afterwards to change the size.

Icons are drawn at the image size, so `SetImageSize` scales them; bitmaps are drawn at their
own size and the image size only places them.

| Parameter | Meaning |
| --- | --- |
| `hImage` | The icon or bitmap. `NULL` is ignored. |
| `ImageType` | `IMAGE_ICON` or `IMAGE_BITMAP`; any other value is ignored. |
| `ImageState` | `XPBI_NORMAL`, `XPBI_HOT` or `XPBI_DISABLED`; any other value is ignored. |
| `fRedraw` | Nonzero repaints the button. |

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
dim hIcon as HICON = LoadImageW( GetModuleHandleW( NULL ), "#101", IMAGE_ICON, 32, 32, 0 )
pBtn->SetImage( hIcon, IMAGE_ICON, XPBI_NORMAL, true )
```

Microsoft Learn: [DrawIconEx](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-drawiconex), [DrawStateW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-drawstatew)

### SetIcon

```freebasic
sub SetIcon( byval hIcon as HICON, byval ImageState as long, byval fRedraw as long = false )
```

[SetImage](#setimage) with `IMAGE_ICON`.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->SetIcon( LoadIconW( NULL, cast( LPCWSTR, IDI_WARNING ) ), XPBI_HOT )
```

### SetBitmap

```freebasic
sub SetBitmap( byval hBitmap as HBITMAP, byval ImageState as long, byval fRedraw as long = false )
```

[SetImage](#setimage) with `IMAGE_BITMAP`. The bitmap is drawn without transparency.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->SetBitmap( LoadImageW( NULL, "open.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE ), XPBI_NORMAL )
```

### SetIconFromFile

```freebasic
sub SetIconFromFile( byval pwszPath as wstring ptr, byval ImageState as long, byval fRedraw as long = false )
```

Loads an icon from an `.ico` file, at the size stored in the file, and passes it to
[SetImage](#setimage). Nothing changes when the file cannot be loaded.

| Parameter | Meaning |
| --- | --- |
| `pwszPath` | The path of the `.ico` file. |
| `ImageState` | `XPBI_NORMAL`, `XPBI_HOT` or `XPBI_DISABLED`. |
| `fRedraw` | Nonzero repaints the button. |

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->SetIconFromFile( "save.ico", XPBI_NORMAL, true )
```

Microsoft Learn: [LoadImageW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-loadimagew)

### SetBitmapFromFile

```freebasic
sub SetBitmapFromFile( byval pwszPath as wstring ptr, byval ImageState as long, byval fRedraw as long = false )
```

Loads a bitmap from a `.bmp` file and passes it to [SetImage](#setimage). Nothing changes when the
file cannot be loaded.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->SetBitmapFromFile( "save.bmp", XPBI_NORMAL )
```

Microsoft Learn: [LoadImageW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-loadimagew)

### SetImageFromFile

```freebasic
sub SetImageFromFile( byref wszPath as wstring, byval ImageState as long = XPBI_NORMAL, byval fRedraw as long = false, byval dimPercent as long = 0, byval bGrayScale as long = false )
```

Loads any image GDI+ reads (PNG, JPEG, GIF, TIFF, BMP …), turns it into an icon, transparency
kept, and passes it to [SetIcon](#seticon). It can lighten the image or turn it grey first, which
makes a disabled image from the normal one. GDI+ is started for the call.

| Parameter | Meaning |
| --- | --- |
| `wszPath` | The path of the image file. |
| `ImageState` | `XPBI_NORMAL` (the default), `XPBI_HOT` or `XPBI_DISABLED`. |
| `fRedraw` | Nonzero repaints the button. |
| `dimPercent` | 1 to 99 lightens every pixel that far towards white; 0 leaves it. |
| `bGrayScale` | Nonzero turns the image grey. |

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->SetImageFromFile( "arrow.png" )
pBtn->SetImageFromFile( "arrow.png", XPBI_DISABLED, false, 50, true )
```

### SetImageFromRes

```freebasic
sub SetImageFromRes( byval hInstance as HINSTANCE, byref wszImageName as wstring, byval ImageState as long = XPBI_NORMAL, byval fRedraw as long = false, byval dimPercent as long = 0, byval bGrayScale as long = false )
```

[SetImageFromFile](#setimagefromfile) for an image stored in the program as an `RCDATA` resource,
such as a PNG.

| Parameter | Meaning |
| --- | --- |
| `hInstance` | The module that holds the resource; `NULL` means the program itself. |
| `wszImageName` | The resource name, or `"#"` followed by its number, as in `"#998"`. |
| `ImageState` | `XPBI_NORMAL` (the default), `XPBI_HOT` or `XPBI_DISABLED`. |
| `fRedraw` | Nonzero repaints the button. |
| `dimPercent` | 1 to 99 lightens the image; 0 leaves it. |
| `bGrayScale` | Nonzero turns the image grey. |

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->SetImageFromRes( GetModuleHandleW( NULL ), "#998", XPBI_NORMAL, true )
```

Microsoft Learn: [FindResourceW](https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-findresourcew)

### GetImage

```freebasic
function GetImage( byval ImageState as long ) as HANDLE
```

**Returns** the image for `XPBI_NORMAL`, `XPBI_HOT` or `XPBI_DISABLED`, `NULL` when that state
has none or for any other value. The image still belongs to the button.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
if pBtn->GetImage( XPBI_HOT ) = NULL then print "no hot image"
```

### NormalImageHandle

```freebasic
property NormalImageHandle() as HANDLE
```

**Returns** the normal image, as `GetImage( XPBI_NORMAL )` does.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
if pBtn->NormalImageHandle then print "has an image"
```

### HotImageHandle

```freebasic
property HotImageHandle() as HANDLE
```

**Returns** the hot image, as `GetImage( XPBI_HOT )` does.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
print pBtn->HotImageHandle <> NULL
```

### DisabledImageHandle

```freebasic
property DisabledImageHandle() as HANDLE
```

**Returns** the disabled image, as `GetImage( XPBI_DISABLED )` does.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
print pBtn->DisabledImageHandle <> NULL
```

### ImageType, GetImageType

```freebasic
property ImageType() as long
function GetImageType() as long
```

**Returns** `IMAGE_ICON` (1) or `IMAGE_BITMAP` (0): the type passed to the last
[SetImage](#setimage), which decides how all three images are drawn. 0 before any image is set.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
if pBtn->ImageType = IMAGE_ICON then print "icons"
```

### ImageWidth, GetImageWidth, SetImageWidth

```freebasic
property ImageWidth() as long
property ImageWidth( byval nWidth as long )
function GetImageWidth() as long
sub SetImageWidth( byval nWidth as long, byval fRedraw as long = false )
```

The width of the image in pixels, as set by the last [SetImage](#setimage) or by you.

**Returns** (`GetImageWidth` and the property) the width; 0 before any image is set.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->ImageWidth = 32
```

### ImageHeight, GetImageHeight, SetImageHeight

```freebasic
property ImageHeight() as long
property ImageHeight( byval nHeight as long )
function GetImageHeight() as long
sub SetImageHeight( byval nHeight as long, byval fRedraw as long = false )
```

The height of the image in pixels, as set by the last [SetImage](#setimage) or by you.

**Returns** (`GetImageHeight` and the property) the height; 0 before any image is set.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->ImageHeight = 32
```

### SetImageSize

```freebasic
sub SetImageSize( byval nWidth as long, byval nHeight as long, byval fRedraw as long = false )
```

Sets the image width and height together, in pixels. Call it after the images are set, since
each [SetImage](#setimage) resets them.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->SetImageSize( 24, 24, true )
```

### ImagePos, GetImagePos, SetImagePos

```freebasic
property ImagePos() as long
property ImagePos( byval nPos as long )
function GetImagePos() as long
sub SetImagePos( byval nPos as long, byval fRedraw as long = false )
```

Where the image goes, as a combination of the `XPBI_*` values in [Image positions](#image-positions);
`XPBI_LEFT or XPBI_VCENTER` by default. With the image at the left and left-aligned text the
caption starts after the image; with the image at the right and right-aligned text it ends
before it. Centred text is centred on the whole button. A pressed button draws its image one
pixel down and to the right.

**Returns** (`GetImagePos` and the property) the position flags.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->SetImagePos( XPBI_RIGHT or XPBI_VCENTER )
pBtn->SetTextFormat( DT_RIGHT or DT_VCENTER or DT_SINGLELINE, true )
```

### ImageMargin, GetImageMargin, SetImageMargin

```freebasic
property ImageMargin() as long
property ImageMargin( byval nMargin as long )
function GetImageMargin() as long
sub SetImageMargin( byval nMargin as long, byval fRedraw as long = false )
```

The space, in 96-DPI units, between the edge of the button and an image at the left or the
right. The default is 4.

**Returns** (`GetImageMargin` and the property) the margin.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->ImageMargin = 10
```

### ButtonBkColor, GetButtonBkColor, SetButtonBkColor

```freebasic
property ButtonBkColor() as COLORREF
property ButtonBkColor( byval bkColor as COLORREF )
function GetButtonBkColor() as COLORREF
sub SetButtonBkColor( byval bkgColor as COLORREF, byval fRedraw as long = false )
```

The colour of the button face in the classic style; without one the system button colour is
used. Setting it makes a new solid brush, owned by the button, and deletes the old one.

**Returns** (`GetButtonBkColor` and the property) the colour, or 0 when none has been set.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->DisableTheming()
pBtn->ButtonBkColor = BGR( 0, 0, 255 )
```

Microsoft Learn: [CreateSolidBrush](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-createsolidbrush)

### ButtonBkColorDown, GetButtonBkColorDown, SetButtonBkColorDown

```freebasic
property ButtonBkColorDown() as COLORREF
property ButtonBkColorDown( byval bkColorDown as COLORREF )
function GetButtonBkColorDown() as COLORREF
sub SetButtonBkColorDown( byval bkColorDown as COLORREF, byval fRedraw as long = false )
```

The face colour in the classic style while the button is pressed or a toggle button is down.
Without one the normal face colour is used.

**Returns** (`GetButtonBkColorDown` and the property) the colour, or 0 when none has been set.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->SetButtonBkColorDown( BGR( 255, 255, 0 ) )
```

### ButtonBkColorHot, GetButtonBkColorHot, SetButtonBkColorHot

```freebasic
property ButtonBkColorHot() as COLORREF
property ButtonBkColorHot( byval bkColorHot as COLORREF )
function GetButtonBkColorHot() as COLORREF
sub SetButtonBkColorHot( byval bkgColorHot as COLORREF, byval fRedraw as long = false )
```

The face colour in the classic style while the mouse is over the button. Without one the normal
face colour is used.

**Returns** (`GetButtonBkColorHot` and the property) the colour, or 0 when none has been set.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->SetButtonBkColorHot( BGR( 0, 0, 160 ) )
```

### BkBrush

```freebasic
property BkBrush() as HBRUSH
```

**Returns** the brush of [ButtonBkColor](#buttonbkcolor-getbuttonbkcolor-setbuttonbkcolor), or
`NULL` when none has been set. The brush belongs to the button.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
if pBtn->BkBrush then print "custom face colour"
```

### BkBrushDown

```freebasic
property BkBrushDown() as HBRUSH
```

**Returns** the brush of
[ButtonBkColorDown](#buttonbkcolordown-getbuttonbkcolordown-setbuttonbkcolordown), or `NULL`.
The brush belongs to the button.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
print pBtn->BkBrushDown <> NULL
```

### BkBrushHot

```freebasic
property BkBrushHot() as HBRUSH
```

**Returns** the brush of
[ButtonBkColorHot](#buttonbkcolorhot-getbuttonbkcolorhot-setbuttonbkcolorhot), or `NULL`. The
brush belongs to the button.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
print pBtn->BkBrushHot <> NULL
```

### TextForeColor, GetTextForeColor, SetTextForeColor

```freebasic
property TextForeColor() as COLORREF
property TextForeColor( byval textColor as COLORREF )
function GetTextForeColor() as COLORREF
sub SetTextForeColor( byval textColor as COLORREF, byval fRedraw as long = false )
```

The caption colour in the classic style; the system button text colour at first. A disabled
button draws its caption embossed in the system's highlight and shadow colours instead.

**Returns** (`GetTextForeColor` and the property) the colour.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->SetTextForeColor( BGR( 255, 255, 0 ), true )
```

Microsoft Learn: [SetTextColor](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-settextcolor)

### TextForeColorHot, GetTextForeColorHot, SetTextForeColorHot

```freebasic
property TextForeColorHot() as COLORREF
property TextForeColorHot( byval textColor as COLORREF )
function GetTextForeColorHot() as COLORREF
sub SetTextForeColorHot( byval textColor as COLORREF, byval fRedraw as long = false )
```

The caption colour in the classic style while the mouse is over the button. It is used whenever
the button is hot, and it starts as 0, **black**, not as the normal caption colour: set it
whenever you change [TextForeColor](#textforecolor-gettextforecolor-settextforecolor).

**Returns** (`GetTextForeColorHot` and the property) the colour.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->SetTextForeColor( BGR( 255, 255, 0 ) )
pBtn->SetTextForeColorHot( BGR( 255, 255, 255 ) )
```

### TextForeColorDown, GetTextForeColorDown, SetTextForeColorDown

```freebasic
property TextForeColorDown() as COLORREF
property TextForeColorDown( byval textColor as COLORREF )
function GetTextForeColorDown() as COLORREF
sub SetTextForeColorDown( byval textColor as COLORREF, byval fRedraw as long = false )
```

The caption colour in the classic style while the button is down. Set it together with
[TextBkColorDown](#textbkcolordown-gettextbkcolordown-settextbkcolordown): a toggle button that
is down uses the two only when both are set, while a button being pressed uses both as soon as
either is set, so the other must be set too.

**Returns** (`GetTextForeColorDown` and the property) the colour, or `&hFFFFFFFF` when none has
been set.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->SetTextForeColorDown( BGR( 255, 255, 255 ) )
pBtn->SetTextBkColorDown( BGR( 255, 0, 0 ) )
```

### TextBkColor, GetTextBkColor, SetTextBkColor

```freebasic
property TextBkColor() as COLORREF
property TextBkColor( byval textColor as COLORREF )
function GetTextBkColor() as COLORREF
sub SetTextBkColor( byval textColor as COLORREF, byval fRedraw as long = false )
```

The colour painted behind the caption's characters in the classic style; the system button
colour at first. While it equals that system colour the caption is drawn transparently over the
face; any other colour fills the caption's character cells, so match it to
[ButtonBkColor](#buttonbkcolor-getbuttonbkcolor-setbuttonbkcolor).

**Returns** (`GetTextBkColor` and the property) the colour.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->SetButtonBkColor( BGR( 0, 0, 255 ) )
pBtn->SetTextBkColor( BGR( 0, 0, 255 ), true )
```

Microsoft Learn: [SetBkColor](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-setbkcolor)

### TextBkColorDown, GetTextBkColorDown, SetTextBkColorDown

```freebasic
property TextBkColorDown() as COLORREF
property TextBkColorDown( byval textColor as COLORREF )
function GetTextBkColorDown() as COLORREF
sub SetTextBkColorDown( byval textColor as COLORREF, byval fRedraw as long = false )
```

The colour behind the caption in the classic style while the button is down; see
[TextForeColorDown](#textforecolordown-gettextforecolordown-settextforecolordown) for when it is
used.

**Returns** (`GetTextBkColorDown` and the property) the colour, or `&hFFFFFFFF` when none has
been set.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
pBtn->TextBkColorDown = BGR( 255, 255, 0 )
```

### UxDrawPushButton

```freebasic
sub UxDrawPushButton( byval hDC as HDC )
```

Draws the whole button, face, image, caption and focus rectangle, in its current state onto
`hDC`, which must cover the button's client area. The window procedure calls it for `WM_PAINT`
and `WM_PRINTCLIENT`; call it yourself to draw the button somewhere else. The button's font is
selected into `hDC` and left there.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hCtrl )
dim hdc as HDC = GetDC( pBtn->hWindow )
pBtn->UxDrawPushButton( hdc )
ReleaseDC( pBtn->hWindow, hdc )
```

Microsoft Learn: [DrawThemeText](https://learn.microsoft.com/en-us/windows/win32/api/uxtheme/nf-uxtheme-drawthemetext)

### CXPButtonProc

```freebasic
static function CXPButtonProc( byval hWnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
```

The window procedure of the `TK_XPBUTTON` class; you do not call it. It finds the object in the
window's extra bytes, paints on `WM_PAINT` and `WM_PRINTCLIENT` without erasing the background
first, tracks the mouse to draw the hot state, runs the clicks and keys described in the intro,
answers `WM_GETDLGCODE` so that the button takes Enter and its mnemonic in a dialog, repaints on
`WM_ENABLE`, `WM_SETFOCUS` and `WM_KILLFOCUS`, sets its cursor on `WM_SETCURSOR`, takes the font
from `WM_SETFONT`, and passes `WM_COMMAND` and `WM_NOTIFY` on to the parent. While the mouse is
over the button the window has a property named `HOT`.

**Example**

```freebasic
SendMessageW( hCtrl, BM_CLICK, 0, 0 )   ' handled here: flips a toggle and sends BN_CLICKED
```

Microsoft Learn: [BM_CLICK](https://learn.microsoft.com/en-us/windows/win32/controls/bm-click), [BN_CLICKED](https://learn.microsoft.com/en-us/windows/win32/controls/bn-clicked)

## Related functions

| Function | Does |
| --- | --- |
| [CXpButtonPtr](#cxpbuttonptr) | Returns the `CXpButton` object of a button. |

### CXpButtonPtr

```freebasic
function CXpButtonPtr overload ( byval hCtl as HWND ) as CXpButton ptr
function CXpButtonPtr overload ( byval hParent as HWND, byval cID as long ) as CXpButton ptr
```

Returns the object behind a `CXpButton` window, given its handle, or its parent and its
identifier. The address is kept in the window's extra bytes. Use it in a window procedure, where
only the handle or the identifier is at hand.

| Parameter | Meaning |
| --- | --- |
| `hCtl` | The button. |
| `hParent` | The button's parent window. |
| `cID` | The button's identifier. |

**Returns** the object, or `NULL` when there is no such window. For a window of another class the
value read is not an object.

**Example**

```freebasic
dim pBtn as CXpButton ptr = CXpButtonPtr( hwnd, 1001 )
if pBtn then pBtn->SetToggleState( false, true )
```

Microsoft Learn: [GetWindowLongPtrW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindowlongptrw)

## See also

- [Button](SysWin-Gui-Button) for the functions of standard Windows buttons
- [CWindow](CWindow) for the parent window and `AddControl`
- [Colours](SysWin-Colors) for the `RGB_*` colour constants
- [sys/win/gui](SysWin-Gui)
