'' A UDT whose BEST cast against a string context's target is a pointer, a number or a tie
'' reaches no string (castpick.bas). fbc-modern: print 24, assignment 181, '&' 20, argument 58,
'' ustring initialiser tie 98. The last block reaches a string and compiles.
type ZP
    z as zstring * 4 = "z"
    declare operator cast( ) as zstring ptr
    declare operator cast( ) as ustring
end type
operator ZP.cast( ) as zstring ptr : return @this.z : end operator
operator ZP.cast( ) as ustring : return "u" : end operator
type BW
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) byref as wstring
    declare operator cast( ) as wstring ptr
end type
operator BW.cast( ) byref as wstring : return this.w : end operator
operator BW.cast( ) as wstring ptr : return @this.w : end operator
sub takeStr( byval s as string ) : end sub
dim as ZP vz
dim as BW vw
dim as string s
print vz
s = vz
s = "x" & vz
takeStr( vz )
dim as ustring u = vw
'' fine: [as string, byref as zstring] and friends
type OK
    z as zstring * 4 = "z"
    declare operator cast( ) as string
    declare operator cast( ) byref as zstring
end type
operator OK.cast( ) as string : return "s" : end operator
operator OK.cast( ) byref as zstring : return this.z : end operator
dim as OK vo
print vo
s = vo
s = "x" & vo
takeStr( vo )
