sub dumpu( byref u as ustring )
    print len(u); ":"; len(u); ": [" & u & "]"
end sub
sub bv( byval u as ustring )
    print len(u); "<" & u & ">"
end sub
sub never( byref u as ustring )
end sub
dim as ustring u1 = "ABCDEFG", a = "xy"
dumpu( left(u1, 3) & right(u1, 2) )
bv( a & a )
bv( left(u1, 2) & "z" )
for i as integer = 1 to 3 : never( u1 & a ) : next
print "done"
