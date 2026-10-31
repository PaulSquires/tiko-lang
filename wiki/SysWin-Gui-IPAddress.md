[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gui](SysWin-Gui) › **IPAddress**

# IPAddress

Reads, sets and clears the address in an IP address control, and limits its four fields.

An IP address control is an edit box split into four fields of one byte each, for typing an
IPv4 address such as 192.168.1.10. Create one with `CWindow.AddControl( "IPAddress", ... )`.
Every function here takes the control's handle first and is written with the namespace:
`IPAddress.GetAddress( hIPM, @dwAddr )`. Fields are numbered 0 to 3 from the left.

The address travels as one `DWORD` with the first field in the top byte. Build it with
`MAKEIPADDRESS( 192, 168, 1, 10 )` and take it apart with `FIRST_IPADDRESS`,
`SECOND_IPADDRESS`, `THIRD_IPADDRESS` and `FOURTH_IPADDRESS`. When the user leaves a field the
parent receives `WM_NOTIFY` with `IPN_FIELDCHANGED`; when the text changes, `WM_COMMAND` with
`EN_CHANGE`.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui
```

## Example

An address box filled with 192.168.1.10 whose first field accepts only 10 to 223. **Check**
puts the address in the caption, or says which fields are empty.

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

const IDC_IP = 101
const IDC_CHECK = 102

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "IPAddressDemo"
    dim hWin as HWND = pWindow.Create( NULL, "IP address", @WndProc )
    pWindow.SetClientSize( 320, 90 )
    pWindow.Center()
    dim hIP as HWND = pWindow.AddControl( "IPAddress", hWin, IDC_IP, "", 20, 30, 180, 24 )
    pWindow.AddControl( "Button", hWin, IDC_CHECK, "&Check", 215, 28, 80, 28 )
    IPAddress.SetRange( hIP, 0, 10, 223 )
    IPAddress.SetAddress( hIP, MAKEIPADDRESS( 192, 168, 1, 10 ) )
    IPAddress.SetFocus( hIP, 3 )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_COMMAND
            if CBCTL( wParam, lParam ) = IDC_CHECK andalso CBCTLMSG( wParam, lParam ) = BN_CLICKED then
                dim dwAddr as DWORD
                dim nFields as long = IPAddress.GetAddress( GetDlgItem( hwnd, IDC_IP ), @dwAddr )
                if nFields = 4 then
                    SetWindowText( hwnd, FIRST_IPADDRESS( dwAddr ) & "." & SECOND_IPADDRESS( dwAddr ) & "." & _
                                         THIRD_IPADDRESS( dwAddr ) & "." & FOURTH_IPADDRESS( dwAddr ) )
                else
                    SetWindowText( hwnd, ( 4 - nFields ) & " field(s) empty" )
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
| [GetAddress](#getaddress) | Reads the address and counts the fields that are filled in. |
| [SetAddress](#setaddress) | Fills in all four fields. |
| [ClearAddress](#clearaddress) | Empties all four fields. |
| [IsBlank](#isblank) | Asks whether every field is empty, and drops the answer. |
| [SetFocus](#setfocus) | Puts the keyboard focus in one field. |
| [SetRange](#setrange) | Limits the values one field accepts. |

## Reference

### GetAddress

```freebasic
function GetAddress( byval hIPM as HWND, byval pdwAddr as DWORD ptr ) as long
```

Reads the four fields into `*pdwAddr`, the first field in the top byte; an empty field reads
as 0.

**Returns** the number of fields that are not empty: 4 for a complete address, 0 for an empty
control.

**Example**

```freebasic
dim dw as DWORD
if IPAddress.GetAddress( hCtrl, @dw ) = 4 then print FIRST_IPADDRESS( dw ); "."; SECOND_IPADDRESS( dw ); "."; THIRD_IPADDRESS( dw ); "."; FOURTH_IPADDRESS( dw )
```

Microsoft Learn: [IPM_GETADDRESS](https://learn.microsoft.com/en-us/windows/win32/controls/ipm-getaddress)

### SetAddress

```freebasic
sub SetAddress( byval hIPM as HWND, byval dwAddr as DWORD )
```

Fills in all four fields from `dwAddr`, built with `MAKEIPADDRESS`. The control's text becomes
the dotted address, `"192.168.1.10"`.

**Example**

```freebasic
IPAddress.SetAddress( hCtrl, MAKEIPADDRESS( 192, 168, 1, 10 ) )
```

Microsoft Learn: [IPM_SETADDRESS](https://learn.microsoft.com/en-us/windows/win32/controls/ipm-setaddress)

### ClearAddress

```freebasic
sub ClearAddress( byval hIPM as HWND )
```

Empties all four fields; [GetAddress](#getaddress) then returns 0.

**Example**

```freebasic
IPAddress.ClearAddress( hCtrl )
```

Microsoft Learn: [IPM_CLEARADDRESS](https://learn.microsoft.com/en-us/windows/win32/controls/ipm-clearaddress)

### IsBlank

```freebasic
sub IsBlank( byval hIPM as HWND )
```

Asks the control whether all four fields are empty. It is a `sub`, so the answer is dropped and
the call has no effect a program can see. Send the request yourself to get the answer, or test
`GetAddress( h, @dw ) = 0`.

**Example**

```freebasic
IPAddress.IsBlank( hCtrl )   ' the answer is not returned
if SendMessageW( hCtrl, IPM_ISBLANK, 0, 0 ) then print "no address entered"
```

Microsoft Learn: [IPM_ISBLANK](https://learn.microsoft.com/en-us/windows/win32/controls/ipm-isblank)

### SetFocus

```freebasic
sub SetFocus( byval hIPM as HWND, byval nField as long )
```

Puts the keyboard focus in field `nField`, 0 to 3, and selects its text. Written with the
namespace, `IPAddress.SetFocus` is this function; the plain `SetFocus( hwnd )` is still the
Windows one.

**Example**

```freebasic
IPAddress.SetFocus( hCtrl, 0 )
```

Microsoft Learn: [IPM_SETFOCUS](https://learn.microsoft.com/en-us/windows/win32/controls/ipm-setfocus)

### SetRange

```freebasic
function SetRange( byval hIPM as HWND, byval nField as long, byval loRange as byte, byval hiRange as byte ) as boolean
```

Limits field `nField` to values from `loRange` to `hiRange`: a value outside them that the user
types is changed to the nearer limit. The fields accept 0 to 255 unless limited.

| Parameter | Meaning |
| --- | --- |
| `nField` | The field, 0 to 3. |
| `loRange`, `hiRange` | The smallest and largest values, 0 to 255. |

**Returns** `true` on success.

**Example**

```freebasic
IPAddress.SetRange( hCtrl, 0, 1, 223 )   ' first field 1 to 223
```

Microsoft Learn: [IPM_SETRANGE](https://learn.microsoft.com/en-us/windows/win32/controls/ipm-setrange)

## See also

- [sys/win/gui](SysWin-Gui)
- [CWindow](CWindow) for `AddControl( "IPAddress", ... )`
- [Internet](SysWin-Internet)
- [Edit](SysWin-Gui-Edit)
