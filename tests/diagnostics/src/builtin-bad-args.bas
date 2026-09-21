'' TKO0801: A RUNTIME BUILTIN claimed by its spelling, called with arguments no form of
'' it takes. Check lets these names through unbound, and lowering declined and dropped
'' the statement with no diagnostic: the program built and ran without the line. fbc's
'' errors 1 and 99, measured, one per line:
''
''   wait 1            error 1: Argument count mismatch
''   stop 1, 2         error 1: Argument count mismatch
''   hex               error 99: No matching overloaded function
''
'' 'hex 5' and 'wait 1, 2' beside them are right and must stay quiet: the call path that
'' reports is tried speculatively before the intrinsic path lowers 'hex 5'.
hex 5
wait 1, 2
wait 1
stop 1, 2
hex
'' ...and a line whose drop is someone else's -- zz is undeclared, TKO0743 -- is not
'' blamed on 'space' as well.
zz = space( 4 )
