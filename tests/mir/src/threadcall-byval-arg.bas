'' 'byval expr' AT A CALL SITE IS AN N_UNARY, and it is transparent to threadcall: fbc
'' writes the same 'fb_ThreadCall( (void*)&S3, 0, 0ll, 1, 13ll, &TMP$3$0 )' with the
'' byval as without it -- code 13 is BYREF, whatever the parameter says, because the
'' runtime is handed the address of a temporary holding the argument. Unstripped, the
'' argument was classified as a unary expression, the threadcall lowering returned
'' false, and the whole assignment declined -- while the ordinary call path had stripped
'' it since it was written.
''
'' Checked against fbc's emitted C and not against a run: threadcall does not execute
'' its body in this environment, with or without the byval and with or without -mt.
sub S3( byval p as any ptr )
	print "in thread"
end sub

dim as integer bv = 5
dim as any ptr h
h = threadcall S3( byval @bv )
threadwait h
h = threadcall S3( @bv )
threadwait h
