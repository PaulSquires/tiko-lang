# PsRegistry

The controls' process-wide registry. Some PsControls need the message loop to call their
`FilterMessage` before `IsDialogMessage`, or a dropdown would not close on an outside click and
its arrow keys would never arrive. Each such control registers that need here when it is created
and removes it when it is destroyed. [PsApp](../PsApp/README.md)'s message loop walks the
registry, so it names no control.

An app does not normally call PsRegistry at all. A hand-written message loop that calls each
control's `FilterMessage` itself is unaffected: the entries exist, nothing reads them, and no
control behaves differently.

## What registers

| Control | Entry |
|---|---|
| PsComboBox, PsToolbar, PsMenuBar | A row: its filter, plus a dismiss proc (`CloseUp` / `CloseMenu`) |
| PsPopupMenu | A row, removed as soon as the popup is handed to an owner (see below) |
| PsDatePicker | A row for dismissal only, plus its global filter |
| PsTextBox, PsNumericUpDown, PsListTree | A global filter, reference-counted per instance |

**The popup rule.** A popup that another control owns is filtered by that owner, never by a row
of its own. The owner's filter has to see the message first: PsMenuBar's, for example, lets a
click on the bar through to the bar, and a popup row walked after it would treat that click as an
outside click and close the menu. These calls hand a popup over and remove its row:
- `PsMenuBar_SetDropDown`
- `PsPopupMenu_SetItemSubMenu`
- PsComboBox's list
- PsTextBox's context menu
- PsToolbar's item and overflow menus

Only the app's own standalone popups, such as context menus, keep a row.

## API

```freebasic
public type PSREG_FilterProc       as function( byval h as HWND, byval pMsg as MSG ptr ) as boolean
public type PSREG_GlobalFilterProc as function( byval pMsg as MSG ptr ) as boolean
public type PSREG_DismissProc      as sub( byval h as HWND )

PsRegistry_Add( h, prio, pFilter, pDismiss = 0 )   ' prio: PSREG_PRIO_OWNER or PSREG_PRIO_POPUP
PsRegistry_Remove( h )                             ' a no-op when h has no row
PsRegistry_AddGlobalFilter( p )                    ' one more reference
PsRegistry_ReleaseGlobalFilter( p )                ' one fewer
PsRegistry_FilterMessage( pMsg ) as boolean        ' the message loop's one call
PsRegistry_Dismiss( hRoot )                        ' close what is open under hRoot (null: everywhere)
PsRegistry_Count( ), PsRegistry_GlobalCount( ), PsRegistry_HasRow( h )   ' for tests
```

`PsRegistry_FilterMessage` runs the global filters first, then the `PSREG_PRIO_OWNER` rows, then
the `PSREG_PRIO_POPUP` rows. The first filter to return TRUE consumes the message. A row whose
window has been destroyed is skipped. A filter may destroy windows: removals during a walk are
deferred until it ends.

Calling every filter for every message is cheap and safe. Each one stands down at its first
comparison unless its own popup is open, and only one popup chain can be open in a process.

Specified in `C:\dev\docs\tiko-psapp\RFC-0001-psapp.md` §5.
