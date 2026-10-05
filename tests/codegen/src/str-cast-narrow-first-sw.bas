type V
    as long raw
    declare operator cast( ) as string
    declare operator cast( ) byref as wstring
end type
operator V.cast( ) as string : return "NARROW" : end operator
operator V.cast( ) byref as wstring
    static as wstring * 8 w = "WIDE"
    return w
end operator
dim as V x
print x
dim as string s = x
dim as wstring * 20 w = x
print s; " "; w
print len( x ); " "; ucase( x )
