' A large aggregate copy is a memcpy, also where something runs between its load and its store:
' 'this.b = FromStr( str( d ) )' is 'call sret; fb_StrDelete; load; store', and as a first-class
' '[N x i8]' value clang's instruction selection took ~49 s per 5008-byte copy (a decfloat library
' with sixteen of them never finished building). 2008 bytes: above the copy threshold, and below
' the 4096 the adjacent-only fusion used to start at.
type Big
    as long sign, expo
    as long m(0 to 499)
end type

function FromStr( byref s as string ) as Big
    dim as Big r
    r.sign = len( s ) : r.expo = valint( s )
    for i as integer = 0 to 499
        r.m(i) = i * 3 + r.expo
    next
    return r
end function

type Holder
    as Big b
    declare constructor( byval d as double )
    declare operator let( byval d as double )
end type

constructor Holder( byval d as double )
    this.b = FromStr( str( d ) )
end constructor

operator Holder.let( byval d as double )
    this.b = FromStr( str( d ) )
end operator

dim as Holder h = 42
print h.b.sign; h.b.expo; h.b.m(0); h.b.m(499)
h = 7
print h.b.sign; h.b.expo; h.b.m(0); h.b.m(499)

dim as Big a, c
a = FromStr( "123" )
c = a
a.m(499) = 0
print c.sign; c.expo; c.m(1); c.m(499); a.m(499)
