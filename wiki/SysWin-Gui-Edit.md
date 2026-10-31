[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gui](SysWin-Gui) › **Edit**

# Edit

Reads, changes, selects and formats the text of single-line and multiline edit controls.

An edit control is the box the user types text into. Every function here takes the control's
handle first and is written with the namespace: `Edit.SetCueBannerText( hEdit, "Name" )`. Create
the control with `CWindow.AddControl( "Edit", ... )` for one line of text (left-aligned, scrolling
sideways, with a sunken edge) or `AddControl( "EditMultiline", ... )` for several lines (with a
vertical scroll bar, `Enter` starting a new line and the selection kept when the focus leaves).

Text is counted in characters. A **character index** is the zero-based position of a character
from the start of the text, line breaks included (`CR LF` counts as two). A **line** is a line as
displayed: when a multiline control wraps words, one line of text can take several. A **file
line** is the text between two line breaks, however it is wrapped; the `GetFileLine*` functions
count those.

Most functions send one edit-control message and return what it returns. Text comes back as a
`ustring`. The cue banner, balloon tip, zoom, caret-index, end-of-line, Bing search and file-line
functions need version 6 of the common controls, which a program selects with a manifest or by
calling `EnableVisualStyles()` before it creates the control; without it they do nothing and
return 0. The control owns its text buffer; nothing here needs to be freed.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui
```

## Example

A name box with a cue banner and a 40-character limit, and a notes box with margins. The button
puts the number of lines, the selection and whether the notes were changed in the caption.

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

const IDC_NAME = 101
const IDC_NOTES = 102
const IDC_INFO = 103

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    EnableVisualStyles()
    dim pWindow as CWindow = "EditDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Edit", @WndProc )
    pWindow.SetClientSize( 400, 250 )
    pWindow.Center()
    dim hName as HWND = pWindow.AddControl( "Edit", hWin, IDC_NAME, "", 10, 10, 380, 23 )
    Edit.SetCueBannerText( hName, "Your name" )
    Edit.LimitText( hName, 40 )
    dim hNotes as HWND = pWindow.AddControl( "EditMultiline", hWin, IDC_NOTES, "First line" & chr(13, 10) & "Second line", 10, 42, 380, 158 )
    Edit.SetMarginsForDpi( hNotes, 6, 6 )
    Edit.SetModify( hNotes, false )
    pWindow.AddControl( "Button", hWin, IDC_INFO, "&Info", 290, 210, 100, 30 )
    SetFocus( hName )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_COMMAND
            if CBCTL( wParam, lParam ) = IDC_INFO andalso CBCTLMSG( wParam, lParam ) = BN_CLICKED then
                dim hNotes as HWND = GetDlgItem( hwnd, IDC_NOTES )
                dim sel as POINTL = Edit.GetSel( hNotes )
                SetWindowText( hwnd, Edit.GetLineCount( hNotes ) & " lines, selection " & sel.x & " to " & sel.y & _
                                     iif( Edit.GetModify( hNotes ), ", changed", ", unchanged" ) )
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

## Functions

| Function | Does |
| --- | --- |
| [GetText](#gettext) | Returns the control's text. |
| [GetTextLength](#gettextlength) | Returns the length of the text. |
| [SetText](#settext) | Replaces the control's text. |
| [GetLine](#getline) | Returns one line of the text (short lines only). |
| [GetLineCount](#getlinecount) | Returns the number of lines. |
| [LineIndex](#lineindex) | Returns the character index at which a line starts. |
| [LineFromChar](#linefromchar) | Returns the line that holds a character. |
| [LineLength](#linelength) | Returns the length of the line that holds a character. |
| [GetFileLine](#getfileline) | Returns or reads one file line. |
| [GetFileLineCount](#getfilelinecount) | Returns the number of file lines. |
| [GetFileLineIndex](#getfilelineindex) | Returns the character index at which a file line starts. |
| [GetFileLineFromChar](#getfilelinefromchar) | Returns the file line that holds a character. |
| [GetFileLineLength](#getfilelinelength) | Returns the length of the file line that holds a character. |
| [GetSel](#getsel) | Returns or reads the selection. |
| [GetSelStart](#getselstart) | Returns where the selection starts. |
| [GetSelEnd](#getselend) | Returns where the selection ends. |
| [SetSel](#setsel) | Selects a range of characters. |
| [ReplaceSel](#replacesel) | Replaces the selection with text. |
| [GetCaretIndex](#getcaretindex) | Returns the character index of the caret. |
| [SetCaretIndex](#setcaretindex) | Moves the caret to a character index. |
| [Clear](#clear) | Deletes the selection. |
| [Copy](#copy) | Copies the selection to the clipboard. |
| [Cut](#cut) | Moves the selection to the clipboard. |
| [Paste](#paste) | Inserts the clipboard's text at the caret. |
| [CanUndo](#canundo) | Tells whether there is something to undo. |
| [Undo](#undo) | Undoes the last change. |
| [EmptyUndoBuffer](#emptyundobuffer) | Forgets what could be undone. |
| [GetModify](#getmodify) | Tells whether the text has been changed. |
| [SetModify](#setmodify) | Sets or clears the changed flag. |
| [LimitText, SetLimitText](#limittext-setlimittext) | Sets how much text the control accepts. |
| [GetLimitText](#getlimittext) | Returns how much text the control accepts. |
| [SetReadOnly](#setreadonly) | Makes the control read-only or editable. |
| [GetPasswordChar](#getpasswordchar) | Returns the character shown in place of typed text. |
| [SetPasswordChar](#setpasswordchar) | Sets or removes the character shown in place of typed text. |
| [GetCueBannerText](#getcuebannertext) | Returns or reads the cue banner text. |
| [SetCueBannerText](#setcuebannertext) | Sets the grey hint shown while the control is empty. |
| [ShowBalloonTip](#showballoontip) | Shows a balloon tip pointing at the control. |
| [HideBalloonTip](#hideballoontip) | Hides the balloon tip. |
| [CharFromPos](#charfrompos) | Finds the character nearest a point. |
| [PosFromChar](#posfromchar) | Returns where a character is drawn. |
| [GetFirstVisibleLine](#getfirstvisibleline) | Returns the top visible line. |
| [GetThumb](#getthumb) | Returns the position of the vertical scroll box. |
| [LineScroll](#linescroll) | Scrolls by characters and lines. |
| [Scroll](#scroll) | Scrolls up or down by a line or a page. |
| [ScrollCaret](#scrollcaret) | Scrolls the caret into view. |
| [GetMargins](#getmargins) | Returns both margins. |
| [GetLeftMargin](#getleftmargin) | Returns the left margin. |
| [GetRightMargin](#getrightmargin) | Returns the right margin. |
| [SetMargins](#setmargins) | Sets both margins in pixels. |
| [SetMarginsForDpi](#setmarginsfordpi) | Sets both margins in 96-DPI units. |
| [SetLeftMargin](#setleftmargin) | Sets the left margin in pixels. |
| [SetLeftMarginForDpi](#setleftmarginfordpi) | Sets the left margin in 96-DPI units. |
| [SetRightMargin](#setrightmargin) | Sets the right margin in pixels. |
| [SetRightMarginForDpi](#setrightmarginfordpi) | Sets the right margin in 96-DPI units. |
| [Scale](#scale) | Scales a horizontal length by the desktop's DPI. |
| [GetRect](#getrect) | Returns or reads the formatting rectangle. |
| [SetRect](#setrect) | Sets the formatting rectangle and redraws. |
| [SetRectNoPaint](#setrectnopaint) | Sets the formatting rectangle without redrawing. |
| [SetTabStops](#settabstops) | Sets the tab stops of a multiline control. |
| [FmtLines](#fmtlines) | Adds or removes soft line breaks in the text. |
| [GetWordBreakProc](#getwordbreakproc) | Returns the word-break procedure. |
| [SetWordBreakProc](#setwordbreakproc) | Sets the word-break procedure. |
| [GetHandle](#gethandle) | Returns the memory handle of a multiline control's text. |
| [SetHandle](#sethandle) | Gives a multiline control a memory handle for its text. |
| [GetIMEStatus](#getimestatus) | Returns how the control works with the input method editor. |
| [SetIMEStatus](#setimestatus) | Sets how the control works with the input method editor. |
| [SetZoomable](#setzoomable) | Lets the user zoom a multiline control. |
| [SetZoom](#setzoom) | Sets the zoom ratio. |
| [GetZoom](#getzoom) | Returns or reads the zoom ratio. |
| [GetExtendedStyle](#getextendedstyle) | Returns the extended styles. |
| [SetExtendedStyle](#setextendedstyle) | Sets some extended styles. |
| [GetEndOfLine](#getendofline) | Returns the line break the control writes. |
| [SetEndOfLine](#setendofline) | Sets the line break the control writes. |
| [EnableSearchWeb](#enablesearchweb) | Shows or hides the "Search with Bing" menu item. |
| [SearchWeb](#searchweb) | Searches the web for the selection. |
| [Enable](#enable) | Enables the control. |
| [Disable](#disable) | Disables the control. |
| [SetDarkMode](#setdarkmode) | Gives the scroll bars the dark theme. |
| [RemoveDarkMode](#removedarkmode) | Gives the control back its normal theme. |

## Reference

### GetText

```freebasic
function GetText( byval hEdit as HWND ) as ustring
```

Returns the whole text of the control. The string is one character longer than the text: its
last character is the null character that ends the text in the control, so `len()` is
[GetTextLength](#gettextlength) + 1 and a comparison with a literal is false. Text joined after
it is lost when the string is passed back to Windows. Remove it with `rtrim( ..., chr(0) )`.

**Returns** the text and its terminating null. `GetLastError()` is the number of characters
copied.

**Example**

```freebasic
dim sName as ustring = rtrim( Edit.GetText( hCtrl ), chr(0) )
print "["; sName; "]"; len(sName)
```

Microsoft Learn: [GetWindowTextW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindowtextw)

### GetTextLength

```freebasic
function GetTextLength( byval hEdit as HWND ) as long
```

Returns the number of characters in the control, line breaks included.

**Returns** the length, or 0 when the control is empty.

**Example**

```freebasic
if Edit.GetTextLength( hCtrl ) = 0 then print "nothing typed"
```

Microsoft Learn: [GetWindowTextLengthW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindowtextlengthw)

### SetText

```freebasic
function SetText( byval hEdit as HWND, byval pwszText as wstring ptr ) as boolean
```

Replaces all the text of the control. The undo buffer is emptied and the changed flag is
cleared. In a multiline control, lines are separated by `chr(13, 10)`.

**Returns** `true` on success.

**Example**

```freebasic
Edit.SetText( hCtrl, "Line one" & chr(13, 10) & "Line two" )
```

Microsoft Learn: [SetWindowTextW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setwindowtextw)

### GetLine

```freebasic
function GetLine( byval hEdit as HWND, byval which as DWORD ) as ustring
```

Returns line `which` of a multiline control, without its line break; a single-line control
ignores `which`.

The function reads into a buffer of eight characters while telling the control it can take
65,533. A line of up to eight characters comes back whole. A longer line comes back cut to its
first eight characters, and the control writes the rest past the end of the buffer, which can
end the program (a 300-character line does). For longer lines, read the text with
[GetText](#gettext) and cut it with [LineIndex](#lineindex) and [LineLength](#linelength), or
use [GetFileLine](#getfileline) on a control that does not wrap.

| Parameter | Meaning |
| --- | --- |
| `hEdit` | The edit control. |
| `which` | The zero-based line. |

**Returns** the line, or `""` when the line is empty or does not exist.

**Example**

```freebasic
dim nStart as long = Edit.LineIndex( hCtrl, 2 )
dim sLine as ustring = mid( Edit.GetText( hCtrl ), nStart + 1, Edit.LineLength( hCtrl, nStart ) )
print Edit.GetLine( hCtrl, 0 )   ' a short first line
```

Microsoft Learn: [EM_GETLINE](https://learn.microsoft.com/en-us/windows/win32/controls/em-getline)

### GetLineCount

```freebasic
function GetLineCount( byval hEdit as HWND ) as long
```

Returns the number of lines in a multiline control, counting each wrapped line. An empty control
has one line.

**Returns** the number of lines.

**Example**

```freebasic
print Edit.GetLineCount( hCtrl ); " lines"
```

Microsoft Learn: [EM_GETLINECOUNT](https://learn.microsoft.com/en-us/windows/win32/controls/em-getlinecount)

### LineIndex

```freebasic
function LineIndex( byval hEdit as HWND, byval nLine as long ) as long
```

Returns the character index of the first character of line `nLine`. Pass -1 for the line that
holds the caret.

**Returns** the character index, or -1 when the line does not exist.

**Example**

```freebasic
Edit.SetSel( hCtrl, Edit.LineIndex( hCtrl, 3 ), Edit.LineIndex( hCtrl, 3 ) )   ' caret to line 3
```

Microsoft Learn: [EM_LINEINDEX](https://learn.microsoft.com/en-us/windows/win32/controls/em-lineindex)

### LineFromChar

```freebasic
function LineFromChar( byval hEdit as HWND, byval index as long ) as long
```

Returns the zero-based line that holds the character at `index`. Pass -1 for the line of the
caret, or of the start of the selection.

**Returns** the line.

**Example**

```freebasic
print "caret on line"; Edit.LineFromChar( hCtrl, -1 ) + 1
```

Microsoft Learn: [EM_LINEFROMCHAR](https://learn.microsoft.com/en-us/windows/win32/controls/em-linefromchar)

### LineLength

```freebasic
function LineLength( byval hEdit as HWND, byval index as long ) as long
```

Returns the length of the line that holds the character at `index`, without its line break.
`index` is a **character index**, not a line number: use [LineIndex](#lineindex) to turn one into
the other. With -1 it returns the number of unselected characters on the lines the selection
touches.

**Returns** the length in characters.

**Example**

```freebasic
print Edit.LineLength( hCtrl, Edit.LineIndex( hCtrl, 0 ) )   ' length of the first line
```

Microsoft Learn: [EM_LINELENGTH](https://learn.microsoft.com/en-us/windows/win32/controls/em-linelength)

### GetFileLine

```freebasic
function GetFileLine overload( byval hEdit as HWND, byval lineNumber as UINT, byval textBuffer as wstring ptr ) as UINT
function GetFileLine overload( byval hEdit as HWND, byval lineNumber as UINT ) as ustring
```

Copies file line `lineNumber`, the text between two line breaks whatever the wrapping. The
first form fills a buffer of your own: before the call, set its first character to the
buffer's size in characters (with 0 nothing is copied). No null character is added.

The second form sizes the buffer itself, from [LineIndex](#lineindex) and
[GetFileLineLength](#getfilelinelength), and returns it. It works on a control that does not
wrap, with two limits: the buffer starts with a space, which the control reads as a size of 32,
so at most the first 32 characters of the line are copied and the rest of the string is spaces;
and in a control that wraps, `LineIndex` counts displayed lines, so the string can have the
length of another line, padded with spaces (`"short"` in a wrapped control comes back as 48
characters).

| Parameter | Meaning |
| --- | --- |
| `hEdit` | The edit control. |
| `lineNumber` | The zero-based file line. |
| `textBuffer` | A buffer whose first character holds its size. |

**Returns** the number of characters copied (first form), or the line (second form), `""` when
the line does not exist or is empty.

**Example**

```freebasic
dim wszLine as wstring * 256
wszLine[0] = 256
dim n as UINT = Edit.GetFileLine( hCtrl, 0, @wszLine )
print left( wszLine, n )
print rtrim( Edit.GetFileLine( hCtrl, 1 ) )
```

Microsoft Learn: [EM_GETFILELINE](https://learn.microsoft.com/en-us/windows/win32/controls/em-getfileline)

### GetFileLineCount

```freebasic
function GetFileLineCount( byval hEdit as HWND ) as UINT
```

Returns the number of file lines: the number of line breaks plus one, however the text wraps.

**Returns** the number of file lines.

**Example**

```freebasic
print Edit.GetFileLineCount( hCtrl ); " lines in the file,"; Edit.GetLineCount( hCtrl ); " on screen"
```

Microsoft Learn: [EM_GETFILELINECOUNT](https://learn.microsoft.com/en-us/windows/win32/controls/em-getfilelinecount)

### GetFileLineIndex

```freebasic
function GetFileLineIndex( byval hEdit as HWND, byval lineNumber as UINT ) as UINT
```

Returns the character index at which file line `lineNumber` starts: the file-line counterpart of
[LineIndex](#lineindex). With `"one two … ten" & chr(13, 10) & "short"` wrapped over four lines,
file line 1 starts at 50.

**Returns** the character index.

**Example**

```freebasic
print "the second paragraph starts at"; Edit.GetFileLineIndex( hCtrl, 1 )
```

Microsoft Learn: [EM_FILELINEINDEX](https://learn.microsoft.com/en-us/windows/win32/controls/em-filelineindex)

### GetFileLineFromChar

```freebasic
function GetFileLineFromChar( byval hEdit as HWND, byval characterIndex as UINT ) as UINT
```

Returns the zero-based file line that holds the character at `characterIndex`.

**Returns** the file line.

**Example**

```freebasic
print "paragraph"; Edit.GetFileLineFromChar( hCtrl, Edit.GetCaretIndex( hCtrl ) ) + 1
```

Microsoft Learn: [EM_FILELINEFROMCHAR](https://learn.microsoft.com/en-us/windows/win32/controls/em-filelinefromchar)

### GetFileLineLength

```freebasic
function GetFileLineLength( byval hEdit as HWND, byval characterIndex as UINT ) as UINT
```

Returns the length of the file line that holds the character at `characterIndex`, without its
line break.

**Returns** the length in characters.

**Example**

```freebasic
print Edit.GetFileLineLength( hCtrl, Edit.GetFileLineIndex( hCtrl, 1 ) )
```

Microsoft Learn: [EM_FILELINELENGTH](https://learn.microsoft.com/en-us/windows/win32/controls/em-filelinelength)

### GetSel

```freebasic
function GetSel overload( byval hEdit as HWND, byref dwStartPos as DWORD, byref dwEndPos as DWORD ) as long
function GetSel overload( byval hEdit as HWND, byval pdwStartPos as DWORD ptr, byval pdwEndPos as DWORD ptr ) as long
function GetSel overload( byval hEdit as HWND ) as ..POINTL
```

Reads the selection as two character indexes: where it starts and the first character after it.
When nothing is selected both are the caret position. The first two forms store them in your
variables; the third returns them in a `POINTL`, `x` the start and `y` the end.

**Returns** for the first two forms, the start in the low word and the end in the high word (-1
in a word whose value is over 65,535); for the third, the `POINTL`, with that packed value in
`GetLastError()`.

**Example**

```freebasic
dim as DWORD nStart, nEnd
Edit.GetSel( hCtrl, nStart, nEnd )
dim sel as POINTL = Edit.GetSel( hCtrl )
print sel.y - sel.x; " characters selected"
```

Microsoft Learn: [EM_GETSEL](https://learn.microsoft.com/en-us/windows/win32/controls/em-getsel)

### GetSelStart

```freebasic
function GetSelStart( byval hEdit as HWND ) as DWORD
```

Returns the character index where the selection starts.

**Returns** the start. `GetLastError()` holds the packed value of [GetSel](#getsel).

**Example**

```freebasic
print "selection from"; Edit.GetSelStart( hCtrl )
```

Microsoft Learn: [EM_GETSEL](https://learn.microsoft.com/en-us/windows/win32/controls/em-getsel)

### GetSelEnd

```freebasic
function GetSelEnd( byval hEdit as HWND ) as DWORD
```

Returns the character index just after the selection.

**Returns** the end. `GetLastError()` holds the packed value of [GetSel](#getsel).

**Example**

```freebasic
print "selection to"; Edit.GetSelEnd( hCtrl )
```

### SetSel

```freebasic
sub SetSel( byval hEdit as HWND, byval nStart as long, byval nEnd as long )
```

Selects the characters from `nStart` up to, not including, `nEnd`. `0, -1` selects all the text;
an `nStart` of -1 removes the selection. The selection is not scrolled into view: call
[ScrollCaret](#scrollcaret) for that.

**Example**

```freebasic
Edit.SetSel( hCtrl, 0, -1 )   ' select all
SetFocus( hCtrl )
```

Microsoft Learn: [EM_SETSEL](https://learn.microsoft.com/en-us/windows/win32/controls/em-setsel)

### ReplaceSel

```freebasic
sub ReplaceSel( byval hEdit as HWND, byval bCanBeUndone as boolean, byval pwszText as wstring ptr )
```

Replaces the selection with `pwszText`, or inserts it at the caret when nothing is selected.
Note the order: the undo flag comes before the text.

| Parameter | Meaning |
| --- | --- |
| `hEdit` | The edit control. |
| `bCanBeUndone` | `true` lets [Undo](#undo) take the replacement back. |
| `pwszText` | The new text. |

**Example**

```freebasic
dim nEnd as long = Edit.GetTextLength( hCtrl )
Edit.SetSel( hCtrl, nEnd, nEnd )   ' caret to the end
Edit.ReplaceSel( hCtrl, true, "appended text" )
```

Microsoft Learn: [EM_REPLACESEL](https://learn.microsoft.com/en-us/windows/win32/controls/em-replacesel)

### GetCaretIndex

```freebasic
function GetCaretIndex( byval hEdit as HWND ) as long
```

Returns the character index of the caret: after `Edit.SetSel( hEdit, 1, 3 )` it is 3.

**Returns** the caret's character index.

**Example**

```freebasic
print "caret at"; Edit.GetCaretIndex( hCtrl )
```

Microsoft Learn: [EM_GETCARETINDEX](https://learn.microsoft.com/en-us/windows/win32/controls/em-getcaretindex)

### SetCaretIndex

```freebasic
function SetCaretIndex( byval hEdit as HWND, byval newCaretPosition as long ) as boolean
```

Moves the caret to the character index `newCaretPosition`.

**Returns** `true` on success.

**Example**

```freebasic
Edit.SetCaretIndex( hCtrl, Edit.GetTextLength( hCtrl ) )   ' to the end
```

Microsoft Learn: [EM_SETCARETINDEX](https://learn.microsoft.com/en-us/windows/win32/controls/em-setcaretindex)

### Clear

```freebasic
sub Clear( byval hEdit as HWND )
```

Deletes the selected text. The clipboard is not touched; [Undo](#undo) brings the text back.

**Example**

```freebasic
Edit.Clear( hCtrl )
```

Microsoft Learn: [WM_CLEAR](https://learn.microsoft.com/en-us/windows/win32/dataxchg/wm-clear)

### Copy

```freebasic
sub Copy( byval hEdit as HWND )
```

Copies the selected text to the clipboard.

**Example**

```freebasic
Edit.SetSel( hCtrl, 0, -1 )
Edit.Copy( hCtrl )
```

Microsoft Learn: [WM_COPY](https://learn.microsoft.com/en-us/windows/win32/dataxchg/wm-copy)

### Cut

```freebasic
sub Cut( byval hEdit as HWND )
```

Copies the selected text to the clipboard and deletes it from the control.

**Example**

```freebasic
Edit.Cut( hCtrl )
```

Microsoft Learn: [WM_CUT](https://learn.microsoft.com/en-us/windows/win32/dataxchg/wm-cut)

### Paste

```freebasic
sub Paste( byval hEdit as HWND )
```

Inserts the text on the clipboard at the caret, replacing the selection. Nothing happens when the
clipboard holds no text.

**Example**

```freebasic
Edit.Paste( hCtrl )
```

Microsoft Learn: [WM_PASTE](https://learn.microsoft.com/en-us/windows/win32/dataxchg/wm-paste)

### CanUndo

```freebasic
function CanUndo( byval hEdit as HWND ) as boolean
```

Tells whether the control has a change it can undo.

**Returns** `true` when [Undo](#undo) would do something.

**Example**

```freebasic
if Edit.CanUndo( hCtrl ) = false then print "nothing to undo"
```

Microsoft Learn: [EM_CANUNDO](https://learn.microsoft.com/en-us/windows/win32/controls/em-canundo)

### Undo

```freebasic
function Undo( byval hEdit as HWND ) as boolean
```

Undoes the last change. An edit control keeps one level of undo, so a second `Undo` redoes the
change.

**Returns** `true` on success; a single-line control always returns `true`.

**Example**

```freebasic
if Edit.CanUndo( hCtrl ) then Edit.Undo( hCtrl )
```

Microsoft Learn: [EM_UNDO](https://learn.microsoft.com/en-us/windows/win32/controls/em-undo)

### EmptyUndoBuffer

```freebasic
sub EmptyUndoBuffer( byval hEdit as HWND )
```

Forgets the last change, so that [CanUndo](#canundo) returns `false`. [SetText](#settext) does
this too.

**Example**

```freebasic
Edit.EmptyUndoBuffer( hCtrl )
```

Microsoft Learn: [EM_EMPTYUNDOBUFFER](https://learn.microsoft.com/en-us/windows/win32/controls/em-emptyundobuffer)

### GetModify

```freebasic
function GetModify( byval hEdit as HWND ) as boolean
```

Tells whether the text has been changed since the control was created, since its text was last
set, or since [SetModify](#setmodify) last cleared the flag.

**Returns** `true` when the text has been changed.

**Example**

```freebasic
if Edit.GetModify( hCtrl ) then print "save your changes?"
```

Microsoft Learn: [EM_GETMODIFY](https://learn.microsoft.com/en-us/windows/win32/controls/em-getmodify)

### SetModify

```freebasic
sub SetModify( byval hEdit as HWND, byval fModify as boolean )
```

Sets (`true`) or clears (`false`) the changed flag. Clear it after saving the text.

**Example**

```freebasic
Edit.SetModify( hCtrl, false )   ' just saved
```

Microsoft Learn: [EM_SETMODIFY](https://learn.microsoft.com/en-us/windows/win32/controls/em-setmodify)

### LimitText, SetLimitText

```freebasic
sub LimitText( byval hEdit as HWND, byval chMax as DWORD )
sub SetLimitText( byval hEdit as HWND, byval chMax as DWORD )
```

Sets the most characters the user can type into the control. The two are the same call. Text
already longer is not cut, and text set with [SetText](#settext) is not limited. `chMax = 0`
sets the largest limit: 2,147,483,646 in a single-line control.

**Example**

```freebasic
Edit.LimitText( hCtrl, 10 )
print Edit.GetLimitText( hCtrl )   ' 10
```

Microsoft Learn: [EM_LIMITTEXT](https://learn.microsoft.com/en-us/windows/win32/controls/em-limittext)

### GetLimitText

```freebasic
function GetLimitText( byval hEdit as HWND ) as DWORD
```

Returns the most characters the control accepts from the user: 30,000 for a new control until
a limit is set.

**Returns** the limit.

**Example**

```freebasic
print "up to"; Edit.GetLimitText( hCtrl ); " characters"
```

Microsoft Learn: [EM_GETLIMITTEXT](https://learn.microsoft.com/en-us/windows/win32/controls/em-getlimittext)

### SetReadOnly

```freebasic
function SetReadOnly( byval hEdit as HWND, byval fReadOnly as boolean ) as long
```

Makes the control read-only (`true`) or editable again (`false`), setting or clearing its
`ES_READONLY` style. A read-only control can still be selected and copied from.

**Returns** nonzero on success.

**Example**

```freebasic
Edit.SetReadOnly( hCtrl, true )
```

Microsoft Learn: [EM_SETREADONLY](https://learn.microsoft.com/en-us/windows/win32/controls/em-setreadonly)

### GetPasswordChar

```freebasic
function GetPasswordChar( byval hEdit as HWND ) as long
```

Returns the character shown in place of each typed character.

**Returns** the character code, or 0 when the text is shown as typed.

**Example**

```freebasic
if Edit.GetPasswordChar( hCtrl ) then print "masked"
```

Microsoft Learn: [EM_GETPASSWORDCHAR](https://learn.microsoft.com/en-us/windows/win32/controls/em-getpasswordchar)

### SetPasswordChar

```freebasic
sub SetPasswordChar( byval hEdit as HWND, byval dwchar as DWORD )
```

Shows `dwchar` in place of each character of the text, or the text itself again when `dwchar`
is 0. The control is redrawn.

**Example**

```freebasic
Edit.SetPasswordChar( hCtrl, &h25CF )   ' a black circle
```

Microsoft Learn: [EM_SETPASSWORDCHAR](https://learn.microsoft.com/en-us/windows/win32/controls/em-setpasswordchar)

### GetCueBannerText

```freebasic
function GetCueBannerText overload( byval hEdit as HWND, byval pwszText as wstring ptr, byval cchText as DWORD ) as boolean
function GetCueBannerText overload( byval hEdit as HWND, byval cchText as DWORD ) as ustring
```

Reads the cue banner, the grey hint set with [SetCueBannerText](#setcuebannertext). The first
form fills your buffer of `cchText` characters. The second returns a string of `cchText + 1`
characters: the hint, a null character and spaces to the end; cut it at the null.

| Parameter | Meaning |
| --- | --- |
| `hEdit` | The edit control. |
| `pwszText` | The buffer. |
| `cchText` | The size of the buffer, or the longest hint to read, in characters. |

**Returns** `true` on success (first form); the padded string, with the message's result (1 on
success, 0 without version 6 of the common controls) in `GetLastError()` (second form).

**Example**

```freebasic
dim sCue as ustring = Edit.GetCueBannerText( hCtrl, 64 )
print left( sCue, instr( sCue, chr(0) ) - 1 )
```

Microsoft Learn: [EM_GETCUEBANNER](https://learn.microsoft.com/en-us/windows/win32/controls/em-getcuebanner)

### SetCueBannerText

```freebasic
function SetCueBannerText( byval hEdit as HWND, byval pwszText as wstring ptr, byval fDrawFocused as boolean = false ) as long
```

Sets a hint, drawn in grey while the control is empty, that tells the user what to type. A
multiline control does not show one.

| Parameter | Meaning |
| --- | --- |
| `hEdit` | A single-line edit control. |
| `pwszText` | The hint. |
| `fDrawFocused` | `true` keeps the hint while the control has the focus; with `false`, the default, it goes when the user clicks in. |

**Returns** nonzero on success.

**Example**

```freebasic
Edit.SetCueBannerText( hCtrl, "Search", true )
```

Microsoft Learn: [EM_SETCUEBANNER](https://learn.microsoft.com/en-us/windows/win32/controls/em-setcuebanner)

### ShowBalloonTip

```freebasic
function ShowBalloonTip overload( byval hEdit as HWND, byval peditballoontip as EDITBALLOONTIP ptr ) as boolean
function ShowBalloonTip overload( byval hEdit as HWND, byref edittip as EDITBALLOONTIP ) as boolean
function ShowBalloonTip overload( byval hEdit as HWND, byval pwszTitle as wstring ptr, byval pwszText as wstring ptr, byval iIcon as long ) as boolean
```

Shows a balloon tip pointing at the control: a way to say "only digits" without a message box.
The first two forms take an `EDITBALLOONTIP` you fill in and set its `cbStruct` for you (the
pointer form returns `false` for `NULL`); the third fills one in from a title, a text and an
icon. The tip goes when the user types or clicks, or with [HideBalloonTip](#hideballoontip).

| Parameter | Meaning |
| --- | --- |
| `hEdit` | The edit control. |
| `peditballoontip`, `edittip` | The tip: `pszTitle`, `pszText` and `ttiIcon`. |
| `pwszTitle` | The title, in bold. |
| `pwszText` | The text. |
| `iIcon` | `TTI_NONE`, `TTI_INFO`, `TTI_WARNING`, `TTI_ERROR`, or the `TTI_*_LARGE` forms. |

**Returns** `true` on success.

**Example**

```freebasic
Edit.ShowBalloonTip( hCtrl, "Wrong input", "Type a number from 1 to 100.", TTI_WARNING )
```

Microsoft Learn: [EM_SHOWBALLOONTIP](https://learn.microsoft.com/en-us/windows/win32/controls/em-showballoontip)

### HideBalloonTip

```freebasic
function HideBalloonTip( byval hEdit as HWND ) as boolean
```

Hides the balloon tip shown with [ShowBalloonTip](#showballoontip).

**Returns** `true` on success.

**Example**

```freebasic
Edit.HideBalloonTip( hCtrl )
```

Microsoft Learn: [EM_HIDEBALLOONTIP](https://learn.microsoft.com/en-us/windows/win32/controls/em-hideballoontip)

### CharFromPos

```freebasic
function CharFromPos( byval hEdit as HWND, byval x as short, byval y as short ) as DWORD
```

Finds the character nearest the point (`x`, `y`) in the control's client coordinates.

**Returns** the character index in the low word and the line in the high word (0 in a
single-line control). A point past the end gives the last character.

**Example**

```freebasic
dim r as DWORD = Edit.CharFromPos( hCtrl, 40, 10 )
print "character"; LOWORD( r ); " on line"; HIWORD( r )
```

Microsoft Learn: [EM_CHARFROMPOS](https://learn.microsoft.com/en-us/windows/win32/controls/em-charfrompos)

### PosFromChar

```freebasic
function PosFromChar( byval hEdit as HWND, byval index as long ) as long
```

Returns where the character at `index` is drawn, in client coordinates: x in the low word, y in
the high word.

**Returns** the packed position, or -1 when `index` is past the end of the text.

**Example**

```freebasic
dim p as long = Edit.PosFromChar( hCtrl, 0 )
if p <> -1 then print "first character at"; LOWORD( p ); ","; HIWORD( p )
```

Microsoft Learn: [EM_POSFROMCHAR](https://learn.microsoft.com/en-us/windows/win32/controls/em-posfromchar)

### GetFirstVisibleLine

```freebasic
function GetFirstVisibleLine( byval hEdit as HWND ) as long
```

Returns the zero-based line at the top of a multiline control; for a single-line control, the
first visible character.

**Returns** the line or character index.

**Example**

```freebasic
print "top line"; Edit.GetFirstVisibleLine( hCtrl )
```

Microsoft Learn: [EM_GETFIRSTVISIBLELINE](https://learn.microsoft.com/en-us/windows/win32/controls/em-getfirstvisibleline)

### GetThumb

```freebasic
function GetThumb( byval hEdit as HWND ) as long
```

Returns the position of the scroll box in the control's vertical scroll bar. It reads the scroll
bar itself rather than asking the control, which answers 0 for a multiline edit control.

**Returns** the position, 0 without a vertical scroll bar.

**Example**

```freebasic
print "scrolled to"; Edit.GetThumb( hCtrl )
```

Microsoft Learn: [GetScrollPos](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getscrollpos)

### LineScroll

```freebasic
function LineScroll( byval hEdit as HWND, byval x as long, byval y as long ) as boolean
```

Scrolls a multiline control `x` characters sideways and `y` lines down; negative values scroll
left and up.

**Returns** `true` for a multiline control, `false` for a single-line one, which does not scroll.

**Example**

```freebasic
Edit.LineScroll( hCtrl, 0, 10 )   ' ten lines down
```

Microsoft Learn: [EM_LINESCROLL](https://learn.microsoft.com/en-us/windows/win32/controls/em-linescroll)

### Scroll

```freebasic
function Scroll( byval hEdit as HWND, byval nAction as long ) as DWORD
```

Scrolls a multiline control as a click on its vertical scroll bar would.

| Parameter | Meaning |
| --- | --- |
| `hEdit` | A multiline edit control. |
| `nAction` | `SB_LINEUP`, `SB_LINEDOWN`, `SB_PAGEUP` or `SB_PAGEDOWN`. |

**Returns** the number of lines scrolled in the low word and `TRUE` in the high word on success;
0 on failure.

**Example**

```freebasic
Edit.Scroll( hCtrl, SB_PAGEDOWN )
```

Microsoft Learn: [EM_SCROLL](https://learn.microsoft.com/en-us/windows/win32/controls/em-scroll)

### ScrollCaret

```freebasic
sub ScrollCaret( byval hEdit as HWND )
```

Scrolls the control until the caret can be seen.

**Example**

```freebasic
Edit.SetSel( hCtrl, Edit.GetTextLength( hCtrl ), -1 )
Edit.ScrollCaret( hCtrl )
```

Microsoft Learn: [EM_SCROLLCARET](https://learn.microsoft.com/en-us/windows/win32/controls/em-scrollcaret)

### GetMargins

```freebasic
function GetMargins( byval hEdit as HWND ) as ( WORD, WORD )
```

Returns the left and right margins, in pixels, as a tuple.

**Returns** `( left, right )`.

**Example**

```freebasic
var (l, r) = Edit.GetMargins( hCtrl )
print "margins"; l; r
```

Microsoft Learn: [EM_GETMARGINS](https://learn.microsoft.com/en-us/windows/win32/controls/em-getmargins)

### GetLeftMargin

```freebasic
function GetLeftMargin( byval hEdit as HWND ) as WORD
```

Returns the left margin in pixels.

**Returns** the margin.

**Example**

```freebasic
print Edit.GetLeftMargin( hCtrl )
```

### GetRightMargin

```freebasic
function GetRightMargin( byval hEdit as HWND ) as WORD
```

Returns the right margin in pixels.

**Returns** the margin.

**Example**

```freebasic
print Edit.GetRightMargin( hCtrl )
```

### SetMargins

```freebasic
sub SetMargins( byval hEdit as HWND, byval leftMarginWidth as long, byval rightMarginWidth as long )
```

Sets the left and right margins, in pixels, and redraws the control.

**Example**

```freebasic
Edit.SetMargins( hCtrl, 7, 9 )
var (l, r) = Edit.GetMargins( hCtrl )   ' 7, 9
```

Microsoft Learn: [EM_SETMARGINS](https://learn.microsoft.com/en-us/windows/win32/controls/em-setmargins)

### SetMarginsForDpi

```freebasic
sub SetMarginsForDpi( byval hEdit as HWND, byval leftMarginWidth as long, byval rightMarginWidth as long )
```

Sets both margins like [SetMargins](#setmargins), but in 96-DPI units: each is passed through
[Scale](#scale) first.

**Example**

```freebasic
Edit.SetMarginsForDpi( hCtrl, 6, 6 )   ' 9, 9 pixels at 150 %
```

### SetLeftMargin

```freebasic
sub SetLeftMargin( byval hEdit as HWND, byval nWidth as WORD )
```

Sets the left margin in pixels; the right one stays as it is.

**Example**

```freebasic
Edit.SetLeftMargin( hCtrl, 20 )
```

### SetLeftMarginForDpi

```freebasic
sub SetLeftMarginForDpi( byval hEdit as HWND, byval nWidth as WORD )
```

Sets the left margin in 96-DPI units, scaled with [Scale](#scale).

**Example**

```freebasic
Edit.SetLeftMarginForDpi( hCtrl, 20 )
```

### SetRightMargin

```freebasic
sub SetRightMargin( byval hEdit as HWND, byval nWidth as WORD )
```

Sets the right margin in pixels; the left one stays as it is.

**Example**

```freebasic
Edit.SetRightMargin( hCtrl, 20 )
```

### SetRightMarginForDpi

```freebasic
sub SetRightMarginForDpi( byval hEdit as HWND, byval nWidth as WORD )
```

Sets the right margin in 96-DPI units, scaled with [Scale](#scale).

**Example**

```freebasic
Edit.SetRightMarginForDpi( hCtrl, 20 )
```

### Scale

```freebasic
function Scale( byval cx as single ) as single
```

Multiplies `cx` by the desktop's horizontal scaling ratio, `LOGPIXELSX / 96`, read from the
screen each call. A program that is not DPI-aware always gets `cx` back.

**Returns** the scaled length.

**Example**

```freebasic
print Edit.Scale( 100 )   ' 150 at 150 %
```

Microsoft Learn: [GetDeviceCaps](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-getdevicecaps)

### GetRect

```freebasic
sub GetRect overload( byval hEdit as HWND, byref rc as RECT )
sub GetRect overload( byval hEdit as HWND, byval prc as RECT ptr )
function GetRect overload( byval hEdit as HWND ) as ( long, long, long, long )
```

Reads the formatting rectangle: the area, in client coordinates, that the control draws its text
in. It is the client area less the margins unless [SetRect](#setrect) has changed it. The first
two forms fill your `RECT`; the third returns `( left, top, right, bottom )`.

**Returns** the four edges (third form), with `GetLastError()` 1 afterwards.

**Example**

```freebasic
var (l, t, r, b) = Edit.GetRect( hCtrl )
print "text area"; r - l; " x"; b - t
```

Microsoft Learn: [EM_GETRECT](https://learn.microsoft.com/en-us/windows/win32/controls/em-getrect)

### SetRect

```freebasic
sub SetRect overload( byval hEdit as HWND, byref rc as RECT )
sub SetRect overload( byval hEdit as HWND, byval prc as RECT ptr )
sub SetRect overload( byval hEdit as HWND, byval nLeft as long, byval nTop as long, byval nRight as long, byval nBottom as long )
```

Sets the formatting rectangle of a multiline control, in client coordinates, and redraws it.
The text wraps and is clipped to it, whatever the size of the control. A single-line control
ignores the call.

**Example**

```freebasic
var (l, t, r, b) = GetWindowClientRect( hCtrl )
Edit.SetRect( hCtrl, l + 8, t + 8, r - 8, b - 8 )
```

Microsoft Learn: [EM_SETRECT](https://learn.microsoft.com/en-us/windows/win32/controls/em-setrect)

### SetRectNoPaint

```freebasic
sub SetRectNoPaint overload( byval hEdit as HWND, byref rc as RECT )
sub SetRectNoPaint overload( byval hEdit as HWND, byval prc as RECT ptr )
sub SetRectNoPaint overload( byval hEdit as HWND, byval nLeft as long, byval nTop as long, byval nRight as long, byval nBottom as long )
```

Sets the formatting rectangle like [SetRect](#setrect) but does not redraw the control.

**Example**

```freebasic
Edit.SetRectNoPaint( hCtrl, 8, 8, 300, 200 )
InvalidateRect( hCtrl, NULL, true )
```

Microsoft Learn: [EM_SETRECTNP](https://learn.microsoft.com/en-us/windows/win32/controls/em-setrectnp)

### SetTabStops

```freebasic
function SetTabStops( byval hEdit as HWND, byval cTabs as long, byval prgTabStops as long ptr ) as boolean
```

Sets where a tab character in a multiline control jumps to, in dialog template units (a quarter
of the average character width). The control is not redrawn.

| Parameter | Meaning |
| --- | --- |
| `hEdit` | A multiline edit control. |
| `cTabs` | 0 for a stop every 32 units, 1 for a stop every `prgTabStops[0]` units, or the number of stops in the array. |
| `prgTabStops` | The stops, in increasing order. |

**Returns** `true` when every stop was set.

**Example**

```freebasic
dim tabs(0) as long = { 16 }
Edit.SetTabStops( hCtrl, 1, @tabs(0) )   ' every four characters
```

Microsoft Learn: [EM_SETTABSTOPS](https://learn.microsoft.com/en-us/windows/win32/controls/em-settabstops)

### FmtLines

```freebasic
function FmtLines( byval hEdit as HWND, byval AddEolFlag as boolean ) as boolean
```

With `true`, a multiline control that wraps words puts a soft line break (`CR CR LF`) at the end
of each wrapped line of the text it hands out; with `false` it takes them out again. What is
displayed does not change.

**Returns** `AddEolFlag`, the value passed.

**Example**

```freebasic
Edit.FmtLines( hCtrl, true )
dim sWrapped as ustring = rtrim( Edit.GetText( hCtrl ), chr(0) )
Edit.FmtLines( hCtrl, false )
```

Microsoft Learn: [EM_FMTLINES](https://learn.microsoft.com/en-us/windows/win32/controls/em-fmtlines)

### GetWordBreakProc

```freebasic
function GetWordBreakProc( byval hEdit as HWND ) as LONG_PTR
```

Returns the address of the procedure the control uses to find where words break.

**Returns** the address, or 0 while the control uses its own.

**Example**

```freebasic
if Edit.GetWordBreakProc( hCtrl ) = 0 then print "default word breaks"
```

Microsoft Learn: [EM_GETWORDBREAKPROC](https://learn.microsoft.com/en-us/windows/win32/controls/em-getwordbreakproc)

### SetWordBreakProc

```freebasic
sub SetWordBreakProc( byval hEdit as HWND, byval pfn as LONG_PTR )
```

Gives the control a procedure of your own, an `EDITWORDBREAKPROCW`, to find where words break
when it wraps lines and when the user presses `Ctrl+Left` or `Ctrl+Right`. Pass 0 to go back to
the control's own.

**Example**

```freebasic
function BreakAtSpaces( byval lpch as wstring ptr, byval ichCurrent as long, byval cch as long, byval code as long ) as long
    if code = WB_ISDELIMITER then return lpch[ichCurrent] = 32
    return ichCurrent
end function
sub UseBreakAtSpaces( byval hEdit as HWND )
    Edit.SetWordBreakProc( hEdit, cast( LONG_PTR, @BreakAtSpaces ) )
end sub
```

Microsoft Learn: [EM_SETWORDBREAKPROC](https://learn.microsoft.com/en-us/windows/win32/controls/em-setwordbreakproc)

### GetHandle

```freebasic
function GetHandle( byval hEdit as HWND ) as ..HLOCAL
```

Returns the handle of the local memory that holds a multiline control's text. The memory
belongs to the control: lock it with `LocalLock` only to read it, and do not free it.

**Returns** the memory handle.

**Example**

```freebasic
dim hMem as HLOCAL = Edit.GetHandle( hCtrl )
```

Microsoft Learn: [EM_GETHANDLE](https://learn.microsoft.com/en-us/windows/win32/controls/em-gethandle)

### SetHandle

```freebasic
sub SetHandle( byval hEdit as HWND, byval hLocal as ..HLOCAL )
```

Gives a multiline control a local memory block, allocated with `LocalAlloc( LMEM_MOVEABLE, … )`,
to keep its text in. The control does not free the block it used before: read it with
[GetHandle](#gethandle) first and free it after the call.

**Example**

```freebasic
dim hOld as HLOCAL = Edit.GetHandle( hCtrl )
Edit.SetHandle( hCtrl, LocalAlloc( LMEM_MOVEABLE or LMEM_ZEROINIT, 4096 ) )
LocalFree( hOld )
```

Microsoft Learn: [EM_SETHANDLE](https://learn.microsoft.com/en-us/windows/win32/controls/em-sethandle)

### GetIMEStatus

```freebasic
function GetIMEStatus( byval hEdit as HWND, byval nStatusType as long ) as long
```

Returns the flags that say how the control handles the composition string of an input method
editor (IME).

**Returns** for `EMSIS_COMPOSITIONSTRING`, a combination of `EIMES_*` flags.

**Example**

```freebasic
print hex( Edit.GetIMEStatus( hCtrl, EMSIS_COMPOSITIONSTRING ) )
```

Microsoft Learn: [EM_GETIMESTATUS](https://learn.microsoft.com/en-us/windows/win32/controls/em-getimestatus)

### SetIMEStatus

```freebasic
function SetIMEStatus( byval hEdit as HWND, byval nStatusType as long, byval flags as DWORD ) as DWORD
```

Sets how the control handles the composition string of an input method editor.

| Parameter | Meaning |
| --- | --- |
| `hEdit` | The edit control. |
| `nStatusType` | `EMSIS_COMPOSITIONSTRING`. |
| `flags` | `EIMES_GETCOMPSTRATONCE`, `EIMES_CANCELCOMPSTRINFOCUS`, `EIMES_COMPLETECOMPSTRKILLFOCUS`, combined with `or`. |

**Returns** the previous flags.

**Example**

```freebasic
Edit.SetIMEStatus( hCtrl, EMSIS_COMPOSITIONSTRING, EIMES_COMPLETECOMPSTRKILLFOCUS )
```

Microsoft Learn: [EM_SETIMESTATUS](https://learn.microsoft.com/en-us/windows/win32/controls/em-setimestatus)

### SetZoomable

```freebasic
function SetZoomable( byval hEdit as HWND ) as HRESULT
```

Gives a multiline control the `ES_EX_ZOOMABLE` extended style, so that the user can zoom it with
`Ctrl` and the mouse wheel and [SetZoom](#setzoom) works.

**Returns** `S_OK` on success.

**Example**

```freebasic
Edit.SetZoomable( hCtrl )
Edit.SetZoom( hCtrl, 150, 100 )
```

Microsoft Learn: [EM_SETEXTENDEDSTYLE](https://learn.microsoft.com/en-us/windows/win32/controls/em-setextendedstyle)

### SetZoom

```freebasic
function SetZoom( byval hEdit as HWND, byval zNum as DWORD, byval zDen as DWORD ) as boolean
```

Zooms a zoomable multiline control to `zNum / zDen`, between 1/64 and 64. `0, 0` turns the zoom
off.

**Returns** `true` on success.

**Example**

```freebasic
Edit.SetZoom( hCtrl, 175, 100 )   ' 175 %
```

Microsoft Learn: [EM_SETZOOM](https://learn.microsoft.com/en-us/windows/win32/controls/em-setzoom)

### GetZoom

```freebasic
function GetZoom overload( byval hEdit as HWND, byval numerator as long ptr, byval denominator as long ptr ) as boolean
function GetZoom overload( byval hEdit as HWND, byref numerator as long, byref denominator as long ) as boolean
function GetZoom overload( byval hEdit as HWND ) as ( long, long )
```

Reads the zoom ratio as a numerator and a denominator. The third form returns them as a tuple.

**Returns** `true` on success (first two forms); `( numerator, denominator )`, with 1 in
`GetLastError()` on success (third form).

**Example**

```freebasic
var (n, d) = Edit.GetZoom( hCtrl )
print "zoom"; n; " /"; d   ' 150 / 100 after SetZoom( hCtrl, 150, 100 )
```

Microsoft Learn: [EM_GETZOOM](https://learn.microsoft.com/en-us/windows/win32/controls/em-getzoom)

### GetExtendedStyle

```freebasic
function GetExtendedStyle( byval hEdit as HWND ) as DWORD
```

Returns the control's `ES_EX_*` extended styles.

**Returns** the styles, 0 for a new control.

**Example**

```freebasic
if Edit.GetExtendedStyle( hCtrl ) and ES_EX_ZOOMABLE then print "zoomable"
```

Microsoft Learn: [EM_GETEXTENDEDSTYLE](https://learn.microsoft.com/en-us/windows/win32/controls/em-getextendedstyle)

### SetExtendedStyle

```freebasic
function SetExtendedStyle( byval hEdit as HWND, byval dwExStyle as DWORD, byval dwMask as DWORD ) as HRESULT
```

Sets the extended styles in `dwMask` to their values in `dwExStyle`; the others stay. Note the
order: the styles come before the mask (`CBEx.SetExtendedStyle` takes the mask first).

| Parameter | Meaning |
| --- | --- |
| `hEdit` | The edit control. |
| `dwExStyle` | The new values: `ES_EX_ZOOMABLE`, `ES_EX_ALLOWEOL_CR`, `ES_EX_ALLOWEOL_LF`, `ES_EX_ALLOWEOL_ALL`, `ES_EX_CONVERT_EOL_ON_PASTE`. |
| `dwMask` | The styles to change. |

**Returns** `S_OK` on success.

**Example**

```freebasic
Edit.SetExtendedStyle( hCtrl, ES_EX_ZOOMABLE, ES_EX_ZOOMABLE )
```

Microsoft Learn: [EM_SETEXTENDEDSTYLE](https://learn.microsoft.com/en-us/windows/win32/controls/em-setextendedstyle)

### GetEndOfLine

```freebasic
function GetEndOfLine( byval hEdit as HWND ) as EC_ENDOFLINE
```

Returns the line break the control inserts when the user presses `Enter`.

**Returns** `EC_ENDOFLINE_DETECTFROMCONTENT` (0, the default: as in the text), `EC_ENDOFLINE_CRLF`
(1), `EC_ENDOFLINE_CR` (2) or `EC_ENDOFLINE_LF` (3).

**Example**

```freebasic
if Edit.GetEndOfLine( hCtrl ) = EC_ENDOFLINE_LF then print "LF"
```

Microsoft Learn: [EM_GETENDOFLINE](https://learn.microsoft.com/en-us/windows/win32/controls/em-getendofline)

### SetEndOfLine

```freebasic
function SetEndOfLine( byval hEdit as HWND, byval eoltype as EC_ENDOFLINE ) as boolean
```

Sets the line break the control inserts when the user presses `Enter`. For the control to also
read `LF` or `CR` alone as a line break, give it `ES_EX_ALLOWEOL_ALL` with
[SetExtendedStyle](#setextendedstyle).

**Returns** `true` on success.

**Example**

```freebasic
Edit.SetExtendedStyle( hCtrl, ES_EX_ALLOWEOL_ALL, ES_EX_ALLOWEOL_ALL )
Edit.SetEndOfLine( hCtrl, EC_ENDOFLINE_LF )
```

Microsoft Learn: [EM_SETENDOFLINE](https://learn.microsoft.com/en-us/windows/win32/controls/em-setendofline)

### EnableSearchWeb

```freebasic
function EnableSearchWeb( byval hEdit as HWND, byval fEnable as boolean ) as boolean
```

Shows (`true`) or hides (`false`) the "Search with Bing…" item of the control's context menu.

**Returns** the message's result as a `boolean`.

**Example**

```freebasic
Edit.EnableSearchWeb( hCtrl, false )
```

Microsoft Learn: [EM_ENABLESEARCHWEB](https://learn.microsoft.com/en-us/windows/win32/controls/em-enablesearchweb)

### SearchWeb

```freebasic
function SearchWeb( byval hEdit as HWND ) as boolean
```

Does what the "Search with Bing…" menu item does: opens a web search for the selected text in
the default browser.

**Returns** the message's result as a `boolean`.

**Example**

```freebasic
Edit.SearchWeb( hCtrl )
```

Microsoft Learn: [EM_SEARCHWEB](https://learn.microsoft.com/en-us/windows/win32/controls/em-searchweb)

### Enable

```freebasic
function Enable( byval hEdit as HWND ) as boolean
```

Lets the user type into and select in the control again.

**Returns** `true` when the control was disabled, `false` when it was already enabled.

**Example**

```freebasic
Edit.Enable( hCtrl )
```

Microsoft Learn: [EnableWindow](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-enablewindow)

### Disable

```freebasic
function Disable( byval hEdit as HWND ) as boolean
```

Greys the control out: it cannot take the focus or input until [Enable](#enable) is called.

**Returns** `true` when the control was enabled, `false` when it was already disabled.

**Example**

```freebasic
Edit.Disable( hCtrl )
```

Microsoft Learn: [EnableWindow](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-enablewindow)

### SetDarkMode

```freebasic
function SetDarkMode( byval hEdit as HWND ) as HRESULT
```

Gives the control the `DarkMode_Explorer` visual style. Only the scroll bars of a multiline
control change; for dark text and background, answer `WM_CTLCOLOREDIT` in the parent window.

**Returns** `S_OK` on success.

**Example**

```freebasic
if AppsUseDarkMode() then Edit.SetDarkMode( hCtrl )
```

Microsoft Learn: [SetWindowTheme](https://learn.microsoft.com/en-us/windows/win32/api/uxtheme/nf-uxtheme-setwindowtheme)

### RemoveDarkMode

```freebasic
function RemoveDarkMode( byval hEdit as HWND ) as HRESULT
```

Gives the control back its normal visual style.

**Returns** `S_OK` on success.

**Example**

```freebasic
Edit.RemoveDarkMode( hCtrl )
```

Microsoft Learn: [SetWindowTheme](https://learn.microsoft.com/en-us/windows/win32/api/uxtheme/nf-uxtheme-setwindowtheme)

## See also

- [sys/win/gui](SysWin-Gui)
- [CWindow](CWindow) for `AddControl( "Edit", ... )` and `AddControl( "EditMultiline", ... )`
- [CMaskedEdit](CMaskedEdit) for an edit control that follows an input mask
- [Combo](SysWin-Gui-Combo), whose drop-down combo boxes hold an edit control
- [RichEdit](SysWin-RichEdit-Control) for formatted text
- [Dark mode](SysWin-Dark-Mode)
