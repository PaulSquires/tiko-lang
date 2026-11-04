[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gui](SysWin-Gui) › **HotKey**

# HotKey

Reads and sets the key combination in a hot key control, and the combinations it refuses.

A hot key control is an edit-like box that shows the key combination the user presses in it,
such as **Ctrl+Shift+F5**, so a program can let the user choose a shortcut. It only records the
combination; making it do something is up to the program, for instance with `RegisterHotKey`
or `WM_SETHOTKEY`. Create one with `CWindow.AddControl( "HotKey", ... )`. Every function here
takes the control's handle first and is written with the namespace:
`HotKey.GetHotKey( hHotKey )`.

A combination is a virtual-key code (`VK_F5`, `asc( "A" )` …) and modifier flags:
`HOTKEYF_SHIFT`, `HOTKEYF_CONTROL`, `HOTKEYF_ALT` and `HOTKEYF_EXT` (an extended key). These are
not the `MOD_*` flags `RegisterHotKey` takes: Shift and Alt are swapped.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui
```

## Example

A box for choosing the key that brings the window to the front, from anywhere. **Set** hands
the combination to Windows with `WM_SETHOTKEY`; plain letters and Shift+letter are refused and
become Ctrl+Alt+letter.

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

const IDC_HOTKEY = 101
const IDC_SET = 102

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "HotKeyDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Choose an activation key", @WndProc )
    pWindow.SetClientSize( 320, 90 )
    pWindow.Center()
    dim hHotKey as HWND = pWindow.AddControl( "HotKey", hWin, IDC_HOTKEY, "", 20, 30, 180, 24 )
    pWindow.AddControl( "Button", hWin, IDC_SET, "&Set", 215, 28, 80, 28 )
    HotKey.SetRules( hHotKey, HKCOMB_NONE or HKCOMB_S, HOTKEYF_CONTROL or HOTKEYF_ALT )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_COMMAND
            if CBCTL( wParam, lParam ) = IDC_SET andalso CBCTLMSG( wParam, lParam ) = BN_CLICKED then
                dim wKey as DWORD = HotKey.GetHotKey( GetDlgItem( hwnd, IDC_HOTKEY ) )
                if SendMessageW( hwnd, WM_SETHOTKEY, LOWORD( wKey ), 0 ) = 1 then
                    SetWindowText( hwnd, "Activation key set" )
                else
                    SetWindowText( hwnd, "That key cannot be used" )
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

## Functions

| Function | Does |
| --- | --- |
| [GetHotKey](#gethotkey) | Returns the key and modifiers in the control. |
| [SetHotKey](#sethotkey) | Puts a key in the control; the modifiers are not passed on. |
| [SetRules](#setrules) | Sets the combinations the control refuses and what it uses instead. |

## Reference

### GetHotKey

```freebasic
function GetHotKey( byval hHotKey as HWND ) as DWORD
```

Returns the combination in the control: the virtual-key code in the low byte and the
`HOTKEYF_*` modifier flags in the next byte, so `LOBYTE( LOWORD( r ) )` is the key and
`HIBYTE( LOWORD( r ) )` the modifiers. That low word is also what `WM_SETHOTKEY` takes. Ctrl+F5
is `&h274`.

**Returns** the combination, or 0 when the control is empty.

**Example**

```freebasic
dim r as DWORD = HotKey.GetHotKey( hCtrl )
print "key &h"; hex( LOBYTE( LOWORD( r ) ) ); ", ctrl:"; ( HIBYTE( LOWORD( r ) ) and HOTKEYF_CONTROL ) <> 0
```

Microsoft Learn: [HKM_GETHOTKEY](https://learn.microsoft.com/en-us/windows/win32/controls/hkm-gethotkey)

### SetHotKey

```freebasic
sub SetHotKey( byval hHotKey as HWND, byval vkCode as short, byval fMods as short )
```

Puts the key `vkCode` in the control.

| Parameter | Meaning |
| --- | --- |
| `vkCode` | The virtual-key code. |
| `fMods` | `HOTKEYF_*` flags; not passed on, as above. |

**Example**

```freebasic
HotKey.SetHotKey( hCtrl, VK_F5, 0 )                                          ' F5
SendMessageW( hCtrl, HKM_SETHOTKEY, MAKEWORD( VK_F5, HOTKEYF_CONTROL ), 0 )   ' Ctrl+F5
```

Microsoft Learn: [HKM_SETHOTKEY](https://learn.microsoft.com/en-us/windows/win32/controls/hkm-sethotkey)

### SetRules

```freebasic
sub SetRules( byval hHotKey as HWND, byval fwCombInv as WORD, byval fwModInv as WORD )
```

Says which modifier combinations the control refuses, and what it puts in their place. When the
user presses a refused combination, the control uses the same key with the `fwModInv` modifiers
instead.

| Parameter | Meaning |
| --- | --- |
| `fwCombInv` | The refused combinations, any of `HKCOMB_NONE` (no modifier), `HKCOMB_S`, `HKCOMB_C`, `HKCOMB_A`, `HKCOMB_SC`, `HKCOMB_SA`, `HKCOMB_CA`, `HKCOMB_SCA`. |
| `fwModInv` | The `HOTKEYF_*` flags used instead. |

**Example**

```freebasic
HotKey.SetRules( hCtrl, HKCOMB_NONE or HKCOMB_S, HOTKEYF_CONTROL or HOTKEYF_ALT )
```

Microsoft Learn: [HKM_SETRULES](https://learn.microsoft.com/en-us/windows/win32/controls/hkm-setrules)

## See also

- [sys/win/gui](SysWin-Gui)
- [CWindow](CWindow) for `AddControl( "HotKey", ... )`
- [Menu](SysWin-Gui-Menu) for keyboard shortcuts on menu items
- [Edit](SysWin-Gui-Edit)
