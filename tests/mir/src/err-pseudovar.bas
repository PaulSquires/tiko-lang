'' ERR IS A PSEUDO-VARIABLE -- readable AND assignable -- and the two halves go to
'' different entry points. Measured:
''
''     e = err     int32 vr = fb_ErrorGetNum( );  E = (int64)vr
''     err = 5     fb_ErrorSetNum( 5 )
''
'' The READ has always worked: the prelude declares 'err' aliased to fb_ErrorGetNum,
'' so it is an ordinary call. The WRITE never reached the statement parser at all --
'' ERR is a KEYWORD, so it fell off the end of the statement dispatch and was
'' "expected a statement", with fb_ErrorSetNum sitting in the runtime table and
'' nothing calling it. Found by auditing the table for entries with no caller, the
'' same way date( ) and time( ) turned up.
''
'' It is a STATEMENT OF ITS OWN rather than the call-or-assign ambiguity: the name
'' resolves to the prelude FUNCTION, so an assignment to it would read as
'' 'function = expr', the result assignment, which is a different statement with a
'' different meaning.
dim e as integer
dim n as integer = 7

err = 5
e = err
print e

err = n
e = err
print e

err = n + 1
print err
