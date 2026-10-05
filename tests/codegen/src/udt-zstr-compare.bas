type K
    as zstring * 8 z
    declare operator cast( ) byref as zstring
end type
operator K.cast( ) byref as zstring : return this.z : end operator
dim as K a, b, d
a.z = "ab" : b.z = "ab" : d.z = "ac"
print ( a = b ); ( a < b ); ( a < d ); ( d > a ); ( a <> d ); ( a = "ab" )
print a + b; " "; a & d
