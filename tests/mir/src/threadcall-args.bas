'' TWO DEFECTS IN 'threadcall', one of them silent.
''
'' A DEFAULTED PARAMETER IS PASSED LIKE ANY OTHER. Measured, for
'' 'sub two( byval a as integer, opt as integer = 13 )' called as 'threadcall two( 5 )':
''
''     TMP$4$0 = 13ll;
''     fb_ThreadCall( &TWO, 0, 0ll, 2, 8ll, &TMP$3$0, 8ll, &TMP$4$0 )
''
'' -- TWO arguments, the written one and the default. tiko-lang passed the WRITTEN count
'' and stopped there, and fb_ThreadCall is VARIADIC, so nothing complained: the thread
'' read an uninitialised 'opt'. Lowered, verified, and wrong. The ordinary call path has
'' taken defaults from the callee since it was written.
''
'' AN EXPLICIT 'byval' AGAINST A BYREF PARAMETER MEANS THE VALUE IS THE REFERENCE.
'' 'byval @bv' has no address of its own -- it IS one -- so asking LowerAddr for the
'' address of an address-of gave nothing and the whole assignment declined. fbc stores
'' the value: 'TMP$3$0 = &BV$0'. threads/threadcall.bas:166 is exactly this argument.
''
'' Every call below was compared against fbc's own C, argument for argument.
sub two( byval a as integer, opt as integer = 13 )
    print a, opt
end sub

sub arrOpt( AnArray( ) as string, opt as integer = 13 )
    print ubound( AnArray ), opt
end sub

sub refOpt( byref bv as integer, opt as integer = 13 )
    print bv, opt
end sub

sub arrRef( AnArray( ) as string, byref bv as integer )
    print ubound( AnArray ), bv
end sub

dim AnArray( 0 to 1 ) as string
dim bv as integer ptr
dim as any ptr h

'' fbc: ( &TWO, 0, 0ll, 2, 8ll, &TMP, 8ll, &TMP )
h = threadcall two( 5 )
threadwait h

'' fbc: ( &ARROPT, 0, 0ll, 2, 13ll, &TMP, 8ll, &TMP )
h = threadcall arrOpt( AnArray( ) )
threadwait h

'' fbc: ( &REFOPT, 0, 0ll, 2, 13ll, &TMP, 8ll, &TMP )
h = threadcall refOpt( byval @bv )
threadwait h

'' fbc: ( &ARRREF, 0, 0ll, 2, 13ll, &TMP, 13ll, &TMP )
h = threadcall arrRef( AnArray( ), byval @bv )
threadwait h
