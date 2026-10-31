[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gui](SysWin-Gui) › **CMaskedEdit**

# CMaskedEdit

Creates an edit control that accepts input only in a set shape, such as a phone number.

A `CMaskedEdit` is a standard Windows edit control, subclassed so that what the user types is
checked against two strings of the same length:

- the **template** is what the control shows: literal characters, plus `_` at every position the
  user fills in. A run of consecutive `_` positions is a **group**. `"(___) ___-____"` has three
  groups, at positions 1–3, 6–8 and 10–13 (counting from 0).
- the **mask** says which characters each `_` position accepts. The characters at literal
  positions are not used; a space is the usual filler.

| Mask character | Accepts |
| --- | --- |
| `D` | a digit |
| `d` | a digit or a space |
| `+` | `+`, `-` or a space |
| `C` | a letter |
| `c` | a letter or a space |
| `A` | a letter or a digit |
| `a` | a letter, a digit or a space |
| `*` | any printable character |

The caret jumps over the literals: typing at the end of a group moves on to the next one,
Backspace at the start of a group moves back to the previous one, and a character the mask
refuses is dropped with a beep. A list of valid characters ([SetValidChars](#setvalidchars))
narrows the mask further. Backspace and Delete fill the position they clear with the **prompt
character** given to [EnableMask](#enablemask), `_` by default. Ctrl+C, Ctrl+X, Ctrl+V and
Ctrl+Z (one level of undo) work as in a normal edit box; pasted text is typed in character by
character. The control sends its parent the usual `EN_CHANGE` and other edit notifications.

**Lifetime.** The subclass keeps the object's address, so the object must stay where it is, and
alive, for as long as the control exists: a local in `main` around `DoEvents`, a field of your
window's state, or an object made with `new`. It cannot be copied usefully. Destroying the object
does not destroy the control; the control goes with its parent window and removes the subclass
itself. [CMaskedEditPtr](#cmaskededitptr) finds the object again from the control's handle.

The control's handle is also the public field `m_hCtl`; read it with [hWindow](#hwindow).

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui
```

## Example

A phone-number field and a button that shows the digits typed so far in the caption:

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

const IDC_PHONE = 1001
const IDC_SHOW  = 1002

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "MaskedEditDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Phone number", @WndProc )
    pWindow.SetClientSize( 300, 110 )
    pWindow.Center()
    dim pPhone as CMaskedEdit = CMaskedEdit( @pWindow, IDC_PHONE, 50, 20, 200, 23 )
    pPhone.EnableMask( " ddd  ddd dddd", "(___) ___-____" )
    pPhone.SetText( "(555) 123-4567", true )
    pWindow.AddControl( "Button", hWin, IDC_SHOW, "&Show digits", 100, 60, 100, 28 )
    SetFocus( pPhone.hWindow )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_COMMAND
            if CBCTL( wParam, lParam ) = IDC_SHOW andalso CBCTLMSG( wParam, lParam ) = BN_CLICKED then
                dim pPhone as CMaskedEdit ptr = CMaskedEditPtr( hwnd, IDC_PHONE )
                if pPhone then SetWindowText( hwnd, "Digits: " & pPhone->GetText( true ) )
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

## Members

| Member | Does |
| --- | --- |
| [Constructor](#constructor) | Creates the object and, given a parent, the control. |
| [Create](#create) | Creates the control for an object made with the default constructor. |
| [Destructor](#destructor) | Does nothing; the control lives on until its parent is destroyed. |
| [hWindow](#hwindow) | Returns the control's handle. |
| [EnableMask](#enablemask) | Sets the mask, the template, the prompt character and the valid characters. |
| [SetValidChars](#setvalidchars) | Sets the list of characters the user may type. |
| [SetText](#settext) | Replaces the contents, typing the new text in through the mask. |
| [GetText](#gettext) | Returns the contents, with or without the literals. |
| [GetTextLength](#gettextlength) | Returns the length of the contents, with or without the literals. |
| [SetPos](#setpos) | Moves the caret. |
| [GetGroupBounds](#getgroupbounds) | Finds the group of entry positions at or near a position. |
| [IsMaskedChar](#ismaskedchar) | Tells whether a character fits a mask character. |
| [CheckChar](#checkchar) | Tells whether a character may be typed at a position. |
| [SetValue](#setvalue) | Validates a string against the mask and stores it as the last good value. |
| [DoUpdate](#doupdate) | Validates the control's text and restores the last good value if it fails. |
| [OnCharPrintchar](#oncharprintchar) | Types one character at the caret. |
| [OnKeyDown](#onkeydown) | Handles the navigation and deletion keys. |
| [OnCharBackspace](#oncharbackspace) | Deletes the character before the caret. |
| [OnCharDelete](#onchardelete) | Deletes the character at the caret. |
| [CMaskedEditProc](#cmaskededitproc) | The subclass procedure. |

## Reference

### Constructor

```freebasic
constructor
constructor( byval pWindow as CWindow ptr, byval cID as LONG_PTR, byval x as long = 0, byval y as long = 0, byval nWidth as long = 0, byval nHeight as long = 0, byval dwStyle as DWORD = -1, byval dwExStyle as DWORD = -1 )
```

The first form makes an object with no control; call [Create](#create) later. The second creates
an `EDIT` control in `pWindow`'s window with [CWindow.AddControl](CWindow#addcontrol), so the
position and size are 96-DPI units, and subclasses it. The control has no mask until
[EnableMask](#enablemask) is called and behaves like a plain edit box until then.

| Parameter | Meaning |
| --- | --- |
| `pWindow` | The parent window's `CWindow`. With `NULL` no control is made. |
| `cID` | The control identifier. |
| `x`, `y` | The position in the parent's client area. |
| `nWidth`, `nHeight` | The size. |
| `dwStyle` | The window styles; -1 gives `WS_VISIBLE or WS_TABSTOP or ES_LEFT or ES_AUTOHSCROLL`. `WS_CHILD` is always added. `ES_UPPERCASE` or `ES_LOWERCASE` converts what is typed. |
| `dwExStyle` | The extended styles; -1 gives `WS_EX_CLIENTEDGE`. |

**Example**

```freebasic
dim pWindow as CWindow ptr = CWindowPtr( hwnd )
dim pZip as CMaskedEdit ptr = new CMaskedEdit( pWindow, 1001, 10, 10, 120, 23 )
pZip->EnableMask( "DDDDD-DDDD", "_____-____" )
```

Microsoft Learn: [SetWindowSubclass](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-setwindowsubclass)

### Create

```freebasic
function Create( byval pWindow as CWindow ptr, byval cID as LONG_PTR, byval x as long = 0, byval y as long = 0, byval nWidth as long = 0, byval nHeight as long = 0, byval dwStyle as DWORD = -1, byval dwExStyle as DWORD = -1 ) as HWND
```

Creates the control for an object made with the default constructor; the parameters are those
of the [Constructor](#constructor). When the object already has a control, nothing is created.

**Returns** the existing control's handle when there is one already. When it creates the control
it returns `NULL`; read the new handle with [hWindow](#hwindow).

**Example**

```freebasic
dim pMask as CMaskedEdit ptr = new CMaskedEdit
pMask->Create( CWindowPtr( hwnd ), 1002, 10, 40, 120, 23 )
if pMask->hWindow = NULL then print "no control"
```

### Destructor

```freebasic
destructor
```

Does nothing. The control is destroyed with its parent window and removes its subclass then. An
object destroyed before its control leaves the control pointing at freed memory, so keep it
alive as long as the window.

**Example**

```freebasic
dim pMask as CMaskedEdit ptr = CMaskedEditPtr( hCtrl )
DestroyWindow( hCtrl )
delete pMask   ' only after the control is gone
```

### hWindow

```freebasic
function hWindow() as HWND
```

**Returns** the edit control's handle, or `NULL` when there is no control.

**Example**

```freebasic
dim pMask as CMaskedEdit ptr = CMaskedEditPtr( hCtrl )
if pMask then SetFocus( pMask->hWindow )
```

### EnableMask

```freebasic
sub EnableMask( byval lpszMask as wstring ptr, byval lpszInputTemplate as wstring ptr, byref chMaskInputTemplate as ustring = "_", byval lpszValid as wstring ptr = NULL )
```

Turns the mask on and shows the template in the control, with the caret moved into the first
group once messages are next processed. Call it once after creating the control, then
[SetText](#settext) to put in a starting value.

The template is shown with its own `_` characters; the prompt character is what Backspace and
Delete, a cleared selection and a cleared value fill positions with.

| Parameter | Meaning |
| --- | --- |
| `lpszMask` | The mask, one character per template position (see the table above). |
| `lpszInputTemplate` | The template: literals, with `_` for each entry position. Must be as long as the mask. |
| `chMaskInputTemplate` | The prompt character, the first character of the string; it must be printable. Default `_`. |
| `lpszValid` | The characters the user may type, or `NULL` (the default) for any the mask accepts. |

Nothing changes when either string is `NULL` or the prompt character is not printable. When the
two strings differ in length, the mask is stored but the control stays empty and ignores what is
typed.

**Example**

```freebasic
dim pMask as CMaskedEdit ptr = CMaskedEditPtr( hCtrl )
pMask->EnableMask( "       cc       ddddd-dddd", "State: __, Zip: _____-____" )
```

### SetValidChars

```freebasic
sub SetValidChars( byval lpszValid as wstring ptr )
```

Sets the characters the user may type. A character must then both fit the mask and be in this
list. `NULL` or an empty string removes the list. What is already in the control is not checked
again.

**Example**

```freebasic
dim pMask as CMaskedEdit ptr = CMaskedEditPtr( hCtrl )
pMask->EnableMask( "  DDDD", "0o____" )
pMask->SetValidChars( "01234567" )   ' octal digits only
pMask->SetText( "0o0755", true )
```

### SetText

```freebasic
function SetText( byref ustrText as ustring ) as boolean
function SetText( byref ustrText as ustring, byval bSetMaskedCharsOnly as boolean ) as boolean
```

Without a mask, sets the control's text as it is. With a mask, puts the template back and then
types every character of `ustrText` in through the mask from the first group, as the user would:
each character goes to the next position that takes it, and one that fits nowhere is dropped with
a beep. An empty string clears the control to the template.

So the one-argument form is meant for the **entry characters only**: with the template
`__/__/____`, `"31122026"` gives `31/12/2026`. The displayed form works only while no mask
character accepts a literal: with `" ddd  ddd dddd"` and `"(___) ___-____"`, passing
`"(555) 123-4567"` gives `(555)  12-3456`, because the parentheses and the hyphen are dropped
but the space after `)` fits the `d` position that follows. For the displayed form use the second form with `true`, which first removes every
character that matches the template at the same position, and every `_`, then types in the rest.
The second form with `false` is the first form.

The caret is put back at the start, and moved into the first group once messages are next
processed.

| Parameter | Meaning |
| --- | --- |
| `ustrText` | The new contents. |
| `bSetMaskedCharsOnly` | `true` when `ustrText` includes the template's literals. |

**Returns** `true`.

**Example**

```freebasic
dim pMask as CMaskedEdit ptr = CMaskedEditPtr( hCtrl )
pMask->EnableMask( "DD DD DDDD", "__/__/____" )
pMask->SetText( "31122026" )               ' 31/12/2026
pMask->SetText( "31/12/2026", true )       ' the same, from the displayed form
```

### GetText

```freebasic
function GetText( byval bGetMaskedCharsOnly as boolean = false ) as ustring
```

Returns the control's text. With `bGetMaskedCharsOnly`, every character that equals the template
character at the same position is removed, and so is every `_`: what remains is what the user
typed. Positions cleared with Backspace or Delete hold the prompt character, which is removed
only when it is `_`.

| Parameter | Meaning |
| --- | --- |
| `bGetMaskedCharsOnly` | `false` (the default) returns the text as shown; `true` without the literals and unfilled positions. |

**Returns** the text.

**Example**

```freebasic
dim pMask as CMaskedEdit ptr = CMaskedEditPtr( hCtrl )
pMask->EnableMask( "       cc       ddddd-dddd", "State: __, Zip: _____-____" )
pMask->SetText( "State: NY, Zip: 12345-6789", true )
print pMask->GetText()        ' State: NY, Zip: 12345-6789
print pMask->GetText( true )  ' NY123456789
```

Microsoft Learn: [GetWindowTextW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindowtextw)

### GetTextLength

```freebasic
function GetTextLength( byval bGetMaskedCharsOnly as boolean = false ) as long
```

**Returns** the length of what [GetText](#gettext) returns with the same argument, in characters.

**Example**

```freebasic
dim pMask as CMaskedEdit ptr = CMaskedEditPtr( hCtrl )
pMask->EnableMask( "       cc       ddddd-dddd", "State: __, Zip: _____-____" )
pMask->SetText( "State: NY, Zip: 12345-6789", true )
print pMask->GetTextLength(); pMask->GetTextLength( true )   ' 26 11
```

### SetPos

```freebasic
sub SetPos( byval nPos as long = -1 )
```

Puts the caret at position `nPos`, counting from 0. With -1, the default, the caret goes to the
start of the group it is in, or of the nearest group before it, or of the first group when there
is none before.

**Example**

```freebasic
dim pMask as CMaskedEdit ptr = CMaskedEditPtr( hCtrl )
pMask->SetPos( 0 )
pMask->SetPos()   ' now at 1, the start of the first group of "(___) ___-____"
```

Microsoft Learn: [EM_SETSEL](https://learn.microsoft.com/en-us/windows/win32/controls/em-setsel)

### GetGroupBounds

```freebasic
sub GetGroupBounds( byref nBegin as long, byref nEnd as long, byval nStartPos as long = 0, byval bForward as boolean = true )
```

Finds a group of the template. Searching forward, it is the group that contains `nStartPos` or
the first one after it; searching backward, the group that contains `nStartPos` or the last one
before it. `nBegin` receives the position of the group's first character and `nEnd` the position
just after its last. When there is no such group `nBegin` is -1 and `nEnd` 0. Without a mask
neither variable is changed.

| Parameter | Meaning |
| --- | --- |
| `nBegin` | Receives the start of the group. |
| `nEnd` | Receives the position after the end of the group. |
| `nStartPos` | Where to start, counting from 0. |
| `bForward` | `true` (the default) searches forward, `false` backward. |

**Example**

```freebasic
dim pMask as CMaskedEdit ptr = CMaskedEditPtr( hCtrl )
dim as long nBegin, nEnd
pMask->GetGroupBounds( nBegin, nEnd, 5 )   ' "(___) ___-____": 6 and 9
```

### IsMaskedChar

```freebasic
function IsMaskedChar( byval chChar as ushort, byval chMaskChar as ushort ) as boolean
```

Checks one character against one mask character, using the table above. The valid-character
list is not consulted.

| Parameter | Meaning |
| --- | --- |
| `chChar` | The character. |
| `chMaskChar` | The mask character: `D`, `d`, `+`, `C`, `c`, `A`, `a` or `*`. |

**Returns** `true` when the character fits; `false` when it does not or `chMaskChar` is not a
mask character.

**Example**

```freebasic
dim pMask as CMaskedEdit ptr = CMaskedEditPtr( hCtrl )
print pMask->IsMaskedChar( asc( " " ), asc( "d" ) )   ' true
print pMask->IsMaskedChar( asc( " " ), asc( "D" ) )   ' false
```

### CheckChar

```freebasic
function CheckChar( byval chChar as ushort, byval nPos as long ) as boolean
```

Checks whether `chChar` may be typed at position `nPos`: the position must be an entry position,
the character must fit its mask character and, when there is a valid-character list, be in it.

| Parameter | Meaning |
| --- | --- |
| `chChar` | The character. |
| `nPos` | The position, counting from 0. |

**Returns** `true` when the character may go there; always `false` without a mask.

**Example**

```freebasic
dim pMask as CMaskedEdit ptr = CMaskedEditPtr( hCtrl )
print pMask->CheckChar( asc( "7" ), 1 )   ' true for "(___) ___-____"
print pMask->CheckChar( asc( "7" ), 0 )   ' false: position 0 is "("
```

### SetValue

```freebasic
function SetValue( byval lpszString as wstring ptr, byval bWithDelimiters as boolean = true ) as boolean
```

Checks a whole string against the mask and, when it passes, stores it as the control's last good
value: the one [DoUpdate](#doupdate) restores. The text shown in the control does **not** change;
use [SetText](#settext) for that. Entry positions the string does not reach take the prompt
character, and the prompt character is accepted at any entry position.

With `bWithDelimiters` the string is in the displayed form and each literal must match the
template; without it the string holds only the entry characters. With a valid-character list the
outcome of that check is the one for the **last** entry character tested, so a refused character
earlier in the string is not caught.

| Parameter | Meaning |
| --- | --- |
| `lpszString` | The string to check. |
| `bWithDelimiters` | `true` (the default) when the string includes the template's literals. |

**Returns** `true` when the string fits, `false` when it is `NULL`, too long or does not fit.

**Example**

```freebasic
dim pMask as CMaskedEdit ptr = CMaskedEditPtr( hCtrl )
print pMask->SetValue( "(111) 222-3333" )        ' true for "(___) ___-____"
print pMask->SetValue( "(1a1) 222-3333" )        ' false
```

### DoUpdate

```freebasic
function DoUpdate( byval bRestoreLastGood as boolean, byval nBeginOld as long = -1, byval nEndOld as long = -1 ) as boolean
```

Checks the control's current text with [SetValue](#setvalue) and beeps when it does not fit.
When it does not fit and `bRestoreLastGood` is `true`, the last good value is put back and, if
`nBeginOld` is not -1, the selection `nBeginOld` to `nEndOld` with it. The class calls it when
there is no template; with a mask in place the other members keep the text valid themselves.

| Parameter | Meaning |
| --- | --- |
| `bRestoreLastGood` | `true` puts the last good value back when the text does not fit. |
| `nBeginOld`, `nEndOld` | The selection to restore with it, or -1 to leave the selection alone. |

**Returns** `true` when the text fits the mask.

**Example**

```freebasic
dim pMask as CMaskedEdit ptr = CMaskedEditPtr( hCtrl )
SetWindowText( hCtrl, "not a number" )
pMask->DoUpdate( true )   ' beeps and puts the last good value back
```

### OnCharPrintchar

```freebasic
sub OnCharPrintchar( byval nChar as UINT, byval nRepCnt as UINT, byval nFlags as UINT )
```

Types the character `nChar` at the caret, exactly as a key press does: `ES_UPPERCASE` or
`ES_LOWERCASE` is applied, the caret skips to the next group when it is at the end of one or on a
literal, and a character that does not fit is dropped with a beep. With a selection, the selected
positions are cleared to the prompt character first. The subclass calls it for every printable
`WM_CHAR`. `nRepCnt` and `nFlags` are not used. Nothing happens when the mask and the template
differ in length.

**Example**

```freebasic
dim pMask as CMaskedEdit ptr = CMaskedEditPtr( hCtrl )
pMask->SetPos( 6 )
pMask->OnCharPrintchar( asc( "9" ), 1, 0 )   ' "(___) 9__-____", caret at 7
```

### OnKeyDown

```freebasic
sub OnKeyDown( byval nChar as UINT, byval nRepCnt as UINT, byval nFlags as UINT )
```

Handles a key press while a mask is in place. The subclass passes it every `WM_KEYDOWN` and lets
none through to the edit control, so keys not listed here do nothing.

| Key | Effect |
| --- | --- |
| Home, End | To the start or the end of the group the caret is in. Ctrl+Home puts the caret at position 1, Ctrl+End after the last character. |
| Left, Up | One position back within the group, or to the end of the previous group from its start. With Shift the selection grows one position back, never past the start of the group; with Ctrl the previous group is selected. |
| Right, Down | One position on within the group, or to the start of the next group from its end. With Shift the selection grows one position on, never past the end of the group; with Ctrl the next group is selected. |
| Backspace | [OnCharBackspace](#oncharbackspace); nothing with Shift. |
| Delete | [OnCharDelete](#onchardelete); nothing with Shift. |

It beeps when the template has no entry positions, and at the first or last group when there is
nowhere to go. `nRepCnt` and `nFlags` are not used.

**Example**

```freebasic
dim pMask as CMaskedEdit ptr = CMaskedEditPtr( hCtrl )
pMask->OnKeyDown( VK_END, 1, 0 )   ' to the end of the current group
```

### OnCharBackspace

```freebasic
sub OnCharBackspace( byval nChar as UINT, byval nRepCnt as UINT, byval nFlags as UINT )
```

Deletes the character before the caret. The characters after it in the group that have the same
mask character move one place left, and the last of them becomes the prompt character. At the
start of a group the caret moves to the end of the previous group instead, with a beep when there
is none. A selection is cleared to the prompt character. Only works with a mask; the arguments
are not used.

**Example**

```freebasic
dim pMask as CMaskedEdit ptr = CMaskedEditPtr( hCtrl )
pMask->SetPos( 3 )
pMask->OnCharBackspace( VK_BACK, 1, 0 )   ' "(123)..." becomes "(13_)..."
```

### OnCharDelete

```freebasic
sub OnCharDelete( byval nChar as UINT, byval nRepCnt as UINT, byval nFlags as UINT )
```

Deletes the character at the caret, moving the rest of its run of same mask characters one place
left and ending it with the prompt character. At the end of a group it beeps and does nothing. A
selection is cleared to the prompt character. Only works with a mask; the arguments are not used.

**Example**

```freebasic
dim pMask as CMaskedEdit ptr = CMaskedEditPtr( hCtrl )
pMask->SetPos( 2 )
pMask->OnCharDelete( VK_DELETE, 1, 0 )   ' "(123)..." becomes "(13_)..."
```

### CMaskedEditProc

```freebasic
static function CMaskedEditProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM, byval uIdSubclass as UINT_PTR, byval dwRefData as DWORD_PTR ) as LRESULT
```

The subclass procedure the constructor installs; you do not call it. `dwRefData` is the object.
It answers `WM_GETDLGCODE` with `DLGC_WANTARROWS or DLGC_WANTCHARS`, so Tab and Enter still move
around a dialog; sends `WM_KEYDOWN` and printable `WM_CHAR` to the members above while a mask is
in place; turns Ctrl+C, Ctrl+X and Ctrl+V into `WM_COPY`, `WM_CUT` and `WM_PASTE`, and Ctrl+Z
into a [SetText](#settext) of the text before the last change; handles `WM_CUT`, `WM_CLEAR` and
`WM_PASTE` through the mask; and removes the subclass on `WM_DESTROY`.

Two messages are taken for the class: `WM_USER + 100` returns the object's address (what
[CMaskedEditPtr](#cmaskededitptr) sends), and message 9999 runs [SetPos](#setpos). Do not send
either to the control with another meaning.

**Example**

```freebasic
dim pMask as CMaskedEdit ptr = cast( CMaskedEdit ptr, SendMessageW( hCtrl, WM_USER + 100, 0, 0 ) )
```

Microsoft Learn: [DefSubclassProc](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-defsubclassproc)

## Related functions

| Function | Does |
| --- | --- |
| [CMaskedEditPtr](#cmaskededitptr) | Returns the `CMaskedEdit` object of a masked edit control. |

### CMaskedEditPtr

```freebasic
function CMaskedEditPtr overload ( byval hMasKedEdit as HWND ) as CMaskedEdit ptr
function CMaskedEditPtr overload ( byval hParent as HWND, byval cID as long ) as CMaskedEdit ptr
```

Returns the object behind a masked edit control, given its handle, or its parent and its
identifier. Use it in a window procedure, where only the handle or the identifier is at hand.

| Parameter | Meaning |
| --- | --- |
| `hMasKedEdit` | The masked edit control. |
| `hParent` | The control's parent window. |
| `cID` | The control's identifier. |

**Returns** the object, or `NULL` when there is no such control. Sent to another kind of control,
the message it uses means something else and the result is not an object.

**Example**

```freebasic
dim pMask as CMaskedEdit ptr = CMaskedEditPtr( hwnd, 1001 )
if pMask then print pMask->GetText( true )
```

## See also

- [Edit](SysWin-Gui-Edit) for the functions of plain edit controls, which work on a masked edit too
- [CWindow](CWindow) for the parent window and `AddControl`
- [sys/win/gui](SysWin-Gui)
