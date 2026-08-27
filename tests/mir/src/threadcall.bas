'' 'threadcall f( a )' in EXPRESSION position, which is how every real use in the
'' corpus writes it -- it never parsed at all, and the initialiser was left as the bare
'' name 'threadcall' with the callee and its whole argument list dropped.
''
'' Measured against fbc, and no argument travels by value:
''
''   threadcall NoArgs           fb_ThreadCall( (void*)&NOARGS, 0, 0ll, 0 )
''   threadcall Scal( iv, 2.5, 3 )
''       fb_ThreadCall( (void*)&SCAL, 0, 0ll, 3, 8ll, &IV$0, 11ll, &TMP$4$0, 4ll, &TMP$5$0 )
''       -- a VARIABLE passes its own address; only an rvalue gets a temporary
''   threadcall WithStr( sv )    fb_StrAssign into a copy, a POINTER temp to the copy,
''       13ll, and the copy's fb_StrDelete directly after the call
''   threadcall ByRefInt( iv )   13ll and a pointer temp holding the address
''
'' The statement form is the same call with its handle discarded.

sub NoArgs()
end sub
sub Scal( byval a as integer, byval b as double, byval c as short )
end sub
sub WithStr( byval s as string )
end sub
sub ByRefInt( byref v as integer )
end sub
dim as any ptr t1 = threadcall NoArgs
dim as integer iv = 1
dim as any ptr t2 = threadcall Scal( iv, 2.5, 3 )
dim as string sv = "hi"
dim as any ptr t3 = threadcall WithStr( sv )
dim as any ptr t4 = threadcall ByRefInt( iv )
threadcall NoArgs
threadwait t1 : threadwait t2 : threadwait t3 : threadwait t4
