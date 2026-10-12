'' hinitwin-parity.bas -- Windows runtime init. Three symbols in libfb.a
'' (win32/hinit.o's unconditional half); the twelve MT locks are in
'' tests/abi/hinitwinmt-parity.bas.
''
'' NEEDS-GEN-LLVM
''
'' WHAT THIS ACTUALLY CHECKS IS THE FPU CONTROL WORD, and it is the only
'' observable fb_hInit leaves behind. fb_hInit runs before main on every program
'' either runtime builds, so by the time this line executes the call has already
'' happened -- there is nothing to invoke and no way to invoke it safely, since
'' calling it again would memset the console context out from under the console
'' layer mid-program.
''
'' So the test reads the control word back with _controlfp( 0, 0 ) -- a zero
'' mask is the documented QUERY form -- and masks it down to the two fields
'' fb_hInit sets. If tiko-rt's fb_hInit had skipped the call, or passed the mask
'' and the value the wrong way round (an easy transposition: both arguments are
'' unsigned ints and the value here is ZERO, so a transposed call still
'' compiles, still runs, and simply does nothing), this number would differ from
'' the C runtime's.
''
'' THE NUMBER IS NOT ASSERTED, IT IS COMPARED. What _controlfp reports for
'' precision control on x86-64 is a CRT-version question, not a runtime one --
'' the 64-bit CRT has no x87 precision to control. Printing the masked value and
'' letting diff.sh compare the two runtimes tests exactly what is in scope
'' (did fb_hInit make the same call) and nothing that is not.
''
'' fb_hEnd IS ADDRESS-ONLY. It is a no-op in the single-threaded build, and in
'' the MT build it DELETES the six critical sections -- calling it from a test
'' would leave every later lock operating on freed state. That is a real
'' constraint, not a gap being papered over.

const MCW_RC_ = &h00000300
const MCW_PC_ = &h00030000

#ifdef __FB_WIN32__

extern "c"
	declare function c_controlfp alias "_controlfp" _
		( byval unNew as ulong, byval unMask as ulong ) as ulong
	declare sub hInit alias "fb_hInit" ( )
	declare sub hEnd alias "fb_hEnd" ( byval unused as long )
end extern

print "-- the FPU control word fb_hInit left behind"
dim as ulong cw = c_controlfp( 0, 0 )
print "  rc="; cw and MCW_RC_
print "  pc="; cw and MCW_PC_

print "-- resolution"
dim shared as any ptr a2( 0 to 1 )
a2(0) = cast( any ptr, @hInit )
a2(1) = cast( any ptr, @hEnd )
'' NEGATED: FreeBASIC's TRUE is -1, so a bare sum of two comparisons prints -2
'' for "both resolved". Counting up reads as a count.
print "  count="; -((a2(0) <> 0) + (a2(1) <> 0)); " distinct="; -(a2(0) <> a2(1))
print "  fb_hInit and fb_hEnd are ADDRESS ONLY -- see the header"

'' __fb_con IS NOT PRINTED. Its address differs between the two runtimes by
'' construction, and every field in it is whatever the console layer last put
'' there -- a handle value, a window rect that depends on the terminal. The
'' LAYOUT is what matters and that is asserted at compile time in
'' src/init/hinitwin.tiko, where a wrong offset is an error rather than a
'' difference in output.
print "  (__fb_con's layout is #assert'd in the module, not printed here)"

#else

print "-- resolution"
print "  win32/hinit.o is EMPTY-ON linux-x86_64; see hinitposix.tiko"

#endif

print "done"
