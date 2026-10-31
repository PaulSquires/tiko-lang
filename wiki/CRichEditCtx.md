[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/richedit](SysWin-RichEdit) › **CRichEditCtx**

# CRichEditCtx
Creates a rich edit control in a CWindow and reads and sets its options and formatting.

<!-- scope: CRichEditCtx -->

Creates a rich edit control in a CWindow and reads and sets its options and formatting.

A `CRichEditCtx` object owns one rich edit control (window class `RichEdit50W`, from
`MSFTEDIT.DLL`, which `CWindow` loads the first time it is needed). The constructor adds the
control to a [CWindow](CWindow), subclasses it and stores a pointer to the object in the
subclass, so any message handler can get back to the object from the control's handle with
[CRichEditCtxPtr](#cricheditctxptr). Most members are thin wrappers over one rich edit message
(`EM_*`), sent with `SendMessageW`.

This page covers construction and the control's settings: options, styles, character and
paragraph formats, the text limit, the modification flag and the plain text. The selection,
inserting text, searching, undo, margins, streaming and printing are on
[CRichEditCtx: editing](CRichEditCtx-Editing); the font, files, RTF and the Text Object Model
document are on [CRichEditCtx: document](CRichEditCtx-Document).

**Lifetime.** The object must outlive the control's use: the subclass keeps a pointer to it.
Declare it in `main` after the `CWindow` (so it is destroyed first), or allocate it with `new`
and `delete` it. The destructor **destroys the control** and releases the `ITextDocument2`
interface the constructor obtained.

**Keyboard.** The subclass asks for every key (`DLGC_WANTALLKEYS`). **Esc** is swallowed (a multiline
rich edit would otherwise close its parent). **Tab** inserts a tab unless
[AcceptTab](#accepttab) is `false`, in which case Tab and Shift+Tab move the focus to the next
and previous control that has `WS_TABSTOP`.

**Results.** `CRichEditCtx` extends `CTextObjectBase`: after most calls `GetLastResult()`
returns the value the control sent back (or 0 for a plain query), and `GetErrorInfo()` turns a
result code into text.

The snippets on this page assume `hCtrl` is a rich edit control made by `CRichEditCtx`.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/richedit"
using win, gui, richedit
```

## Example

A rich edit box that fills the window, with a button that turns bold on and off for the
selection. The caption gets a `*` once the text has been changed.

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/richedit"
using win, gui, richedit

const IDC_RICHEDIT = 101
const IDC_BOLD     = 102

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "RichEditDemo"
    dim hWin as HWND = pWindow.Create( NULL, "CRichEditCtx", @WndProc )
    pWindow.SetClientSize( 500, 300 )
    pWindow.Center()
    dim pRichEdit as CRichEditCtx = CRichEditCtx( @pWindow, IDC_RICHEDIT, "", 10, 10, 480, 240, -1, WS_EX_CLIENTEDGE )
    pRichEdit.SetText( "Select some text and press Bold. Links such as https://example.com are detected." )
    pRichEdit.AcceptTab = false
    pRichEdit.SetAutoUrlDetect( AURL_ENABLEURL )
    pRichEdit.EnableAdvancedTypography()
    pRichEdit.SetEventMask( ENM_CHANGE )
    pRichEdit.SetModify( 0 )
    pWindow.AddControl( "Button", hWin, IDC_BOLD, "&Bold", 390, 262, 100, 28 )
    pWindow.AnchorControl( IDC_RICHEDIT, ANCHOR_HEIGHT_WIDTH )
    pWindow.AnchorControl( IDC_BOLD, ANCHOR_BOTTOM_RIGHT )
    SetFocus( pRichEdit.hRichEdit )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_COMMAND
            dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hwnd, IDC_RICHEDIT )
            if pRichEdit = NULL then return 0
            select case CBCTL( wParam, lParam )
                case IDC_BOLD
                    if CBCTLMSG( wParam, lParam ) = BN_CLICKED then
                        dim cf as CHARFORMATW
                        cf.dwMask = CFM_BOLD
                        if ( pRichEdit->GetSelectionCharFormat().dwEffects and CFE_BOLD ) = 0 then cf.dwEffects = CFE_BOLD
                        pRichEdit->SetSelectionCharFormat( cf )
                        SetFocus( pRichEdit->hRichEdit )
                    end if
                case IDC_RICHEDIT
                    if CBCTLMSG( wParam, lParam ) = EN_CHANGE andalso pRichEdit->IsModified() then
                        SetWindowText( hwnd, "CRichEditCtx *" )
                    end if
            end select
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

**Creating and finding the object**

| Member | Does |
| --- | --- |
| [Constructor](#constructor) | Adds a rich edit control to a `CWindow` and subclasses it. |
| [Destructor](#destructor) | Releases the document interface and destroys the control. |
| [hRichEdit](#hrichedit) | The control's handle. |
| [CRichEditCtxProc](#cricheditctxproc) | The subclass procedure that handles Tab, Esc and the object lookup. |
| [CRichEditCtxPtr](#cricheditctxptr) | Returns the object of a control, from its handle or its parent and id. |

**Behaviour and options**

| Member | Does |
| --- | --- |
| [ScalingRatio, GetScalingRatio, SetScalingRatio](#scalingratio-getscalingratio-setscalingratio) | The DPI ratio used to size inserted images. |
| [AcceptTab](#accepttab) | Whether Tab inserts a tab or moves the focus. |
| [SetWysiwygPrint](#setwysiwygprint) | Lays the text out for a printer's page width. |
| [RestoreTargetDevice](#restoretargetdevice) | Lays the text out for the screen again. |
| [AutoCorrectProc, GetAutoCorrectProc, SetAutoCorrectProc](#autocorrectproc-getautocorrectproc-setautocorrectproc) | The autocorrect callback. |
| [AutoUrlDetect, GetAutoUrlDetect, SetAutoUrlDetect](#autourldetect-getautourldetect-setautourldetect) | Automatic detection of URLs and other links. |
| [DisableAutoUrlDetect](#disableautourldetect) | Turns link detection off. |
| [EnableAutoUrlDetect](#enableautourldetect) | Turns link detection on. |
| [EditStyle, GetEditStyle, SetEditStyle](#editstyle-geteditstyle-seteditstyle) | The `SES_*` edit style flags. |
| [EditStyleEx, GetEditStyleEx, SetEditStyleEx](#editstyleex-geteditstyleex-seteditstyleex) | The `SES_EX_*` extended edit style flags. |
| [EllipsisMode, GetEllipsisMode, SetEllipsisMode](#ellipsismode-getellipsismode-setellipsismode) | Whether text that does not fit ends in an ellipsis. |
| [EllipsisState, GetEllipsisState](#ellipsisstate-getellipsisstate) | Whether an ellipsis is showing. |
| [EventMask, GetEventMask, SetEventMask](#eventmask-geteventmask-seteventmask) | Which notifications the control sends its parent. |
| [Options, GetOptions, SetOptions](#options-getoptions-setoptions) | The `ECO_*` options. |
| [PasswordChar, GetPasswordChar, SetPasswordChar](#passwordchar-getpasswordchar-setpasswordchar) | The character shown in place of each typed one. |
| [TextMode, GetTextMode, SetTextMode](#textmode-gettextmode-settextmode) | Rich or plain text, and the undo level. |
| [TouchOptions, GetTouchOptions, SetTouchOptions](#touchoptions-gettouchoptions-settouchoptions) | The touch selection handles. |
| [TypographyOptions, GetTypographyOptions, SetTypographyOptions](#typographyoptions-gettypographyoptions-settypographyoptions) | Advanced typography and line breaking. |
| [EnableAdvancedTypography](#enableadvancedtypography) | Turns advanced typography on. |

**Formatting**

| Member | Does |
| --- | --- |
| [BidiOptions, GetBidiOptions, SetBidiOptions](#bidioptions-getbidioptions-setbidioptions) | Bidirectional text options. |
| [CharFormat, GetCharFormat, SetCharFormat](#charformat-getcharformat-setcharformat) | Character formatting of the selection, a word, all text or the default. |
| [DefaultCharFormat, GetDefaultCharFormat, SetDefaultCharFormat](#defaultcharformat-getdefaultcharformat-setdefaultcharformat) | The default character formatting. |
| [GetSelectionCharFormat, SetSelectionCharFormat](#getselectioncharformat-setselectioncharformat) | The character formatting of the selection. |
| [WordCharFormat, GetWordCharFormat, SetWordCharFormat](#wordcharformat-getwordcharformat-setwordcharformat) | The character formatting of the selection, by whole words. |
| [ParaFormat, GetParaFormat, SetParaFormat](#paraformat-getparaformat-setparaformat) | The paragraph formatting of the selection. |
| [HyphenateInfo, GetHyphenateInfo, SetHyphenateInfo](#hyphenateinfo-gethyphenateinfo-sethyphenateinfo) | How the control hyphenates. |
| [PageRotate, GetPageRotate, SetPageRotate](#pagerotate-getpagerotate-setpagerotate) | The text layout direction (deprecated by Windows). |
| [Punctuation, GetPunctuation, SetPunctuation](#punctuation-getpunctuation-setpunctuation) | The punctuation characters for Asian line breaking. |

**Input methods**

| Member | Does |
| --- | --- |
| [CTFModeBias, GetCTFModeBias, SetCTFModeBias](#ctfmodebias-getctfmodebias-setctfmodebias) | The Text Services Framework mode bias. |
| [CTFOpenStatus, GetCTFOpenStatus, SetCTFOpenStatus](#ctfopenstatus-getctfopenstatus-setctfopenstatus) | Whether the TSF keyboard is open. |
| [IMEModeBias, GetIMEModeBias, SetIMEModeBias](#imemodebias-getimemodebias-setimemodebias) | The IME mode bias. |
| [IMEOptions, GetIMEOptions, SetIMEOptions](#imeoptions-getimeoptions-setimeoptions) | The IME options. |
| [LangOptions, GetLangOptions, SetLangOptions](#langoptions-getlangoptions-setlangoptions) | IME and Asian-language options. |

**Text, limits and layout**

| Member | Does |
| --- | --- |
| [Text, GetText, SetText](#text-gettext-settext) | The whole text, as plain text. |
| [TextLength, GetTextLength](#textlength-gettextlength) | The length of the text. |
| [LimitText, GetLimitText, SetLimitText](#limittext-getlimittext-setlimittext) | The most characters the user can enter. |
| [Modify, GetModify, SetModify](#modify-getmodify-setmodify) | The modification flag. |
| [IsModified](#ismodified) | Whether the text has been changed. |
| [Rect, GetRect, SetRect](#rect-getrect-setrect) | The formatting rectangle. |
| [RectNP, SetRectNP](#rectnp-setrectnp) | Sets the formatting rectangle without redrawing. |
| [ScrollPos, GetScrollPos, SetScrollPos](#scrollpos-getscrollpos-setscrollpos) | The scroll position. |
| [StoryType, GetStoryType, SetStoryType](#storytype-getstorytype-setstorytype) | The type of a story. |
| [RedoName, GetRedoName](#redoname-getredoname) | The kind of the next redo action. |
| [UndoName, GetUndoName](#undoname-getundoname) | The kind of the next undo action. |

**Properties that take two values.** `EditStyle`, `EditStyleEx`, `IMEOptions`, `Options`,
`Rect` and `TypographyOptions` are set with the first value in brackets and the second after
`=`: `pRichEdit.TypographyOptions( TO_ADVANCEDTYPOGRAPHY ) = TO_ADVANCEDTYPOGRAPHY`. That form
compiles on a `CRichEditCtx` variable, not through a pointer or a `byref` parameter; there, call
the `Set` function, as the snippets below do.

## Reference

### Constructor

```freebasic
constructor( byval pWindow as CWindow ptr, byval cID as LONG_PTR, byref wszTitle as wstring = "", byval x as long = 0, byval y as long = 0, byval nWidth as long = 0, byval nHeight as long = 0, byval dwStyle as long = -1, byval dwExStyle as long = -1, byval lpParam as LONG_PTR = 0 )
```

Adds a rich edit control to the window of `pWindow` with `pWindow->AddControl( "RICHEDIT", … )`,
subclasses it with [CRichEditCtxProc](#cricheditctxproc), turns on zooming with Ctrl+mouse wheel
(`ES_EX_ZOOMABLE`) and obtains the control's `ITextDocument2` interface, which the document
members use. The object's [ScalingRatio](#scalingratio-getscalingratio-setscalingratio) starts as
the window's horizontal ratio.

Position and size are in 96-DPI units: `CWindow` multiplies them by its scaling ratio. With
`pWindow` `NULL`, or when the control cannot be created, the object has no control and
[hRichEdit](#hrichedit) is `NULL`.

| Parameter | Meaning |
| --- | --- |
| `pWindow` | The `CWindow` the control goes on; its window is the parent. |
| `cID` | The control's identifier, unique among the window's controls. It is also the subclass id. |
| `wszTitle` | The initial text. |
| `x`, `y` | The top-left corner in the parent's client area. |
| `nWidth`, `nHeight` | The size. |
| `dwStyle` | Window styles. -1 (the default) gives `WS_VISIBLE or WS_TABSTOP or ES_LEFT or WS_HSCROLL or WS_VSCROLL or ES_AUTOHSCROLL or ES_AUTOVSCROLL or ES_MULTILINE or ES_WANTRETURN or ES_NOHIDESEL or ES_SAVESEL`. `WS_CHILD` is always added. |
| `dwExStyle` | Extended window styles. -1 (the default) gives none, so the control has no border; pass `WS_EX_CLIENTEDGE` for the sunken edge. |
| `lpParam` | A value passed to `CreateWindowExW` as its creation data. |

**Example**

```freebasic
dim pWindow as CWindow ptr = CWindowPtr( hwnd )
dim pEditor as CRichEditCtx ptr = new CRichEditCtx( pWindow, 1001, "", 10, 10, 400, 200, -1, WS_EX_CLIENTEDGE )
' ... later, when the window closes:
delete pEditor
```

Microsoft Learn: [About Rich Edit Controls](https://learn.microsoft.com/en-us/windows/win32/controls/about-rich-edit-controls)

### Destructor

```freebasic
destructor
```

Releases the `ITextDocument2` interface and destroys the control with `DestroyWindow`, which also
removes the subclass. When the control is already gone, because its parent window was destroyed
first, `DestroyWindow` simply fails.

**Example**

```freebasic
dim pEditor as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )   ' an object made with new
delete pEditor   ' the control is gone afterwards
```

### hRichEdit

```freebasic
function hRichEdit() as HWND
```

Returns the control's window handle, for Win32 calls and messages the class does not wrap.

**Returns** the handle, or `NULL` when the constructor made no control.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
SetFocus( pRichEdit->hRichEdit )
```

### CRichEditCtxProc

```freebasic
static function CRichEditCtxProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM, byval uIdSubclass as UINT_PTR, byval dwRefData as DWORD_PTR ) as LRESULT
```

The subclass procedure the constructor installs; `dwRefData` is the object. You do not call it.
It handles four messages and passes everything else on:

| Message | What it does |
| --- | --- |
| `WM_GETDLGCODE` | Returns `DLGC_WANTALLKEYS`, except for Tab when `AcceptTab` is `false` (then 0). |
| `WM_KEYDOWN` | Swallows Esc; when `AcceptTab` is `false`, moves the focus on Tab and Shift+Tab. |
| `WM_DESTROY` | Removes the subclass. |
| `WM_USER + 100` | Returns the object pointer, for [CRichEditCtxPtr](#cricheditctxptr). |

`WM_USER + 100` has the value of `EM_SETPUNCTUATION`, so that message never reaches the control
(see [Punctuation](#punctuation-getpunctuation-setpunctuation)).

**Returns** the result of the message.

**Example**

```freebasic
dim dwRef as DWORD_PTR
if GetWindowSubclass( hCtrl, cast( SUBCLASSPROC, @CRichEditCtx.CRichEditCtxProc ), GetDlgCtrlID( hCtrl ), @dwRef ) then
    print "subclassed by CRichEditCtx"
end if
```

Microsoft Learn: [SetWindowSubclass](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-setwindowsubclass)

### CRichEditCtxPtr

```freebasic
function CRichEditCtxPtr overload( byval hRichEdit as HWND ) as CRichEditCtx ptr
function CRichEditCtxPtr overload( byval hParent as HWND, byval cID as long ) as CRichEditCtx ptr
```

Returns the `CRichEditCtx` object of a control, from the control's handle or from its parent
window and identifier. It works by sending the control `WM_USER + 100`, which the subclass
answers with the object pointer.

| Parameter | Meaning |
| --- | --- |
| `hRichEdit` | The rich edit control. |
| `hParent` | The control's parent window. |
| `cID` | The control's identifier. |

**Returns** the object pointer. A control that was not made by `CRichEditCtx` gets the message as
`EM_SETPUNCTUATION` and returns no object, so only pass controls you know are `CRichEditCtx`
controls.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hwnd, 1001 )
if pRichEdit then print "chars:"; pRichEdit->TextLength()
```

### ScalingRatio, GetScalingRatio, SetScalingRatio

```freebasic
property ScalingRatio( byval ratio as single )
property ScalingRatio() as single
function GetScalingRatio() as single
sub SetScalingRatio( byval ratio as single )
```

The ratio `InsertImage` and `InsertObject` multiply image sizes by, so that an image comes out
the same physical size on every display. It starts as the parent `CWindow`'s horizontal ratio
(1 in a process that is not DPI aware). Setting 1 turns the scaling off; setting 0 sets 1.

**Returns** the ratio (getters).

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
print "ratio:"; pRichEdit->ScalingRatio
pRichEdit->SetScalingRatio( 1 )   ' insert images at their pixel size
```

### AcceptTab

```freebasic
property AcceptTab() as boolean
property AcceptTab( byval bAccept as boolean )
```

`true` (the default): the Tab key types a tab character. `false`: Tab moves the focus to the next
control with `WS_TABSTOP` and Shift+Tab to the previous one, as in a dialog. The value is held by
the object and read by the subclass on each key press.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->AcceptTab = false
```

### SetWysiwygPrint

```freebasic
function SetWysiwygPrint( byref wszPrinterName as wstring = "" ) as boolean
```

Makes the control lay its text out as it will print ("what you see is what you get"): it creates
a device context for the printer and sends it with the printer's printable width, in twips, as
the target device. Lines then break where they will break on paper.

With no name, the default printer is used. The name must be that of an installed printer: an
unknown name gives no device context and the program stops with an integer division fault. The
printer device context is not deleted, neither here nor by
[RestoreTargetDevice](#restoretargetdevice).

| Parameter | Meaning |
| --- | --- |
| `wszPrinterName` | The printer, for example `"Microsoft Print to PDF"`; empty for the default printer. |

**Returns** `true` on success, `false` on failure (and `GetLastResult()` is `E_FAIL`).

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
if pRichEdit->SetWysiwygPrint( "Microsoft Print to PDF" ) then print "laid out for the printer"
```

Microsoft Learn: [EM_SETTARGETDEVICE](https://learn.microsoft.com/en-us/windows/win32/controls/em-settargetdevice)

### RestoreTargetDevice

```freebasic
function RestoreTargetDevice() as boolean
```

Makes the screen the target device again, with a line width of 0, so lines wrap at the edge of
the control. It gets the control's device context with `GetDC` and does not release it.

**Returns** `true` on success.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->RestoreTargetDevice()
```

Microsoft Learn: [EM_SETTARGETDEVICE](https://learn.microsoft.com/en-us/windows/win32/controls/em-settargetdevice)

### AutoCorrectProc, GetAutoCorrectProc, SetAutoCorrectProc

```freebasic
property AutoCorrectProc() as LONG_PTR
property AutoCorrectProc( byval pfn as LONG_PTR )
function GetAutoCorrectProc() as LONG_PTR
function SetAutoCorrectProc( byval pfn as LONG_PTR ) as HRESULT
```

Reads or sets the application's autocorrect callback, which the control calls (through
`CallAutocorrectProc`) to replace the word before the insertion point. The callback has the
`AUTOCORRECTPROC` signature; pass its address cast to `LONG_PTR`, or 0 to remove it.

**Returns** the callback's address (getters, 0 when there is none); `SetAutoCorrectProc` returns
0 on success, a nonzero value on failure.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
if pRichEdit->GetAutoCorrectProc() = 0 then print "no autocorrect callback"
```

Microsoft Learn: [EM_SETAUTOCORRECTPROC](https://learn.microsoft.com/en-us/windows/win32/controls/em-setautocorrectproc), [AutoCorrectProc](https://learn.microsoft.com/en-us/windows/win32/api/richedit/nc-richedit-autocorrectproc)

### AutoUrlDetect, GetAutoUrlDetect, SetAutoUrlDetect

```freebasic
property AutoUrlDetect() as boolean
property AutoUrlDetect( byval fUrlDetect as long )
function GetAutoUrlDetect() as boolean
function SetAutoUrlDetect( byval fUrlDetect as long ) as HRESULT
```

Reads whether automatic link detection is on, or turns it on or off. When it is on, the control
marks text that looks like a URL (and, with the newer flags, e-mail addresses, telephone numbers
or file paths) with the `CFE_LINK` effect, and sends `EN_LINK` to the parent when the mouse acts
on it, if `ENM_LINK` is in the [event mask](#eventmask-geteventmask-seteventmask).

| Parameter | Meaning |
| --- | --- |
| `fUrlDetect` | 0 to turn detection off, or `AURL_ENABLEURL` combined with other `AURL_*` flags such as `AURL_ENABLEEMAILADDR`, `AURL_ENABLETELNO`, `AURL_ENABLEDRIVELETTERS`. |

**Returns** `true` when detection is on (getters); `SetAutoUrlDetect` returns 0 on success, a
nonzero value on failure.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->SetAutoUrlDetect( AURL_ENABLEURL or AURL_ENABLEEMAILADDR )
print "detecting links: "; pRichEdit->AutoUrlDetect
```

Microsoft Learn: [EM_AUTOURLDETECT](https://learn.microsoft.com/en-us/windows/win32/controls/em-autourldetect), [EM_GETAUTOURLDETECT](https://learn.microsoft.com/en-us/windows/win32/controls/em-getautourldetect)

### DisableAutoUrlDetect

```freebasic
function DisableAutoUrlDetect() as boolean
```

Turns automatic link detection off.

**Returns** `true` on success.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->DisableAutoUrlDetect()
```

Microsoft Learn: [EM_AUTOURLDETECT](https://learn.microsoft.com/en-us/windows/win32/controls/em-autourldetect)

### EnableAutoUrlDetect

```freebasic
function EnableAutoUrlDetect( byval fUrlDetect as long ) as HRESULT
```

Turns automatic link detection on with the `AURL_*` flags given; the same as
[SetAutoUrlDetect](#autourldetect-getautourldetect-setautourldetect).

**Returns** 0 on success, a nonzero value on failure.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
if pRichEdit->EnableAutoUrlDetect( AURL_ENABLEURL ) = 0 then print "links on"
```

Microsoft Learn: [EM_AUTOURLDETECT](https://learn.microsoft.com/en-us/windows/win32/controls/em-autourldetect)

### BidiOptions, GetBidiOptions, SetBidiOptions

```freebasic
property BidiOptions() as .BIDIOPTIONS
property BidiOptions( byref opt as .BIDIOPTIONS )
function GetBidiOptions() as .BIDIOPTIONS
sub SetBidiOptions( byref opt as .BIDIOPTIONS )
```

Reads or sets the bidirectional options (`BOE_*` effects selected by a `BOM_*` mask) used for
right-to-left text. The getters fill in `cbSize` themselves; the setters fill it in when it is
0, so `opt` may be changed.

**Returns** a `BIDIOPTIONS` with `cbSize`, `wMask` and `wEffects` (getters).

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
dim bo as BIDIOPTIONS = pRichEdit->GetBidiOptions()
bo.wMask = BOM_CONTEXTREADING : bo.wEffects = BOE_CONTEXTREADING
pRichEdit->SetBidiOptions( bo )
```

Microsoft Learn: [EM_SETBIDIOPTIONS](https://learn.microsoft.com/en-us/windows/win32/controls/em-setbidioptions)

### CharFormat, GetCharFormat, SetCharFormat

```freebasic
property CharFormat( byval fOption as DWORD ) as CHARFORMATW
property CharFormat( byval chfmt as DWORD, byref cf as CHARFORMATW )
function GetCharFormat( byval fOption as DWORD ) as CHARFORMATW
function SetCharFormat( byval chfmt as DWORD, byref cf as CHARFORMATW ) as boolean
```

Reads or sets character formatting: font, size, colour and effects such as bold. `dwMask` says
which members of the `CHARFORMATW` count; `dwEffects` holds the `CFE_*` effects for the `CFM_*`
bits of the mask. Only the members named in the mask change. `cbSize` is filled in when it is 0.

| Parameter | Meaning |
| --- | --- |
| `fOption` | `SCF_DEFAULT` for the default format, `SCF_SELECTION` for the selection. |
| `chfmt` | Where to apply it: `SCF_SELECTION`, `SCF_WORD or SCF_SELECTION`, `SCF_ALL` or `SCF_DEFAULT`. |
| `cf` | The format to apply. |

**Returns** the format read (getters); `SetCharFormat` returns `true` on success. After the
property setter `GetLastResult()` is `E_FAIL` when it failed.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
dim cf as CHARFORMATW
cf.dwMask = CFM_COLOR : cf.crTextColor = RGB_RED
pRichEdit->SetCharFormat( SCF_ALL, cf )   ' all the text in red
```

Microsoft Learn: [EM_SETCHARFORMAT](https://learn.microsoft.com/en-us/windows/win32/controls/em-setcharformat), [EM_GETCHARFORMAT](https://learn.microsoft.com/en-us/windows/win32/controls/em-getcharformat)

### DefaultCharFormat, GetDefaultCharFormat, SetDefaultCharFormat

```freebasic
property DefaultCharFormat() as CHARFORMATW
property DefaultCharFormat( byref cf as CHARFORMATW )
function GetDefaultCharFormat() as CHARFORMATW
function SetDefaultCharFormat( byref cf as CHARFORMATW ) as boolean
```

Reads or sets the default character format: the format of new text typed where there is no
other formatting. The same as [CharFormat](#charformat-getcharformat-setcharformat) with
`SCF_DEFAULT`.

**Returns** the default format (getters); `SetDefaultCharFormat` returns `true` on success.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
dim cf as CHARFORMATW = pRichEdit->GetDefaultCharFormat()
print "default height in twips:"; cf.yHeight
```

Microsoft Learn: [EM_SETCHARFORMAT](https://learn.microsoft.com/en-us/windows/win32/controls/em-setcharformat)

### GetSelectionCharFormat, SetSelectionCharFormat

```freebasic
function GetSelectionCharFormat() as CHARFORMATW
function SetSelectionCharFormat( byref cf as CHARFORMATW ) as boolean
```

Reads or sets the character format of the selection; with no selection, of the insertion point
(what will be typed next). The same as `CharFormat` with `SCF_SELECTION`. When the selection mixes
formats, the read `dwMask` has the bits of the attributes that are the same throughout.

The class also declares a `SelectionCharFormat` property, but it has no body: a program that
uses it fails to link. Use these two functions.

**Returns** the format (`GetSelectionCharFormat`); `true` on success (`SetSelectionCharFormat`).

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
dim cf as CHARFORMATW
cf.dwMask = CFM_ITALIC : cf.dwEffects = CFE_ITALIC
pRichEdit->SetSelectionCharFormat( cf )
```

Microsoft Learn: [EM_SETCHARFORMAT](https://learn.microsoft.com/en-us/windows/win32/controls/em-setcharformat)

### WordCharFormat, GetWordCharFormat, SetWordCharFormat

```freebasic
property WordCharFormat() as CHARFORMATW
property WordCharFormat( byref cf as CHARFORMATW )
function GetWordCharFormat() as CHARFORMATW
function SetWordCharFormat( byref cf as CHARFORMATW ) as boolean
```

Like the selection format, with `SCF_SELECTION or SCF_WORD`: when the selection is empty, a format
that is set applies to the whole word at the insertion point.

**Returns** the format (getters); `SetWordCharFormat` returns `true` on success.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
dim cf as CHARFORMATW
cf.dwMask = CFM_UNDERLINE : cf.dwEffects = CFE_UNDERLINE
pRichEdit->SetWordCharFormat( cf )   ' underline the word at the caret
```

Microsoft Learn: [EM_SETCHARFORMAT](https://learn.microsoft.com/en-us/windows/win32/controls/em-setcharformat)

### CTFModeBias, GetCTFModeBias, SetCTFModeBias

```freebasic
property CTFModeBias() as long
property CTFModeBias( byval nModeBias as long )
function GetCTFModeBias() as long
function SetCTFModeBias( byval nModeBias as long ) as HRESULT
```

Reads or sets the Text Services Framework mode bias, a hint to the input method about the kind
of text expected (`CTFMODEBIAS_DEFAULT`, `CTFMODEBIAS_FILENAME`, `CTFMODEBIAS_NAME`,
`CTFMODEBIAS_NUMERIC` …).

**Returns** the bias (getters); `SetCTFModeBias` returns the new bias on success, the old one on
failure.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->SetCTFModeBias( CTFMODEBIAS_NUMERIC )
```

Microsoft Learn: [EM_SETCTFMODEBIAS](https://learn.microsoft.com/en-us/windows/win32/controls/em-setctfmodebias)

### CTFOpenStatus, GetCTFOpenStatus, SetCTFOpenStatus

```freebasic
property CTFOpenStatus() as boolean
property CTFOpenStatus( byval fTSFkbd as long )
function GetCTFOpenStatus() as boolean
function SetCTFOpenStatus( byval fTSFkbd as long ) as boolean
```

Reads whether the Text Services Framework keyboard is open, or opens (`true`) or closes
(`false`) it.

**Returns** `true` when it is open (getters); `SetCTFOpenStatus` returns `true` on success.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
if pRichEdit->GetCTFOpenStatus() then pRichEdit->SetCTFOpenStatus( false )
```

Microsoft Learn: [EM_SETCTFOPENSTATUS](https://learn.microsoft.com/en-us/windows/win32/controls/em-setctfopenstatus)

### EditStyle, GetEditStyle, SetEditStyle

```freebasic
property EditStyle() as DWORD
property EditStyle( byval fStyle as long, byval fMask as long )
function GetEditStyle() as DWORD
function SetEditStyle( byval fStyle as long, byval fMask as long ) as HRESULT
```

Reads or sets the `SES_*` edit style flags, such as `SES_EMULATESYSEDIT` (behave like a plain edit
control), `SES_UPPERCASE`, `SES_LOWERCASE`, `SES_BEEPONMAXTEXT` and `SES_HYPERLINKTOOLTIPS`. Only
the flags in `fMask` change: each takes its value from `fStyle`.

| Parameter | Meaning |
| --- | --- |
| `fStyle` | The new values of the flags. |
| `fMask` | The flags to change. |

**Returns** the flags (getters); `SetEditStyle` returns the flags as they are after the change,
not an `HRESULT`.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->SetEditStyle( SES_UPPERCASE, SES_UPPERCASE )   ' typing comes out in capitals
```

Microsoft Learn: [EM_SETEDITSTYLE](https://learn.microsoft.com/en-us/windows/win32/controls/em-seteditstyle)

### EditStyleEx, GetEditStyleEx, SetEditStyleEx

```freebasic
property EditStyleEx() as DWORD
property EditStyleEx( byval fStyle as long, byval fMask as long )
function GetEditStyleEx() as DWORD
function SetEditStyleEx( byval fStyle as long, byval fMask as long ) as HRESULT
```

Reads or sets the extended edit style flags (`SES_EX_*`), such as `SES_EX_NOACETATESELECTION`
(draw the selection in the classic colours) and `SES_EX_HIDETEMPFORMAT`. `fMask` selects the
flags to change, as for [EditStyle](#editstyle-geteditstyle-seteditstyle).

**Returns** the flags (getters); `SetEditStyleEx` returns what the control returns.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->SetEditStyleEx( SES_EX_NOACETATESELECTION, SES_EX_NOACETATESELECTION )
```

Microsoft Learn: [EM_SETEDITSTYLEEX](https://learn.microsoft.com/en-us/windows/win32/controls/em-seteditstyleex)

### EllipsisMode, GetEllipsisMode, SetEllipsisMode

```freebasic
property EllipsisMode() as DWORD
property EllipsisMode( byval fMode as DWORD )
function GetEllipsisMode() as DWORD
function SetEllipsisMode( byval fMode as DWORD ) as boolean
```

Reads or sets how text that does not fit is cut short: `ELLIPSIS_NONE`, `ELLIPSIS_END` (at the
last character that fits) or `ELLIPSIS_WORD` (at the last whole word).

**Returns** the mode (getters); `SetEllipsisMode` returns `true` on success.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->SetEllipsisMode( ELLIPSIS_WORD )
```

Microsoft Learn: [EM_SETELLIPSISMODE](https://learn.microsoft.com/en-us/windows/win32/controls/em-setellipsismode)

### EllipsisState, GetEllipsisState

```freebasic
property EllipsisState() as boolean
function GetEllipsisState() as boolean
```

Tells whether the control is showing an ellipsis now.

**Returns** `true` when an ellipsis is shown.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
if pRichEdit->EllipsisState then print "the text is cut short"
```

Microsoft Learn: [EM_GETELLIPSISSTATE](https://learn.microsoft.com/en-us/windows/win32/controls/em-getellipsisstate)

### EventMask, GetEventMask, SetEventMask

```freebasic
property EventMask() as DWORD
property EventMask( byval fMask as DWORD )
function GetEventMask() as DWORD
function SetEventMask( byval fMask as DWORD ) as HRESULT
```

Reads or sets which notifications the control sends its parent. A new control's mask is 0, so it
sends none of the optional ones: `EN_CHANGE` needs `ENM_CHANGE`, `EN_SELCHANGE` needs `ENM_SELCHANGE`, `EN_LINK` needs `ENM_LINK`,
and so on. The mask replaces the old one; combine the old value to add to it.

**Returns** the mask (getters); `SetEventMask` returns the previous mask.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->SetEventMask( pRichEdit->GetEventMask() or ENM_CHANGE or ENM_SELCHANGE )
```

Microsoft Learn: [EM_SETEVENTMASK](https://learn.microsoft.com/en-us/windows/win32/controls/em-seteventmask)

### HyphenateInfo, GetHyphenateInfo, SetHyphenateInfo

```freebasic
property HyphenateInfo() as .HYPHENATEINFO
property HyphenateInfo( byref hinfo as .HYPHENATEINFO )
function GetHyphenateInfo() as .HYPHENATEINFO
function SetHyphenateInfo( byref info as .HYPHENATEINFO ) as HRESULT
```

Reads or sets how the control hyphenates: the hyphenation zone and the callback that decides
where a word breaks. `cbSize` is filled in when it is 0.

**Returns** a `HYPHENATEINFO` (getters); `SetHyphenateInfo` returns what the control returns
(nothing meaningful).

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
dim hi as HYPHENATEINFO = pRichEdit->GetHyphenateInfo()
print "hyphenation zone:"; hi.dxHyphenateZone
```

Microsoft Learn: [EM_SETHYPHENATEINFO](https://learn.microsoft.com/en-us/windows/win32/controls/em-sethyphenateinfo)

### IMEModeBias, GetIMEModeBias, SetIMEModeBias

```freebasic
property IMEModeBias() as DWORD
property IMEModeBias( byval nModeBias as long )
function GetIMEModeBias() as DWORD
function SetIMEModeBias( byval nModeBias as long ) as HRESULT
```

Reads or sets the Input Method Editor mode bias: `IMF_SMODE_NONE` or `IMF_SMODE_PLAURALCLAUSE`.
The setter passes the value as both the bias and its mask.

**Returns** the bias (getters); `SetIMEModeBias` returns the new bias.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->SetIMEModeBias( IMF_SMODE_NONE )
```

Microsoft Learn: [EM_SETIMEMODEBIAS](https://learn.microsoft.com/en-us/windows/win32/controls/em-setimemodebias)

### IMEOptions, GetIMEOptions, SetIMEOptions

```freebasic
property IMEOptions() as DWORD
property IMEOptions( byval fCoop as long, byval fOptions as long )
function GetIMEOptions() as DWORD
function SetIMEOptions( byval fCoop as long, byval fOptions as long ) as HRESULT
```

Reads or changes the IME options (`IMF_CLOSESTATUSWINDOW`, `IMF_FORCEACTIVE`, `IMF_VERTICAL` …).
These options apply on East Asian versions of Windows.

| Parameter | Meaning |
| --- | --- |
| `fCoop` | How to combine: `ECOOP_SET`, `ECOOP_OR`, `ECOOP_AND` or `ECOOP_XOR`. |
| `fOptions` | The `IMF_*` options. |

**Returns** the options (getters). `SetIMEOptions` returns -1 (`true`) on success and 0 on
failure, despite its `HRESULT` type.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->SetIMEOptions( ECOOP_OR, IMF_CLOSESTATUSWINDOW )
```

Microsoft Learn: [EM_SETIMEOPTIONS](https://learn.microsoft.com/en-us/windows/win32/controls/em-setimeoptions)

### LangOptions, GetLangOptions, SetLangOptions

```freebasic
property LangOptions() as DWORD
property LangOptions( byval lgoptions as long )
function GetLangOptions() as DWORD
function SetLangOptions( byval lgoptions as long ) as HRESULT
```

Reads or replaces the language options: `IMF_AUTOFONT` (switch fonts for other scripts),
`IMF_AUTOKEYBOARD`, `IMF_DUALFONT`, `IMF_UIFONTS` and the other `IMF_*` flags of this message.
The value replaces all the flags.

**Returns** the options (getters); `SetLangOptions` returns what the control returns (1).

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->SetLangOptions( pRichEdit->GetLangOptions() and not IMF_AUTOFONT )
```

Microsoft Learn: [EM_SETLANGOPTIONS](https://learn.microsoft.com/en-us/windows/win32/controls/em-setlangoptions)

### LimitText, GetLimitText, SetLimitText

```freebasic
property LimitText() as long
property LimitText( byval chMax as DWORD )
function GetLimitText() as long
sub SetLimitText( byval chMax as DWORD )
```

Reads or sets the most characters the user can type or paste. A new control's limit is 32,767;
setting 0 sets 65,536. `ExLimitText` on [CRichEditCtx: editing](CRichEditCtx-Editing) sets a
limit above 64 K.

**Returns** the limit (getters).

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->SetLimitText( 500 )
print "limit:"; pRichEdit->GetLimitText()   ' 500
```

Microsoft Learn: [EM_LIMITTEXT](https://learn.microsoft.com/en-us/windows/win32/controls/em-limittext), [EM_GETLIMITTEXT](https://learn.microsoft.com/en-us/windows/win32/controls/em-getlimittext)

### Modify, GetModify, SetModify

```freebasic
property Modify() as long
property Modify( byval fModify as long )
function GetModify() as long
sub SetModify( byval fModify as long )
```

Reads, sets or clears the modification flag. The control sets it whenever its text changes;
clear it after loading or saving, and read it to ask whether to save.

**Returns** nonzero (-1) when the flag is set, 0 when it is clear (getters).

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->SetModify( 0 )   ' just saved
```

Microsoft Learn: [EM_SETMODIFY](https://learn.microsoft.com/en-us/windows/win32/controls/em-setmodify), [EM_GETMODIFY](https://learn.microsoft.com/en-us/windows/win32/controls/em-getmodify)

### IsModified

```freebasic
function IsModified() as boolean
```

Reads the modification flag as a `boolean`.

**Returns** `true` when the text has been changed since the flag was last cleared.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
if pRichEdit->IsModified() then print "unsaved changes"
```

Microsoft Learn: [EM_GETMODIFY](https://learn.microsoft.com/en-us/windows/win32/controls/em-getmodify)

### Options, GetOptions, SetOptions

```freebasic
property Options() as DWORD
property Options( byval fCoop as long, byval fOptions as long )
function GetOptions() as DWORD
function SetOptions( byval fCoop as long, byval fOptions as long ) as DWORD
```

Reads or changes the control's `ECO_*` options: `ECO_AUTOWORDSELECTION`, `ECO_AUTOVSCROLL`,
`ECO_NOHIDESEL`, `ECO_READONLY`, `ECO_SELECTIONBAR` (a margin for selecting whole lines),
`ECO_WANTRETURN` and the others.

| Parameter | Meaning |
| --- | --- |
| `fCoop` | `ECOOP_SET` replaces the options, `ECOOP_OR` adds, `ECOOP_AND` keeps only, `ECOOP_XOR` toggles. |
| `fOptions` | The `ECO_*` options. |

**Returns** the options (getters); `SetOptions` returns the options after the change.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->SetOptions( ECOOP_OR, ECO_SELECTIONBAR )
```

Microsoft Learn: [EM_SETOPTIONS](https://learn.microsoft.com/en-us/windows/win32/controls/em-setoptions)

### PageRotate, GetPageRotate, SetPageRotate

```freebasic
property PageRotate() as DWORD
property PageRotate( byval txtlayout as long )
function GetPageRotate() as DWORD
function SetPageRotate( byval txtlayout as long ) as DWORD
```

Reads or sets the text layout: `EPR_0` (left to right, top to bottom), `EPR_90`, `EPR_180` or
`EPR_270`. Windows marks the underlying messages as deprecated.

**Returns** the layout (getters); `SetPageRotate` returns the new layout.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
print "layout:"; pRichEdit->GetPageRotate()
```

Microsoft Learn: [EM_SETPAGEROTATE](https://learn.microsoft.com/en-us/windows/win32/controls/em-setpagerotate)

### ParaFormat, GetParaFormat, SetParaFormat

```freebasic
property ParaFormat() as .PARAFORMAT
property ParaFormat( byref pfmt as .PARAFORMAT )
function GetParaFormat() as .PARAFORMAT
function SetParaFormat( byref pfmt as .PARAFORMAT ) as boolean
```

Reads or sets the paragraph formatting of the selection, or of the paragraph holding the caret:
alignment, indents, numbering, tab stops. As with character formats, `dwMask` says which members
count, and `cbSize` is filled in when it is 0. The type is `PARAFORMAT`; for the `PARAFORMAT2`
members (spacing, borders, shading) send `EM_SETPARAFORMAT` yourself.

**Returns** the format (getters); `SetParaFormat` returns `true` on success.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
dim pf as PARAFORMAT
pf.dwMask = PFM_ALIGNMENT : pf.wAlignment = PFA_CENTER
pRichEdit->SetParaFormat( pf )
```

Microsoft Learn: [EM_SETPARAFORMAT](https://learn.microsoft.com/en-us/windows/win32/controls/em-setparaformat)

### PasswordChar, GetPasswordChar, SetPasswordChar

```freebasic
property PasswordChar() as long
property PasswordChar( byval dwchar as DWORD )
function GetPasswordChar() as long
sub SetPasswordChar( byval dwchar as DWORD )
```

Reads or sets the character shown in place of each character of the text, for password entry.
0 shows the text itself.

**Returns** the character code, 0 when there is none (getters).

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->SetPasswordChar( asc( "*" ) )
print pRichEdit->GetPasswordChar()   ' 42
```

Microsoft Learn: [EM_SETPASSWORDCHAR](https://learn.microsoft.com/en-us/windows/win32/controls/em-setpasswordchar)

### Punctuation, GetPunctuation, SetPunctuation

```freebasic
property Punctuation( byval punctp as DWORD ) as .PUNCTUATION
property Punctuation( byval ptype as long, byref punct as .PUNCTUATION )
function GetPunctuation( byval punctype as DWORD ) as .PUNCTUATION
function SetPunctuation( byval punctype as long, byref punct as .PUNCTUATION ) as boolean
```

Reads or sets the punctuation characters used for line breaking in Asian text. `punctype` is
`PC_FOLLOWING`, `PC_LEADING`, `PC_OVERFLOW` or `PC_DELIMITER`.

The setters send `EM_SETPUNCTUATION`, which has the same value as the message the subclass uses
to hand out the object pointer: the subclass answers it, the control never sees it, and
`SetPunctuation` returns `true` without changing anything.

**Returns** a `PUNCTUATION` (getters); `true` (`SetPunctuation`).

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
dim pu as PUNCTUATION = pRichEdit->GetPunctuation( PC_LEADING )
print "leading punctuation buffer size:"; pu.iSize
```

Microsoft Learn: [EM_GETPUNCTUATION](https://learn.microsoft.com/en-us/windows/win32/controls/em-getpunctuation), [EM_SETPUNCTUATION](https://learn.microsoft.com/en-us/windows/win32/controls/em-setpunctuation)

### Rect, GetRect, SetRect

```freebasic
property Rect() as .RECT
property Rect( byval fCoord as long, byref rc as .RECT )
function GetRect() as .RECT
sub SetRect( byval fCoord as long, byref rc as .RECT )
```

Reads or sets the formatting rectangle, the area of the client area the text is laid out in, and
redraws the control. Making it smaller than the client area leaves a margin.

| Parameter | Meaning |
| --- | --- |
| `fCoord` | 0: `rc` is in client coordinates. 1: its members are added to the current rectangle's edges. |
| `rc` | The new rectangle, or the offsets. |

**Returns** the rectangle in client coordinates (getters).

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
dim rc as RECT = pRichEdit->GetRect()
rc.left += 8 : rc.top += 8
pRichEdit->SetRect( 0, rc )
```

Microsoft Learn: [EM_SETRECT](https://learn.microsoft.com/en-us/windows/win32/controls/em-setrect), [EM_GETRECT](https://learn.microsoft.com/en-us/windows/win32/controls/em-getrect)

### RectNP, SetRectNP

```freebasic
property RectNP( byval fCoord as long, byref rc as .RECT )
sub SetRectNP( byval fCoord as long, byref rc as .RECT )
```

Sets the formatting rectangle like [SetRect](#rect-getrect-setrect) but does not redraw the
control.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
dim rc as RECT = pRichEdit->GetRect()
rc.right -= 8
pRichEdit->SetRectNP( 0, rc )
```

Microsoft Learn: [EM_SETRECTNP](https://learn.microsoft.com/en-us/windows/win32/controls/em-setrectnp)

### RedoName, GetRedoName

```freebasic
function RedoName() as long
function GetRedoName() as long
```

Tells what kind of action `Redo` would redo next: a `UNDONAMEID` value such as `UID_TYPING`,
`UID_DELETE`, `UID_PASTE` or `UID_DRAGDROP`.

**Returns** the kind, or `UID_UNKNOWN` (0) when the redo queue is empty or the kind is unknown.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
if pRichEdit->GetRedoName() = UID_TYPING then print "Redo typing"
```

Microsoft Learn: [EM_GETREDONAME](https://learn.microsoft.com/en-us/windows/win32/controls/em-getredoname)

### ScrollPos, GetScrollPos, SetScrollPos

```freebasic
property ScrollPos() as .POINT
property ScrollPos( byref pt as .POINT )
function GetScrollPos() as .POINT
function SetScrollPos( byref pt as .POINT ) as HRESULT
```

Reads or sets the scroll position: the point of the document, in pixels, that is at the top-left
corner of the client area.

**Returns** the position (getters); `SetScrollPos` returns 1.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
dim pt as POINT = pRichEdit->GetScrollPos()
pRichEdit->SetText( wstr( "reloaded" ) )
pRichEdit->SetScrollPos( pt )   ' back where the user was
```

Microsoft Learn: [EM_SETSCROLLPOS](https://learn.microsoft.com/en-us/windows/win32/controls/em-setscrollpos), [EM_GETSCROLLPOS](https://learn.microsoft.com/en-us/windows/win32/controls/em-getscrollpos)

### StoryType, GetStoryType, SetStoryType

```freebasic
property StoryType( byval Index as DWORD ) as DWORD
property StoryType( byval Index as long, byval dwType as DWORD )
function GetStoryType( byval Index as DWORD ) as DWORD
function SetStoryType( byval Index as long, byval dwType as DWORD ) as DWORD
```

Reads or sets the type of a story, one of the separate texts a rich edit document can hold (the
main text is story 0). The types are the Text Object Model `tom*Story` constants.

| Parameter | Meaning |
| --- | --- |
| `Index` | The story's index. |
| `dwType` | The new type. |

**Returns** the type (getters); `SetStoryType` returns the new type.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
print "main story type:"; pRichEdit->GetStoryType( 0 )
```

Microsoft Learn: [EM_SETSTORYTYPE](https://learn.microsoft.com/en-us/windows/win32/controls/em-setstorytype)

### Text, GetText, SetText

```freebasic
property Text() as ustring
property Text( byref wszText as wstring )
function GetText() as ustring
function SetText( byref wszText as wstring ) as boolean
```

Reads or replaces the whole text of the control as plain text, without formatting (it uses
`WM_GETTEXT` and `WM_SETTEXT`). Text set this way is not an undoable action. For RTF use the document
members on [CRichEditCtx: document](CRichEditCtx-Document).

Give the `Text =` property a wide string, such as `wstr( "…" )` or a `wstring` variable: a narrow
literal assigned to it does not arrive as text, and a `ustring` does not compile there. `SetText`
takes a literal or a `ustring` as well.

**Returns** the text (getters, `""` for an empty control); `SetText` returns `true` when the text
was set.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->SetText( "abc" )
print pRichEdit->GetText()   ' abc
```

Microsoft Learn: [WM_SETTEXT](https://learn.microsoft.com/en-us/windows/win32/winmsg/wm-settext), [WM_GETTEXT](https://learn.microsoft.com/en-us/windows/win32/winmsg/wm-gettext)

### TextLength, GetTextLength

```freebasic
function TextLength() as long
function GetTextLength() as long
```

Returns the length of the text in characters, with `WM_GETTEXTLENGTH`. `TextLengthEx` on
[CRichEditCtx: editing](CRichEditCtx-Editing) counts in other ways.

**Returns** the length; 3 after `SetText( "abc" )`.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
print "characters:"; pRichEdit->TextLength()
```

Microsoft Learn: [WM_GETTEXTLENGTH](https://learn.microsoft.com/en-us/windows/win32/winmsg/wm-gettextlength)

### TextMode, GetTextMode, SetTextMode

```freebasic
property TextMode() as DWORD
property TextMode( byval pvalues as long )
function GetTextMode() as DWORD
function SetTextMode( byval values as long ) as boolean
```

Reads or sets the text mode: rich text or plain text (`TM_RICHTEXT`, `TM_PLAINTEXT`), single or
multiple undo levels (`TM_SINGLELEVELUNDO`, `TM_MULTILEVELUNDO`) and one or several code pages
(`TM_SINGLECODEPAGE`, `TM_MULTICODEPAGE`). A new control reads `&h2A`: rich text, multilevel
undo, multiple code pages. The mode can only be changed while the control is empty.

**Returns** the mode (getters); `SetTextMode` returns `true` on success and `false` when the
control holds text.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->SetText( "" )
if pRichEdit->SetTextMode( TM_PLAINTEXT or TM_MULTILEVELUNDO ) then print "plain text now"
```

Microsoft Learn: [EM_SETTEXTMODE](https://learn.microsoft.com/en-us/windows/win32/controls/em-settextmode)

### TouchOptions, GetTouchOptions, SetTouchOptions

```freebasic
property TouchOptions( byval opt as long ptr ) as DWORD
property TouchOptions( byval opt as long, byval fEnable as long )
function GetTouchOptions( byval opt as long ptr ) as DWORD
function SetTouchOptions( byval opt as long, byval fEnable as long ) as HRESULT
```

Reads or sets the touch options: `RTO_SHOWHANDLES` (show the selection handles) and
`RTO_DISABLEHANDLES` (never show them). The getters take the option to read as a pointer type:
pass the constant cast to `long ptr`.

**Returns** the option's state (getters); `SetTouchOptions` returns what the control returns.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->SetTouchOptions( RTO_SHOWHANDLES, 1 )
print "handles:"; pRichEdit->GetTouchOptions( cast( long ptr, RTO_SHOWHANDLES ) )
```

Microsoft Learn: [EM_SETTOUCHOPTIONS](https://learn.microsoft.com/en-us/windows/win32/controls/em-settouchoptions)

### TypographyOptions, GetTypographyOptions, SetTypographyOptions

```freebasic
property TypographyOptions() as DWORD
property TypographyOptions( byval pto as long, byval fMask as long )
function GetTypographyOptions() as DWORD
function SetTypographyOptions( byval pto as long, byval fMask as long ) as boolean
```

Reads or sets the typography options: `TO_ADVANCEDTYPOGRAPHY` (OpenType shaping and, with it,
better line breaking and justification) and `TO_SIMPLELINEBREAK`. Only the options in `fMask`
change, each taking its value from `pto`. A new control reads 0.

| Parameter | Meaning |
| --- | --- |
| `pto` | The new values. |
| `fMask` | The options to change. |

**Returns** the options (getters); `SetTypographyOptions` returns `true` on success.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->SetTypographyOptions( TO_ADVANCEDTYPOGRAPHY, TO_ADVANCEDTYPOGRAPHY )
```

Microsoft Learn: [EM_SETTYPOGRAPHYOPTIONS](https://learn.microsoft.com/en-us/windows/win32/controls/em-settypographyoptions)

### EnableAdvancedTypography

```freebasic
function EnableAdvancedTypography() as boolean
```

Turns on `TO_ADVANCEDTYPOGRAPHY` and `TO_SIMPLELINEBREAK` together; afterwards
`GetTypographyOptions()` reads 3.

**Returns** `true` on success.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
pRichEdit->EnableAdvancedTypography()
```

Microsoft Learn: [EM_SETTYPOGRAPHYOPTIONS](https://learn.microsoft.com/en-us/windows/win32/controls/em-settypographyoptions)

### UndoName, GetUndoName

```freebasic
function UndoName() as DWORD
function GetUndoName() as DWORD
```

Tells what kind of action `Undo` would undo next, as a `UNDONAMEID` value: after `ReplaceSel` it
reads `UID_TYPING` (1).

**Returns** the kind, or `UID_UNKNOWN` (0) when the undo queue is empty or the kind is unknown.

**Example**

```freebasic
dim pRichEdit as CRichEditCtx ptr = CRichEditCtxPtr( hCtrl )
if pRichEdit->UndoName() = UID_TYPING then print "Undo typing"
```

Microsoft Learn: [EM_GETUNDONAME](https://learn.microsoft.com/en-us/windows/win32/controls/em-getundoname)

## See also

- [sys/win/richedit](SysWin-RichEdit) for the module and its other pages
- [CRichEditCtx: editing](CRichEditCtx-Editing) for the selection, searching, undo and printing members
- [CRichEditCtx: document](CRichEditCtx-Document) for fonts, files, RTF and the Text Object Model document
- [RichEdit](SysWin-RichEdit-Control) for the same messages as functions on a control handle
- [CRichEditOleCallback](CRichEditOleCallback) for pasting and dropping images and objects
- [CWindow](CWindow) for the window the control lives in
