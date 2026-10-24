'' TKO0801 for a runtime builtin CALLED with arguments no form of it takes -- the call form,
'' where builtin-bad-args.bas has the statement form. fbc-modern 1.20: error 1 on lines 4 and 5;
'' line 6 is right.
dim as any ptr p = callocate( 1, 2, 3 )
reallocate p
wait 1, 2
