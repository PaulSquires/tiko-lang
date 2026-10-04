'' Every string-kind pair swapped between guard variables, and '&=' on every kind --
'' audit Phase 3 item 7. (The wide cases print raw UTF-16 and are in the probe only.)
sub sw1( )
    dim as long g1 = 111
    dim as string x = "S1"
    dim as long g2 = 222
    dim as string y = "S2"
    dim as long g3 = 333
    swap x, y
    print "ss: [" & x & "] [" & y & "]"; g1; g2; g3
end sub
sub sw2( )
    dim as long g1 = 111
    dim as string x = "S1"
    dim as long g2 = 222
    dim as zstring * 8 y = "Z2"
    dim as long g3 = 333
    swap x, y
    print "sz: [" & x & "] [" & y & "]"; g1; g2; g3
end sub
sub sw4( )
    dim as long g1 = 111
    dim as string x = "S1"
    dim as long g2 = 222
    dim as string * 6 y = "F2"
    dim as long g3 = 333
    swap x, y
    print "sf: [" & x & "] [" & y & "]"; g1; g2; g3
end sub
sub sw6( )
    dim as long g1 = 111
    dim as zstring * 8 x = "Z1"
    dim as long g2 = 222
    dim as string y = "S2"
    dim as long g3 = 333
    swap x, y
    print "zs: [" & x & "] [" & y & "]"; g1; g2; g3
end sub
sub sw7( )
    dim as long g1 = 111
    dim as zstring * 8 x = "Z1"
    dim as long g2 = 222
    dim as zstring * 8 y = "Z2"
    dim as long g3 = 333
    swap x, y
    print "zz: [" & x & "] [" & y & "]"; g1; g2; g3
end sub
sub sw9( )
    dim as long g1 = 111
    dim as zstring * 8 x = "Z1"
    dim as long g2 = 222
    dim as string * 6 y = "F2"
    dim as long g3 = 333
    swap x, y
    print "zf: [" & x & "] [" & y & "]"; g1; g2; g3
end sub
sub sw16( )
    dim as long g1 = 111
    dim as string * 6 x = "F1"
    dim as long g2 = 222
    dim as string y = "S2"
    dim as long g3 = 333
    swap x, y
    print "fs: [" & x & "] [" & y & "]"; g1; g2; g3
end sub
sub sw17( )
    dim as long g1 = 111
    dim as string * 6 x = "F1"
    dim as long g2 = 222
    dim as zstring * 8 y = "Z2"
    dim as long g3 = 333
    swap x, y
    print "fz: [" & x & "] [" & y & "]"; g1; g2; g3
end sub
sub sw19( )
    dim as long g1 = 111
    dim as string * 6 x = "F1"
    dim as long g2 = 222
    dim as string * 6 y = "F2"
    dim as long g3 = 333
    swap x, y
    print "ff: [" & x & "] [" & y & "]"; g1; g2; g3
end sub
sub sw25( )
    dim as long g1 = 111
    dim as ustring x = "U1"
    dim as long g2 = 222
    dim as ustring y = "U2"
    dim as long g3 = 333
    swap x, y
    print "uu: [" & x & "] [" & y & "]"; g1; g2; g3
end sub
sub ce26( )
    dim as long g1 = 111
    dim as string x = "S1"
    dim as long g2 = 222
    x &= "ab"
    x &= "ab"
    print "s&='ab': [" & x & "]"; len( x ); g1; g2
end sub
sub ce27( )
    dim as long g1 = 111
    dim as string x = "S1"
    dim as long g2 = 222
    x &= x
    x &= x
    print "s&=x: [" & x & "]"; len( x ); g1; g2
end sub
sub ce28( )
    dim as long g1 = 111
    dim as string x = "S1"
    dim as long g2 = 222
    x &= "" & 12
    x &= "" & 12
    print "s&='' & 12: [" & x & "]"; len( x ); g1; g2
end sub
sub ce29( )
    dim as long g1 = 111
    dim as zstring * 8 x = "Z1"
    dim as long g2 = 222
    x &= "ab"
    x &= "ab"
    print "z&='ab': [" & x & "]"; len( x ); g1; g2
end sub
sub ce30( )
    dim as long g1 = 111
    dim as zstring * 8 x = "Z1"
    dim as long g2 = 222
    x &= x
    x &= x
    print "z&=x: [" & x & "]"; len( x ); g1; g2
end sub
sub ce31( )
    dim as long g1 = 111
    dim as zstring * 8 x = "Z1"
    dim as long g2 = 222
    x &= "" & 12
    x &= "" & 12
    print "z&='' & 12: [" & x & "]"; len( x ); g1; g2
end sub
sub ce35( )
    dim as long g1 = 111
    dim as string * 6 x = "F1"
    dim as long g2 = 222
    x &= "ab"
    x &= "ab"
    print "f&='ab': [" & x & "]"; len( x ); g1; g2
end sub
sub ce36( )
    dim as long g1 = 111
    dim as string * 6 x = "F1"
    dim as long g2 = 222
    x &= x
    x &= x
    print "f&=x: [" & x & "]"; len( x ); g1; g2
end sub
sub ce37( )
    dim as long g1 = 111
    dim as string * 6 x = "F1"
    dim as long g2 = 222
    x &= "" & 12
    x &= "" & 12
    print "f&='' & 12: [" & x & "]"; len( x ); g1; g2
end sub
sub ce38( )
    dim as long g1 = 111
    dim as ustring x = "U1"
    dim as long g2 = 222
    x &= "ab"
    x &= "ab"
    print "u&='ab': [" & x & "]"; len( x ); g1; g2
end sub
sub ce39( )
    dim as long g1 = 111
    dim as ustring x = "U1"
    dim as long g2 = 222
    x &= x
    x &= x
    print "u&=x: [" & x & "]"; len( x ); g1; g2
end sub
sub ce40( )
    dim as long g1 = 111
    dim as ustring x = "U1"
    dim as long g2 = 222
    x &= "" & 12
    x &= "" & 12
    print "u&='' & 12: [" & x & "]"; len( x ); g1; g2
end sub
sw1( )
sw2( )
sw4( )
sw6( )
sw7( )
sw9( )
sw16( )
sw17( )
sw19( )
sw25( )
ce26( )
ce27( )
ce28( )
ce29( )
ce30( )
ce31( )
ce35( )
ce36( )
ce37( )
ce38( )
ce39( )
ce40( )
