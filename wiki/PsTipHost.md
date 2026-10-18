[Home](Home) › [All Categories](Categories) › [PsControls](Category-PsControls) › **PsTipHost**

# PsTipHost

The tooltip backend switch shared by the PsControls family. It is **not a control**: like [PsBufferPaint](PsBufferPaint) and [PsImage](PsImage) it is a support type a control holds, with no window of its own and no message-pump obligation.

Every control that shows tooltips keeps one `PSTIPHOST_STATE` and drives it through `PsTipHost_*`. The host never calls those itself. What a host needs from this module is its two constants, passed to a control's `Ps<X>_SetTooltipMode`:

| Constant | Value | Backend |
|---|---|---|
| `PSTIP_MODE_SYSTEM` | `0` | the system (comctl32) tooltip. **The default.** |
| `PSTIP_MODE_PS` | `1` | [PsTooltip](PsTooltip): owner-drawn, themeable, word-wrapping |

```freebasic
#import "vendor/PsControls/PsTipHost"
#import "vendor/PsControls/PsButton"

using PsTipHost
using PsButton

PsButton_SetTooltipMode( hButton, PSTIP_MODE_PS )
```

The controls with a `SetTooltipMode`: [PsButton](PsButton), [PsCalendar](PsCalendar), [PsChart](PsChart), [PsCheckBox](PsCheckBox), [PsColumnHeader](PsColumnHeader), [PsDatePicker](PsDatePicker), [PsIconPanel](PsIconPanel), [PsListTree](PsListTree), [PsOptionButton](PsOptionButton), [PsProgressBar](PsProgressBar), [PsSelectBar](PsSelectBar), [PsStatusBar](PsStatusBar), [PsTabBar](PsTabBar), [PsToolbar](PsToolbar).

## What the switch changes

- **How a tip is drawn and driven, never what it says.** Each control resolves its own tip text (authored text first, then its callback); the backend only shows it. Switching cannot change a tip's text.
- **Delays survive a switch.** A hover, auto-pop or reshow time the host set is re-applied to the new backend, and a delay of `0` stays a real "no delay".
- **The system tooltip is the default on purpose.** PsTooltip's colour defaults are dark and the system tip is light, so a control that switched by itself would put a dark tip on a light form. Theme every PsTooltip in the process with `PsTooltip_SetDefaultColors` and friends, then opt in per control.
- **Tracked tips** (PsCalendar, PsDatePicker) are positioned and shown by the control rather than after a dwell. They work on both backends.

Single-threaded: UI thread only, like every control in the family.

### See also

- [PsTooltip](PsTooltip)
- [PsControls](Category-PsControls)
