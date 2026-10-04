function idn( byval x as long ) as long
    return x
end function
function idq( byval x as longint ) as longint
    return x
end function
function idd( byval x as double ) as double
    return x
end function

dim as long a = idn( 2147483647 )
' wrap: fbc wraps
dim as long b = a + 1
print "wrap"; b
if a + 1 < a then print "cmp-wrap yes" else print "cmp-wrap no"
dim as longint q = idq( 9223372036854775807 )
if q + 1 < q then print "cmp-wrapq yes" else print "cmp-wrapq no"
dim as long m = idn( -2147483648 )
print "neg"; -m
print "abs"; abs( m )
' shifts by a variable count >= width
dim as long sc = idn( 33 )
print "shl33"; idn( 1 ) shl sc
print "shr33"; idn( -8 ) shr sc
dim as long sc2 = idn( 32 )
print "shl32"; idn( 1 ) shl sc2
dim as longint sq = idq( 65 )
print "shlq65"; idq( 1 ) shl sq
dim as long sneg = idn( -1 )
print "shlneg"; idn( 1 ) shl sneg
' float -> int out of range
dim as double big = idd( 1e20 )
print "cint"; cint( big )
print "clng"; clng( big )
print "culng"; culng( idd( -1 ) )
dim as double nan_ = idd( 0 ) / idd( 0 )
print "clngnan"; clng( nan_ )
' byte overflow
dim as byte by = idn( 127 )
by += 1
print "byte"; by
' integer loop wrap
dim as long cnt = 0
for i as long = 2147483640 to 2147483647
    cnt += 1
    if cnt > 20 then exit for
next
print "loop"; cnt
