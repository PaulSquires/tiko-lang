'' overload-picks.bas -- which overload is chosen, twenty-two ways: the regression set for the
'' one ranker (LATER-PLAN D step 3, review SEM-08). Every line printed is fbc-modern 1.20's,
'' measured 2026-10-24: the calls, the global and member binary operators, the unary ones.
'' ('g( 1 )' is fbc's error 98 between g's first two -- the default makes them tie.)

type V
    as integer x
    declare constructor( byval a as integer )
    declare operator cast( ) as double
    declare operator += ( byref r as V )
end type
constructor V( byval a as integer )
    x = a
end constructor
operator V.cast( ) as double
    return x + 0.5
end operator
operator V.+= ( byref r as V )
    print "V+=V"
    x += r.x
end operator
operator + ( byref a as V, byref b as V ) as V
    print "V+V"
    return V( a.x + b.x )
end operator
operator + ( byref a as V, byval b as integer ) as V
    print "V+int"
    return V( a.x + b )
end operator
operator - ( byref a as V ) as V
    print "-V"
    return V( -a.x )
end operator

sub f overload ( byval a as byte )     : print "f byte"     : end sub
sub f overload ( byval a as short )    : print "f short"    : end sub
sub f overload ( byval a as long )     : print "f long"     : end sub
sub f overload ( byval a as longint )  : print "f longint"  : end sub
sub f overload ( byval a as single )   : print "f single"   : end sub
sub f overload ( byval a as double )   : print "f double"   : end sub
sub f overload ( byref a as string )   : print "f string"   : end sub
sub f overload ( byval a as any ptr )  : print "f any ptr"  : end sub

sub g overload ( byval a as integer )                      : print "g int"        : end sub
sub g overload ( byval a as integer, byval b as integer = 2 ) : print "g int, int" : end sub
sub g overload ( byval a as double, byval b as double )     : print "g dbl, dbl"   : end sub

sub h overload ( byval a as ulong )    : print "h ulong"    : end sub
sub h overload ( byval a as longint )  : print "h longint"  : end sub

sub k overload ( byval a as V )        : print "k V"        : end sub
sub k overload ( byval a as string )   : print "k string"   : end sub

sub m overload ( byval a as zstring ptr ) : print "m zstring ptr" : end sub
sub m overload ( byval a as integer ptr ) : print "m integer ptr" : end sub

dim as byte bb = 1
dim as short ss = 1
dim as long ll = 1
dim as longint qq = 1
dim as single sg = 1
dim as double dd = 1
dim as string st = "s"
dim as integer ii = 1
dim as ubyte ub = 1
dim as uinteger ui = 1
dim as integer ptr ip = @ii
dim as zstring * 4 zs = "z"

print "01 ";: f( bb )
print "02 ";: f( ss )
print "03 ";: f( ll )
print "04 ";: f( qq )
print "05 ";: f( sg )
print "06 ";: f( dd )
print "07 ";: f( st )
print "08 ";: f( ip )
print "09 ";: f( ub )
print "10 ";: f( 1.5 )
print "11 ";: f( "lit" )
print "12 ";: g( 1, 2 )
print "13 ";: g( 1.5, 2 )
print "14 ";: h( ub )
print "15 ";: h( ui )
print "16 ";: k( st )
print "17 ";: m( @zs )
print "18 ";: m( ip )

dim as V p = V( 1 ), q = V( 2 )
print "19 ";
dim as V r = p + q
print "20 ";
dim as V t = p + 3
print "21 ";
dim as V u = -p
print "22 ";: p += q
