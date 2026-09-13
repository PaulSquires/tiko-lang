'' 'RETURN T( ARGS )' INTO A UDT RETURNED THROUGH THE HIDDEN POINTER CONSTRUCTS the result
'' in place, when the type has a copy constructor too. fbc-modern's C for each of the four
'' functions below is one constructor call on the hidden pointer -- '_ZN2CCC1Ei( tmp$2$1,
'' N$1 )', and '_ZN2CCC1ERS_( tmp$6$1, O$1 )' for 'return CC( o )' -- and so is the IR here.
'' The copy-constructor path took the ADDRESS of 'CC( n )' instead: a temporary, a copy of
'' it into the result, and the temporary's destructor, in every one of them. fbc-modern
'' prints, and tiko now prints too:
''
''     7 8 3 ctor= 3 copy= 0 dtor= 0
''     8 ctor= 3 copy= 1 dtor= 0
''    cc ctor= 3 copy= 1 dtor= 4
''
'' Before this and the in-place declaration beneath it, tiko's last line was
'' 'cc ctor= 3 copy= 6 dtor= 8'.
type CC
    v as long
    declare constructor( byval n as long )
    declare constructor( byref o as CC )
    declare destructor( )
end type
dim shared as long cctor, ccopy, cdtor
constructor CC( byval n as long ) : cctor += 1 : v = n : end constructor
constructor CC( byref o as CC ) : ccopy += 1 : v = o.v : end constructor
destructor CC( ) : cdtor += 1 : end destructor
function mkC( byval n as long ) as CC
    return CC( n )
end function
function mkLit( byval n as long ) as CC
    return type<CC>( n )
end function
function mkCopy( byref o as CC ) as CC
    return CC( o )
end function
operator + ( byref a as CC, byval n as long ) as CC
    return CC( a.v + n )
end operator
scope
    dim as CC m = mkC( 7 )
    dim as CC n = m + 1
    dim as CC l = mkLit( 3 )
    print m.v; n.v; l.v; " ctor="; cctor; " copy="; ccopy; " dtor="; cdtor
    dim as CC k = mkCopy( n )
    print k.v; " ctor="; cctor; " copy="; ccopy; " dtor="; cdtor
end scope
print "cc ctor="; cctor; " copy="; ccopy; " dtor="; cdtor
