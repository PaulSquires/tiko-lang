[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkDatePicker**

# tkDatePicker

Shows an editable date field with a calendar icon that drops down a month calendar.

`tkDatePicker` is the [tkControls](Category-tkControls) date entry. Typing a date into the field
and picking one from the drop-down calendar are two routes to the same `TKDATE` value. The field
is a borderless [tkTextBox](tkTextBox), so caret, selection, undo, paste and the right-click menu
are the text box's; the drop-down is a [tkCalendar](tkCalendar) in a popup, with an optional
"Today: ..." band underneath.

Your program owns the text format: a format callback turns a date into text and a parse callback
turns text back into a date. Without them the field uses ISO `yyyy-MM-dd`. Typed text commits on
Enter or when focus leaves the field; text that does not parse silently reverts. The
date-changed callback runs only for a real change by the user. The setters are silent.

F4, Down or Alt+Down opens the calendar. While it is open its own keys work (arrows, Page
Up/Page Down, Home/End, Enter picks), one click on a day picks it, and Escape or a click outside
closes it.

## Importing

```freebasic
#import "vendor/tkControls/tkDatePicker"

using tkDatePicker
using tkHost
using tkCalendar
```

The module brings in [tkHost](tkHost) (and through it [tkPaint](tkPaint), SDL3, SDL_ttf and
SDL_image), [tkTheme](tkTheme), [tkTooltip](tkTooltip), [tkTextBox](tkTextBox) and
[tkCalendar](tkCalendar). `using tkCalendar` names `TKDATE` and `tkCalendar_LocalToday`.

## Example

`host` is a `TK_HOST ptr` from `tkHost_Create`, set up as in the [tkButton](tkButton) example.

```freebasic
sub Due_Changed( byval hCtrl as TK_WIDGET ptr, byval pDate as TKDATE ptr, byval bHasDate as boolean )
    if bHasDate then
        print "due " & pDate->wYear & "-" & pDate->wMonth & "-" & pDate->wDay
    else
        print "no due date"
    end if
end sub

dim as TKDATE today = tkCalendar_LocalToday()
dim as TKDATE last = tkDatePicker_MakeDate( today.wYear + 1, 12, 31 )

dim as TK_WIDGET ptr due = tkDatePicker_Create( tkHost_Root( host ), 6000 )
tkDatePicker_SetWeekStart( due, DTP_MONDAY )
tkDatePicker_SetRange( due, today, last, true, true )
tkDatePicker_SetAllowEmpty( due, true )
tkDatePicker_SetShowTodayFooter( due, true )
tkDatePicker_SetDate( due, today )                  ' silent: no callback
tkDatePicker_SetDateChangedCallback( due, @Due_Changed )

dim as long w, h
tkDatePicker_GetIdealSize( due, w, h )
tkWidget_SetPos( due, tkHost_Scale( host, 20 ), tkHost_Scale( host, 20 ), w, h )
```

## Coming from PsDatePicker

[PsDatePicker](PsDatePicker) is the Win32 twin; its page remains the behaviour reference for
everything not listed here.

- Names: `PsDatePicker_*` → `tkDatePicker_*`, `PSDATEPICKER_*` types → `TKDATEPICKER_*`.
  `DTP_*` constants, the `DTP_*Callback*` types and `CDTP_DEFAULT_*` keep their names. Dates are
  `TKDATE` (from [tkCalendar](tkCalendar)) instead of `SYSTEMTIME`. The handle is
  `TK_WIDGET ptr`.
- `tkDatePicker_Create( hParent, CtrlID )` takes a `TK_WIDGET ptr` parent; for a top-level
  control pass `tkHost_Root( host )`.
- The drop-down is a [tkCalendar](tkCalendar), so it has that control's look, captions and
  keyboard. `tkDatePicker_GetCalendarHandle` returns it only while it is open, and 0 otherwise.
- The popup is rebuilt from the picker's settings at every open.
- The icon is drawn from rectangles until you give a glyph font (`tkDatePicker_SetIconFont` or
  the glyph argument of `ApplyFonts`); then it draws `TK_ICON_CALENDAR` from the bundled icon
  font. Fonts are `TTF_Font ptr`.
- The date-changed callback fires only for a real change, not for re-picking the same day.
- The tooltip is the calendar's, with [tkTooltip](tkTooltip) timing, and appears only when a
  tooltip callback is set. `tkDatePicker_GetTooltipHandle` returns a `TK_TIP ptr`; there is no
  tooltip mode.
- The message callback sees `TKM_*` messages, and the field's messages arrive as the picker's.
- Scale changes reach the control as `TKM_SCALECHANGED` and close an open calendar; there is no
  `Rescale` call.
- No equivalent: `FilterMessage`, `TestPrepareCalendar`, `DTP_CM_*`, `DTP_HIT_*`, PsRegistry.
- Added: `tkDatePicker_SetToday` (pin "today" for the ring and the band), `GetPopup`,
  `GetFooterHandle` and `GetIconHot`.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const CDTP_DEFAULT_ICONWIDTH = 28
const CDTP_DEFAULT_FIELDPAD = 6
const CDTP_DEFAULT_VERTPAD = 5
const CDTP_DEFAULT_CORNERRADIUS = 6
const CDTP_DEFAULT_BORDERTHICK = 1 ' never scaled: a hairline
const CDTP_DEFAULT_DIVIDERTHICK = 1 ' never scaled
const CDTP_DEFAULT_ICONGLYPH = TK_ICON_CALENDAR
const CDTP_CAL_BORDERTHICK = 1 ' the popup's outline; never scaled
const CDTP_CAL_FOOTERH = 30 ' the Today band

enum
    DTP_SUNDAY = 0
    DTP_MONDAY = 1
end enum

enum
    DTP_VIEW_DAYS = 0
    DTP_VIEW_MONTHS
    DTP_VIEW_YEARS
end enum
```

### Types

```freebasic
type TKDATEPICKER_COLORS
    BackColor                as ulong = &hFF21252Bul    ' behind the rounded corners
    BorderColor              as ulong = &hFF3C424Dul
    FocusBorderColor         as ulong = &hFF569CD6ul    ' while the field has focus
    BorderColorDisabled      as ulong = &hFF30343Cul
    DividerColor             as ulong = &hFF3C424Dul
    DividerColorDisabled     as ulong = &hFF30343Cul
    FieldBackColor           as ulong = &hFF2C313Aul
    FieldForeColor           as ulong = &hFFD7DAE0ul
    FieldBackColorDisabled   as ulong = &hFF262A31ul
    FieldForeColorDisabled   as ulong = &hFF5A606Aul
    IconColor                as ulong = &hFF2C313Aul    ' = FieldBackColor (flat at rest)
    IconGlyphColor           as ulong = &hFFBEC4CEul
    IconGlyphColorHot        as ulong = &hFFFFFFFFul
    IconBackColorHot         as ulong = &hFF383E49ul
    IconGlyphColorDisabled   as ulong = &hFF5A606Aul
    CalBackColor             as ulong = &hFF21252Bul
    CalBorderColor           as ulong = &hFF464C58ul
    TitleColor               as ulong = &hFFE1E4EAul
    TitleColorHot            as ulong = &hFFFFFFFFul
    NavGlyphColor            as ulong = &hFFBEC4CEul
    NavGlyphColorHot         as ulong = &hFFFFFFFFul
    NavGlyphColorDisabled    as ulong = &hFF464A52ul
    WeekdayColor             as ulong = &hFF8C929Cul
    DayColor                 as ulong = &hFFD2D6DCul
    DayColorWeekend          as ulong = &hFF96AFCDul
    DayColorAdjacent         as ulong = &hFF7C838Eul    ' still clickable: keep it far from Disabled
    DayColorDisabled         as ulong = &hFF383C44ul    ' out of range, inert
    DayBackColorHot          as ulong = &hFF343A44ul
    DayForeColorHot          as ulong = &hFFFFFFFFul
    DayBackColorSelected     as ulong = &hFF0078D7ul
    DayForeColorSelected     as ulong = &hFFFFFFFFul
    TodayRingColor           as ulong = &hFF569CD6ul
    TodayFooterColor         as ulong = &hFFAAB0BAul
    TodayFooterColorHot      as ulong = &hFFFFFFFFul
    TodayFooterColorDisabled as ulong = &hFF464A52ul    ' today is outside the range
end type

type TKDATEPICKER_PAINTINFO
    hCtrl       as TK_WIDGET ptr
    b           as TK_PAINT ptr
    rcClient    as TKRECT
    rcFrame     as TKRECT
    rcField     as TKRECT
    rcDiv       as TKRECT
    rcIcon      as TKRECT
    isEnabled   as boolean
    isFocused   as boolean
    isOpen      as boolean
    iconHot     as boolean
    iconPressed as boolean
end type

type TKDATEPICKER_DAYPAINTINFO
    hCtrl       as TK_WIDGET ptr       ' the PICKER, not the calendar
    b           as TK_PAINT ptr
    rcCell      as TKRECT              ' calendar-local pixels
    stDate      as TKDATE
    dayNumber   as long
    monthIndex  as long                ' 0 = left / only panel, 1 = right
    isAdjacent  as boolean
    isWeekend   as boolean
    isToday     as boolean
    isSelected  as boolean
    isHot       as boolean
    isDisabled  as boolean
    isEnabled   as boolean
end type

type TKDATEPICKER_MESSAGEINFO
    hCtrl       as TK_WIDGET ptr       ' the picker, also for a message that reached the field
    msg         as long                ' TKM_* (or TKTEXTBOX_MSG_CONTEXTMENU from the field)
    x           as single
    y           as single
    key         as long
    mods        as long
    text        as string
end type

type TKDATEPICKER_TOOLTIPINFO
    hCtrl       as TK_WIDGET ptr
    stDate      as TKDATE
    isValid     as boolean
    outText     as ustring
end type

type TKDATEPICKER_STATE   ' per-instance state; reach it through the procedures

type DTP_ParseCallbackFunc as function( byval hCtrl as TK_WIDGET ptr, byval sText as ustring, byval pDate as TKDATE ptr ) as boolean
type DTP_FormatCallbackSub as sub( byval hCtrl as TK_WIDGET ptr, byval pDate as TKDATE ptr, byref sOut as ustring )
type DTP_DateChangedCallbackSub as sub( byval hCtrl as TK_WIDGET ptr, byval pDate as TKDATE ptr, byval bHasDate as boolean )
type DTP_DropDownCallbackSub as sub( byval hCtrl as TK_WIDGET ptr, byval isOpen as boolean )
type DTP_PaintCallbackSub as sub( byval p as TKDATEPICKER_PAINTINFO ptr )
type DTP_DayPaintCallbackSub as sub( byval p as TKDATEPICKER_DAYPAINTINFO ptr )
type DTP_MessageCallbackFunc as function( byval m as TKDATEPICKER_MESSAGEINFO ptr ) as boolean
type DTP_TooltipCallbackFunc as function( byval t as TKDATEPICKER_TOOLTIPINFO ptr ) as boolean
```

### Procedures

```freebasic
function tkDatePicker_IsLeapYear( byval y as long ) as boolean
function tkDatePicker_DaysInMonth( byval y as long, byval m as long ) as long
function tkDatePicker_DateToSerial( byval y as long, byval m as long, byval d as long ) as longint
sub tkDatePicker_SerialToDate( byval serial as longint, byref y as long, byref m as long, byref d as long )
function tkDatePicker_DowSunday( byval y as long, byval m as long, byval d as long ) as long
function tkDatePicker_LeadingCells( byval y as long, byval m as long, byval nWeekStart as long ) as long
function tkDatePicker_MakeDate( byval y as long, byval m as long, byval d as long ) as TKDATE
function tkDatePicker_AddMonths( byref st as TKDATE, byval delta as long ) as TKDATE
function tkDatePicker_DecadeBase( byval y as long ) as long
function tkDatePicker_Create( byval hParent as TK_WIDGET ptr, byval CtrlID as long ) as TK_WIDGET ptr
function tkDatePicker_GetTextBoxHandle( byval hCtrl as TK_WIDGET ptr ) as TK_WIDGET ptr
function tkDatePicker_GetCalendarHandle( byval hCtrl as TK_WIDGET ptr ) as TK_WIDGET ptr
function tkDatePicker_GetPopup( byval hCtrl as TK_WIDGET ptr ) as TK_HOST ptr
function tkDatePicker_GetFooterHandle( byval hCtrl as TK_WIDGET ptr ) as TK_WIDGET ptr
function tkDatePicker_HasFocus( byval hCtrl as TK_WIDGET ptr ) as boolean
function tkDatePicker_GetDate( byval hCtrl as TK_WIDGET ptr, byref st as TKDATE ) as boolean
sub tkDatePicker_SetDate( byval hCtrl as TK_WIDGET ptr, byref st as TKDATE )
sub tkDatePicker_ClearDate( byval hCtrl as TK_WIDGET ptr )
function tkDatePicker_HasDate( byval hCtrl as TK_WIDGET ptr ) as boolean
sub tkDatePicker_GetRange( byval hCtrl as TK_WIDGET ptr, byref stMin as TKDATE, byref stMax as TKDATE, byref bHasMin as boolean, byref bHasMax as boolean )
sub tkDatePicker_SetRange( byval hCtrl as TK_WIDGET ptr, byref stMin as TKDATE, byref stMax as TKDATE, byval bHasMin as boolean, byval bHasMax as boolean )
function tkDatePicker_GetAllowEmpty( byval hCtrl as TK_WIDGET ptr ) as boolean
sub tkDatePicker_SetAllowEmpty( byval hCtrl as TK_WIDGET ptr, byval bAllow as boolean )
sub tkDatePicker_ReformatText( byval hCtrl as TK_WIDGET ptr )
sub tkDatePicker_SetToday( byval hCtrl as TK_WIDGET ptr, byref st as TKDATE, byval bPin as boolean = true )
function tkDatePicker_GetWeekStart( byval hCtrl as TK_WIDGET ptr ) as long
sub tkDatePicker_SetWeekStart( byval hCtrl as TK_WIDGET ptr, byval nWeekStart as long )
function tkDatePicker_GetMonthCount( byval hCtrl as TK_WIDGET ptr ) as long
sub tkDatePicker_SetMonthCount( byval hCtrl as TK_WIDGET ptr, byval nCount as long )
function tkDatePicker_GetShowToday( byval hCtrl as TK_WIDGET ptr ) as boolean
sub tkDatePicker_SetShowToday( byval hCtrl as TK_WIDGET ptr, byval bShow as boolean )
function tkDatePicker_GetShowTodayFooter( byval hCtrl as TK_WIDGET ptr ) as boolean
sub tkDatePicker_SetShowTodayFooter( byval hCtrl as TK_WIDGET ptr, byval bShow as boolean )
sub tkDatePicker_DropDown( byval hCtrl as TK_WIDGET ptr )
sub tkDatePicker_CloseUp( byval hCtrl as TK_WIDGET ptr )
function tkDatePicker_IsDroppedDown( byval hCtrl as TK_WIDGET ptr ) as boolean
function tkDatePicker_GetFont( byval hCtrl as TK_WIDGET ptr ) as TTF_Font ptr
sub tkDatePicker_SetFont( byval hCtrl as TK_WIDGET ptr, byval f as TTF_Font ptr )
function tkDatePicker_GetIconFont( byval hCtrl as TK_WIDGET ptr ) as TTF_Font ptr
sub tkDatePicker_SetIconFont( byval hCtrl as TK_WIDGET ptr, byval f as TTF_Font ptr )
function tkDatePicker_GetIconGlyph( byval hCtrl as TK_WIDGET ptr ) as ustring
sub tkDatePicker_SetIconGlyph( byval hCtrl as TK_WIDGET ptr, byval sGlyph as ustring )
function tkDatePicker_GetIconWidth( byval hCtrl as TK_WIDGET ptr ) as long
sub tkDatePicker_SetIconWidth( byval hCtrl as TK_WIDGET ptr, byval nWidth as long )
function tkDatePicker_GetCornerRadius( byval hCtrl as TK_WIDGET ptr ) as long
sub tkDatePicker_SetCornerRadius( byval hCtrl as TK_WIDGET ptr, byval nRadius as long )
function tkDatePicker_GetBorderThickness( byval hCtrl as TK_WIDGET ptr ) as long
sub tkDatePicker_SetBorderThickness( byval hCtrl as TK_WIDGET ptr, byval nThickness as long )
sub tkDatePicker_GetIdealSize( byval hCtrl as TK_WIDGET ptr, byref nWidth as long, byref nHeight as long )
function tkDatePicker_GetEnabled( byval hCtrl as TK_WIDGET ptr ) as boolean
sub tkDatePicker_SetEnabled( byval hCtrl as TK_WIDGET ptr, byval isEnabled as boolean )
sub tkDatePicker_Refresh( byval hCtrl as TK_WIDGET ptr )
function tkDatePicker_GetFrameRect( byval hCtrl as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkDatePicker_GetFieldRect( byval hCtrl as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkDatePicker_GetIconRect( byval hCtrl as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkDatePicker_HitTest( byval hCtrl as TK_WIDGET ptr, byval pt as TKPOINT ) as long
function tkDatePicker_GetIconHot( byval hCtrl as TK_WIDGET ptr ) as boolean
sub tkDatePicker_GetColors( byval hCtrl as TK_WIDGET ptr, byval pColors as TKDATEPICKER_COLORS ptr )
sub tkDatePicker_SetColors( byval hCtrl as TK_WIDGET ptr, byval pColors as TKDATEPICKER_COLORS ptr )
function tkDatePicker_ThemeColors( byref t as TKTHEME_COLORS ) as TKDATEPICKER_COLORS
sub tkDatePicker_ApplyTheme( byval hCtrl as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkDatePicker_UnpinColors( byval hCtrl as TK_WIDGET ptr )
sub tkDatePicker_ApplyFonts( byval hCtrl as TK_WIDGET ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
sub tkDatePicker_SetParseCallback( byval hCtrl as TK_WIDGET ptr, byval userfunc as DTP_ParseCallbackFunc )
sub tkDatePicker_SetFormatCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as DTP_FormatCallbackSub )
sub tkDatePicker_SetDateChangedCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as DTP_DateChangedCallbackSub )
sub tkDatePicker_SetDropDownCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as DTP_DropDownCallbackSub )
sub tkDatePicker_SetPaintCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as DTP_PaintCallbackSub )
sub tkDatePicker_SetDayPaintCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as DTP_DayPaintCallbackSub )
sub tkDatePicker_SetMessageCallback( byval hCtrl as TK_WIDGET ptr, byval userfunc as DTP_MessageCallbackFunc )
sub tkDatePicker_SetTooltipCallback( byval hCtrl as TK_WIDGET ptr, byval userfunc as DTP_TooltipCallbackFunc )
function tkDatePicker_GetTooltipHandle( byval hCtrl as TK_WIDGET ptr ) as TK_TIP ptr
function tkDatePicker_TestCalendarTones( byval hCtrl as TK_WIDGET ptr ) as long
function tkDatePicker_TestPartBrightness( byval hCtrl as TK_WIDGET ptr, byval nPart as long ) as long
function tkDatePicker_TestFooterTones( byval hCtrl as TK_WIDGET ptr ) as long
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsDatePicker](PsDatePicker), the PsControls control
