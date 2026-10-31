[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › **Colours**

# Colours

Names the web colours twice: as `RGB_*` values for GDI and as `ARGB_*` values for GDI+.

The two sets name the same web colours, `RGB_STEELBLUE` and `ARGB_SteelBlue`, but pack them
differently, and the two must not be mixed:

| | `RGB_*` | `ARGB_*` |
| --- | --- | --- |
| Type | `COLORREF` | an `ARGB` (`ulong`) |
| Layout | `&h00BBGGRR`: red in the **low** byte | `&hAARRGGBB`: blue in the low byte, alpha on top |
| Red | `&h0000FF` | `&hFFFF0000` |
| Used by | GDI: `SetTextColor`, `CreateSolidBrush`, `SetBkColor`, the controls' colour messages | GDI+, and the pixels of a 32-bit DIB section |

Every `ARGB_*` colour is opaque (alpha `&hFF`) except `ARGB_Transparent_`, which is white with
alpha 0.

To build a colour from its parts, `BGR( r, g, b )` makes a `COLORREF` (`BGR( 255, 0, 0 )` is
`&hFF`), and `GetRValue`, `GetGValue` and `GetBValue` take one apart. `RGB( r, g, b )` makes the
other layout, `&hFFRRGGBB`, the same as an `ARGB_*` value: `RGB( 255, 0, 0 )` is `&hFFFF0000`, which
is not a `COLORREF`.

The constants are not part of `win`: they come with `sys/win/gui` and `sys/win/gdiplus`. After
`#import "sys/win"` alone, `RGB_RED` is not declared.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui
```

## Example

A window that paints five swatches with `RGB_*` colours and writes each one's name in a
contrasting colour:

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "ColourDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Colours", @WndProc )
    SetWindowClientSizeForDpi( hWin, 500, 100 )
    CenterWindow( hWin )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_PAINT
            static colours( 4 ) as COLORREF = { RGB_CRIMSON, RGB_GOLD, RGB_SEAGREEN, RGB_STEELBLUE, RGB_INDIGO }
            static names( 4 ) as wstring * 16 = { "Crimson", "Gold", "SeaGreen", "SteelBlue", "Indigo" }
            dim ps as PAINTSTRUCT
            dim hdc as HDC = BeginPaint( hwnd, @ps )
            dim w as long = GetWindowClientWidth( hwnd ) \ 5
            dim h as long = GetWindowClientHeight( hwnd )
            SetBkMode( hdc, TRANSPARENT )
            for i as long = 0 to 4
                dim rc as RECT
                SetRect( @rc, i * w, 0, ( i + 1 ) * w, h )
                dim hBrush as HBRUSH = CreateSolidBrush( colours( i ) )
                FillRect( hdc, @rc, hBrush )
                DeleteObject( hBrush )
                SetTextColor( hdc, iif( i = 1, RGB_BLACK, RGB_WHITE ) )
                DrawTextW( hdc, @names( i ), -1, @rc, DT_CENTER or DT_VCENTER or DT_SINGLELINE )
            next
            EndPaint( hwnd, @ps )
            return 0
        case WM_DESTROY
            PostQuitMessage( 0 )
            return 0
    end select
    return DefWindowProcW( hwnd, uMsg, wParam, lParam )
end function

end main()
```

## Tables

| Table | Holds |
| --- | --- |
| [RGB colours](#rgb-colours) | The 138 `RGB_*` `COLORREF` constants, by colour group. |
| [ARGB colours](#argb-colours) | The 141 `ARGB_*` GDI+ colour constants, in alphabetical order. |

## Reference

### RGB colours

`COLORREF` values, `&h00BBGGRR`, upper-case names, grouped as in the source.
`RGB_LIGHTSALMON` is defined twice, among the reds and the oranges, and `RGB_MEDIUMSLATEBLUE`
twice, among the purples and the blues, with the same value each time. There is no `RGB_AQUA`
or `RGB_FUCHSIA`; use `RGB_CYAN` and `RGB_MAGENTA`.

**Example**

```freebasic
dim c as COLORREF = RGB_ORANGE
print GetRValue( c ); GetGValue( c ); GetBValue( c )   ' 255 165 0
```

Microsoft Learn: [COLORREF](https://learn.microsoft.com/en-us/windows/win32/gdi/colorref)

| Constant | Value | R, G, B | Group |
| --- | --- | --- | --- |
| `RGB_INDIANRED` | `&h5C5CCD` | 205, 92, 92 | Red |
| `RGB_LIGHTCORAL` | `&h8080F0` | 240, 128, 128 | Red |
| `RGB_SALMON` | `&h7280FA` | 250, 128, 114 | Red |
| `RGB_DARKSALMON` | `&h7A96E9` | 233, 150, 122 | Red |
| `RGB_LIGHTSALMON` | `&h7AA0FF` | 255, 160, 122 | Red, Orange |
| `RGB_CRIMSON` | `&h3C14DC` | 220, 20, 60 | Red |
| `RGB_RED` | `&h0000FF` | 255, 0, 0 | Red |
| `RGB_FIREBRICK` | `&h2222B2` | 178, 34, 34 | Red |
| `RGB_DARKRED` | `&h00008B` | 139, 0, 0 | Red |
| `RGB_PINK` | `&hCBC0FF` | 255, 192, 203 | Pink |
| `RGB_LIGHTPINK` | `&hC1B6FF` | 255, 182, 193 | Pink |
| `RGB_HOTPINK` | `&hB469FF` | 255, 105, 180 | Pink |
| `RGB_DEEPPINK` | `&h9314FF` | 255, 20, 147 | Pink |
| `RGB_MEDIUMVIOLETRED` | `&h8515C7` | 199, 21, 133 | Pink |
| `RGB_PALEVIOLETRED` | `&h9370DB` | 219, 112, 147 | Pink |
| `RGB_CORAL` | `&h507FFF` | 255, 127, 80 | Orange |
| `RGB_TOMATO` | `&h4763FF` | 255, 99, 71 | Orange |
| `RGB_ORANGERED` | `&h0045FF` | 255, 69, 0 | Orange |
| `RGB_DARKORANGE` | `&h008CFF` | 255, 140, 0 | Orange |
| `RGB_ORANGE` | `&h00A5FF` | 255, 165, 0 | Orange |
| `RGB_GOLD` | `&h00D7FF` | 255, 215, 0 | Yellow |
| `RGB_YELLOW` | `&h00FFFF` | 255, 255, 0 | Yellow |
| `RGB_LIGHTYELLOW` | `&hE0FFFF` | 255, 255, 224 | Yellow |
| `RGB_LEMONCHIFFON` | `&hCDFAFF` | 255, 250, 205 | Yellow |
| `RGB_LIGHTGOLDENRODYELLOW` | `&hD2FAFA` | 250, 250, 210 | Yellow |
| `RGB_PAPAYAWHIP` | `&hD5EFFF` | 255, 239, 213 | Yellow |
| `RGB_MOCCASIN` | `&hB5E4FF` | 255, 228, 181 | Yellow |
| `RGB_PEACHPUFF` | `&hB9DAFF` | 255, 218, 185 | Yellow |
| `RGB_PALEGOLDENROD` | `&hAAE8EE` | 238, 232, 170 | Yellow |
| `RGB_KHAKI` | `&h8CE6F0` | 240, 230, 140 | Yellow |
| `RGB_DARKKHAKI` | `&h6BB7BD` | 189, 183, 107 | Yellow |
| `RGB_LAVENDER` | `&hFAE6E6` | 230, 230, 250 | Purple |
| `RGB_THISTLE` | `&hD8BFD8` | 216, 191, 216 | Purple |
| `RGB_PLUM` | `&hDDA0DD` | 221, 160, 221 | Purple |
| `RGB_VIOLET` | `&hEE82EE` | 238, 130, 238 | Purple |
| `RGB_ORCHID` | `&hD670DA` | 218, 112, 214 | Purple |
| `RGB_MAGENTA` | `&hFF00FF` | 255, 0, 255 | Purple |
| `RGB_MEDIUMORCHID` | `&hD355BA` | 186, 85, 211 | Purple |
| `RGB_MEDIUMPURPLE` | `&hDB7093` | 147, 112, 219 | Purple |
| `RGB_BLUEVIOLET` | `&hE22B8A` | 138, 43, 226 | Purple |
| `RGB_DARKVIOLET` | `&hD30094` | 148, 0, 211 | Purple |
| `RGB_DARKORCHID` | `&hCC3299` | 153, 50, 204 | Purple |
| `RGB_DARKMAGENTA` | `&h8B008B` | 139, 0, 139 | Purple |
| `RGB_PURPLE` | `&h800080` | 128, 0, 128 | Purple |
| `RGB_INDIGO` | `&h82004B` | 75, 0, 130 | Purple |
| `RGB_SLATEBLUE` | `&hCD5A6A` | 106, 90, 205 | Purple |
| `RGB_DARKSLATEBLUE` | `&h8B3D48` | 72, 61, 139 | Purple |
| `RGB_MEDIUMSLATEBLUE` | `&hEE687B` | 123, 104, 238 | Purple, Blue |
| `RGB_GREENYELLOW` | `&h2FFFAD` | 173, 255, 47 | Green |
| `RGB_CHARTREUSE` | `&h00FF7F` | 127, 255, 0 | Green |
| `RGB_LAWNGREEN` | `&h00FC7C` | 124, 252, 0 | Green |
| `RGB_LIME` | `&h00FF00` | 0, 255, 0 | Green |
| `RGB_LIMEGREEN` | `&h32CD32` | 50, 205, 50 | Green |
| `RGB_PALEGREEN` | `&h98FB98` | 152, 251, 152 | Green |
| `RGB_LIGHTGREEN` | `&h90EE90` | 144, 238, 144 | Green |
| `RGB_MEDIUMSPRINGGREEN` | `&h9AFA00` | 0, 250, 154 | Green |
| `RGB_SPRINGGREEN` | `&h7FFF00` | 0, 255, 127 | Green |
| `RGB_MEDIUMSEAGREEN` | `&h71B33C` | 60, 179, 113 | Green |
| `RGB_SEAGREEN` | `&h578B2E` | 46, 139, 87 | Green |
| `RGB_FORESTGREEN` | `&h228B22` | 34, 139, 34 | Green |
| `RGB_GREEN` | `&h008000` | 0, 128, 0 | Green |
| `RGB_DARKGREEN` | `&h006400` | 0, 100, 0 | Green |
| `RGB_YELLOWGREEN` | `&h32CD9A` | 154, 205, 50 | Green |
| `RGB_OLIVEDRAB` | `&h238E6B` | 107, 142, 35 | Green |
| `RGB_OLIVE` | `&h008080` | 128, 128, 0 | Green |
| `RGB_DARKOLIVEGREEN` | `&h2F6B55` | 85, 107, 47 | Green |
| `RGB_MEDIUMAQUAMARINE` | `&hAACD66` | 102, 205, 170 | Green |
| `RGB_DARKSEAGREEN` | `&h8FBC8F` | 143, 188, 143 | Green |
| `RGB_LIGHTSEAGREEN` | `&hAAB220` | 32, 178, 170 | Green |
| `RGB_DARKCYAN` | `&h8B8B00` | 0, 139, 139 | Green |
| `RGB_TEAL` | `&h808000` | 0, 128, 128 | Green |
| `RGB_CYAN` | `&hFFFF00` | 0, 255, 255 | Blue |
| `RGB_LIGHTCYAN` | `&hFFFFE0` | 224, 255, 255 | Blue |
| `RGB_PALETURQUOISE` | `&hEEEEAF` | 175, 238, 238 | Blue |
| `RGB_AQUAMARINE` | `&hD4FF7F` | 127, 255, 212 | Blue |
| `RGB_TURQUOISE` | `&hD0E040` | 64, 224, 208 | Blue |
| `RGB_MEDIUMTURQUOISE` | `&hCCD148` | 72, 209, 204 | Blue |
| `RGB_DARKTURQUOISE` | `&hD1CE00` | 0, 206, 209 | Blue |
| `RGB_CADETBLUE` | `&hA09E5F` | 95, 158, 160 | Blue |
| `RGB_STEELBLUE` | `&hB48246` | 70, 130, 180 | Blue |
| `RGB_LIGHTSTEELBLUE` | `&hDEC4B0` | 176, 196, 222 | Blue |
| `RGB_POWDERBLUE` | `&hE6E0B0` | 176, 224, 230 | Blue |
| `RGB_LIGHTBLUE` | `&hE6D8AD` | 173, 216, 230 | Blue |
| `RGB_SKYBLUE` | `&hEBCE87` | 135, 206, 235 | Blue |
| `RGB_LIGHTSKYBLUE` | `&hFACE87` | 135, 206, 250 | Blue |
| `RGB_DEEPSKYBLUE` | `&hFFBF00` | 0, 191, 255 | Blue |
| `RGB_DODGERBLUE` | `&hFF901E` | 30, 144, 255 | Blue |
| `RGB_CORNFLOWERBLUE` | `&hED9564` | 100, 149, 237 | Blue |
| `RGB_ROYALBLUE` | `&hE16941` | 65, 105, 225 | Blue |
| `RGB_BLUE` | `&hFF0000` | 0, 0, 255 | Blue |
| `RGB_MEDIUMBLUE` | `&hCD0000` | 0, 0, 205 | Blue |
| `RGB_DARKBLUE` | `&h8B0000` | 0, 0, 139 | Blue |
| `RGB_NAVY` | `&h800000` | 0, 0, 128 | Blue |
| `RGB_MIDNIGHTBLUE` | `&h701919` | 25, 25, 112 | Blue |
| `RGB_CORNSILK` | `&hDCF8FF` | 255, 248, 220 | Brown |
| `RGB_BLANCHEDALMOND` | `&hCDEBFF` | 255, 235, 205 | Brown |
| `RGB_BISQUE` | `&hC4E4FF` | 255, 228, 196 | Brown |
| `RGB_NAVAJOWHITE` | `&hADDEFF` | 255, 222, 173 | Brown |
| `RGB_WHEAT` | `&hB3DEF5` | 245, 222, 179 | Brown |
| `RGB_BURLYWOOD` | `&h87B8DE` | 222, 184, 135 | Brown |
| `RGB_TAN` | `&h8CB4D2` | 210, 180, 140 | Brown |
| `RGB_ROSYBROWN` | `&h8F8FBC` | 188, 143, 143 | Brown |
| `RGB_SANDYBROWN` | `&h60A4F4` | 244, 164, 96 | Brown |
| `RGB_GOLDENROD` | `&h20A5DA` | 218, 165, 32 | Brown |
| `RGB_DARKGOLDENROD` | `&h0B86B8` | 184, 134, 11 | Brown |
| `RGB_PERU` | `&h3F85CD` | 205, 133, 63 | Brown |
| `RGB_CHOCOLATE` | `&h1E69D2` | 210, 105, 30 | Brown |
| `RGB_SADDLEBROWN` | `&h13458B` | 139, 69, 19 | Brown |
| `RGB_SIENNA` | `&h2D52A0` | 160, 82, 45 | Brown |
| `RGB_BROWN` | `&h2A2AA5` | 165, 42, 42 | Brown |
| `RGB_MAROON` | `&h000080` | 128, 0, 0 | Brown |
| `RGB_WHITE` | `&hFFFFFF` | 255, 255, 255 | White |
| `RGB_SNOW` | `&hFAFAFF` | 255, 250, 250 | White |
| `RGB_HONEYDEW` | `&hF0FFF0` | 240, 255, 240 | White |
| `RGB_MINTCREAM` | `&hFAFFF5` | 245, 255, 250 | White |
| `RGB_AZURE` | `&hFFFFF0` | 240, 255, 255 | White |
| `RGB_ALICEBLUE` | `&hFFF8F0` | 240, 248, 255 | White |
| `RGB_GHOSTWHITE` | `&hFFF8F8` | 248, 248, 255 | White |
| `RGB_WHITESMOKE` | `&hF5F5F5` | 245, 245, 245 | White |
| `RGB_SEASHELL` | `&hEEF5FF` | 255, 245, 238 | White |
| `RGB_BEIGE` | `&hDCF5F5` | 245, 245, 220 | White |
| `RGB_OLDLACE` | `&hE6F5FD` | 253, 245, 230 | White |
| `RGB_FLORALWHITE` | `&hF0FAFF` | 255, 250, 240 | White |
| `RGB_IVORY` | `&hF0FFFF` | 255, 255, 240 | White |
| `RGB_ANTIQUEWHITE` | `&hD7EBFA` | 250, 235, 215 | White |
| `RGB_LINEN` | `&hE6F0FA` | 250, 240, 230 | White |
| `RGB_LAVENDERBLUSH` | `&hF5F0FF` | 255, 240, 245 | White |
| `RGB_MISTYROSE` | `&hE1E4FF` | 255, 228, 225 | White |
| `RGB_GAINSBORO` | `&hDCDCDC` | 220, 220, 220 | Gray |
| `RGB_LIGHTGRAY` | `&hD3D3D3` | 211, 211, 211 | Gray |
| `RGB_SILVER` | `&hC0C0C0` | 192, 192, 192 | Gray |
| `RGB_DARKGRAY` | `&hA9A9A9` | 169, 169, 169 | Gray |
| `RGB_GRAY` | `&h808080` | 128, 128, 128 | Gray |
| `RGB_DIMGRAY` | `&h696969` | 105, 105, 105 | Gray |
| `RGB_LIGHTSLATEGRAY` | `&h998877` | 119, 136, 153 | Gray |
| `RGB_SLATEGRAY` | `&h908070` | 112, 128, 144 | Gray |
| `RGB_DARKSLATEGRAY` | `&h4F4F2F` | 47, 79, 79 | Gray |
| `RGB_BLACK` | `&h000000` | 0, 0, 0 | Gray |

### ARGB colours

GDI+ colours, `&hAARRGGBB`, with the GDI+ names. `ARGB_Tan_` and `ARGB_Transparent_` end in an
underscore. `ARGB_DarkSeaGreen` is 143, 188, 139, as GDI+ defines it, while
`RGB_DARKSEAGREEN` is 143, 188, 143.

**Example**

```freebasic
dim c as ulong = ARGB_SteelBlue
print hex( c )   ' FF4682B4
```

Microsoft Learn: [Color (GDI+)](https://learn.microsoft.com/en-us/windows/win32/api/gdipluscolor/nl-gdipluscolor-color)

| Constant | Value | R, G, B |
| --- | --- | --- |
| `ARGB_AliceBlue` | `&hFFF0F8FF` | 240, 248, 255 |
| `ARGB_AntiqueWhite` | `&hFFFAEBD7` | 250, 235, 215 |
| `ARGB_Aqua` | `&hFF00FFFF` | 0, 255, 255 |
| `ARGB_Aquamarine` | `&hFF7FFFD4` | 127, 255, 212 |
| `ARGB_Azure` | `&hFFF0FFFF` | 240, 255, 255 |
| `ARGB_Beige` | `&hFFF5F5DC` | 245, 245, 220 |
| `ARGB_Bisque` | `&hFFFFE4C4` | 255, 228, 196 |
| `ARGB_Black` | `&hFF000000` | 0, 0, 0 |
| `ARGB_BlanchedAlmond` | `&hFFFFEBCD` | 255, 235, 205 |
| `ARGB_Blue` | `&hFF0000FF` | 0, 0, 255 |
| `ARGB_BlueViolet` | `&hFF8A2BE2` | 138, 43, 226 |
| `ARGB_Brown` | `&hFFA52A2A` | 165, 42, 42 |
| `ARGB_BurlyWood` | `&hFFDEB887` | 222, 184, 135 |
| `ARGB_CadetBlue` | `&hFF5F9EA0` | 95, 158, 160 |
| `ARGB_Chartreuse` | `&hFF7FFF00` | 127, 255, 0 |
| `ARGB_Chocolate` | `&hFFD2691E` | 210, 105, 30 |
| `ARGB_Coral` | `&hFFFF7F50` | 255, 127, 80 |
| `ARGB_CornflowerBlue` | `&hFF6495ED` | 100, 149, 237 |
| `ARGB_Cornsilk` | `&hFFFFF8DC` | 255, 248, 220 |
| `ARGB_Crimson` | `&hFFDC143C` | 220, 20, 60 |
| `ARGB_Cyan` | `&hFF00FFFF` | 0, 255, 255 |
| `ARGB_DarkBlue` | `&hFF00008B` | 0, 0, 139 |
| `ARGB_DarkCyan` | `&hFF008B8B` | 0, 139, 139 |
| `ARGB_DarkGoldenrod` | `&hFFB8860B` | 184, 134, 11 |
| `ARGB_DarkGray` | `&hFFA9A9A9` | 169, 169, 169 |
| `ARGB_DarkGreen` | `&hFF006400` | 0, 100, 0 |
| `ARGB_DarkKhaki` | `&hFFBDB76B` | 189, 183, 107 |
| `ARGB_DarkMagenta` | `&hFF8B008B` | 139, 0, 139 |
| `ARGB_DarkOliveGreen` | `&hFF556B2F` | 85, 107, 47 |
| `ARGB_DarkOrange` | `&hFFFF8C00` | 255, 140, 0 |
| `ARGB_DarkOrchid` | `&hFF9932CC` | 153, 50, 204 |
| `ARGB_DarkRed` | `&hFF8B0000` | 139, 0, 0 |
| `ARGB_DarkSalmon` | `&hFFE9967A` | 233, 150, 122 |
| `ARGB_DarkSeaGreen` | `&hFF8FBC8B` | 143, 188, 139 |
| `ARGB_DarkSlateBlue` | `&hFF483D8B` | 72, 61, 139 |
| `ARGB_DarkSlateGray` | `&hFF2F4F4F` | 47, 79, 79 |
| `ARGB_DarkTurquoise` | `&hFF00CED1` | 0, 206, 209 |
| `ARGB_DarkViolet` | `&hFF9400D3` | 148, 0, 211 |
| `ARGB_DeepPink` | `&hFFFF1493` | 255, 20, 147 |
| `ARGB_DeepSkyBlue` | `&hFF00BFFF` | 0, 191, 255 |
| `ARGB_DimGray` | `&hFF696969` | 105, 105, 105 |
| `ARGB_DodgerBlue` | `&hFF1E90FF` | 30, 144, 255 |
| `ARGB_Firebrick` | `&hFFB22222` | 178, 34, 34 |
| `ARGB_FloralWhite` | `&hFFFFFAF0` | 255, 250, 240 |
| `ARGB_ForestGreen` | `&hFF228B22` | 34, 139, 34 |
| `ARGB_Fuchsia` | `&hFFFF00FF` | 255, 0, 255 |
| `ARGB_Gainsboro` | `&hFFDCDCDC` | 220, 220, 220 |
| `ARGB_GhostWhite` | `&hFFF8F8FF` | 248, 248, 255 |
| `ARGB_Gold` | `&hFFFFD700` | 255, 215, 0 |
| `ARGB_Goldenrod` | `&hFFDAA520` | 218, 165, 32 |
| `ARGB_Gray` | `&hFF808080` | 128, 128, 128 |
| `ARGB_Green` | `&hFF008000` | 0, 128, 0 |
| `ARGB_GreenYellow` | `&hFFADFF2F` | 173, 255, 47 |
| `ARGB_Honeydew` | `&hFFF0FFF0` | 240, 255, 240 |
| `ARGB_HotPink` | `&hFFFF69B4` | 255, 105, 180 |
| `ARGB_IndianRed` | `&hFFCD5C5C` | 205, 92, 92 |
| `ARGB_Indigo` | `&hFF4B0082` | 75, 0, 130 |
| `ARGB_Ivory` | `&hFFFFFFF0` | 255, 255, 240 |
| `ARGB_Khaki` | `&hFFF0E68C` | 240, 230, 140 |
| `ARGB_Lavender` | `&hFFE6E6FA` | 230, 230, 250 |
| `ARGB_LavenderBlush` | `&hFFFFF0F5` | 255, 240, 245 |
| `ARGB_LawnGreen` | `&hFF7CFC00` | 124, 252, 0 |
| `ARGB_LemonChiffon` | `&hFFFFFACD` | 255, 250, 205 |
| `ARGB_LightBlue` | `&hFFADD8E6` | 173, 216, 230 |
| `ARGB_LightCoral` | `&hFFF08080` | 240, 128, 128 |
| `ARGB_LightCyan` | `&hFFE0FFFF` | 224, 255, 255 |
| `ARGB_LightGoldenrodYellow` | `&hFFFAFAD2` | 250, 250, 210 |
| `ARGB_LightGray` | `&hFFD3D3D3` | 211, 211, 211 |
| `ARGB_LightGreen` | `&hFF90EE90` | 144, 238, 144 |
| `ARGB_LightPink` | `&hFFFFB6C1` | 255, 182, 193 |
| `ARGB_LightSalmon` | `&hFFFFA07A` | 255, 160, 122 |
| `ARGB_LightSeaGreen` | `&hFF20B2AA` | 32, 178, 170 |
| `ARGB_LightSkyBlue` | `&hFF87CEFA` | 135, 206, 250 |
| `ARGB_LightSlateGray` | `&hFF778899` | 119, 136, 153 |
| `ARGB_LightSteelBlue` | `&hFFB0C4DE` | 176, 196, 222 |
| `ARGB_LightYellow` | `&hFFFFFFE0` | 255, 255, 224 |
| `ARGB_Lime` | `&hFF00FF00` | 0, 255, 0 |
| `ARGB_LimeGreen` | `&hFF32CD32` | 50, 205, 50 |
| `ARGB_Linen` | `&hFFFAF0E6` | 250, 240, 230 |
| `ARGB_Magenta` | `&hFFFF00FF` | 255, 0, 255 |
| `ARGB_Maroon` | `&hFF800000` | 128, 0, 0 |
| `ARGB_MediumAquamarine` | `&hFF66CDAA` | 102, 205, 170 |
| `ARGB_MediumBlue` | `&hFF0000CD` | 0, 0, 205 |
| `ARGB_MediumOrchid` | `&hFFBA55D3` | 186, 85, 211 |
| `ARGB_MediumPurple` | `&hFF9370DB` | 147, 112, 219 |
| `ARGB_MediumSeaGreen` | `&hFF3CB371` | 60, 179, 113 |
| `ARGB_MediumSlateBlue` | `&hFF7B68EE` | 123, 104, 238 |
| `ARGB_MediumSpringGreen` | `&hFF00FA9A` | 0, 250, 154 |
| `ARGB_MediumTurquoise` | `&hFF48D1CC` | 72, 209, 204 |
| `ARGB_MediumVioletRed` | `&hFFC71585` | 199, 21, 133 |
| `ARGB_MidnightBlue` | `&hFF191970` | 25, 25, 112 |
| `ARGB_MintCream` | `&hFFF5FFFA` | 245, 255, 250 |
| `ARGB_MistyRose` | `&hFFFFE4E1` | 255, 228, 225 |
| `ARGB_Moccasin` | `&hFFFFE4B5` | 255, 228, 181 |
| `ARGB_NavajoWhite` | `&hFFFFDEAD` | 255, 222, 173 |
| `ARGB_Navy` | `&hFF000080` | 0, 0, 128 |
| `ARGB_OldLace` | `&hFFFDF5E6` | 253, 245, 230 |
| `ARGB_Olive` | `&hFF808000` | 128, 128, 0 |
| `ARGB_OliveDrab` | `&hFF6B8E23` | 107, 142, 35 |
| `ARGB_Orange` | `&hFFFFA500` | 255, 165, 0 |
| `ARGB_OrangeRed` | `&hFFFF4500` | 255, 69, 0 |
| `ARGB_Orchid` | `&hFFDA70D6` | 218, 112, 214 |
| `ARGB_PaleGoldenrod` | `&hFFEEE8AA` | 238, 232, 170 |
| `ARGB_PaleGreen` | `&hFF98FB98` | 152, 251, 152 |
| `ARGB_PaleTurquoise` | `&hFFAFEEEE` | 175, 238, 238 |
| `ARGB_PaleVioletRed` | `&hFFDB7093` | 219, 112, 147 |
| `ARGB_PapayaWhip` | `&hFFFFEFD5` | 255, 239, 213 |
| `ARGB_PeachPuff` | `&hFFFFDAB9` | 255, 218, 185 |
| `ARGB_Peru` | `&hFFCD853F` | 205, 133, 63 |
| `ARGB_Pink` | `&hFFFFC0CB` | 255, 192, 203 |
| `ARGB_Plum` | `&hFFDDA0DD` | 221, 160, 221 |
| `ARGB_PowderBlue` | `&hFFB0E0E6` | 176, 224, 230 |
| `ARGB_Purple` | `&hFF800080` | 128, 0, 128 |
| `ARGB_Red` | `&hFFFF0000` | 255, 0, 0 |
| `ARGB_RosyBrown` | `&hFFBC8F8F` | 188, 143, 143 |
| `ARGB_RoyalBlue` | `&hFF4169E1` | 65, 105, 225 |
| `ARGB_SaddleBrown` | `&hFF8B4513` | 139, 69, 19 |
| `ARGB_Salmon` | `&hFFFA8072` | 250, 128, 114 |
| `ARGB_SandyBrown` | `&hFFF4A460` | 244, 164, 96 |
| `ARGB_SeaGreen` | `&hFF2E8B57` | 46, 139, 87 |
| `ARGB_SeaShell` | `&hFFFFF5EE` | 255, 245, 238 |
| `ARGB_Sienna` | `&hFFA0522D` | 160, 82, 45 |
| `ARGB_Silver` | `&hFFC0C0C0` | 192, 192, 192 |
| `ARGB_SkyBlue` | `&hFF87CEEB` | 135, 206, 235 |
| `ARGB_SlateBlue` | `&hFF6A5ACD` | 106, 90, 205 |
| `ARGB_SlateGray` | `&hFF708090` | 112, 128, 144 |
| `ARGB_Snow` | `&hFFFFFAFA` | 255, 250, 250 |
| `ARGB_SpringGreen` | `&hFF00FF7F` | 0, 255, 127 |
| `ARGB_SteelBlue` | `&hFF4682B4` | 70, 130, 180 |
| `ARGB_Tan_` | `&hFFD2B48C` | 210, 180, 140 |
| `ARGB_Teal` | `&hFF008080` | 0, 128, 128 |
| `ARGB_Thistle` | `&hFFD8BFD8` | 216, 191, 216 |
| `ARGB_Tomato` | `&hFFFF6347` | 255, 99, 71 |
| `ARGB_Transparent_` | `&h00FFFFFF` | 255, 255, 255 (alpha 0) |
| `ARGB_Turquoise` | `&hFF40E0D0` | 64, 224, 208 |
| `ARGB_Violet` | `&hFFEE82EE` | 238, 130, 238 |
| `ARGB_Wheat` | `&hFFF5DEB3` | 245, 222, 179 |
| `ARGB_White` | `&hFFFFFFFF` | 255, 255, 255 |
| `ARGB_WhiteSmoke` | `&hFFF5F5F5` | 245, 245, 245 |
| `ARGB_Yellow` | `&hFFFFFF00` | 255, 255, 0 |
| `ARGB_YellowGreen` | `&hFF9ACD32` | 154, 205, 50 |

## See also

- [Category: sys/win](Category-Sys-Win)
- [Common dialogs](SysWin-Common-Dialogs) for letting the user pick a `COLORREF`
- [Bitmaps](SysWin-Bitmaps) for DIB pixels, which use the ARGB layout
- [CGpGraphics](CGpGraphics) and [Brushes (GDI+)](SysWin-GdiPlus-Brushes), which take `ARGB_*` colours
