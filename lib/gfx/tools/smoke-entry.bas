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

'' THE SETTLING WAITS MUST ACTUALLY WAIT, so they are not the SLEEP statement.
''
'' `Sleep( 150 )` is FB's SLEEP -- the keyword wins the parse -- and SLEEP on a
'' graphics screen is INTERRUPTED BY A KEYSTROKE above 100 ms. Every settle here
'' follows a PostMessage of a key, so the statement would return the moment that
'' key arrived and the wait it was supposed to provide would be gone.
''
'' The API is bound under a name the parser cannot claim.
extern "windows"
    declare sub WinSleep alias "Sleep" ( byval ms as ulong )
end extern

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

'' THE POINTER CHECKS NEED THE WINDOW IN FRONT, and a window that will not come
'' to the front makes them meaningless rather than failing: GETMOUSE reports
'' failure while the window is inactive, so every reading would be -1 and every
'' check would "pass" for the wrong reason. Same helper as
'' tools/abtest-mouse.bas, and the same reasoning.
function ForceForeground( byval hwin as HWND ) as long
    dim as HWND fg = GetForegroundWindow( )
    dim as DWORD us = GetCurrentThreadId( )
    dim as DWORD them = iif( fg <> 0, GetWindowThreadProcessId( fg, NULL ), 0 )

    if (them <> 0) andalso (them <> us) then AttachThreadInput( us, them, TRUE )
    ShowWindow( hwin, SW_SHOW )
    BringWindowToTop( hwin )
    SetForegroundWindow( hwin )
    SetActiveWindow( hwin )
    if (them <> 0) andalso (them <> us) then AttachThreadInput( us, them, FALSE )

    for i as integer = 1 to 40
        if GetForegroundWindow( ) = hwin then return 1
        WinSleep( 25 )
    next
    return 0
end function

screenres 64, 48, 32

'' ---- the screen target ----
'' OPAQUE BLACK, not 0: set_mode fills every page with bg_color, which at 32bpp is
'' &hFF000000. Measured against fbc-modern's gfxlib2 on 2026-09-21; this check
'' used to want the 0 a bare callocate left.
chk( "point on a fresh screen", &hFF000000, point( 5, 5 ) )
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

'' Both FREE THE TEMPORARY they are handed, on every call. A literal arrives as a temp
'' descriptor from the runtime's fixed pool, and gfxlib2 releases it on every exit;
'' keeping it drained the pool, and the loop below SEGFAULTED at about 200 calls. So
'' reaching the check is the assertion. Found by starshine.bas, one DRAW STRING a frame.
for i as integer = 1 to 2000
    draw string ( 2, 20 ), "A", &hFFFFFF
    draw "BM2,20"
next
chk( "draw string and draw free their temporaries", 1, 1 )

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
        WinSleep( 150 )
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
        WinSleep( 150 )
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
        WinSleep( 150 )
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
        WinSleep( 150 )
        dim as string got
        input "", got
        chk( "input reads the window", 0, iif( got = "Hi", 0, 1 ) )

        '' Backspace really edits: AXB, two rubs, Y -> AY.
        dim as string typed2 = "AXB" + chr( 8 ) + chr( 8 ) + "Y" + chr( 13 )
        for i as integer = 0 to len( typed2 ) - 1
            PostMessage( hw, WM_CHAR, cast( WPARAM, typed2[i] ), 0 )
        next
        WinSleep( 150 )
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
        WinSleep( 200 )
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
        WinSleep( 200 )
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
        WinSleep( 200 )
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
        WinSleep( 200 )
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
        WinSleep( 300 )
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
        WinSleep( 200 )
        dim as string e5
        input "", e5
        chk( "an unhandled arrow is swallowed", 0, iif( e5 = "z", 0, 1 ) )

'' ---- THE CARET LEAVES NOTHING BEHIND ----
        ''
        '' WHAT THIS CAN AND CANNOT CHECK. The caret is only on screen while the
        '' editing loop is BLOCKED on a key, and this program is the one that is
        '' blocked, so it can never look at the screen while the caret is up.
        '' What it can check is the other half -- that hiding it restores the
        '' cell -- and that half is where the bug would be: a caret drawn and not
        '' erased is a smear that survives the input.
        ''
        '' The shape itself IS compared against gfxlib2, in tools/gate-entry.bas,
        '' through the PRINT that draws it. Only the loop's use of it is here.
        ''
        '' THE UNDERLINE, not the block: `INPUT s` reaches the lineinput hook
        '' rather than readstr (fb_ConsoleInput asks isredir first), so the
        '' residue to look for is one row of pixels, not a filled cell. The
        '' block belongs to readstr and nothing here exercises it.
        cls
        locate 3, 1
        dim as string typed4 = "ab" + chr( 13 )
        for i as integer = 0 to len( typed4 ) - 1
            PostMessage( hw, WM_CHAR, cast( WPARAM, typed4[i] ), 0 )
        next
        WinSleep( 200 )
        dim as string e7
        input "", e7
        chk( "input still reads after a cls", 0, iif( e7 = "ab", 0, 1 ) )

        '' Cell (3,3) is where the caret stood when Enter arrived -- one past the
        '' "b". Every pixel of it must be background.
        dim as long resid
        for y as integer = 0 to 7
            for x as integer = 0 to 7
                if (point( 2 * 8 + x, 2 * 8 + y ) and &hFFFFFF) <> 0 then resid += 1
            next
        next
        chk( "the input caret is erased when the line ends", 0, resid )

        '' AND THE CHARACTER UNDER IT SURVIVES. Left puts the caret ON the "b";
        '' Enter then ends the line with the caret sitting over a glyph rather
        '' than over a blank. Erasing it repaints that cell from the plane, so
        '' the "b" must be identical to one that was never covered.
        cls
        locate 5, 1
        print "b";
        dim as long want_
        for y as integer = 0 to 7
            for x as integer = 0 to 7
                if (point( x, 4 * 8 + y ) and &hFFFFFF) <> 0 then want_ += 1
            next
        next

        cls
        locate 3, 1
        dim as string typed5 = "ab"
        for i as integer = 0 to len( typed5 ) - 1
            PostMessage( hw, WM_CHAR, cast( WPARAM, typed5[i] ), 0 )
        next
        PostMessage( hw, WM_KEYDOWN, VK_LEFT, cast( LPARAM, SC_LEFT shl 16 ) )
        PostMessage( hw, WM_CHAR, 13, 0 )
        WinSleep( 200 )
        dim as string e8
        input "", e8
        dim as long got_
        for y as integer = 0 to 7
            for x as integer = 0 to 7
                if (point( 8 + x, 2 * 8 + y ) and &hFFFFFF) <> 0 then got_ += 1
            next
        next
        chk( "the caret does not eat the character under it", want_, got_ )

'' ---- SLEEP, AND THE 100 ms BOUNDARY ----
        ''
        '' WHAT THE HOOK CHANGES IS WHICH BUFFER IS POLLED. With the slot null
        '' the runtime polls its CONSOLE input, so a key typed into the graphics
        '' window cannot cut a sleep short -- the sleep and the keyboard look at
        '' different places. These checks measure that, and they fail with the
        '' hook removed, which is what makes them worth having.
        ''
        '' Win32 Sleep is used for the settling waits on purpose: FB's SLEEP is
        '' the thing under test.
        scope
            '' Drain first: reading a key clears the "changed" flag, so a
            '' leftover keystroke from an earlier check would cut the sleep
            '' short for the wrong reason.
            for i as integer = 1 to 20
                inkey
            next

            PostMessage( hw, WM_CHAR, cast( WPARAM, asc( "k" ) ), 0 )
            WinSleep( 150 )
            dim as double t0 = timer
            sleep 400
            dim as long ms = clng( (timer - t0) * 1000 )
            chk( "a key cuts a long sleep short", 1, iif( ms < 250, 1, 0 ) )

            '' AND THE KEY SURVIVES IT. Only the flag is consumed; the code
            '' stays on the ring, so the INKEY after a woken sleep still sees it.
            chk( "the key that woke it is still readable", 0, iif( inkey = "k", 0, 1 ) )

            '' BELOW 100 ms NOTHING IS POLLED. A pending key must NOT shorten
            '' this one -- that asymmetry is the reference's and the runtime's.
            for i as integer = 1 to 20
                inkey
            next
            PostMessage( hw, WM_CHAR, cast( WPARAM, asc( "j" ) ), 0 )
            WinSleep( 150 )
            t0 = timer
            sleep 60
            ms = clng( (timer - t0) * 1000 )
            chk( "a key does NOT cut a short sleep short", 1, iif( ms >= 40, 1, 0 ) )

'' THE INFINITE FORM. Bare SLEEP is fb_Sleep( -1 ) -- measured -- and waits
            '' until a key arrives, polling every 50 ms. If this branch were broken
            '' the check would not fail, it would HANG, which the harness turns
            '' into a timeout rather than a message.
            for i as integer = 1 to 20
                inkey
            next
            PostMessage( hw, WM_CHAR, cast( WPARAM, asc( "z" ) ), 0 )
            WinSleep( 150 )
            t0 = timer
            sleep
            ms = clng( (timer - t0) * 1000 )
            chk( "a bare sleep returns when a key arrives", 1, iif( ms < 250, 1, 0 ) )

            '' And an uninterrupted sleep actually waits.
            for i as integer = 1 to 20
                inkey
            next
            t0 = timer
            sleep 200
            ms = clng( (timer - t0) * 1000 )
            chk( "an uninterrupted sleep waits", 1, iif( ms >= 150, 1, 0 ) )
        end scope

                '' ---- THE POINTER ----
        ''
        '' THIS MOVES THE REAL CURSOR, which is what SETMOUSE is. It is put back
        '' where it was afterwards, and the clip is released on every path --
        '' leaving ClipCursor set would trap the desktop pointer inside a window
        '' that is about to close.
        ''
        '' The state machine underneath is A/B'd by tools/abtest-mouse.bas
        '' against gfxlib2, by moving the pointer over both windows in turn. What
        '' is checked here is the SEAM: that GETMOUSE and SETMOUSE reach it, with
        '' the arguments decoded right. The two sentinels are the part worth
        '' having a check for -- an omitted coordinate is &h80000000 and an
        '' omitted cursor or clip flag is -1, and one rule for all four is wrong.
        dim as POINT saved
        GetCursorPos( @saved )

        if ForceForeground( hw ) = 0 then
            '' NOT A FAILURE, AND NOT SILENT. An unattended or locked desktop
            '' cannot give a window focus, and a check that cannot run must say
            '' so rather than pass.
            Log_ += "  SKIP the pointer checks -- the window would not take focus" + chr( 10 )
        else
            dim as long mx, my, mz, mb, mc

            setmouse 20, 10
            getmouse mx, my, mz, mb, mc
            chk( "setmouse then getmouse reads back x", 20, mx )
            chk( "setmouse then getmouse reads back y", 10, my )

            '' AN OMITTED COORDINATE KEEPS THE OLD ONE. `setmouse 5` passes
            '' &h80000000 for y, and a rule that treated any negative as "leave
            '' alone" would work here and break the next check.
            setmouse 5
            getmouse mx, my, mz, mb, mc
            chk( "an omitted y is kept", 10, my )
            chk( "and x still moved", 5, mx )

            '' A NEGATIVE COORDINATE IS A COORDINATE. It clamps to the corner
            '' rather than being ignored -- measured against gfxlib2.
            setmouse -3, -4
            getmouse mx, my, mz, mb, mc
            chk( "a negative x clamps to 0", 0, mx )
            chk( "a negative y clamps to 0", 0, my )

            '' AND THE FAR CORNER CLAMPS TO THE LAST PIXEL, not to the width.
            setmouse 1000, 1000
            getmouse mx, my, mz, mb, mc
            chk( "x clamps to the last column", 63, mx )
            chk( "y clamps to the last row", 47, my )

            '' THE CLIP FLAG IS REPORTED BACK by GETMOUSE's fifth output, which
            '' is the only way a program can see it.
            setmouse 30, 20, , 1
            getmouse mx, my, mz, mb, mc
            chk( "clip on is reported", 1, mc )
            setmouse , , , 0
            getmouse mx, my, mz, mb, mc
            chk( "clip off is reported", 0, mc )

            '' THE CURSOR FLAG HAS NO READBACK -- there is no GETMOUSE output for
            '' it and no way to ask Windows whose cursor is showing without
            '' owning the thread. Both directions are exercised so the posted
            '' WM_SETCURSOR path runs at all, and the pointer is left VISIBLE.
            setmouse , , 0
            setmouse , , 1
        end if

        ClipCursor( NULL )
        SetCursorPos( saved.x, saved.y )

                '' LINE INPUT into a VAR-LEN string: dst_len is -1 there, which is an
        '' FBSTRING to assign and not a byte count.
        dim as string typed3 = "Q" + chr( 13 )
        for i as integer = 0 to len( typed3 ) - 1
            PostMessage( hw, WM_CHAR, cast( WPARAM, typed3[i] ), 0 )
        next
        WinSleep( 150 )
        dim as string got3
        line input "P"; got3
        chk( "line input assigns a var-len string", 0, iif( got3 = "Q", 0, 1 ) )

        '' ---- LINE INPUT into a WSTRING ----
        ''
        '' A DIFFERENT HOOK WITH DIFFERENT ARGUMENTS: no fillrem, and the third
        '' argument is MAX_CHARS -- a character count, which fbc emits as the
        '' declared size, not a byte count. Measured: `dim as wstring * 16`
        '' passes 16.
        ''
        '' The line is still collected by the NARROW editor, in both libraries:
        '' gfxlib2's wide form carries a "no support for unicode input" comment
        '' and converts the result up, which is what this does.
        dim as string typedw = "Wq" + chr( 13 )
        for i as integer = 0 to len( typedw ) - 1
            PostMessage( hw, WM_CHAR, cast( WPARAM, typedw[i] ), 0 )
        next
        WinSleep( 200 )
        dim as wstring * 16 wgot
        line input wgot
        chk( "wide line input assigns the wstring", 0, iif( wgot = wstr( "Wq" ), 0, 1 ) )

        '' AN EMPTY LINE MUST EMPTY THE DESTINATION, not leave the old value.
        '' strptr of an empty FB string is NULL, and passing that through would
        '' have the runtime skip the assignment entirely -- so the previous
        '' answer would still be sitting there and this check is what sees it.
        PostMessage( hw, WM_CHAR, 13, 0 )
        WinSleep( 200 )
        line input wgot
        chk( "an empty wide line input clears it", 0, iif( len( wgot ) = 0, 0, 1 ) )

'' THESE FOUR CHECK THE STATEMENT, NOT THE HOOK, and that distinction is
        '' measured rather than assumed: with lineinputwproc deliberately left
        '' NULL, all four still pass. The runtime's own editor falls back onto
        '' the inkey, getkey and printbuff hooks -- which ARE installed -- so
        '' wide LINE INPUT already read the window and echoed to the screen.
        ''
        '' So this is not a hole being closed. It is the same editor serving
        '' both widths instead of two editors that happen to agree, and nothing
        '' here can tell them apart. Said plainly because a check that cannot
        '' fail for the reason you think it can is worse than no check.
        dim as string typedx = "ab"
        for i as integer = 0 to len( typedx ) - 1
            PostMessage( hw, WM_CHAR, cast( WPARAM, typedx[i] ), 0 )
        next
        PostMessage( hw, WM_KEYDOWN, VK_LEFT, cast( LPARAM, SC_LEFT shl 16 ) )
        PostMessage( hw, WM_CHAR, cast( WPARAM, asc( "X" ) ), 0 )
        PostMessage( hw, WM_CHAR, 13, 0 )
        WinSleep( 250 )
        line input wgot
        chk( "wide line input edits with the arrows", 0, iif( wgot = wstr( "aXb" ), 0, 1 ) )

        dim as wstring * 4 wshort
        dim as string typedy = "abcdef" + chr( 13 )
        for i as integer = 0 to len( typedy ) - 1
            PostMessage( hw, WM_CHAR, cast( WPARAM, typedy[i] ), 0 )
        next
        WinSleep( 250 )
        line input wshort
        chk( "max_chars truncates the wide destination", 3, len( wshort ) )
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
