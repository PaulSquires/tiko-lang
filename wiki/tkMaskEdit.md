[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkMaskEdit**

# tkMaskEdit

Draws a text box whose input follows a mask: a phone number, a price, a date or a pattern.

`tkMaskEdit` is the [tkControls](Category-tkControls) masked and formatted edit box. It is a
single-line [tkTextBox](tkTextBox) with the TextBox's look, in which every keystroke, Backspace,
Delete, Cut, Paste and context-menu command passes through a **mask** before it lands. A key the
mask does not take is refused and reported, never beeped. Undo, Redo, the IME and the clipboard
work as they do in a TextBox.

There are six kinds of mask:

| Kind | Mask | What the user sees and types |
| --- | --- | --- |
| `TKMASK_FIXED` | `(999) 000-0000`, `>L0L 0L0` | a template: literals in place, `_` in each empty slot, typed over |
| `TKMASK_NUMERIC` | `$#,##0.00`, `0.0%`, `#,##0 kg` | a number regrouped as it is typed, the decimals fixed |
| `TKMASK_DATE` | `dd/mm/yyyy` | a date typed digit by digit, the separators coming by themselves |
| `TKMASK_TIME` | `hh:nn` | a time, the same way |
| `TKMASK_DATETIME` | `yyyy-mm-dd hh:nn` | both |
| `TKMASK_REGEX` | `[A-Z]{2}\d{6}` | free text, kept only while it can still match the pattern |

The value comes back as text in one of four forms, as a number, or as a `TKDATE`, `TKTIME` or
`TKDATETIME`. Every setter is silent; only the user's actions notify. The Form Designer's
**MaskEdit** binds it to a field of any type, and a [tkDataGrid](tkDataGrid) column can carry
the same mask.

## Importing

```freebasic
#import "vendor/tkControls/tkMaskEdit"
#import "vendor/tkControls/tkMaskEditRegex"      ' only for Regex masks: it links PCRE2

using tkMaskEdit
using tkMask
using tkMaskEditRegex
using tkCalendar          ' TKDATE
using tkTimePanel         ' TKTIME, TKDATETIME
using tkHost
```

The module brings in [tkHost](tkHost) (and through it [tkPaint](tkPaint), SDL3, SDL_ttf and
SDL_image), [tkTheme](tkTheme), [tkTextBox](tkTextBox), [tkCalendar](tkCalendar) and
[tkTimePanel](tkTimePanel) (the date and time types), `tkBind`, and two modules with no SDL:

- **`tkMask`**, the mask engine. It holds the kinds and constants and the edit rules, and the
  grid uses it too.
- **`tkFormat`**, the number and date formatter it shares with [tkReport](tkReport).

**Write `using tkMaskEdit` before `using tkMask`.** tkMaskEdit re-exports tkMask, but the name is
known only after tkMaskEdit's own `using`. To write them the other way round, import
`vendor/tkControls/tkMask` as well.

**Regular expressions are a separate module, `tkMaskEditRegex`**, and it is the only one that
links PCRE2. A program that imports it calls `tkMaskEditRegex_Enable( )` once, before the first
Regex mask; a program that has no Regex masks links no PCRE2 at all.

## Example

`host` is a `TK_HOST ptr` from `tkHost_Create`, set up as in the [tkButton](tkButton) example,
with the imports above.

```freebasic
sub Phone_Rejected( byval h as TK_WIDGET ptr, byval nPos as int32, byval nReason as int32, byref sText as const ustring )
    print "refused '" & sText & "' at " & nPos & " (reason " & nReason & ")"
end sub

sub Price_Commit( byval h as TK_WIDGET ptr )
    print "price: " & tkMaskEdit_GetValue( h )       ' clamped into its range by now
end sub

tkMaskEditRegex_Enable( )                             ' once, for the Regex mask below

dim as TK_WIDGET ptr phone = tkMaskEdit_Create( tkHost_Root( host ), 100 )
tkMaskEdit_SetMask( phone, TKMASK_FIXED, "(999) 000-0000" )
tkMaskEdit_SetCueBannerText( phone, "Phone" )         ' shown while empty and unfocused
tkMaskEdit_SetRejectedCallback( phone, @Phone_Rejected )

dim as TK_WIDGET ptr price = tkMaskEdit_Create( tkHost_Root( host ), 101 )
tkMaskEdit_SetMask( price, TKMASK_NUMERIC, "$#,##0.00" )
tkMaskEdit_SetMin( price, 0 ) : tkMaskEdit_SetMax( price, 10000 )
tkMaskEdit_SetValue( price, 1234.5 )                  ' silent: "$1,234.50"
tkMaskEdit_SetCommitCallback( price, @Price_Commit )

dim as TK_WIDGET ptr born = tkMaskEdit_Create( tkHost_Root( host ), 102 )
tkMaskEdit_SetMask( born, TKMASK_DATE, "dd/mm/yyyy" )

dim as TK_WIDGET ptr code = tkMaskEdit_Create( tkHost_Root( host ), 103 )
tkMaskEdit_SetMask( code, TKMASK_REGEX, "[A-Z]{2}\d{6,8}" )

tkWidget_SetPos( phone, tkHost_Scale( host, 20 ), tkHost_Scale( host, 20 ), tkHost_Scale( host, 180 ), tkHost_Scale( host, 28 ) )

' later: the values
print tkMaskEdit_GetValueText( phone )               ' "5551234567" (Raw, the default form)
dim as TKDATE d = tkMaskEdit_GetDateValue( born )     ' wYear = 0 unless a real, complete date
if tkMaskEdit_IsValid( code ) = false then print "the code is not finished"
```

## The masks

### Fixed

A Fixed mask is a picture, one character per position, with the characters of WinForms' and
VB6's masked edit boxes:

| Char | Takes | Char | Means |
| --- | --- | --- | --- |
| `0` | a digit, required | `<` | the slots after it are lower-case |
| `9` | a digit or a space, optional | `>` | the slots after it are upper-case |
| `#` | a digit, a space, `+` or `-`, optional | `\|` | the case as typed again |
| `L` | a letter, required | `\` | the next character is a literal |
| `?` | a letter, optional | any other | a literal: `( ) - / . , : $` and the rest |
| `&` | any character, required | | |
| `C` | any character, optional | | |
| `A` | a letter or a digit, required | | |
| `a` | a letter or a digit, optional | | |

Letters are A to Z only. `& C` take any character, UTF-8 included. `. , : / $` are always the
literal characters themselves, not the user's locale's. A mask with no slot to type into, or with
a `\` at its end, is refused.

### Numeric

A Numeric mask is a [tkFormat](tkReport) number pattern: `#` and `0` for the digits, `,` to group
them in thousands, `.` and the number of `0` or `#` after it for the decimals, and anything around
them as a prefix or a suffix (`$`, ` kg`, `%`). A `%` shows the value times 100: the value 0.125
shows `12.5%`. A negative number shows its sign after the prefix, `$-1,234.00`, as a report prints
it. A number holds at most 15 significant digits.

### Date and time

A date or time mask uses tkFormat's letters, each at most once: `yyyy`, `mm`, `dd`, and `hh`,
`nn`, `ss` (24-hour; `nn` is minutes). Anything else is literal. A Date mask needs the year, month
and day and no time; a Time mask the hours and minutes; a DateTime mask both.

### Regex

A Regex mask is a PCRE2 pattern (UTF and Unicode classes on) that the **whole** text must match:
you do not write `^` or `$`. A keystroke or a paste is kept when the text it leaves can still
become a match, so `AB12` is kept for `[A-Z]{2}\d{6}` and `AB1x` is not. The box is complete when
the text is a full match. A pattern PCRE2 refuses makes `SetMask` return FALSE, and
`tkMaskEditRegex_LastError( )` gives PCRE2's message and offset. Each match is bounded at 100,000
steps, so a pattern that runs away answers "no match".

## Typing and editing

- **Fixed and dates: the template.** While the box has the focus it holds the template:
  literals in place and the prompt character (`_`, `SetPromptChar`) in each empty slot. Focusing
  an empty box puts the caret in the first slot. A click never leaves the caret past the first
  empty slot.
- **Overwrite.** A typed character goes into the next slot that takes it, over what is there.
  The caret then steps past the literals. Typing a literal that is next (the `(` or the `)` of a
  phone) steps over it, and one just behind the caret is ignored, so `(555) 123` and `555123` type
  the same.
- **Insert mode** (`SetInsertMode`, or the Insert key) shifts the filled slots right instead, and
  refuses a character that would push the last one off.
- **Backspace and Delete** leave prompts: nothing shifts. Over a literal they clear the slot
  beside it.
- **Numbers** are regrouped after every keystroke, and the caret keeps its place among the digits.
  `.` jumps to the decimals and typed decimals overwrite. A deleted decimal becomes 0. `-` toggles
  the sign anywhere unless `SetAllowNegative( h, false )`.
- **Dates** are typed digit by digit, each part range-checked as it is typed (month 01 to 12, day
  01 to 31, hour 00 to 23, minutes and seconds 00 to 59):
  - A digit that cannot start its part fills it out and moves on: `4` in the month gives `04`.
  - The separator fills out a one-digit part: `3/` gives `03/`.
  - Up and Down step the part under the caret, wrapping within it (the day within its month).
    PgUp and PgDn step by 10. An empty year starts at this year.
- **Paste:**
  - A Fixed paste takes `5551234567` and `(555) 123-4567` alike, and stops at the first character
    that does not fit.
  - A number paste must be a number, and is refused whole otherwise.
  - A date paste takes `3/4/2026` or `03042026`, and is refused whole when a part is out of range.
- **Copy and Cut** put the selection on the clipboard in the `CopyFormat` form (literals kept,
  empty slots as spaces, by default).
- **Unfocused**, an empty box shows nothing, so its cue banner (`SetCueBannerText`) shows. With
  `SetHidePromptOnLeave( h, true )` a filled box shows its prompts as spaces.

## Values

| Call | Gives |
| --- | --- |
| `GetText` / `SetText` | the text as the box holds it while focused: `(555) 123-45__`. `SetText` takes any form and maps it in, leaving out what does not fit |
| `GetValueText` / `SetValueText` | the value in `ValueFormat`, "" when empty. `TKMASK_FMT_RAW` (the default) gives the filled slots only, `5551234567`; `LITERALS` gives literals and spaces, `(555) 123-45  `; `PROMPTS` gives slots and prompts, `5551234567__`; `BOTH` gives the text as shown |
| `GetValue` / `SetValue` | a Numeric box's number (a `%` mask's divided by 100). `SetValue` formats it as the mask does and does **not** clamp it |
| `GetDateValue` / `SetDateValue` | a `TKDATE`; `wYear = 0` when the box holds no complete, real date. `SetDateValue` on a DateTime keeps its time |
| `GetTimeValue` / `SetTimeValue` | a `TKTIME`; `wHour = -1` when there is none |
| `GetDateTimeValue` / `SetDateTimeValue` | a `TKDATETIME`; `wYear = 0` when there is none |
| `GetBindText` / `SetBindText` | the canonical text a field or a file keeps: `1234.50`, `2026-12-25`, `14:30:00`, `2026-12-25T14:30:00`, or the value text |
| `IsEmpty`, `IsComplete`, `IsValid` | nothing typed; every required slot filled (every part of a date, a full regex match); empty or complete, a date that exists, inside its range |

`Clear` empties the box. A new `SetMask` clears the value too, and keeps the prompt character.

## Commit and errors

A box **commits** when Enter is pressed and when it loses the focus:

- A Numeric value is clamped into `SetMin` / `SetMax` (each bound is off until set;
  `ClearRange`). Clamping it is a Change.
- An empty Numeric box with `SetZeroWhenEmpty( h, true )` becomes 0 on focus loss, silently.
- Then a value that is not valid turns the border to ErrorColor (`SetShowError( h, false )` turns
  that off; `GetError` reads it), and **Commit** fires. The border clears with the user's next
  change.

A date is never changed to make it valid. 31/02, or a date outside `SetMinDate` / `SetMaxDate`
(and the Time and DateTime setters; `ClearDateRange`), is flagged by `IsValid` and by the border.

## Notifications

| Callback | When |
| --- | --- |
| `SetChangeCallback` | the user changed the text: typing, Backspace, Delete, Cut, Paste, Undo, a date step, a commit's clamp |
| `SetRejectedCallback` | a key or paste was refused, or a paste stopped part-way (then after its Change): where, why (`TKMASK_REJ_*`), and the text |
| `SetCommitCallback` | Enter, or the focus left |
| `SetEnterPressedCallback` | Enter only, after Commit |
| `SetFocusCallback` | the box got or lost the focus |

Do not replace the text box's own callbacks or its edit filter (`tkTextBox_Set*` on `GetEdit`):
the control runs on them. `GetEdit` is there for anything else the TextBox offers, such as the
context menu's text. For a host that drives the box itself, `TypeText` puts text in at the caret
as typing (tkDataGrid opens its editor with the key that started the edit).

## Colours and theme

`TKMASKEDIT_COLORS` is `TKTEXTBOX_COLORS`: the box has the TextBox's colours and follows the theme
as a TextBox does. `GetColors`, `SetColors` (it pins them), `UnpinColors`, `ThemeColors( t )`,
`ApplyTheme`. A Numeric mask right-aligns the text, and a change back to another kind left-aligns
it; `SetTextAlign` after `SetMask` wins. `SetFont`, `ApplyFonts`, `SetBorderWidth`,
`SetCornerRadius`, `SetReadOnly` and `SetCueBannerText` pass to the text box. A box whose mask
takes only digits asks a phone or tablet for the number keyboard.

## In the Form Designer

The toolbox's **MaskEdit** (under Common) has these properties:

- **MaskKind** (Fixed, Numeric, Date, Time, DateTime, Regex) and **Mask**, in either order.
- **The rest:** Text, PromptChar, HidePromptOnLeave, ValueFormat, CopyFormat, InsertMode,
  ShowError, AllowNegative, ZeroWhenEmpty, ReadOnly, TextAlign, CueBannerText, Font, BorderWidth
  and CornerRadius.
- **Code only:** the Numeric range (`SetMin` / `SetMax`) and the date range. A form's binding
  rules (Minimum and Maximum) cover the same need when the form saves.
- **Events:** Change (the default event), Rejected, Commit and FocusChanged.

**Bind** moves the value into and out of a field of the form's DataType, through the canonical
bind text, so the field can be any type:

- a phone or a code into a `ustring`, in ValueFormat
- a price into a `float64`
- a date into a `TKDATE` (or a `ustring`, as ISO)
- a time into a `TKTIME`

On **SaveTo**, an incomplete value, a Regex value that does not match, or a date that does not
exist stops the save with "is incomplete", "does not match its pattern" or "is not a real date,
or is outside its range". With Required, an empty one stops it with "is required". A form with a
Regex mask needs `tkMaskEditRegex_Enable( )` in the program before the form is built.

See [Form Designer](Form-Designer), Data binding.

## In a DataGrid

A [tkDataGrid](tkDataGrid) text or number column with `maskKind` and `mask` shows its values
through the mask, edits them in a tkMaskEdit, and takes typed and pasted values through it into
the column's kind. The Form Designer's Columns editor has **MaskKind** and **Mask** for each
column.

## Public declarations

### Constants

- **Kinds:** `TKMASK_NONE`, `TKMASK_FIXED`, `TKMASK_NUMERIC`, `TKMASK_DATE`, `TKMASK_TIME`,
  `TKMASK_DATETIME`, `TKMASK_REGEX`.
- **Value forms:** `TKMASK_FMT_RAW`, `TKMASK_FMT_LITERALS`, `TKMASK_FMT_PROMPTS`,
  `TKMASK_FMT_BOTH`.
- **Why a key was refused:** `TKMASK_REJ_NONE`, `TKMASK_REJ_CLASS` (the slot does not take it),
  `TKMASK_REJ_FULL` (no room), `TKMASK_REJ_RANGE` (a date or time part), `TKMASK_REJ_PATTERN`
  (a regex), `TKMASK_REJ_SIGN` (AllowNegative is off), `TKMASK_REJ_NOTNUMBER` (a paste).
- **Limits:** `TKMASK_MAXDIGITS` (15).

All of these are tkMask's.

### Types

- `TKMASKEDIT_COLORS` (`TKTEXTBOX_COLORS`).
- The callback types `MSK_ChangeCallbackSub`, `MSK_RejectedCallbackSub`, `MSK_CommitCallbackSub`,
  `MSK_FocusCallbackSub` and `MSK_EnterPressedCallbackSub`.
- From tkMask: `TKMASK_SPEC` (a compiled mask) and `TKMASK_DT`.

The Form Designer's typed wrapper is `MaskEdit` (`tkMaskEdit.forms.tiko`).

### Procedures

```freebasic
function tkMaskEdit_Create( byval hParent as TK_WIDGET ptr, byval CtrlID as int32 ) as TK_WIDGET ptr
function tkMaskEdit_GetEdit( byval hCtrl as TK_WIDGET ptr ) as TK_WIDGET ptr
function tkMaskEdit_GetID( byval hCtrl as TK_WIDGET ptr ) as int32
function tkMaskEdit_SetMask( byval hCtrl as TK_WIDGET ptr, byval nKind as int32, byref sMask as const ustring ) as boolean
function tkMaskEdit_GetMaskKind( byval hCtrl as TK_WIDGET ptr ) as int32
function tkMaskEdit_GetMask( byval hCtrl as TK_WIDGET ptr ) as ustring
sub tkMaskEdit_SetMaskKind( byval hCtrl as TK_WIDGET ptr, byval nKind as int32 )
sub tkMaskEdit_SetMaskPattern( byval hCtrl as TK_WIDGET ptr, byref sMask as const ustring )
function tkMaskEdit_GetText( byval hCtrl as TK_WIDGET ptr ) as ustring
sub tkMaskEdit_SetText( byval hCtrl as TK_WIDGET ptr, byref sText as const ustring )
function tkMaskEdit_GetValueText( byval hCtrl as TK_WIDGET ptr ) as ustring
sub tkMaskEdit_SetValueText( byval hCtrl as TK_WIDGET ptr, byref sValue as const ustring )
function tkMaskEdit_GetBindText( byval hCtrl as TK_WIDGET ptr ) as ustring
sub tkMaskEdit_SetBindText( byval hCtrl as TK_WIDGET ptr, byref sText as const ustring )
sub tkMaskEdit_Clear( byval hCtrl as TK_WIDGET ptr )
function tkMaskEdit_IsEmpty( byval hCtrl as TK_WIDGET ptr ) as boolean
function tkMaskEdit_IsComplete( byval hCtrl as TK_WIDGET ptr ) as boolean
function tkMaskEdit_IsValid( byval hCtrl as TK_WIDGET ptr ) as boolean
sub tkMaskEdit_TypeText( byval hCtrl as TK_WIDGET ptr, byref sText as const ustring )
function tkMaskEdit_GetValue( byval hCtrl as TK_WIDGET ptr ) as float64
sub tkMaskEdit_SetValue( byval hCtrl as TK_WIDGET ptr, byval v as float64 )
sub tkMaskEdit_SetMin( byval hCtrl as TK_WIDGET ptr, byval v as float64 )
sub tkMaskEdit_SetMax( byval hCtrl as TK_WIDGET ptr, byval v as float64 )
sub tkMaskEdit_ClearRange( byval hCtrl as TK_WIDGET ptr )
function tkMaskEdit_GetMin( byval hCtrl as TK_WIDGET ptr, byref v as float64 ) as boolean
function tkMaskEdit_GetMax( byval hCtrl as TK_WIDGET ptr, byref v as float64 ) as boolean
sub tkMaskEdit_SetAllowNegative( byval hCtrl as TK_WIDGET ptr, byval bAllow as boolean )
function tkMaskEdit_GetAllowNegative( byval hCtrl as TK_WIDGET ptr ) as boolean
sub tkMaskEdit_SetZeroWhenEmpty( byval hCtrl as TK_WIDGET ptr, byval bZero as boolean )
function tkMaskEdit_GetZeroWhenEmpty( byval hCtrl as TK_WIDGET ptr ) as boolean
function tkMaskEdit_GetDateValue( byval hCtrl as TK_WIDGET ptr ) as TKDATE
sub tkMaskEdit_SetDateValue( byval hCtrl as TK_WIDGET ptr, byval d as TKDATE )
function tkMaskEdit_GetTimeValue( byval hCtrl as TK_WIDGET ptr ) as TKTIME
sub tkMaskEdit_SetTimeValue( byval hCtrl as TK_WIDGET ptr, byval t as TKTIME )
function tkMaskEdit_GetDateTimeValue( byval hCtrl as TK_WIDGET ptr ) as TKDATETIME
sub tkMaskEdit_SetDateTimeValue( byval hCtrl as TK_WIDGET ptr, byval v as TKDATETIME )
sub tkMaskEdit_SetMinDate( byval hCtrl as TK_WIDGET ptr, byval d as TKDATE )
sub tkMaskEdit_SetMaxDate( byval hCtrl as TK_WIDGET ptr, byval d as TKDATE )
sub tkMaskEdit_SetMinTime( byval hCtrl as TK_WIDGET ptr, byval t as TKTIME )
sub tkMaskEdit_SetMaxTime( byval hCtrl as TK_WIDGET ptr, byval t as TKTIME )
sub tkMaskEdit_SetMinDateTime( byval hCtrl as TK_WIDGET ptr, byval v as TKDATETIME )
sub tkMaskEdit_SetMaxDateTime( byval hCtrl as TK_WIDGET ptr, byval v as TKDATETIME )
sub tkMaskEdit_ClearDateRange( byval hCtrl as TK_WIDGET ptr )
sub tkMaskEdit_SetPromptChar( byval hCtrl as TK_WIDGET ptr, byref sPrompt as const ustring )
function tkMaskEdit_GetPromptChar( byval hCtrl as TK_WIDGET ptr ) as ustring
sub tkMaskEdit_SetHidePromptOnLeave( byval hCtrl as TK_WIDGET ptr, byval bHide as boolean )
function tkMaskEdit_GetHidePromptOnLeave( byval hCtrl as TK_WIDGET ptr ) as boolean
sub tkMaskEdit_SetValueFormat( byval hCtrl as TK_WIDGET ptr, byval nFormat as int32 )
function tkMaskEdit_GetValueFormat( byval hCtrl as TK_WIDGET ptr ) as int32
sub tkMaskEdit_SetCopyFormat( byval hCtrl as TK_WIDGET ptr, byval nFormat as int32 )
function tkMaskEdit_GetCopyFormat( byval hCtrl as TK_WIDGET ptr ) as int32
sub tkMaskEdit_SetInsertMode( byval hCtrl as TK_WIDGET ptr, byval bInsert as boolean )
function tkMaskEdit_GetInsertMode( byval hCtrl as TK_WIDGET ptr ) as boolean
sub tkMaskEdit_SetShowError( byval hCtrl as TK_WIDGET ptr, byval bShow as boolean )
function tkMaskEdit_GetShowError( byval hCtrl as TK_WIDGET ptr ) as boolean
function tkMaskEdit_GetError( byval hCtrl as TK_WIDGET ptr ) as boolean
function tkMaskEdit_HasFocus( byval hCtrl as TK_WIDGET ptr ) as boolean
sub tkMaskEdit_SetReadOnly( byval hCtrl as TK_WIDGET ptr, byval bReadOnly as boolean )
function tkMaskEdit_GetReadOnly( byval hCtrl as TK_WIDGET ptr ) as boolean
function tkMaskEdit_SetFont( byval hCtrl as TK_WIDGET ptr, byval f as TTF_Font ptr ) as boolean
function tkMaskEdit_GetFont( byval hCtrl as TK_WIDGET ptr ) as TTF_Font ptr
sub tkMaskEdit_ApplyFonts( byval hCtrl as TK_WIDGET ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
sub tkMaskEdit_SetCueBannerText( byval hCtrl as TK_WIDGET ptr, byref sText as const ustring )
function tkMaskEdit_GetCueBannerText( byval hCtrl as TK_WIDGET ptr ) as ustring
sub tkMaskEdit_SetTextAlign( byval hCtrl as TK_WIDGET ptr, byval nAlign as int32 )
function tkMaskEdit_GetTextAlign( byval hCtrl as TK_WIDGET ptr ) as int32
sub tkMaskEdit_SetBorderWidth( byval hCtrl as TK_WIDGET ptr, byval nWidth as integer )
function tkMaskEdit_GetBorderWidth( byval hCtrl as TK_WIDGET ptr ) as integer
sub tkMaskEdit_SetCornerRadius( byval hCtrl as TK_WIDGET ptr, byval nRadius as integer )
function tkMaskEdit_GetCornerRadius( byval hCtrl as TK_WIDGET ptr ) as integer
sub tkMaskEdit_GetColors( byval hCtrl as TK_WIDGET ptr, byval pColors as TKMASKEDIT_COLORS ptr )
sub tkMaskEdit_SetColors( byval hCtrl as TK_WIDGET ptr, byval pColors as TKMASKEDIT_COLORS ptr )
function tkMaskEdit_ThemeColors( byref t as TKTHEME_COLORS ) as TKMASKEDIT_COLORS
sub tkMaskEdit_ApplyTheme( byval hCtrl as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkMaskEdit_UnpinColors( byval hCtrl as TK_WIDGET ptr )
sub tkMaskEdit_SetChangeCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as MSK_ChangeCallbackSub )
sub tkMaskEdit_SetRejectedCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as MSK_RejectedCallbackSub )
sub tkMaskEdit_SetCommitCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as MSK_CommitCallbackSub )
sub tkMaskEdit_SetEnterPressedCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as MSK_EnterPressedCallbackSub )
sub tkMaskEdit_SetFocusCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as MSK_FocusCallbackSub )
```

`vendor/tkControls/tkMaskEditRegex`:

```freebasic
sub tkMaskEditRegex_Enable( )
function tkMaskEditRegex_LastError( ) as ustring
function tkMaskEditRegex_Test( byref pattern as const ustring, byref text as const ustring ) as int32
```

`tkMaskEditRegex_Test` answers 0 when the text cannot become a match, 1 when it can, 2 when it is
one, and -1 for a bad pattern.

### See also

- [tkControls](Category-tkControls)
- [tkTextBox](tkTextBox), the text box inside; [tkNumericUpDown](tkNumericUpDown), a number with
  spin buttons; [tkDatePicker](tkDatePicker) and [tkTimePicker](tkTimePicker), a date or time
  picked from a dropdown
- [tkDataGrid](tkDataGrid), masked columns
- [Form Designer](Form-Designer), data binding
