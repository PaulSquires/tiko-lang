'' probe-hooks.bas -- prove we can take over the runtime's console and give it back.
''
'' ORIGINAL WORK. Part of libtkogfx: LGPL-2.1-or-later with the static-linking
'' exception.
''
'' This is the first thing in the library that CHANGES runtime state rather than
'' observing it, so the check is end-to-end rather than structural:
''
''   1. install a table whose printbuffproc captures instead of printing
''   2. PRINT -- the text must reach our capture and NOT stdout
''   3. clear the table
''   4. PRINT -- the text must reach stdout again
''   5. set the exit hook; it must fire during fb_End() and write a sentinel
''
'' Step 2 is the one that cannot be faked: if the hook were not installed, or had
'' the wrong calling convention, or sat at the wrong offset, the text would go to
'' stdout and the harness would see it there.
''
'' The harness (tools/gate-abi.sh) checks stdout for the presence of the visible
'' line, the ABSENCE of the captured line, and the existence of the sentinel.
''
'' `dim shared` is used here for the capture buffer. That is fine in a probe --
'' but note the library proper still owes its `dim shared` allowlist entries in
'' build/lint.sh, which does not yet scan lib/ for that rule.

#include once "../core/hooks.ti"
#include once "crt/string.bi"

using TkoGfx

dim shared as string g_captured
dim shared as string g_sentinel

sub CaptureProc cdecl ( byval buffer as const any ptr, byval length as uinteger, byval mask as long )
    if buffer <> 0 andalso length > 0 then
        dim as string s = space( length )
        memcpy( strptr( s ), buffer, length )
        g_captured += s
    end if
end sub

'' fb_End() calls this. It must not touch the console -- by this point the
'' runtime is shutting down -- so it writes a file instead.
sub OnRuntimeExit cdecl ( )
    dim as long f = freefile
    if open( g_sentinel, for output, as #f ) = 0 then
        print #f, "exit hook fired"
        close #f
    end if
end sub

if command( 1 ) = "" then
    print "usage: probe-hooks <sentinel-path>"
    end 2
end if
g_sentinel = command( 1 )
kill g_sentinel

dim as long failures = 0

'' --- 1. install -------------------------------------------------------------
dim as TkoAbi.FB_HOOKSTB tbl
tbl.printbuffproc = cptr( any ptr, @CaptureProc )
HooksInstall( @tbl )

if HooksLive( ) <> 1 then
    print "FAIL: expected 1 live hook after install, got"; HooksLive( )
    failures += 1
end if

'' --- 2. PRINT must be captured, not printed ---------------------------------
print "CAPTURED-LINE-SHOULD-NOT-REACH-STDOUT"

'' --- 3. give the console back ----------------------------------------------
HooksClear( )

'' --- 4. PRINT must work again ----------------------------------------------
if HooksLive( ) <> 0 then
    print "FAIL: hooks still live after clear:"; HooksLive( )
    failures += 1
end if

print "hooks probe -- capture buffer held "; len( g_captured ); " bytes"
if instr( g_captured, "CAPTURED-LINE" ) > 0 then
    print "  PRINT was diverted to our hook   ok"
else
    print "  PRINT was NOT diverted   FAIL"
    failures += 1
end if

'' --- 5. the exit hook -------------------------------------------------------
SetExitHook( cptr( any ptr, @OnRuntimeExit ) )
if GetExitHook( ) = 0 then
    print "  exit hook did not stick   FAIL"
    failures += 1
else
    print "  exit hook installed   ok"
end if

print "VISIBLE-LINE-SHOULD-REACH-STDOUT"

if failures = 0 then
    print "hooks probe: PASS"
    end 0
else
    print "hooks probe: FAIL -- "; failures; " check(s) failed"
    end 1
end if
