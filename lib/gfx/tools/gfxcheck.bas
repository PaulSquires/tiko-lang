'' gfxcheck.bas -- an interactive check of libtkogfx, the same on Windows, Linux and macOS.
''
'' ORIGINAL WORK. Part of libtkogfx (LGPL-2.1-or-later with the static-linking exception).
''
'' THE HAND CHECK nothing automatic can do (docs/graphics RFC-0012, "owed: an interactive
'' pass"): real keys, a real pointer, a real close box. Build it with the toolchain under
'' test and nothing else:
''
''     tiko gfxcheck.bas            then run ./gfxcheck  (gfxcheck.exe on Windows)
''     ./gfxcheck --auto            no input needed: switches every page, exits 0
''
'' Five pages, TAB moves between them. ESC twice -- or the window's close box -- quits.
''   1 keyboard   INKEY (extended keys named), typed text, MULTIKEY lit on a key map
''   2 mouse      GETMOUSE, buttons, wheel, a crosshair; SETMOUSE: C centre, H hide/show,
''                L clip on/off; W retitles the window, P moves it
''   3 events     SCREENEVENT, every kind, with what it carried
''   4 8bpp       a paletted screen with the palette rotating; keys still work
''   5 input      LINE INPUT on the graphics screen
'' On every page the ball keeps bouncing: if it stops, presentation has stopped.

#include once "fbgfx.bi"
using FB

const SW = 640
const SH = 480

#if defined( __FB_WIN32__ )
    const PLATFORM_NAME = "Windows"
#elseif defined( __FB_DARWIN__ )
    const PLATFORM_NAME = "macOS"
#elseif defined( __FB_LINUX__ )
    const PLATFORM_NAME = "Linux"
#else
    const PLATFORM_NAME = "unknown"
#endif

const PAGES = 5
dim shared as long CurPage = 1
dim shared as long AutoMode, Frames, Quitting, EscArmed
dim shared as string TypedText, LastKey, Banner
dim shared as string EvLog( 0 to 13 )
dim shared as long EvCount
dim shared as long BallX = 100, BallY = 100, BallDX = 3, BallDY = 2
dim shared as long CursorHidden, Clipped, TitleN, WinMoved
dim shared as string InputResult

'' ------------------------------------------------------------ helpers

sub Txt( byval x as long, byval y as long, byref s as string, byval c as ulong = &hFFFFFF )
    draw string ( x, y ), s, c
end sub

sub LogEvent( byref s as string )
    for i as integer = 0 to 12
        EvLog(i) = EvLog(i + 1)
    next
    EvCount += 1
    EvLog(13) = right( "    " & EvCount, 4 ) & "  " & s
end sub

function ExtKeyName( byval sc as long ) as string
    select case sc
    case SC_UP       : return "Up"
    case SC_DOWN     : return "Down"
    case SC_LEFT     : return "Left"
    case SC_RIGHT    : return "Right"
    case SC_HOME     : return "Home"
    case SC_END      : return "End"
    case SC_PAGEUP   : return "PgUp"
    case SC_PAGEDOWN : return "PgDn"
    case SC_INSERT   : return "Ins"
    case SC_DELETE   : return "Del"
    case SC_F1 to SC_F10 : return "F" & (sc - SC_F1 + 1)
    case SC_F11      : return "F11"
    case SC_F12      : return "F12"
    case &h6B        : return "window close (KEY_QUIT)"
    end select
    return "scancode &h" & hex( sc, 2 )
end function

'' What INKEY returned, spelled out byte by byte, and named.
function DescribeKey( byref k as string ) as string
    if len( k ) = 2 andalso k[0] = 255 then
        return "chr(255)+chr(" & k[1] & ")  = " & ExtKeyName( k[1] )
    end if
    dim as long c = k[0]
    select case c
    case 8   : return "chr(8)  = Backspace"
    case 9   : return "chr(9)  = Tab"
    case 13  : return "chr(13) = Enter"
    case 27  : return "chr(27) = Esc"
    case 1 to 26 : return "chr(" & c & ") = Ctrl+" & chr( c + 64 )
    case 32 to 126 : return "chr(" & c & ") = '" & chr( c ) & "'"
    end select
    return "chr(" & c & ")"
end function

function EventName( byval t as long ) as string
    select case t
    case EVENT_KEY_PRESS            : return "KEY_PRESS"
    case EVENT_KEY_RELEASE          : return "KEY_RELEASE"
    case EVENT_KEY_REPEAT           : return "KEY_REPEAT"
    case EVENT_MOUSE_MOVE           : return "MOUSE_MOVE"
    case EVENT_MOUSE_BUTTON_PRESS   : return "BUTTON_PRESS"
    case EVENT_MOUSE_BUTTON_RELEASE : return "BUTTON_RELEASE"
    case EVENT_MOUSE_DOUBLE_CLICK   : return "DOUBLE_CLICK"
    case EVENT_MOUSE_WHEEL          : return "MOUSE_WHEEL"
    case EVENT_MOUSE_ENTER          : return "MOUSE_ENTER"
    case EVENT_MOUSE_EXIT           : return "MOUSE_EXIT"
    case EVENT_WINDOW_GOT_FOCUS     : return "GOT_FOCUS"
    case EVENT_WINDOW_LOST_FOCUS    : return "LOST_FOCUS"
    case EVENT_WINDOW_CLOSE         : return "WINDOW_CLOSE"
    case EVENT_MOUSE_HWHEEL         : return "MOUSE_HWHEEL"
    end select
    return "type " & t
end function

'' ------------------------------------------------------------ screens

sub OpenScreen( )
    if CurPage = 4 then
        screenres 320, 200, 8
        for i as integer = 0 to 255
            palette i, (i * 3) and 255, (i * 5 + 80) and 255, (255 - i) and 255
        next
    else
        screenres SW, SH, 32
    end if
    windowtitle "tiko gfxcheck -- " & PLATFORM_NAME & " -- page " & CurPage
    CursorHidden = 0
    Clipped = 0
end sub

'' ------------------------------------------------------------ input

sub HandleKey( byref k as string )
    LastKey = DescribeKey( k )
    if len( k ) = 2 andalso k[0] = 255 andalso k[1] = &h6B then
        LogEvent( "INKEY saw the close box: quitting" )
        Quitting = 1
        exit sub
    end if
    if k = chr( 27 ) then
        if EscArmed then Quitting = 1 else EscArmed = 1
        exit sub
    end if
    EscArmed = 0
    if k = chr( 9 ) then
        CurPage = (CurPage mod PAGES) + 1
        OpenScreen( )
        exit sub
    end if
    select case CurPage
    case 1
        if k = chr( 8 ) then
            if len( TypedText ) then TypedText = left( TypedText, len( TypedText ) - 1 )
        elseif k = chr( 13 ) then
            TypedText = ""
        elseif (len( k ) = 1) andalso (k[0] >= 32) then
            TypedText = right( TypedText & k, 60 )
        end if
    case 2
        select case ucase( k )
        case "C" : setmouse SW \ 2, SH \ 2 : Banner = "SETMOUSE to the centre"
        case "H"
            CursorHidden xor= 1
            setmouse , , iif( CursorHidden, 0, 1 )
            Banner = iif( CursorHidden, "cursor HIDDEN (H shows it)", "cursor shown" )
        case "L"
            Clipped xor= 1
            setmouse , , , Clipped
            Banner = iif( Clipped, "pointer CLIPPED to the window (L frees it)", "pointer free" )
        case "W"
            TitleN += 1
            windowtitle "retitled " & TitleN & " times -- tiko gfxcheck"
            Banner = "WINDOWTITLE changed -- look at the title bar"
        case "P"
            WinMoved xor= 1
            screencontrol SET_WINDOW_POS, iif( WinMoved, 40, 200 ), iif( WinMoved, 40, 160 )
            Banner = "window moved"
        end select
    end select
end sub

sub PumpInput( )
    dim as string k = inkey
    while len( k )
        HandleKey( k )
        if Quitting then exit sub
        k = inkey
    wend
    dim as EVENT e
    while screenevent( @e )
        dim as string s = EventName( e.type )
        select case e.type
        case EVENT_KEY_PRESS, EVENT_KEY_RELEASE, EVENT_KEY_REPEAT
            s &= "  scancode &h" & hex( e.scancode, 2 ) & "  ascii " & e.ascii
        case EVENT_MOUSE_MOVE
            s &= "  x " & e.x & "  y " & e.y & "  dx " & e.dx & "  dy " & e.dy
        case EVENT_MOUSE_BUTTON_PRESS, EVENT_MOUSE_BUTTON_RELEASE, EVENT_MOUSE_DOUBLE_CLICK
            s &= "  button " & e.button
        case EVENT_MOUSE_WHEEL
            s &= "  z " & e.z
        case EVENT_MOUSE_HWHEEL
            s &= "  w " & e.w
        case EVENT_WINDOW_CLOSE
            s &= "  (the close box)"
        end select
        '' a mouse move floods the log; keep it off page 3 unless it is the only thing
        if (e.type <> EVENT_MOUSE_MOVE) orelse (CurPage = 3) then LogEvent( s )
    wend
end sub

'' ------------------------------------------------------------ drawing

sub DrawBall( byval sw_ as long, byval sh_ as long, byval col as ulong )
    BallX += BallDX : BallY += BallDY
    if (BallX < 10) orelse (BallX > sw_ - 10) then BallDX = -BallDX
    if (BallY < 40) orelse (BallY > sh_ - 10) then BallDY = -BallDY
    circle ( BallX, BallY ), 8, col, , , , F
end sub

sub DrawHeader( )
    dim as string drv
    screencontrol GET_DRIVER_NAME, drv
    dim as long dw, dh
    screeninfo dw, dh
    line ( 0, 0 )-( SW - 1, 27 ), &h203060, BF
    Txt( 8, 4, "tiko gfxcheck  " & PLATFORM_NAME & "  driver " & drv & "  desktop " & dw & "x" & dh & "  frame " & Frames, &hFFFF80 )
    Txt( 8, 16, "TAB next page (" & CurPage & "/" & PAGES & ")   ESC twice or the close box quits" & iif( EscArmed, "   -- ESC again to quit", "" ), &hC0C0C0 )
end sub

'' One key of the MULTIKEY map: lit while held.
sub KeyCap( byval x as long, byval y as long, byval wd as long, byref lab as string, byval sc as long )
    dim as long held = multikey( sc )
    line ( x, y )-( x + wd, y + 18 ), iif( held, &h30C030, &h303030 ), BF
    line ( x, y )-( x + wd, y + 18 ), &h808080, B
    Txt( x + 4, y + 6, lab, iif( held, &h000000, &hD0D0D0 ) )
end sub

sub PageKeyboard( )
    Txt( 16, 44, "1. KEYBOARD -- type anything. Arrows, F-keys, Home/End, Ctrl+letters too.", &h80FFFF )
    Txt( 16, 64, "last INKEY : " & LastKey )
    Txt( 16, 80, "typed text : " & TypedText & iif( (Frames \ 20) mod 2, "_", " " ) )
    Txt( 16, 92, "             (Backspace deletes, Enter clears)", &h909090 )
    Txt( 16, 116, "MULTIKEY -- a key lights while it is HELD:", &h80FFFF )
    dim as string row1 = "QWERTYUIOP", row2 = "ASDFGHJKL", row3 = "ZXCVBNM"
    dim as long sc1( 0 to 9 ) = { SC_Q, SC_W, SC_E, SC_R, SC_T, SC_Y, SC_U, SC_I, SC_O, SC_P }
    dim as long sc2( 0 to 8 ) = { SC_A, SC_S, SC_D, SC_F, SC_G, SC_H, SC_J, SC_K, SC_L }
    dim as long sc3( 0 to 6 ) = { SC_Z, SC_X, SC_C, SC_V, SC_B, SC_N, SC_M }
    for i as integer = 0 to 9 : KeyCap( 40 + i * 26, 136, 22, mid( row1, i + 1, 1 ), sc1(i) ) : next
    for i as integer = 0 to 8 : KeyCap( 50 + i * 26, 160, 22, mid( row2, i + 1, 1 ), sc2(i) ) : next
    for i as integer = 0 to 6 : KeyCap( 62 + i * 26, 184, 22, mid( row3, i + 1, 1 ), sc3(i) ) : next
    KeyCap( 40, 212, 50, "Shift", SC_LSHIFT )
    KeyCap( 96, 212, 44, "Ctrl", SC_CONTROL )
    KeyCap( 146, 212, 36, "Alt", SC_ALT )
    KeyCap( 188, 212, 76, "Cmd/Win", SC_LWIN )
    KeyCap( 270, 212, 100, "Space", SC_SPACE )
    KeyCap( 376, 212, 36, "Esc", SC_ESCAPE )
    KeyCap( 418, 212, 46, "Enter", SC_ENTER )
    KeyCap( 470, 212, 36, "Tab", SC_TAB )
    KeyCap( 520, 160, 22, "^", SC_UP )
    KeyCap( 494, 184, 22, "<", SC_LEFT )
    KeyCap( 520, 184, 22, "v", SC_DOWN )
    KeyCap( 546, 184, 22, ">", SC_RIGHT )
    dim as long fx = 40
    for i as integer = 0 to 9
        KeyCap( fx + i * 44, 248, 40, "F" & (i + 1), SC_F1 + i )
    next
    KeyCap( fx + 440, 248, 40, "F11", SC_F11 )
    KeyCap( fx + 484, 248, 40, "F12", SC_F12 )
    Txt( 16, 290, "On macOS the F-keys may need fn; Cmd lights Cmd/Win.", &h909090 )
end sub

sub PageMouse( )
    Txt( 16, 44, "2. MOUSE -- move, click, wheel. C centre  H hide/show  L clip  W retitle  P move", &h80FFFF )
    dim as long mx, my, mz, mb, mc
    dim as long r = getmouse( mx, my, mz, mb, mc )
    if r = 0 then
        Txt( 16, 64, "GETMOUSE x " & mx & "  y " & my & "  wheel " & mz & "  buttons " & mb & "  clip " & mc )
        line ( mx - 12, my )-( mx + 12, my ), &hFF4040
        line ( mx, my - 12 )-( mx, my + 12 ), &hFF4040
        circle ( mx, my ), 6, &hFF4040
    else
        Txt( 16, 64, "GETMOUSE -1: the pointer is outside the window (or the window is not active)", &hFF8080 )
    end if
    dim as string nm( 0 to 2 ) = { "LEFT", "RIGHT", "MIDDLE" }
    for i as integer = 0 to 2
        dim as long down = iif( (r = 0) andalso ((mb and (1 shl i)) <> 0), 1, 0 )
        line ( 16 + i * 90, 84 )-( 96 + i * 90, 110 ), iif( down, &h30C030, &h303030 ), BF
        Txt( 26 + i * 90, 94, nm(i), iif( down, &h000000, &hD0D0D0 ) )
    next
    dim as long px, py
    screencontrol GET_WINDOW_POS, px, py
    Txt( 16, 122, "window position " & px & ", " & py & "   cursor " & iif( CursorHidden, "hidden", "shown" ) & "   clip " & iif( Clipped, "on", "off" ) )
    if len( Banner ) then Txt( 16, 138, "-> " & Banner, &hFFFF80 )
end sub

sub PageEvents( )
    Txt( 16, 44, "3. SCREENEVENT -- press/release/hold keys, click, wheel, leave/enter, unfocus/refocus", &h80FFFF )
    for i as integer = 0 to 13
        Txt( 16, 64 + i * 14, EvLog(i), iif( i = 13, &hFFFFFF, &hA0A0A0 ) )
    next
end sub

sub PagePaletted( )
    '' rotate the palette: every pixel's colour changes, no pixel is redrawn
    for i as integer = 0 to 255
        dim as long j = (i + Frames * 2) and 255
        palette i, (j * 3) and 255, (j * 5 + 80) and 255, (255 - j) and 255
    next
    if (Frames mod 60) = 0 orelse (Frames < 3) then
        for y as integer = 30 to 199
            line ( 0, y )-( 319, y ), y and 255
        next
    end if
    line ( 0, 0 )-( 319, 28 ), 0, BF
    draw string ( 4, 4 ), "4. 8bpp, palette rotating", 255
    draw string ( 4, 16 ), "last key: " & left( LastKey, 26 ), 255
end sub

sub PageInput( )
    Txt( 16, 44, "5. LINE INPUT on the graphics screen. Press I to start, type, Enter.", &h80FFFF )
    Txt( 16, 64, "last result: [" & InputResult & "]" )
end sub

'' ------------------------------------------------------------ main

if command( 1 ) = "--auto" then AutoMode = 1
OpenScreen( )
LogEvent( "started on " & PLATFORM_NAME )

do
    PumpInput( )
    if Quitting then exit do

    if (CurPage = 5) andalso (multikey( SC_I ) <> 0) then
        while multikey( SC_I ) : sleep 10 : wend
        while len( inkey ) : wend
        cls
        locate 6, 3
        dim as string s
        line input "Type something and press Enter: ", s
        InputResult = s
        LogEvent( "LINE INPUT returned [" & s & "]" )
    end if

    screenlock
    if CurPage = 4 then
        PagePaletted( )
        DrawBall( 320, 200, 15 )
    else
        cls
        DrawHeader( )
        select case CurPage
        case 1 : PageKeyboard( )
        case 2 : PageMouse( )
        case 3 : PageEvents( )
        case 5 : PageInput( )
        end select
        DrawBall( SW, SH, &hFFC020 )
    end if
    screenunlock
    sleep 15
    Frames += 1

    '' --auto: every page for 40 frames, a few keys through the real handler, then out
    if AutoMode then
        if (Frames mod 40) = 0 then
            HandleKey( "x" )
            HandleKey( chr( 255 ) & chr( SC_UP ) )
            HandleKey( chr( 9 ) )
        end if
        if Frames >= 40 * PAGES + 5 then exit do
    end if
loop

dim as long finalPage = CurPage, finalFrames = Frames
screen 0
print "gfxcheck: " & PLATFORM_NAME & ", " & finalFrames & " frames, ended on page " & finalPage & iif( AutoMode, " (--auto)", "" )
print "gfxcheck: last key " & LastKey
end 0
