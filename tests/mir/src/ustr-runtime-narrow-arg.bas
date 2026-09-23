'' A USTRING REACHING A RUNTIME ENTRY'S NARROW STRING PARAMETER IS CONVERTED FIRST.
'' The prelude declares mkdir, chdir, rmdir, kill and setenviron with
'' 'byref as const string', and a ustring path went over as its own FBUSTRING -- read
'' as narrow, 'C:\...' in UTF-16 is the string "C". fb/fsdir.bi's fixtures are made
'' with mkdir over a ustring, so fsinfo_dir aborted on its first ListDir. DIR is its
'' own intrinsic and had the same fault. Measured, fbc writes:
''
''   vr = fb_UStrToStr( &ROOT, -1 );  fb_MkDir( vr )
''   vr = fb_UStrToStr( &ROOT, -1 );  fb_Dir( vr, 16, 0 )
''   vr = fb_UStrConcat( &TMP, &EV, ... );  fb_SetEnviron( fb_UStrToStr( vr, -1 ) )
dim as ustring root = environ( "TEMP" ) & "\tko_ustr_runtime_narrow"
print mkdir( root )
print len( dir( root, &h10 ) ) > 0
print rmdir( root )
dim as ustring ev = "TKO_USTR_RUNTIME_NARROW"
print setenviron( ev & "=xyz" )
print environ( ev )
