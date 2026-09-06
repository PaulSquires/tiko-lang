'' smoke-entry.bas -- the ENTRY LAYER, driven the way a real program drives it.
''
'' ORIGINAL WORK. Part of libtkogfx (LGPL-2.1-or-later with the static-linking
'' exception).
''
'' NOT AN A/B TEST, and that is the point. Every abtest-*.bas compares an
'' INTERNAL routine against gfxlib2 -- nothing there calls fb_GfxLine. This
'' does: it is compiled by fbc, linked against libtkogfx and tiko-rt's MSVC
'' archive, and it reaches the rasterizers ONLY through the public symbols,
'' which is the one thing the abtests structurally cannot do because they link
'' gfxlib2 for the same names.
''
'' So it checks a different claim. Not "our line matches theirs" -- that is what
'' the abtests are for -- but "our fb_GfxLine reaches our line at all, with the
'' arguments decoded right". It asserts pixels through POINT, because the values
'' it can assert are the ones it just wrote.
''
'' IT FOUND THE INVERTED WindowOpen TEST ON ITS FIRST RUN. WindowOpen returns 1
'' on success; entry/screen.bi tested it for non-zero and treated success as
'' failure, so SCREEN had NEVER opened a screen and every drawing call answered
'' -1. Nothing else in the project could have caught it: the abtests never call
'' an entry point, and the archive linked and exported all 39 symbols happily.
''
'' Run by tools/smoke.sh.

#include once "fbgfx.bi"
#include once "windows.bi"
using FB

dim shared as long fails

'' FAILURES ARE BUFFERED UNTIL AFTER SCREEN 0, and this is not cosmetic. Once
'' the console hooks are installed PRINT on a graphics screen draws into the
'' FRAMEBUFFER, so a failure reported mid-run is written to a window nobody
'' reads and the program exits non-zero with no message. This test only ever
'' printed on failure, so it passed either way and the trap stayed invisible.
dim shared as string Log_

sub chk( byref what as string, byval want as long, byval got as long )
    if want <> got then
        Log_ += "  FAIL " + what + " -- want " + str( want ) + " got " + str( got ) + chr( 10 )
        fails += 1
    end if
end sub

screenres 64, 48, 32

'' ---- the screen target ----
chk( "point on a fresh screen", 0, point( 5, 5 ) )
pset ( 5, 5 ), &hFF3366
chk( "pset then point", &hFF3366, point( 5, 5 ) )

line ( 0, 0 )-( 10, 0 ), &h112233
chk( "line", &h112233, point( 7, 0 ) )

line ( 20, 20 )-( 30, 30 ), &h445566, BF
chk( "line BF", &h445566, point( 25, 25 ) )

circle ( 40, 20 ), 6, &h778899
chk( "circle", &h778899, point( 46, 20 ) )

'' ---- an image target ----
''
'' Exercises the OTHER half of ContextFor: a target that is not the screen, and
'' therefore the per-image context cache.
dim as any ptr im = imagecreate( 8, 8, &h010203 )
chk( "imagecreate fill", &h010203, point( 3, 3, im ) )
pset im, ( 1, 1 ), &h0A0B0C
chk( "pset into an image", &h0A0B0C, point( 1, 1, im ) )

put ( 50, 30 ), im, PSET
chk( "put PSET", &h010203, point( 53, 33 ) )
chk( "put carried the drawn pixel", &h0A0B0C, point( 51, 31 ) )

'' ---- GET into a plain buffer, then PUT it back ----
''
'' The round trip is what checks GET's header: a PUT that reads it back wrong
'' draws nothing or draws garbage, and either way the pixel below is not the one
'' that went in.
dim as ubyte g(0 to 4095)
get ( 20, 20 )-( 27, 27 ), g(0)
put ( 0, 40 ), g(0), PSET
chk( "get then put round trip", &h445566, point( 3, 43 ) )

'' ---- DRAW STRING ----
''
'' Only that it drew SOMETHING in the cell. Which pixels are the built-in font's
'' business and tools/abtest-print.bas compares those against gfxlib2; what is
'' new here is that the entry point reaches them.
draw string ( 2, 20 ), "A", &hFFFFFF
dim as long lit
for y as integer = 20 to 27
    for x as integer = 2 to 9
        if point( x, y ) = &hFFFFFF then lit += 1
    next
next
chk( "draw string put pixels down", 1, iif( lit > 0, 1, 0 ) )

'' ---- the console input half ----
''
'' NOT AN A/B, AND IT CANNOT BE. tools/gate-entry.sh drives both libraries from
'' one source, and there is no key-injection route they share: PostMessage of
'' WM_CHAR reaches this library's window procedure and does NOT reach gfxlib2 --
'' measured, the reference run timed out with nothing in its queue. SendInput
'' would reach both and would also type into whatever else has focus, which is
'' the desktop risk the project already refuses for mouse clicks.
''
'' So this is a REGRESSION check against what was measured by hand, not a
'' comparison. It is here rather than in the gate for exactly that reason.
scope
    dim as long winh
    screencontrol GET_WINDOW_HANDLE, winh
    dim as HWND hw = cast( HWND, cast( any ptr, cast( uinteger, winh ) ) )
    chk( "screencontrol returns a window handle", 1, iif( hw <> 0, 1, 0 ) )

    if hw <> 0 then
        '' Posted BEFORE the read, so neither side races the pump.
        for i as integer = 0 to 2
            PostMessage( hw, WM_CHAR, cast( WPARAM, asc( "a" ) + i ), 0 )
        next
        Sleep( 150 )
        dim as string acc
        for i as integer = 1 to 6
            acc += inkey
        next
        chk( "inkey drains the posted keys", 0, iif( acc = "abc", 0, 1 ) )

        '' ---- extended keys ----
        ''
        '' ASSERTED AGAINST fbgfx.bi's OWN SC_* CONSTANTS, which is what makes
        '' this more than a restatement: the expected string is built from
        '' SC_UP and SC_LEFT as the reference header declares them, not from a
        '' number written here. If FreeBASIC's scancodes were ever NOT the PC
        '' set-1 codes that lParam carries, this is what would say so.
        ''
        '' The lParam is crafted -- scancode in bits 16..23 -- because that is
        '' where the window procedure reads it from. Posting the VK alone would
        '' pass a zero scancode and prove nothing.
        for i as integer = 1 to 6
            inkey
        next
        PostMessage( hw, WM_KEYDOWN, VK_UP, cast( LPARAM, SC_UP shl 16 ) )
        PostMessage( hw, WM_KEYDOWN, VK_LEFT, cast( LPARAM, SC_LEFT shl 16 ) )
        Sleep( 150 )
        dim as string ext
        for i as integer = 1 to 4
            ext += inkey
        next
        '' THE RESTATED SCANCODES MUST MATCH fbgfx.bi. core/keyboard.bi cannot
        '' include the reference header, so it restates the five codes the
        '' editing loop needs; this is what stops that restatement drifting.
        '' The expected values come from fbgfx.bi, the actual ones from what the
        '' library acts on -- posting each key and seeing the edit happen is the
        '' same assertion made the long way round.
        chk( "SC_LEFT is &h4B",   &h4B, SC_LEFT )
        chk( "SC_RIGHT is &h4D",  &h4D, SC_RIGHT )
        chk( "SC_HOME is &h47",   &h47, SC_HOME )
        chk( "SC_END is &h4F",    &h4F, SC_END )
        chk( "SC_DELETE is &h53", &h53, SC_DELETE )

        chk( "extended keys arrive as chr(255) + scancode", 0, _
             iif( ext = chr( 255 ) + chr( SC_UP ) + chr( 255 ) + chr( SC_LEFT ), 0, 1 ) )

        '' A CHARACTER KEY MUST ARRIVE ONCE, not twice. WM_KEYDOWN fires for
        '' ordinary keys too, and if the window procedure posted an extended
        '' code for those as well, every letter would arrive as itself AND as a
        '' scancode pair. Only WM_KEYDOWN is posted here: the pump's
        '' TranslateMessage is what turns it into the WM_CHAR, which is exactly
        '' what a real key press does.
        ''
        '' Posting WM_CHAR alongside it is what the first version of this check
        '' did, and it failed -- correctly. Two WM_CHARs reach the ring because
        '' the test sent one and TranslateMessage made another; that is the
        '' harness double-counting, not the library.
        for i as integer = 1 to 6
            inkey
        next
        PostMessage( hw, WM_KEYDOWN, cast( WPARAM, asc( "A" ) ), cast( LPARAM, &h1E shl 16 ) )
        Sleep( 150 )
        dim as string once_
        for i as integer = 1 to 4
            once_ += inkey
        next
        '' LOWERCASE, and that is the point rather than a detail. The VK posted
        '' is 'A' -- virtual keys are uppercase letters -- and what comes back
        '' is "a", because TranslateMessage applied the shift state and no
        '' Shift was held. That is exactly why WM_CHAR is the source this
        '' library reads: the layout, the shift state and any dead-key
        '' composition are already resolved by the time it arrives.
        ''
        '' Measured: expecting "A" here failed with chr(97).
        chk( "a character key arrives once", 0, iif( once_ = "a", 0, 1 ) )

        '' INPUT reads the WINDOW, not stdin. That is what isredirproc decides:
        '' with it null the runtime asks the OS, and a redirected stdin wins.
        dim as string typed = "Hi" + chr( 13 )
        for i as integer = 0 to len( typed ) - 1
            PostMessage( hw, WM_CHAR, cast( WPARAM, typed[i] ), 0 )
        next
        Sleep( 150 )
        dim as string got
        input "", got
        chk( "input reads the window", 0, iif( got = "Hi", 0, 1 ) )

        '' Backspace really edits: AXB, two rubs, Y -> AY.
        dim as string typed2 = "AXB" + chr( 8 ) + chr( 8 ) + "Y" + chr( 13 )
        for i as integer = 0 to len( typed2 ) - 1
            PostMessage( hw, WM_CHAR, cast( WPARAM, typed2[i] ), 0 )
        next
        Sleep( 150 )
        dim as string got2
        input "", got2
        chk( "backspace edits the line", 0, iif( got2 = "AY", 0, 1 ) )

        '' ---- the editing loop moves within the line ----
        ''
        '' Left twice, then a character: it must INSERT, not overwrite or append.
        '' "abc" with the cursor between a and b, typing X, gives "aXbc".
        dim as string t1 = "abc"
        for i as integer = 0 to len( t1 ) - 1
            PostMessage( hw, WM_CHAR, cast( WPARAM, t1[i] ), 0 )
        next
        PostMessage( hw, WM_KEYDOWN, VK_LEFT, cast( LPARAM, SC_LEFT shl 16 ) )
        PostMessage( hw, WM_KEYDOWN, VK_LEFT, cast( LPARAM, SC_LEFT shl 16 ) )
        PostMessage( hw, WM_CHAR, cast( WPARAM, asc( "X" ) ), 0 )
        PostMessage( hw, WM_CHAR, 13, 0 )
        Sleep( 200 )
        dim as string e1
        input "", e1
        chk( "left arrow then a character inserts", 0, iif( e1 = "aXbc", 0, 1 ) )

        '' HOME to the front, then insert. Distinguishes Home from a stack of
        '' Lefts only in that it is one key, but it is the key programs use.
        dim as string t2 = "bc"
        for i as integer = 0 to len( t2 ) - 1
            PostMessage( hw, WM_CHAR, cast( WPARAM, t2[i] ), 0 )
        next
        PostMessage( hw, WM_KEYDOWN, VK_HOME, cast( LPARAM, SC_HOME shl 16 ) )
        PostMessage( hw, WM_CHAR, cast( WPARAM, asc( "a" ) ), 0 )
        PostMessage( hw, WM_CHAR, 13, 0 )
        Sleep( 200 )
        dim as string e2
        input "", e2
        chk( "home then a character prepends", 0, iif( e2 = "abc", 0, 1 ) )

        '' DELETE REMOVES FORWARD AND BACKSPACE REMOVES BACKWARD, which is the
        '' whole difference between them. From "abc" with the cursor at the end:
        '' Home, Delete -> "bc". A Delete that behaved like Backspace would give
        '' "abc" unchanged, because there is nothing behind the start.
        dim as string t3 = "abc"
        for i as integer = 0 to len( t3 ) - 1
            PostMessage( hw, WM_CHAR, cast( WPARAM, t3[i] ), 0 )
        next
        PostMessage( hw, WM_KEYDOWN, VK_HOME, cast( LPARAM, SC_HOME shl 16 ) )
        PostMessage( hw, WM_KEYDOWN, VK_DELETE, cast( LPARAM, SC_DELETE shl 16 ) )
        PostMessage( hw, WM_CHAR, 13, 0 )
        Sleep( 200 )
        dim as string e3
        input "", e3
        chk( "delete removes forward", 0, iif( e3 = "bc", 0, 1 ) )

        '' END returns to the tail, so a character appends after a Home.
        dim as string t4 = "ab"
        for i as integer = 0 to len( t4 ) - 1
            PostMessage( hw, WM_CHAR, cast( WPARAM, t4[i] ), 0 )
        next
        PostMessage( hw, WM_KEYDOWN, VK_HOME, cast( LPARAM, SC_HOME shl 16 ) )
        PostMessage( hw, WM_KEYDOWN, VK_END, cast( LPARAM, SC_END shl 16 ) )
        PostMessage( hw, WM_CHAR, cast( WPARAM, asc( "c" ) ), 0 )
        PostMessage( hw, WM_CHAR, 13, 0 )
        Sleep( 200 )
        dim as string e4
        input "", e4
        chk( "end returns to the tail", 0, iif( e4 = "abc", 0, 1 ) )

        '' ---- editing a line that SCROLLS the console ----
        ''
        '' STARTED ON THE LAST ROW, not made long. The key ring holds fifteen --
        '' KEY_BUFFER_LEN is 16 and one slot is sacrificed, which is gfxlib2's
        '' capacity and what tools/abtest-keyboard.bas gates -- so a burst long
        '' enough to wrap several rows would simply be dropped, and the first
        '' version of this check was invalid for exactly that reason. Beginning
        '' on the bottom row reaches a scroll in ten characters instead of forty.
        ''
        '' The console is 8 columns by 6 rows. Ten characters from row 6 fill it
        '' and wrap, which scrolls the region and moves the row the line began
        '' on from 5 to 4. A redraw using the recorded row would put the line a
        '' row too low -- that is the defect this check exists for.
        locate 6, 1
        dim as string long_ = "abcdefghij"
        for i as integer = 0 to len( long_ ) - 1
            PostMessage( hw, WM_CHAR, cast( WPARAM, long_[i] ), 0 )
        next
        PostMessage( hw, WM_KEYDOWN, VK_HOME, cast( LPARAM, SC_HOME shl 16 ) )
        PostMessage( hw, WM_CHAR, cast( WPARAM, asc( "Z" ) ), 0 )
        PostMessage( hw, WM_CHAR, 13, 0 )
        Sleep( 300 )
        dim as string e6
        input "", e6
        chk( "a line that scrolls still edits at the front", 0, _
             iif( e6 = "Z" + long_, 0, 1 ) )

        '' AND THE SCREEN AGREES. After the scroll the line begins on row 5
        '' (1-based), so the inserted Z is the first cell of that row. The
        '' returned string would be right even with a misplaced redraw, so this
        '' is the half that actually checks the origin tracking.
        '' MEASURED, not predicted. Ten characters typed from the bottom row
        '' scroll the console TWICE, not once -- every keystroke redraws the
        '' whole line plus one blanking cell, so the wrap comes a character
        '' earlier than counting the text alone suggests. The line ends up
        '' beginning on 1-based row 4 and wrapping onto row 5.
        ''
        '' Both rows are asserted: the first pins where the redraw started,
        '' which is the origin tracking, and the second pins that the wrap went
        '' where it should. An off-by-one in either direction moves one of them.
        chk( "the redrawn line starts on the scrolled row", asc( "Z" ), _
             screen( 4, 1, 0 ) )
        chk( "and wraps onto the row below", asc( "h" ), _
             screen( 5, 1, 0 ) )

        '' AN ARROW MUST NOT LAND IN THE STRING. If an extended code fell
        '' through to the printable branch it would insert chr(255).
        PostMessage( hw, WM_KEYDOWN, VK_UP, cast( LPARAM, SC_UP shl 16 ) )
        PostMessage( hw, WM_CHAR, cast( WPARAM, asc( "z" ) ), 0 )
        PostMessage( hw, WM_CHAR, 13, 0 )
        Sleep( 200 )
        dim as string e5
        input "", e5
        chk( "an unhandled arrow is swallowed", 0, iif( e5 = "z", 0, 1 ) )

        '' LINE INPUT into a VAR-LEN string: dst_len is -1 there, which is an
        '' FBSTRING to assign and not a byte count.
        dim as string typed3 = "Q" + chr( 13 )
        for i as integer = 0 to len( typed3 ) - 1
            PostMessage( hw, WM_CHAR, cast( WPARAM, typed3[i] ), 0 )
        next
        Sleep( 150 )
        dim as string got3
        line input "P"; got3
        chk( "line input assigns a var-len string", 0, iif( got3 = "Q", 0, 1 ) )
    end if
end scope

imagedestroy( im )
screen 0

print Log_;
if fails = 0 then
    print "smoke: PASS -- the entry layer answers"
    end 0
else
    print "smoke: FAIL -- "; fails; " check(s)"
    end 1
end if
