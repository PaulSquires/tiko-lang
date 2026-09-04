'' conreadline-parity.bas -- fb_ConReadLine, the interactive INPUT line editor.
'' One symbol, one fbc member (con_readline.o).
''
'' NEEDS-GEN-LLVM
''
'' ADDRESS ONLY, AND THIS ONE IS NOT A JUDGEMENT CALL. fb_ConReadLine's first act
'' is
''
''     while( fb_KeyHit( ) = 0 ) : fb_Delay( 25 ) : wend
''
'' -- it spins until a key arrives and there is no timeout, no cancel and no
'' non-blocking mode. Under the harness, stdin is a file and the console has no
'' key queue, so the loop never terminates. That is not a hypothetical: the same
'' shape hung the suite for twenty minutes when fb_ConsoleReadStr was first
'' added, and the diagnosis then was `ls -lt obj/diff/*.out` showing the stock
'' output present and the rt output absent.
''
'' So this file proves the symbol resolves, is distinct, and stops. Everything
'' the function actually does -- the cursor arithmetic in DoAdjust, the wrap and
'' scroll handling in DoMove, the seven editing keys, the soft cursor, the
'' insert-in-the-middle reflow -- rests on fbc's own suite and on nothing here.
''
'' WHAT WOULD IT TAKE TO TEST PROPERLY? A pseudo-terminal with a scripted key
'' sequence and a screen scraper, on three platforms. That is a harness of its
'' own, and it is worth writing only if this member is ever suspected -- which
'' the gate would be what tells us.

#include once "fbc-int/string.bi"

extern "rtlib"
	declare function pConReadLine alias "fb_ConReadLine" ( byval soft_cursor as long ) as any ptr
end extern

print "-- resolution"
dim shared as any ptr a1
a1 = cast( any ptr, @pConReadLine )
print "  resolved="; iif( a1 <> 0, 1, 0 )
print "  ADDRESS ONLY -- it blocks on fb_KeyHit with no timeout; see the header"

'' THE ADDRESS MUST NOT COLLIDE with a neighbour in the same object. Cheap, and
'' it is the one structural claim available without calling anything: a build
'' that aliased two exports would show up here rather than as a wrong answer
'' somewhere else entirely.
extern "rtlib"
	declare function pKeyHit alias "fb_KeyHit" ( ) as long
	declare sub pGetXY alias "fb_GetXY" ( byval col as long ptr, byval row as long ptr )
end extern

dim shared as any ptr others( 0 to 1 )
others(0) = cast( any ptr, @pKeyHit )
others(1) = cast( any ptr, @pGetXY )
dim as long distinct = 1
for i as integer = 0 to 1
	if( others(i) = a1 ) then distinct = 0
next
print "  distinct from its neighbours="; distinct

print "done"
