'' A ustring chain that renders a NUMBER, with a NARROW or WIDE term beside it: every term is
'' converted to UTF-16, as fbc does. Only the numbers were, so a narrow term's bytes were read
'' as UTF-16 ('bc' as U+6362), and a wide one stopped the build (TKO0994).

dim shared as string bs
dim shared as ustring us
function Q1( byref sp as const ustring ) as ustring
    dim as long k = 7
    return k & bs & sp
end function
function Q2( byref sp as const ustring ) as ustring
    dim as long k = 7
    return k & right( "abc", 2 ) & sp
end function
function Q3( byref sp as const ustring ) as ustring
    dim as long k = 7
    return k & ucase( us ) & sp
end function
function Q4( byref sp as const ustring ) as ustring
    dim as long k = 7
    return k & right( us, 2 ) & sp
end function
function Q5( byref sp as const ustring ) as ustring
    dim as long k = 7
    return k & ucase( "ab" ) & sp
end function
function Q6( byref sp as const ustring ) as ustring
    dim as long k = 7
    return k & str( 55 ) & sp
end function
function Q7( byref sp as const ustring ) as ustring
    dim as long k = 7
    return k & wstr( "wd" ) & sp
end function
function Q8( byref sp as const ustring ) as ustring
    dim as long k = 7
    return k & chr( 65, 66 ) & sp & k & hex( 255 )
end function
function Q9( byref sp as const ustring ) as ustring
    dim as long k = 7
    return sp & k & bs & left( "xyz", 2 )
end function
function Q10( byref sp as const ustring ) as ustring
    dim as long k = 7
    return k & us & sp & 3.5
end function
bs = "bytes"
us = "u" & "x" & "v"
dim as ustring sp = "S"
print "A:" & Q1( sp ) & "|" & Q2( sp ) & "|" & Q3( sp ) & "|" & Q4( sp ) & "|" & Q5( sp )
print "B:" & Q6( sp ) & "|" & Q7( sp ) & "|" & Q8( sp ) & "|" & Q9( sp ) & "|" & Q10( sp )
dim as ustring v
v = 5 & bs & sp
print "V:" & v
v = 5 & right( "abc", 2 ) & sp
print "V:" & v
