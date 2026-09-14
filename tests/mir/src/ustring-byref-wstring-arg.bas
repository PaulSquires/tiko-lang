'' A USTRING PASSED TO A 'byref as wstring' PARAMETER IS ITS DATA POINTER -- already UTF-16.
'' It went through fb_StrToWstr as though it were narrow, and the callee saw one character:
'' tracks' notes panel showed "T". Measured, fbc-modern prints ' 15' and ' 8'.
type Trade
    as ustring notes
end type
sub TakeW( byref wsz as wstring )
    print len( wsz )
end sub
dim as ustring u = "Tom trade #0542"
dim as Trade t
t.notes = "My trade"
TakeW( u )
TakeW( t.notes )
