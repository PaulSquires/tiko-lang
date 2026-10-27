[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkCalendar**

# tkCalendar

Draws a month calendar, one month or a grid of up to twelve, with drill-down to years.

`tkCalendar` is the [tkControls](Category-tkControls) date surface: a child control that shows
one month, or a grid of panels, under a shared navigation band, with one selectable day, an
optional min/max range and a drill-down from days to months to years. It is not a date field;
for typed entry with a drop-down calendar use [tkDatePicker](tkDatePicker), which embeds this
control.

Dates are `TKDATE` values (`wYear`, `wMonth`, `wDayOfWeek`, `wDay`), and the module carries the
date arithmetic to go with them (`tkCalendar_MakeDate`, `AddDays`, `AddMonths`, `DaysInMonth`,
`LocalToday` and more). The setters are silent; `tkCalendar_SelectDate` and
`tkCalendar_Activate` are the two notifying actions. Month and weekday names can be replaced for
localisation, individual day cells can be painted by a callback, and the whole renderer can be
replaced.

## Importing

```freebasic
#import "vendor/tkControls/tkCalendar"

using tkCalendar
using tkHost
```

The module brings in [tkHost](tkHost) (and through it [tkPaint](tkPaint), SDL3, SDL_ttf and
SDL_image), [tkTheme](tkTheme) and [tkTooltip](tkTooltip). Add `using tkPaint` for a paint
callback.

## Example

`host` is a `TK_HOST ptr` from `tkHost_Create`, set up as in the [tkButton](tkButton) example.

```freebasic
sub Cal_SelChange( byval hCtrl as TK_WIDGET ptr, byval pDate as TKDATE ptr, byval bHasDate as boolean )
    if bHasDate then print "selected " & pDate->wYear & "-" & pDate->wMonth & "-" & pDate->wDay
end sub

sub Cal_Activated( byval hCtrl as TK_WIDGET ptr, byval pDate as TKDATE ptr )
    print "chosen (Enter or double-click)"
end sub

dim as TKDATE today = tkCalendar_LocalToday()
dim as TKDATE stLo = tkCalendar_AddDays( today, -10 ), stHi = tkCalendar_AddDays( today, 45 )

dim as TK_WIDGET ptr cal = tkCalendar_Create( tkHost_Root( host ), 7000 )
tkCalendar_SetPanelGrid( cal, 2, 1 )                ' two months side by side
tkCalendar_SetNavStep( cal, 1 )                     ' the chevrons slide one month
tkCalendar_SetWeekStart( cal, CAL_MONDAY )
tkCalendar_SetRange( cal, stLo, stHi, true, true )
tkCalendar_SetSelDate( cal, today )                 ' silent: no callback
tkCalendar_SetSelChangeCallback( cal, @Cal_SelChange )
tkCalendar_SetDateActivatedCallback( cal, @Cal_Activated )

dim as long w, h
tkCalendar_GetIdealSize( cal, w, h )               ' valid before the control is sized
tkWidget_SetPos( cal, tkHost_Scale( host, 20 ), tkHost_Scale( host, 20 ), w, h )
```

## Coming from PsCalendar

[PsCalendar](PsCalendar) is the Win32 twin; its page remains the behaviour reference for
everything not listed here.

- Names: `PsCalendar_*` → `tkCalendar_*`, `PSCALENDAR_*` types → `TKCALENDAR_*`. `CCAL_*`,
  `CAL_*`, `CAL_HITRESULT` and the `CAL_*Callback*` types keep their names. `SYSTEMTIME` →
  `TKDATE` (its date half, same field names), `POINT` → `TKPOINT`, `RECT` → `TKRECT`, `HFONT` →
  `TTF_Font ptr`. The handle is `TK_WIDGET ptr`.
- `tkCalendar_Create( hParent, ctrlId )` takes a `TK_WIDGET ptr` parent; for a top-level control
  pass `tkHost_Root( host )`.
- A key the calendar does not claim bubbles to the parent widget, so Escape in the days view
  still reaches the window.
- `TKCALENDAR_MESSAGEINFO` carries `msg` (a `TKM_*` code), `x`, `y`, `key`, `mods` and `clicks`
  instead of `uMsg` / `wParam` / `lParam`.
- The tooltip is a [tkTooltip](tkTooltip), built on the first day cell whose callback supplies
  text; `tkCalendar_GetTooltipHandle` returns its `TK_TIP ptr` (0 until then). There is no
  tooltip mode.
- Scale changes reach the control as `TKM_SCALECHANGED`; there is no `Rescale` call.
- No equivalent: PsRegistry.
- Added: `tkCalendar_SetToday` (a fixed "today"; `Refresh` returns to the clock),
  `tkCalendar_SetViewChangeCallback` (runs after the user moves the page or changes the view),
  `tkCalendar_LocalToday`, `GetMyFocus` and `GetHot`.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const CCAL_PAD = 8
const CCAL_NAVBANDH = 34
const CCAL_NAVGAP = 4
const CCAL_CHEVW = 28
const CCAL_GUTTERX = 12
const CCAL_GUTTERY = 10
const CCAL_CAPTIONH = 24
const CCAL_WEEKDAYH = 22
const CCAL_CELLMINW = 34
const CCAL_CELLMINH = 30
const CCAL_DEFAULT_BORDERTHICK = 0
const CCAL_DEFAULT_CHEVTHICK = 2
const CCAL_DEFAULT_FOCUSTHICK = 1
const CCAL_MY_COLS = 3
const CCAL_MY_ROWS = 4
const CCAL_MIN_YEAR = 1
const CCAL_MAX_YEAR = 9999
const CCAL_MAX_PANELS = 12
const CAL_PART_MYCELL_BASE = 100
const CAL_PART_DAYCELL_BASE = 1000

enum
    CAL_SUNDAY = 0
    CAL_MONDAY = 1
end enum

enum
    CAL_VIEW_DAYS = 0
    CAL_VIEW_MONTHS
    CAL_VIEW_YEARS
end enum

enum
    CAL_HIT_NONE = 0
    CAL_HIT_PREV
    CAL_HIT_NEXT
    CAL_HIT_TITLE
    CAL_HIT_DAYCELL
    CAL_HIT_MONTHCELL
    CAL_HIT_YEARCELL
end enum

enum
    CAL_PART_CLIENT  = 0
    CAL_PART_NAVBAND = 1
    CAL_PART_PREV    = 2
    CAL_PART_NEXT    = 3
    CAL_PART_TITLE   = 4
    CAL_PART_GRID    = 5
end enum
```

### Types

```freebasic
type TKDATE
    wYear      as long
    wMonth     as long
    wDayOfWeek as long
    wDay       as long
end type

type CAL_HITRESULT
    part   as long = CAL_HIT_NONE
    panel  as long = -1
    index  as long = -1
end type

type TKCALENDAR_COLORS
    BackColor              as ulong = &hFF21252Bul
    BorderColor            as ulong = &hFF464C58ul
    FocusRingColor         as ulong = &hFF569CD6ul
    TitleColor             as ulong = &hFFE1E4EAul
    TitleColorHot          as ulong = &hFFFFFFFFul
    CaptionColor           as ulong = &hFFC8CDD5ul
    NavGlyphColor          as ulong = &hFFBEC4CEul
    NavGlyphColorHot       as ulong = &hFFFFFFFFul
    NavGlyphColorDisabled  as ulong = &hFF464A52ul
    WeekdayColor           as ulong = &hFF8C929Cul
    DayColor               as ulong = &hFFD2D6DCul
    DayColorWeekend        as ulong = &hFF96AFCDul
    DayColorAdjacent       as ulong = &hFF7C838Eul     ' still clickable: keep it far from Disabled
    DayColorDisabled       as ulong = &hFF383C44ul     ' out of range, inert
    DayBackColorHot        as ulong = &hFF343A44ul
    DayForeColorHot        as ulong = &hFFFFFFFFul
    DayBackColorSelected   as ulong = &hFF0078D7ul
    DayForeColorSelected   as ulong = &hFFFFFFFFul
    TodayRingColor         as ulong = &hFF569CD6ul
end type

type TKCALENDAR_PAINTINFO
    hCtrl          as TK_WIDGET ptr
    b              as TK_PAINT ptr
    rcClient       as TKRECT
    rcInner        as TKRECT
    rcNavBand      as TKRECT
    rcPrev         as TKRECT
    rcTitle        as TKRECT
    rcNext         as TKRECT
    rcGrid         as TKRECT
    eView          as long
    nCols          as long
    nRows          as long
    panelCount     as long
    isEnabled      as boolean
    isFocused      as boolean
    isPrevDisabled as boolean
    isNextDisabled as boolean
    hotPart        as long
    hotPanel       as long
    hotIndex       as long
end type

type TKCALENDAR_DAYPAINTINFO
    hCtrl       as TK_WIDGET ptr
    b           as TK_PAINT ptr
    rcCell      as TKRECT
    stDate      as TKDATE
    dayNumber   as long
    panelIndex  as long
    cellIndex   as long
    isAdjacent  as boolean
    isWeekend   as boolean
    isToday     as boolean
    isSelected  as boolean     ' exactly ONE cell per render
    isHot       as boolean
    isFocused   as boolean
    isDisabled  as boolean
    isEnabled   as boolean
end type

type TKCALENDAR_MYPAINTINFO
    hCtrl       as TK_WIDGET ptr
    b           as TK_PAINT ptr
    rcCell      as TKRECT
    eView       as long
    cellIndex   as long
    nValue      as long
    wszLabel    as ustring
    isSelected  as boolean
    isHot       as boolean
    isFocused   as boolean
    isDimmed    as boolean
    isEnabled   as boolean
end type

type TKCALENDAR_MESSAGEINFO
    hCtrl       as TK_WIDGET ptr
    msg         as long
    x           as single
    y           as single
    key         as long
    mods        as long
    clicks      as long
end type

type TKCALENDAR_TOOLTIPINFO
    hCtrl       as TK_WIDGET ptr
    stDate      as TKDATE
    isValid     as boolean
    outText     as ustring
end type

type TKCALENDAR_STATE   ' per-instance state; reach it through the procedures

type CAL_SelChangeCallbackSub as sub( byval hCtrl as TK_WIDGET ptr, byval pDate as TKDATE ptr, byval bHasDate as boolean )
type CAL_DateActivatedCallbackSub as sub( byval hCtrl as TK_WIDGET ptr, byval pDate as TKDATE ptr )
type CAL_PaintCallbackSub as sub( byval p as TKCALENDAR_PAINTINFO ptr )
type CAL_DayPaintCallbackSub as sub( byval p as TKCALENDAR_DAYPAINTINFO ptr )
type CAL_MonthYearPaintCallbackSub as sub( byval p as TKCALENDAR_MYPAINTINFO ptr )
type CAL_MessageCallbackFunc as function( byval m as TKCALENDAR_MESSAGEINFO ptr ) as boolean
type CAL_TooltipCallbackFunc as function( byval t as TKCALENDAR_TOOLTIPINFO ptr ) as boolean
type CAL_ViewChangeCallbackSub as sub( byval hCtrl as TK_WIDGET ptr, byval eView as long, byval pAnchor as TKDATE ptr )
```

### Procedures

```freebasic
function tkCalendar_IsLeapYear( byval y as long ) as boolean
function tkCalendar_DaysInMonth( byval y as long, byval m as long ) as long
function tkCalendar_DateToSerial( byval y as long, byval m as long, byval d as long ) as longint
sub tkCalendar_SerialToDate( byval serial as longint, byref y as long, byref m as long, byref d as long )
function tkCalendar_DowSunday( byval y as long, byval m as long, byval d as long ) as long
function tkCalendar_LeadingCells( byval y as long, byval m as long, byval nWeekStart as long ) as long
function tkCalendar_MakeDate( byval y as long, byval m as long, byval d as long ) as TKDATE
function tkCalendar_AddMonths( byref st as TKDATE, byval delta as long ) as TKDATE
function tkCalendar_AddDays( byref st as TKDATE, byval delta as long ) as TKDATE
function tkCalendar_DecadeBase( byval y as long ) as long
function tkCalendar_LocalToday() as TKDATE
function tkCalendar_Create( byval hParent as TK_WIDGET ptr, byval ctrlId as long ) as TK_WIDGET ptr
function tkCalendar_GetSelDate( byval hCtrl as TK_WIDGET ptr, byref st as TKDATE ) as boolean
sub tkCalendar_SetSelDate( byval hCtrl as TK_WIDGET ptr, byref st as TKDATE )
sub tkCalendar_ClearSelDate( byval hCtrl as TK_WIDGET ptr )
function tkCalendar_HasSelDate( byval hCtrl as TK_WIDGET ptr ) as boolean
sub tkCalendar_SelectDate( byval hCtrl as TK_WIDGET ptr, byref st as TKDATE )
sub tkCalendar_Activate( byval hCtrl as TK_WIDGET ptr )
sub tkCalendar_GetRange( byval hCtrl as TK_WIDGET ptr, byref stMin as TKDATE, byref stMax as TKDATE, byref bHasMin as boolean, byref bHasMax as boolean )
sub tkCalendar_SetRange( byval hCtrl as TK_WIDGET ptr, byref stMin as TKDATE, byref stMax as TKDATE, byval bHasMin as boolean, byval bHasMax as boolean )
function tkCalendar_GetToday( byval hCtrl as TK_WIDGET ptr, byref st as TKDATE ) as boolean
sub tkCalendar_SetToday( byval hCtrl as TK_WIDGET ptr, byref st as TKDATE )
function tkCalendar_GetAnchorDate( byval hCtrl as TK_WIDGET ptr, byref st as TKDATE ) as boolean
sub tkCalendar_SetAnchorDate( byval hCtrl as TK_WIDGET ptr, byref st as TKDATE )
function tkCalendar_GetView( byval hCtrl as TK_WIDGET ptr ) as long
sub tkCalendar_SetView( byval hCtrl as TK_WIDGET ptr, byval eView as long )
function tkCalendar_GetTitleText( byval hCtrl as TK_WIDGET ptr ) as ustring
function tkCalendar_GetWeekStart( byval hCtrl as TK_WIDGET ptr ) as long
sub tkCalendar_SetWeekStart( byval hCtrl as TK_WIDGET ptr, byval nWeekStart as long )
sub tkCalendar_GetPanelGrid( byval hCtrl as TK_WIDGET ptr, byref nCols as long, byref nRows as long )
sub tkCalendar_SetPanelGrid( byval hCtrl as TK_WIDGET ptr, byval nCols as long, byval nRows as long )
function tkCalendar_GetPanelCount( byval hCtrl as TK_WIDGET ptr ) as long
function tkCalendar_GetNavStep( byval hCtrl as TK_WIDGET ptr ) as long
sub tkCalendar_SetNavStep( byval hCtrl as TK_WIDGET ptr, byval nStep as long )
function tkCalendar_GetShowTodayRing( byval hCtrl as TK_WIDGET ptr ) as boolean
sub tkCalendar_SetShowTodayRing( byval hCtrl as TK_WIDGET ptr, byval bShow as boolean )
function tkCalendar_IsPrevDisabled( byval hCtrl as TK_WIDGET ptr ) as boolean
function tkCalendar_IsNextDisabled( byval hCtrl as TK_WIDGET ptr ) as boolean
function tkCalendar_GetMonthName( byval hCtrl as TK_WIDGET ptr, byval m as long ) as ustring
sub tkCalendar_SetMonthName( byval hCtrl as TK_WIDGET ptr, byval m as long, byval sName as ustring )
function tkCalendar_GetMonthAbbrev( byval hCtrl as TK_WIDGET ptr, byval m as long ) as ustring
sub tkCalendar_SetMonthAbbrev( byval hCtrl as TK_WIDGET ptr, byval m as long, byval sName as ustring )
function tkCalendar_GetWeekdayAbbrev( byval hCtrl as TK_WIDGET ptr, byval i as long ) as ustring
sub tkCalendar_SetWeekdayAbbrev( byval hCtrl as TK_WIDGET ptr, byval i as long, byval sName as ustring )
sub tkCalendar_SetMonthNames( byval hCtrl as TK_WIDGET ptr, sNames() as ustring )
sub tkCalendar_SetMonthAbbrevs( byval hCtrl as TK_WIDGET ptr, sNames() as ustring )
sub tkCalendar_SetWeekdayAbbrevs( byval hCtrl as TK_WIDGET ptr, sNames() as ustring )
function tkCalendar_GetFont( byval hCtrl as TK_WIDGET ptr ) as TTF_Font ptr
sub tkCalendar_SetFont( byval hCtrl as TK_WIDGET ptr, byval f as TTF_Font ptr )
function tkCalendar_GetTitleFont( byval hCtrl as TK_WIDGET ptr ) as TTF_Font ptr
sub tkCalendar_SetTitleFont( byval hCtrl as TK_WIDGET ptr, byval f as TTF_Font ptr )
function tkCalendar_GetWeekdayFont( byval hCtrl as TK_WIDGET ptr ) as TTF_Font ptr
sub tkCalendar_SetWeekdayFont( byval hCtrl as TK_WIDGET ptr, byval f as TTF_Font ptr )
sub tkCalendar_ApplyFonts( byval hCtrl as TK_WIDGET ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
function tkCalendar_GetBorderThickness( byval hCtrl as TK_WIDGET ptr ) as long
sub tkCalendar_SetBorderThickness( byval hCtrl as TK_WIDGET ptr, byval nThickness as long )
function tkCalendar_GetChevronThickness( byval hCtrl as TK_WIDGET ptr ) as long
sub tkCalendar_SetChevronThickness( byval hCtrl as TK_WIDGET ptr, byval nThickness as long )
function tkCalendar_GetPadding( byval hCtrl as TK_WIDGET ptr ) as long
sub tkCalendar_SetPadding( byval hCtrl as TK_WIDGET ptr, byval nPad as long )
sub tkCalendar_GetGutters( byval hCtrl as TK_WIDGET ptr, byref nGutterX as long, byref nGutterY as long )
sub tkCalendar_SetGutters( byval hCtrl as TK_WIDGET ptr, byval nGutterX as long, byval nGutterY as long )
sub tkCalendar_GetCellMinSize( byval hCtrl as TK_WIDGET ptr, byref nW as long, byref nH as long )
sub tkCalendar_SetCellMinSize( byval hCtrl as TK_WIDGET ptr, byval nW as long, byval nH as long )
sub tkCalendar_GetIdealSize( byval hCtrl as TK_WIDGET ptr, byref nWidth as long, byref nHeight as long )
function tkCalendar_GetEnabled( byval hCtrl as TK_WIDGET ptr ) as boolean
sub tkCalendar_SetEnabled( byval hCtrl as TK_WIDGET ptr, byval isEnabled as boolean )
function tkCalendar_HasFocus( byval hCtrl as TK_WIDGET ptr ) as boolean
sub tkCalendar_Refresh( byval hCtrl as TK_WIDGET ptr )
function tkCalendar_HitTest( byval hCtrl as TK_WIDGET ptr, byval pt as TKPOINT ) as CAL_HITRESULT
function tkCalendar_GetInnerRect( byval hCtrl as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkCalendar_GetNavBandRect( byval hCtrl as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkCalendar_GetPrevRect( byval hCtrl as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkCalendar_GetNextRect( byval hCtrl as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkCalendar_GetTitleRect( byval hCtrl as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkCalendar_GetGridRect( byval hCtrl as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkCalendar_GetPanelRect( byval hCtrl as TK_WIDGET ptr, byval panel as long, byref rc as TKRECT ) as boolean
function tkCalendar_GetCaptionRect( byval hCtrl as TK_WIDGET ptr, byval panel as long, byref rc as TKRECT ) as boolean
function tkCalendar_GetWeekdayRect( byval hCtrl as TK_WIDGET ptr, byval panel as long, byval i as long, byref rc as TKRECT ) as boolean
function tkCalendar_GetDayCellRect( byval hCtrl as TK_WIDGET ptr, byval panel as long, byval k as long, byref rc as TKRECT ) as boolean
function tkCalendar_GetMyCellRect( byval hCtrl as TK_WIDGET ptr, byval k as long, byref rc as TKRECT ) as boolean
function tkCalendar_GetCellDate( byval hCtrl as TK_WIDGET ptr, byval panel as long, byval k as long, byref st as TKDATE ) as boolean
function tkCalendar_GetPanelMonth( byval hCtrl as TK_WIDGET ptr, byval panel as long, byref nYear as long, byref nMonth as long ) as boolean
function tkCalendar_GetFocusCell( byval hCtrl as TK_WIDGET ptr, byref panel as long, byref index as long ) as boolean
function tkCalendar_GetMyFocus( byval hCtrl as TK_WIDGET ptr ) as long
function tkCalendar_GetHot( byval hCtrl as TK_WIDGET ptr ) as CAL_HITRESULT
sub tkCalendar_GetColors( byval hCtrl as TK_WIDGET ptr, byval pColors as TKCALENDAR_COLORS ptr )
sub tkCalendar_SetColors( byval hCtrl as TK_WIDGET ptr, byval pColors as TKCALENDAR_COLORS ptr )
function tkCalendar_ThemeColors( byref t as TKTHEME_COLORS ) as TKCALENDAR_COLORS
sub tkCalendar_ApplyTheme( byval hCtrl as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkCalendar_UnpinColors( byval hCtrl as TK_WIDGET ptr )
sub tkCalendar_SetSelChangeCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as CAL_SelChangeCallbackSub )
sub tkCalendar_SetDateActivatedCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as CAL_DateActivatedCallbackSub )
sub tkCalendar_SetPaintCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as CAL_PaintCallbackSub )
sub tkCalendar_SetDayPaintCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as CAL_DayPaintCallbackSub )
sub tkCalendar_SetMonthYearPaintCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as CAL_MonthYearPaintCallbackSub )
sub tkCalendar_SetMessageCallback( byval hCtrl as TK_WIDGET ptr, byval userfunc as CAL_MessageCallbackFunc )
sub tkCalendar_SetTooltipCallback( byval hCtrl as TK_WIDGET ptr, byval userfunc as CAL_TooltipCallbackFunc )
sub tkCalendar_SetViewChangeCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as CAL_ViewChangeCallbackSub )
function tkCalendar_GetTooltipHandle( byval hCtrl as TK_WIDGET ptr ) as TK_TIP ptr
function tkCalendar_TestPartTones( byval hCtrl as TK_WIDGET ptr, byval nPart as long ) as long
function tkCalendar_TestPartBrightness( byval hCtrl as TK_WIDGET ptr, byval nPart as long ) as long
function tkCalendar_TestHashPart( byval hCtrl as TK_WIDGET ptr, byval nPart as long ) as ulongint
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsCalendar](PsCalendar), the PsControls control
