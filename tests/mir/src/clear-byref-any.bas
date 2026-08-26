'' CLEAR's first argument is 'byref as any', and fbc has THREE answers for one with no
'' address of its own. Measured, all three from one probe:
''
''   clear local_i      memset( &LOCAL_I$1, ... )        an lvalue: its address
''   clear global_i     memset( &GLOBAL_I$, ... )
''   clear @global_i    memset( (void*)&GLOBAL_I$, ... ) a link-time constant, used
''                                                       DIRECTLY -- no temporary
''   clear @local_i     TMP = &LOCAL_I$1;                a TEMPORARY, and ITS address --
''                      memset( (void*)&TMP, ... )       so the clear hits the temp and
''                                                       the local is untouched
''   clear 0            memset( (void*)0ll, ... )        the VALUE is the address
''
'' The fourth is the point of warnings/param-byref-as-any-suspicious-temp-var.bas, which
'' is named for fbc's own warning 50 on exactly that line: "Suspicious address expression
'' passed to BYREF parameter". Reproducing it means reproducing a clear that does
'' nothing, which is what fbc does -- and the alternative, clearing the local, would be
'' a silent difference in what the program erases.
''
'' Only the first two lowered before; the other three declined because LowerAddr has no
'' answer for them.

dim shared global_i as integer

sub s1( )
	dim local_i as integer
	clear local_i, 0, 8
	clear global_i, 0, 8
	clear @local_i, 0, 8
	clear @global_i, 0, 8
	clear 0, 0, 8
end sub

'' Not called: 'clear 0' writes to address zero.
