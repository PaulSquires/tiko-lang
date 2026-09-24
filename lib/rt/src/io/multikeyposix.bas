'' multikeyposix.bas -- fb_ConsoleMultikey and fb_hConsoleGfxMode, the Linux
'' raw-keyboard driver. Two symbols, one fbc member (linux/io_multikey.o).
''
'' EMPTY-ON: win64
''
'' MULTIKEY NEEDS TO KNOW WHICH KEYS ARE HELD, AND A TERMINAL CANNOT TELL YOU.
'' A tty delivers characters, not key transitions -- there is no way to ask it
'' whether Shift is currently down. So this member takes over the keyboard
'' entirely, by one of two completely different routes:
''
''   REAL LINUX CONSOLE   the tty is switched to K_MEDIUMRAW, after which reads
''                        return KERNEL KEYCODES with bit 7 as the release
''                        flag rather than characters. The driver then has to
''                        translate them back into characters ITSELF, which is
''                        what the KDGKBENT ioctl below is for.
''   UNDER X11            libX11 is dlopen'd and XQueryKeymap returns a 256-bit
''                        bitmap of the whole keyboard in one call. No takeover,
''                        no translation -- but only valid while the terminal
''                        window has focus, hence fb_hXTermHasFocus.
''
'' TAKING THE KEYBOARD MEANS OWNING EVERYTHING IT DID. In MEDIUMRAW the kernel
'' stops doing all of this, so the handler below re-implements it:
''
''   THE MODIFIER TABLE. kb_table is built from the CURRENT key_state -- shift,
''   altgr, control, alt as bits 0,1,2,3 -- and KDGKBENT then returns what that
''   keycode means under those modifiers. That is how a raw keycode becomes 'A'
''   rather than 'a'.
''   THE LEDs. Caps, Num and Scroll Lock are toggled by hand into key_leds,
''   which then feeds the KT_LETTER and KT_PAD cases.
''   CTRL+C. The kernel no longer sends SIGINT, so the handler watches for the
''   two scancodes being held together and calls kill( main_pid, SIGINT )
''   itself. WITHOUT THIS A PROGRAM USING MULTIKEY COULD NOT BE INTERRUPTED.
''   VIRTUAL TERMINAL SWITCHING. Alt+F2 is KT_CONS, and the driver performs the
''   switch with VT_ACTIVATE, waits to come back with VT_WAITACTIVE, and clears
''   the entire key_state on return -- because keys released on the other
''   console were never seen and would otherwise read as still held forever.
''
'' AND IF GRAPHICS IS ACTIVE THE VT SWITCH SAVES AND RESTORES IT, dropping to
'' KD_TEXT for the duration so the other console is usable, then back to
'' KD_GRAPHICS. That is the gfx_save/gfx_restore pair fb_hConsoleGfxMode
'' installs.
''
'' KTYP AND KVAL ARE THE TOP AND BOTTOM HALVES of the KDGKBENT value:
'' KTYP( x ) = (x >> 8) and &h0F, KVAL( x ) = x and &hFF -- measured against
'' linux/keyboard.h rather than assumed.
''
'' THE KT_CONS CASE FALLS THROUGH INTO default AND ZEROES THE KEY. A console
'' switch is not a keystroke, so nothing is buffered -- but note it also clears
'' `extended` inside the ioctl-succeeded branch only, so a FAILED VT_GETSTATE
'' leaves an extended code set and the key IS reported. fbc's, reproduced.
''
'' fb_ConsoleMultikey SLEEPS 50 ms THE FIRST TIME. After installing the handler
'' it drops the lock, waits, and re-takes it, so the background thread has run
'' at least once and key_state is populated -- otherwise the very first
'' MULTIKEY call would always report false.
''
'' fb_hConsoleGfxMode CLEARS FIVE CONSOLE HOOKS when graphics starts, so that
'' INKEY, GETKEY, KEYHIT, MULTIKEY and SLEEP stop going through the console
'' driver and fall back to the runtime's own. The offsets of those five hook
'' slots are derived, not guessed: __fb_ctx.hooks sits at 72 (argc 0, argv 8,
'' null_desc 16, unull_desc 40, errmsg 64) and is 28 function pointers ending
'' exactly at fileTB's measured offset of 296 -- two independently measured
'' anchors that pin it.
''
'' THE 128-ENTRY TABLE WAS GENERATED FROM fbc's SOURCE, not transcribed: a
'' script resolved every SC_ name against fb_event.h.

#include once "inc/descriptors.bi"
#include once "inc/console.bi"
#include once "inc/ctx.bi"
#include once "inc/file.bi"
#include once "inc/iolock.bi"
#include once "inc/sysbind.bi"

#ifndef __FB_WIN32__

const INIT_CONSOLE4_ = 1
const INIT_X11_4_    = 2

const KEY_BUFFER_SIZE_ = 16
const NUM_PAD_KEYS_    = 17

'' MEASURED against linux/kd.h, linux/keyboard.h and linux/vt.h.
const KDGKBMODE_   = 19268
const KDSKBMODE_   = 19269
const KDGETLED_    = 19249
const KDGKBENT_    = 19270
const KDSETMODE_   = 19258
const VT_GETSTATE_ = 22019
const VT_ACTIVATE_ = 22022
const VT_WAITACTIVE_ = 22023

const K_MEDIUMRAW_ = 2
const KD_TEXT_     = 0
const KD_GRAPHICS_ = 1

const LED_SCR_ = 1
const LED_NUM_ = 2
const LED_CAP_ = 4

const K_NOSUCHMAP_ = 639

const KT_LATIN_  = 0
const KT_SPEC_   = 2
const KT_PAD_    = 3
const KT_CONS_   = 5
const KT_ASCII_  = 9
const KT_LETTER_ = 11

#define KTYP_( x ) ((cast( long, x ) shr 8) and &h0F)
#define KVAL_( x ) (cast( long, x ) and &hFF)

const CS8_     = 48
const VTIME2_  = 5
const VMIN2_   = 6
const NCCS2_   = 32
const TCSANOW2_ = 0
const SIGINT2_ = 2

'' Scancodes this file tests by name.
const SC_ESCAPE_    = &h01
const SC_C_         = &h2E
const SC_ENTER_     = &h1C
const SC_CONTROL_   = &h1D
const SC_LSHIFT_    = &h2A
const SC_RSHIFT_    = &h36
const SC_ALT_       = &h38
const SC_ALTGR_     = &h64
const SC_CAPSLOCK_  = &h3A
const SC_NUMLOCK_   = &h45
const SC_SCROLLLOCK_ = &h46
const SC_BACKSPACE_ = &h0E

'' __fb_ctx.hooks -- see the file header on how these are pinned.
const TKORT_HOOKS_BASE   = 72
const TKORT_HOOK_INKEY    = TKORT_HOOKS_BASE + 8 * 0
const TKORT_HOOK_GETKEY   = TKORT_HOOKS_BASE + 8 * 1
const TKORT_HOOK_KEYHIT   = TKORT_HOOKS_BASE + 8 * 2
const TKORT_HOOK_MULTIKEY = TKORT_HOOKS_BASE + 8 * 14
const TKORT_HOOK_SLEEP    = TKORT_HOOKS_BASE + 8 * 23

#assert TKORT_HOOKS_BASE + 8 * 28 = TKORT_FILETB_OFFSET

type TERMIOS3_
	as ulong c_iflag
	as ulong c_oflag
	as ulong c_cflag
	as ulong c_lflag
	as ubyte c_line
	as ubyte c_cc( 0 to NCCS2_ - 1 )
	as ubyte pad_( 0 to 2 )
	as ulong c_ispeed
	as ulong c_ospeed
end type

#assert sizeof( TERMIOS3_ ) = 60

'' MEASURED: 4 bytes, kb_table 0, kb_index 1, kb_value 2.
type KBENTRY_
	as ubyte  kb_table
	as ubyte  kb_index
	as ushort kb_value
end type

#assert sizeof( KBENTRY_ ) = 4

'' MEASURED: 6 bytes, v_active first.
type VTSTAT_
	as ushort v_active
	as ushort v_signal
	as ushort v_state
end type

#assert sizeof( VTSTAT_ ) = 6

'' GENERATED FROM fbc's SOURCE -- see the file header. Kernel keycode to
'' FreeBASIC scancode, 128 entries.
dim shared as ubyte tkort_kernel_to_scancode( 0 to 127 ) = { _
	&h00, &h01, &h02, &h03, &h04, &h05, &h06, &h07, _
	&h08, &h09, &h0A, &h0B, &h0C, &h0D, &h0E, &h0F, _
	&h10, &h11, &h12, &h13, &h14, &h15, &h16, &h17, _
	&h18, &h19, &h1A, &h1B, &h1C, &h1D, &h1E, &h1F, _
	&h20, &h21, &h22, &h23, &h24, &h25, &h26, &h27, _
	&h28, &h29, &h2A, &h2B, &h2C, &h2D, &h2E, &h2F, _
	&h30, &h31, &h32, &h33, &h34, &h35, &h36, &h37, _
	&h38, &h39, &h3A, &h3B, &h3C, &h3D, &h3E, &h3F, _
	&h40, &h41, &h42, &h43, &h44, &h45, &h46, &h47, _
	&h48, &h49, &h0C, &h4B, &h4C, &h4D, &h4E, &h4F, _
	&h50, &h51, &h0B, &h53, &h00, &h00, &h2B, &h57, _
	&h58, &h00, &h00, &h00, &h00, &h00, &h00, &h00, _
	&h1C, &h1D, &h35, &h00, &h64, &h00, &h47, &h48, _
	&h49, &h4B, &h4D, &h4F, &h50, &h51, &h52, &h53, _
	&h00, &h00, &h00, &h00, &h00, &h00, &h00, &h00, _
	&h00, &h00, &h00, &h00, &h00, &h5B, &h5C, &h5D }

'' The keypad, with and without NumLock. The second table is mostly zeroes --
'' without NumLock only the operators produce a character; the digits become
'' cursor keys and are handled as extended codes instead.
dim shared as zstring * 20 tkort_pad_numlock
dim shared as ubyte tkort_pad_plain( 0 to NUM_PAD_KEYS_ - 1 ) = { _
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 43, 45, 42, 47, 13, 0, 0 }

extern "c"   '' NON-FBCALL: libc.
	declare function c_dup alias "dup" ( byval fd as long ) as long
	declare function c_close3 alias "close" ( byval fd as long ) as long
	declare function c_read3 alias "read" ( byval fd as long, byval buf as any ptr, byval n as uinteger ) as integer
	declare function c_ioctl3 alias "ioctl" ( byval fd as long, byval req as ulong, ... ) as long
	declare function c_tcsetattr3 alias "tcsetattr" _
		( byval fd as long, byval act as long, byval t as TERMIOS3_ ptr ) as long
	declare function c_getpid alias "getpid" ( ) as long
	declare function c_kill alias "kill" ( byval pid as long, byval sig as long ) as long
	declare function c_usleep3 alias "usleep" ( byval us as ulong ) as long
end extern

extern "c"   '' NON-FBCALL: rtlib internals, declared plain.
	declare function tkrt_hScancodeToExtendedKey alias "fb_hScancodeToExtendedKey" _
		( byval scancode as long ) as long
	declare sub tkrt_hStartBgThread4 alias "fb_hStartBgThread" ( )
	declare function tkrt_hTermOut4 alias "fb_hTermOut" _
		( byval code_ as long, byval p1 as long, byval p2 as long ) as long
	declare function tkrt_hXTermHasFocus4 alias "fb_hXTermHasFocus" ( ) as long
	declare sub tkrt_hXTermInitFocus4 alias "fb_hXTermInitFocus" ( )
	declare sub tkrt_hXTermExitFocus4 alias "fb_hXTermExitFocus" ( )
	declare sub tkrt_hInitX11KeycodeToScancodeTb alias "fb_hInitX11KeycodeToScancodeTb" _
		( byval d as any ptr, byval dk as any ptr, byval gkm as any ptr, byval fr as any ptr )
	declare function tkrt_hDynLoad4 alias "fb_hDynLoad" _
		( byval libname as zstring ptr, byval funcname as zstring ptr ptr, _
		  byval funcptr as any ptr ptr ) as any ptr
	declare sub tkrt_hDynUnload4 alias "fb_hDynUnload" ( byval lib as any ptr ptr )
	extern fb_x11keycode_to_scancode alias "fb_x11keycode_to_scancode" as ubyte
end extern

extern "rtlib"   '' FBCALL.
	declare sub tkrt_BgLock5 alias "fb_BgLock" ( )
	declare sub tkrt_BgUnlock5 alias "fb_BgUnlock" ( )
end extern

'' THE SIX X11 ENTRY POINTS, FILLED POSITIONALLY by fb_hDynLoad -- the field
'' order IS the name order, and swapping two silently swaps two function
'' pointers. Same contract as src/io/xfocus.bas.
type X_FUNCS6
	as any ptr OpenDisplay
	as any ptr CloseDisplay
	as any ptr QueryKeymap
	as any ptr DisplayKeycodes
	as any ptr GetKeyboardMapping
	as any ptr Free_
end type

dim shared as any ptr   tkort_mk_display
dim shared as any ptr   tkort_mk_xlib
dim shared as X_FUNCS6  tkort_mk_X
dim shared as zstring * 24 tkort_mk_n( 0 to 5 )
dim shared as zstring ptr  tkort_mk_names( 0 to 6 )

dim shared as long     tkort_main_pid
dim shared as long     tkort_key_fd = -1
dim shared as long     tkort_key_old_mode, tkort_key_leds
dim shared as ubyte    tkort_key_state( 0 to 127 )
dim shared as ushort   tkort_mk_buffer( 0 to KEY_BUFFER_SIZE_ - 1 )
dim shared as long     tkort_mk_head, tkort_mk_tail
dim shared as any ptr  tkort_old_getch
dim shared as any ptr  tkort_gfx_save, tkort_gfx_restore, tkort_gfx_key_handler

'' The console getch replacement: reads from THIS driver's own ring, since the
'' tty no longer produces characters.
private function tkort_keyboard_console_getch cdecl ( ) as long
	dim as long key_ = -1

	tkrt_BgLock5( )
	if( tkort_mk_head <> tkort_mk_tail ) then
		key_ = tkort_mk_buffer( tkort_mk_head )
		tkort_mk_head = (tkort_mk_head + 1) and (KEY_BUFFER_SIZE_ - 1)
	end if
	tkrt_BgUnlock5( )

	return key_
end function

'' RUNS ON THE BACKGROUND THREAD. Everything the kernel stopped doing when the
'' tty went to MEDIUMRAW happens here -- see the file header.
private sub tkort_keyboard_console_handler cdecl ( )

	dim as ubyte buffer_( 0 to 127 )
	dim as KBENTRY_ entry_
	dim as VTSTAT_ vt_state

	dim as integer num_bytes = c_read3( tkort_key_fd, @buffer_(0), 128 )
	if( num_bytes > 0 ) then
		for i as integer = 0 to num_bytes - 1
			dim as ubyte scancode = tkort_kernel_to_scancode( buffer_(i) and &h7F )
			'' BIT 7 IS THE RELEASE FLAG, inverted into "pressed".
			dim as long pressed = (buffer_(i) and &h80) xor &h80
			dim as long repeated = iif( (pressed <> 0) andalso (tkort_key_state(scancode) <> 0), -1, 0 )
			tkort_key_state(scancode) = iif( pressed <> 0, 1, 0 )

			dim as long extended = 0
			select case scancode
			case SC_CAPSLOCK_   : if( pressed <> 0 ) then tkort_key_leds xor= LED_CAP_
			case SC_NUMLOCK_    : if( pressed <> 0 ) then tkort_key_leds xor= LED_NUM_
			case SC_SCROLLLOCK_ : if( pressed <> 0 ) then tkort_key_leds xor= LED_SCR_
			case else
				extended = tkrt_hScancodeToExtendedKey( scancode )
			end select

			'' THE MODIFIER TABLE, from the live key_state -- see the header.
			entry_.kb_table = 0
			if( (tkort_key_state(SC_LSHIFT_) <> 0) orelse (tkort_key_state(SC_RSHIFT_) <> 0) ) then
				entry_.kb_table or= &h1
			end if
			if( tkort_key_state(SC_ALTGR_) <> 0 ) then entry_.kb_table or= &h2
			if( tkort_key_state(SC_CONTROL_) <> 0 ) then entry_.kb_table or= &h4
			if( tkort_key_state(SC_ALT_) <> 0 ) then entry_.kb_table or= &h8
			entry_.kb_index = scancode
			c_ioctl3( tkort_key_fd, KDGKBENT_, @entry_ )

			dim as long key_ = any
			if( scancode = SC_BACKSPACE_ ) then
				key_ = 8
			elseif( entry_.kb_value = K_NOSUCHMAP_ ) then
				key_ = 0
			else
				key_ = KVAL_( entry_.kb_value )
				select case KTYP_( entry_.kb_value )
				case KT_LETTER_
					'' CAPS LOCK FLIPS BIT 5, which is the ASCII case bit.
					if( (tkort_key_leds and LED_CAP_) <> 0 ) then key_ xor= &h20

				case KT_LATIN_, KT_ASCII_
					'' Already a character.

				case KT_PAD_
					if( key_ < NUM_PAD_KEYS_ ) then
						if( (tkort_key_leds and LED_NUM_) <> 0 ) then
							key_ = cptr( ubyte ptr, @tkort_pad_numlock )[key_]
						else
							key_ = tkort_pad_plain(key_)
						end if
					else
						key_ = 0
					end if

				case KT_SPEC_
					if( scancode = SC_ENTER_ ) then key_ = 13

				case KT_CONS_
					'' A VIRTUAL TERMINAL SWITCH -- see the file header.
					dim as long vt = key_ + 1
					if( (pressed <> 0) andalso (c_ioctl3( tkort_key_fd, VT_GETSTATE_, @vt_state ) >= 0) ) then
						dim as long orig_vt = vt_state.v_active
						if( vt <> orig_vt ) then
							if( TKORT_CON_P( TKORT_CON_GFXEXIT ) <> 0 ) then
								if( tkort_gfx_save <> 0 ) then
									dim as sub cdecl ( ) fs = cast( sub cdecl ( ), tkort_gfx_save )
									fs( )
								end if
								c_ioctl3( tkort_key_fd, KDSETMODE_, KD_TEXT_ )
							end if
							c_ioctl3( tkort_key_fd, VT_ACTIVATE_, vt )
							c_ioctl3( tkort_key_fd, VT_WAITACTIVE_, vt )
							'' Spin until we are the active console again.
							while( c_ioctl3( tkort_key_fd, VT_WAITACTIVE_, orig_vt ) < 0 )
								c_usleep3( 50000 )
							wend
							if( TKORT_CON_P( TKORT_CON_GFXEXIT ) <> 0 ) then
								c_ioctl3( tkort_key_fd, KDSETMODE_, KD_GRAPHICS_ )
								if( tkort_gfx_restore <> 0 ) then
									dim as sub cdecl ( ) fr = cast( sub cdecl ( ), tkort_gfx_restore )
									fr( )
								end if
							end if
							'' EVERY KEY IS FORGOTTEN: releases that happened on
							'' the other console were never seen.
							memset( @tkort_key_state(0), 0, 128 )
						else
							tkort_key_state(scancode) = 0
						end if
						extended = 0
					end if
					'' Falls through to zero the key -- a console switch is not a
					'' keystroke. Note `extended` is cleared only INSIDE the
					'' branch above, so a FAILED VT_GETSTATE still reports one.
					key_ = 0

				case else
					key_ = 0
				end select
			end if

			if( extended <> 0 ) then key_ = extended

			if( (pressed <> 0) andalso (key_ <> 0) ) then
				tkort_mk_buffer( tkort_mk_tail ) = cast( ushort, key_ )
				if( ((tkort_mk_tail + 1) and (KEY_BUFFER_SIZE_ - 1)) = tkort_mk_head ) then
					tkort_mk_head = (tkort_mk_head + 1) and (KEY_BUFFER_SIZE_ - 1)
				end if
				tkort_mk_tail = (tkort_mk_tail + 1) and (KEY_BUFFER_SIZE_ - 1)
			end if

			if( tkort_gfx_key_handler <> 0 ) then
				dim as sub cdecl ( byval a as long, byval b as long, byval c as long, byval d as long ) kh = _
					cast( sub cdecl ( byval a as long, byval b as long, byval c as long, byval d as long ), _
					      tkort_gfx_key_handler )
				kh( pressed, repeated, scancode, key_ )
			end if
		next
	end if

	'' CTRL+C BY HAND -- the kernel no longer sends SIGINT. See the header.
	if( (tkort_key_state(SC_CONTROL_) <> 0) andalso (tkort_key_state(SC_C_) <> 0) ) then
		c_kill( tkort_main_pid, SIGINT2_ )
	end if
end sub

'' UNDER X11 THE WHOLE KEYBOARD ARRIVES IN ONE CALL, and only while focused.
private sub tkort_keyboard_x11_handler cdecl ( )

	dim as ubyte keymap( 0 to 31 )

	if( tkrt_hXTermHasFocus4( ) = 0 ) then exit sub

	dim as sub cdecl ( byval d as any ptr, byval k as ubyte ptr ) qk = _
		cast( sub cdecl ( byval d as any ptr, byval k as ubyte ptr ), tkort_mk_X.QueryKeymap )
	qk( tkort_mk_display, @keymap(0) )

	memset( @tkort_key_state(0), 0, 128 )
	for i as integer = 0 to 255
		if( (keymap(i \ 8) and (1 shl (i and 7))) <> 0 ) then
			tkort_key_state( (@fb_x11keycode_to_scancode)[i] ) = 1
		end if
	next
end sub

extern "c"   '' NON-FBCALL: fb_private_console.h declares both exports plainly.

'' BOTH ARE FILE-LOCAL, as fbc's `static` versions are. They were briefly
'' exported by an earlier draft -- a forward `declare` inside an `extern "c"`
'' block gives external linkage -- which put two extra globals into libfb.a that
'' fbc does not have. `private` and defining exit BEFORE init removes the need
'' for a forward declaration at all.
private sub tkort_keyboard_exit cdecl ( )

	if( TKORT_CON_L( TKORT_CON_INITED ) = INIT_CONSOLE4_ ) then
		'' THE OLD MODE IS PUT BACK. Failing to do this leaves the terminal in
		'' MEDIUMRAW after the program exits -- an unusable shell.
		c_ioctl3( tkort_key_fd, KDSKBMODE_, tkort_key_old_mode )
		c_close3( tkort_key_fd )
		tkort_key_fd = -1
	elseif( TKORT_CON_L( TKORT_CON_INITED ) = INIT_X11_4_ ) then
		dim as sub cdecl ( byval d as any ptr ) cd = _
			cast( sub cdecl ( byval d as any ptr ), tkort_mk_X.CloseDisplay )
		cd( tkort_mk_display )
		tkrt_hDynUnload4( @tkort_mk_xlib )
		tkrt_hXTermExitFocus4( )
	end if

	TKORT_CON_P( TKORT_CON_KBGETCH ) = cast( ubyte ptr, tkort_old_getch )
	TKORT_CON_P( TKORT_CON_KBHANDLER ) = 0
	TKORT_CON_P( TKORT_CON_KBEXIT ) = 0
end sub

private function tkort_keyboard_init cdecl ( ) as long

	dim as TERMIOS3_ term
	memset( @term, 0, sizeof( TERMIOS3_ ) )

	tkort_main_pid = c_getpid( )
	tkort_old_getch = TKORT_CON_P( TKORT_CON_KBGETCH )

	if( TKORT_CON_L( TKORT_CON_INITED ) = INIT_CONSOLE4_ ) then
		'' A DUPLICATE DESCRIPTOR, so the mode change does not disturb the one
		'' the console layer holds.
		tkort_key_fd = c_dup( TKORT_CON_L( TKORT_CON_HIN ) )

		term.c_iflag = 0
		term.c_cflag = CS8_
		term.c_lflag = 0
		term.c_cc(VMIN2_) = 0
		term.c_cc(VTIME2_) = 0

		if( (c_ioctl3( tkort_key_fd, KDGKBMODE_, @tkort_key_old_mode ) < 0) orelse _
		    (c_tcsetattr3( tkort_key_fd, TCSANOW2_, @term ) < 0) orelse _
		    (c_ioctl3( tkort_key_fd, KDSKBMODE_, K_MEDIUMRAW_ ) < 0) ) then
			c_close3( tkort_key_fd )
			return -1
		end if

		TKORT_CON_P( TKORT_CON_KBHANDLER ) = cast( ubyte ptr, @tkort_keyboard_console_handler )
		TKORT_CON_P( TKORT_CON_KBGETCH ) = cast( ubyte ptr, @tkort_keyboard_console_getch )
		tkort_mk_head = 0
		tkort_mk_tail = 0
		c_ioctl3( tkort_key_fd, KDGETLED_, @tkort_key_leds )
	else
		'' THE SIX NAMES IN X_FUNCS6's FIELD ORDER -- see the type's comment.
		tkort_mk_n(0) = "XOpenDisplay"
		tkort_mk_n(1) = "XCloseDisplay"
		tkort_mk_n(2) = "XQueryKeymap"
		tkort_mk_n(3) = "XDisplayKeycodes"
		tkort_mk_n(4) = "XGetKeyboardMapping"
		tkort_mk_n(5) = "XFree"
		for i as integer = 0 to 5
			tkort_mk_names(i) = @tkort_mk_n(i)
		next
		tkort_mk_names(6) = 0

		tkort_mk_xlib = tkrt_hDynLoad4( @"libX11.so", @tkort_mk_names(0), _
		                                cptr( any ptr ptr, @tkort_mk_X ) )
		if( tkort_mk_xlib = 0 ) then return -1

		dim as function cdecl ( byval n as zstring ptr ) as any ptr od = _
			cast( function cdecl ( byval n as zstring ptr ) as any ptr, tkort_mk_X.OpenDisplay )
		tkort_mk_display = od( 0 )
		if( tkort_mk_display = 0 ) then return -1

		tkrt_hInitX11KeycodeToScancodeTb( tkort_mk_display, tkort_mk_X.DisplayKeycodes, _
		                                  tkort_mk_X.GetKeyboardMapping, tkort_mk_X.Free_ )

		tkrt_hXTermInitFocus4( )
		TKORT_CON_P( TKORT_CON_KBHANDLER ) = cast( ubyte ptr, @tkort_keyboard_x11_handler )
	end if

	TKORT_CON_P( TKORT_CON_KBINIT ) = cast( ubyte ptr, @tkort_keyboard_init )
	TKORT_CON_P( TKORT_CON_KBEXIT ) = cast( ubyte ptr, @tkort_keyboard_exit )

	return 0
end function


function tkort_ConsoleMultikey alias "fb_ConsoleMultikey" ( byval scancode as long ) as long

	if( TKORT_CON_L( TKORT_CON_INITED ) = 0 ) then return 0

	tkrt_BgLock5( )

	tkrt_hStartBgThread4( )

	'' THE 50 ms IS SO THE HANDLER HAS RUN AT LEAST ONCE -- see the header.
	if( (TKORT_CON_P( TKORT_CON_KBHANDLER ) = 0) andalso (tkort_keyboard_init( ) = 0) ) then
		tkrt_BgUnlock5( )
		c_usleep3( 50000 )
		tkrt_BgLock5( )
	end if

	dim as long res = iif( tkort_key_state( scancode and &h7F ) <> 0, -1, 0 )

	tkrt_BgUnlock5( )

	return res
end function

'' CALLED BY gfxlib2 when it takes or releases the screen.
function tkort_hConsoleGfxMode alias "fb_hConsoleGfxMode" _
	( byval gfx_exit as any ptr, byval save_ as any ptr, byval restore_ as any ptr, _
	  byval key_handler as any ptr ) as long

	tkrt_BgLock5( )

	tkrt_hStartBgThread4( )

	TKORT_CON_P( TKORT_CON_GFXEXIT ) = cast( ubyte ptr, gfx_exit )

	if( gfx_exit <> 0 ) then
		'' FIVE CONSOLE HOOKS ARE CLEARED so INKEY, GETKEY, KEYHIT, MULTIKEY and
		'' SLEEP stop going through the console driver -- see the file header on
		'' how the offsets are pinned.
		TKORT_IOLOCK()
		*cptr( any ptr ptr, cptr( ubyte ptr, @__fb_ctx ) + TKORT_HOOK_MULTIKEY ) = 0
		*cptr( any ptr ptr, cptr( ubyte ptr, @__fb_ctx ) + TKORT_HOOK_INKEY ) = 0
		*cptr( any ptr ptr, cptr( ubyte ptr, @__fb_ctx ) + TKORT_HOOK_GETKEY ) = 0
		*cptr( any ptr ptr, cptr( ubyte ptr, @__fb_ctx ) + TKORT_HOOK_KEYHIT ) = 0
		*cptr( any ptr ptr, cptr( ubyte ptr, @__fb_ctx ) + TKORT_HOOK_SLEEP ) = 0
		TKORT_IOUNLOCK()

		tkort_gfx_save = save_
		tkort_gfx_restore = restore_
		tkort_gfx_key_handler = key_handler

		if( tkort_keyboard_init( ) <> 0 ) then
			tkrt_BgUnlock5( )
			return -1
		end if
		c_ioctl3( tkort_key_fd, KDSETMODE_, KD_GRAPHICS_ )
	else
		'' LEAVING GRAPHICS. The fd test matters: gfxlib2 may release a mode it
		'' never successfully took.
		if( tkort_key_fd >= 0 ) then
			c_ioctl3( tkort_key_fd, KDSETMODE_, KD_TEXT_ )
			tkort_keyboard_exit( )
			tkrt_hTermOut4( 106, 0, 0 )        '' SEQ_EXIT_GFX_MODE
		end if
	end if

	tkrt_BgUnlock5( )

	return 0
end function

end extern

#endif
