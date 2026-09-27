'' STRPTR AND SADD OF A 'ustring * N' ARE ITS OWN BUFFER, as fbc's '(uint16*)U$0' -- and so is
'' one passed where a wide pointer is wanted. tiko converted it to a NARROW temporary and gave
'' that away: a callee filling 'strptr( u )' filled the temporary (fbx's
'' GetKeyboardLayoutNameW left u empty), and a callee reading one read a narrow string as
'' wide, past its end. Measured, fbc-modern prints [abc][abc], [abc], [filled] 6 and [el].
sub TakeW( byval p as wstring ptr )
    print "[" & *p & "]";
end sub
sub TakeRW( byref w as wstring )
    print "[" & w & "]";
    w = "zz"
end sub
sub Fill( byval p as wstring ptr )
    *p = "filled"
end sub
dim u as ustring * 12
u = "abc"
TakeW( strptr( u ) )
TakeW( sadd( u ) )
print "[" & u & "]"
Fill( strptr( u ) )
print "[" & u & "]"; len( u )
dim a( 1 ) as ustring * 8
a( 1 ) = "el"
TakeW( strptr( a( 1 ) ) )
print
