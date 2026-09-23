'' A USTRING WHERE A ZSTRING'S BYTES ARE WANTED IS A NARROW COPY, not its own data. A
'' 'zstring ptr' or 'byref as zstring' parameter, and NAME's two paths, were handed the
'' ustring's UTF-16 buffer -- 'C:\...' read as narrow is the string "C" -- so fileexists,
'' filelen and filedatetime answered for a file called "C" and NAME renamed nothing.
'' Measured, fbc converts into a REAL temporary and deletes it after the call:
''
''   vr = fb_UStrToStr( &A, -1 );  fb_StrAssign( &TMP, -1, vr, -1, 0 );
''   fb_FileExists( *(char**)&TMP );  fb_StrDelete( &TMP )
''
'' STRPTR is the exception: over a ustring it is the ustring's own buffer, in fbc too.
'' Declared here as file.bi declares it; the MIR tests have no include path.
declare function FileExists alias "fb_FileExists" ( byval filename as zstring ptr ) as long
sub TakeZ( byval z as zstring ptr )
    print *z
end sub
sub TakeZR( byref z as zstring )
    print z
end sub
dim as ustring a = "x.txt", b = "y.txt"
print FileExists( a )
TakeZ( a & "!" )
TakeZR( b )
name a as b
dim as ushort ptr p = strptr( a )
print p[0]
