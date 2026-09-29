'' A FIXED USTRING FOR 'byref as wstring' OR 'byref as zstring' -- fbc's error 58 on lines 22
'' and 23 (fbc-modern 1.20). tiko passed the UTF-8 buffer as if it were either. From line 24 a
'' fixed wstring or zstring, a var-len ustring, and 'byref as ustring' or 'as string' are
'' fbc's, and are accepted.
sub PW( byref w as wstring )
    print len( w )
end sub
sub PZ( byref z as zstring )
    print len( z )
end sub
sub PU( byref u as ustring )
    print len( u )
end sub
sub PS( byref s as string )
    print len( s )
end sub
dim as ustring * 8 fu = "abc"
dim as wstring * 8 fw = "abcd"
dim as zstring * 8 fz = "ab"
dim as string * 8 fs = "a"
dim as ustring vu = "xyz"
PW( fu )
PZ( fu )
PW( fw )
PW( vu )
PZ( fz )
PU( fu )
PU( fw )
PS( fu )
PS( fs )
