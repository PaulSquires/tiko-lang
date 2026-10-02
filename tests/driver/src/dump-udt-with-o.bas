type P
    x as long
    y as double
end type
type B extends object
    declare virtual sub S( )
end type
sub B.S( )
end sub
dim as P p0
print "ok"
