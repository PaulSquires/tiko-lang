'' Module two. fbc's answer to a '#cmdline' here is 'warning 46(1): #cmdline
'' ignored' and no restart at all -- measured 2026-09-16 with 'fbc b.bas a.bas',
'' where the same directive that restarts from module one does nothing from here.
#cmdline "-d NEVERSYMBOL"

'' ...and the proof that it was dropped rather than applied late.
#ifdef NEVERSYMBOL
#error the ignored directive was honoured after all
#endif

sub cmdlineOther( )
    print "second"
end sub
