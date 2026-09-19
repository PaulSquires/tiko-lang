'' 'cast( string, u )' over a UDT with a narrow 'operator cast', as a PRINT item.
type Box
    x as long
    declare operator cast( ) as string
end type
operator Box.cast( ) as string
    return "box" & x
end operator
dim as Box b
b.x = 7
print cast( string, b )
print cast( string, b ); " tail"
print "head "; cast( string, b )
