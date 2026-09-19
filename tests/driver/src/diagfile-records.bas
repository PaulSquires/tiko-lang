'' diagfile-records.bas -- one of each record kind for --diagnostics-file.
''
'' Line 5 carries a literal TAB inside the #print string: a record is one line of
'' TAB-separated fields, so it must reach the file as a space.
#print "a	b"
declare sub f cdecl ( )
sub f stdcall ( )
end sub
dim as string s = "abc
#error CONFIG not set
