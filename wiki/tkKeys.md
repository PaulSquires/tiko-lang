[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkKeys**

# tkKeys

Parses, formats and dispatches keyboard shortcuts for tkControls surfaces.

tkKeys gives a tkControls program what accelerator tables gave a Win32 one: a **chord** (`TK_CHORD`, a key and its modifiers), its text in both directions, and **key maps** that a surface asks before its focused widget, so Ctrl+S is the application's whichever control has the focus.

Store shortcuts as text such as `"Primary+Shift+S"`: `Primary` is the platform's command key (Ctrl on Windows and Linux, Cmd on macOS), so one keybindings file serves every OS, and a menu shows `Ctrl+Shift+S` or `Cmd+Shift+S`.

## Importing

```freebasic
#import "vendor/tkControls/tkKeys"

using tkKeys
using tkHost
```

tkKeys re-exports [tkHost](tkHost) and imports `std/containers` for its maps. On Linux, put any `std/*` import of your own before the tkControls ones.

## Example

```freebasic
enum
    CMD_SAVE = 1
    CMD_FIND
end enum

sub OnCommand( byval h as TK_HOST ptr, byval cmd as long )
    select case cmd
    case CMD_SAVE : print "save"
    case CMD_FIND : print "find"
    end select
end sub

dim as TK_KEYMAP ptr km = tkKeys_MapCreate()
tkKeys_BindText( km, "Primary+S", CMD_SAVE )
tkKeys_BindText( km, "Primary+F", CMD_FIND )
tkKeys_Attach( tkForm_Host( f ), km, @OnCommand )     ' f: a tkApp form; its surface only

dim as TK_CHORD c
if tkKeys_Parse( "Primary+S", c ) then
    print tkKeys_Format( c )            ' "Ctrl+S" ("Cmd+S" on macOS), for a menu
    print tkKeys_Format( c, true )      ' "Primary+S", for a keybindings file
end if
```

## Key maps

- One command per chord: binding a chord again replaces it. A command may have several chords. Command 0 means "none", so number commands from 1.
- `tkKeys_Attach( h, km, cb )` sets the surface's `OnPreKey`: a key down that matches runs `cb( h, cmd )` and is consumed before any widget sees it. `km = 0` detaches. The map stays yours; free it with `tkKeys_MapDestroy`.
- A map belongs to one surface, so a dialog or a popup never runs the main window's commands.
- `tkKeys_FromMsg( m )` turns a `TKM_KEYDOWN` into a chord, for a widget that matches shortcuts itself.

## Chord text

A chord is modifiers then one key, joined by `+`, case-insensitive. The key is matched **unshifted**, by its physical key: `Ctrl+Shift+/` matches although Shift turns `/` into `?`.

| Part | Spellings |
| --- | --- |
| Modifiers | `Ctrl` / `Control`, `Shift`, `Alt` / `Option`, `Cmd` / `Win` / `Super` / `Meta`, `Primary` |
| Letters, digits, function keys | `A` ... `Z`, `0` ... `9`, `F1` ... `F24` |
| Navigation | `Up`, `Down`, `Left`, `Right`, `Home`, `End`, `PgUp` / `PageUp`, `PgDn` / `PageDown`, `Insert`, `Delete` |
| Editing | `Enter`, `Tab`, `Esc` / `Escape`, `Space`, `Backspace` |
| Punctuation | `Plus` (the `=+` key), `Minus`, `Comma`, `Period`, `Tilde` (the `` `~ `` key), `/`, `\`, `Semicolon`, `Quote`, `[`, `]` |
| Keypad | `NumPlus`, `NumMinus`, `NumMultiply`, `NumDivide`, `NumEnter`, `NumPeriod`, `Num0` ... `Num9` |

The last part is always the key, so write `Ctrl+Plus`, never `Ctrl++`. `tkKeys_Format` writes the first spelling of each name. A chord that does not parse makes `tkKeys_Parse` and `tkKeys_BindText` return FALSE and binds nothing.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const TKKEY_SHIFT = 1
const TKKEY_CTRL = 2
const TKKEY_ALT = 4
const TKKEY_GUI = 8 ' Cmd on macOS, the Windows key, Super
```

### Types

```freebasic
type TK_CHORD
    key  as long                            ' SDL_Keycode, unshifted; 0 = none
    mods as long                            ' TKKEY_*
end type

type TK_KEYMAP
    chords as Map( of longint, long )         ' (mods shl 32) or key -> command
end type

type TKKEYS_CommandSub as sub( byval h as TK_HOST ptr, byval cmd as long )
```

### Procedures

```freebasic
function tkKeys_Primary() as long
function tkKeys_ModsFromSDL( byval m as long ) as long
function tkKeys_FromMsg( byval m as TK_MSG ptr ) as TK_CHORD
function tkKeys_Parse( byref s as string, byref c as TK_CHORD ) as boolean
function tkKeys_Format( byref c as TK_CHORD, byval bPortable as boolean = false ) as string
function tkKeys_MapCreate() as TK_KEYMAP ptr
sub tkKeys_MapDestroy( byval km as TK_KEYMAP ptr )
sub tkKeys_Bind( byval km as TK_KEYMAP ptr, byref c as TK_CHORD, byval cmd as long )
function tkKeys_BindText( byval km as TK_KEYMAP ptr, byref s as string, byval cmd as long ) as boolean
sub tkKeys_Unbind( byval km as TK_KEYMAP ptr, byref c as TK_CHORD )
sub tkKeys_Clear( byval km as TK_KEYMAP ptr )
function tkKeys_Count( byval km as TK_KEYMAP ptr ) as long
function tkKeys_Lookup( byval km as TK_KEYMAP ptr, byref c as TK_CHORD ) as long
sub tkKeys_Attach( byval h as TK_HOST ptr, byval km as TK_KEYMAP ptr, byval cb as TKKEYS_CommandSub )
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
