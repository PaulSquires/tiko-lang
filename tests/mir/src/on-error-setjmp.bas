'' A LOCAL WHOSE VALUE IS LIVE ACROSS THE ERROR JUMP.
''
'' The handler reads variables the code wrote after ON ERROR GOTO installed it,
'' and the throw happens in a CALLED procedure -- the shape that used to die on
'' int3, because LLVM's indirectbr cannot leave the function it appears in and
'' tiko emitted 'unreachable' after the throw. The landing point is a setjmp in
'' the frame that installs the handler; the runtime longjmps into it.
''
'' WHAT THE VALUES ARE IS NOT ASSERTED HERE, and that is deliberate. Measured
'' 2026-09-20 on this program, win64-msvc:
''
''     tiko -O0    a=10 b=20 c=30 d=40   the values the code wrote
''     tiko -O1+   a=1  b=2  c=3  d=4    the values as of the ON ERROR
''     fbc  -O0    a=0 b=4200051 c=0 d=0 garbage, stably
''     fbc  -O2    SEGFAULT
''
'' longjmp restores the callee-saved registers it captured, so a local the
'' optimiser chose to keep in one reads back as it was at the setjmp; at -O0
'' every local is in memory and keeps what was written. That is the ordinary
'' setjmp rule -- in C only a 'volatile' local survives -- and fbc has no answer
'' to match: its cross-function computed goto lands in main with the stack in a
'' state where main's own locals do not read back at all.
''
'' So this test pins the MECHANISM, which is what a regression would remove.

declare sub raise_( )

dim as long a = 1
dim as long b = 2
dim as long c = 3
dim as long d = 4

on error goto caught
a = 10 : b = 20 : c = 30 : d = 40
raise_( )
print "NOT REACHED"
end

caught:
print "a="; a; " b="; b; " c="; c; " d="; d
end

sub raise_( )
    error( 5 )
end sub
