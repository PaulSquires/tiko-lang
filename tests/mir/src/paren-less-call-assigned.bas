'' A PAREN-LESS FUNCTION ON THE RIGHT OF AN ASSIGNMENT IS A CALL, not an address.
'' 'wst = pStream.ReadLine' over 'function ReadLine( ) as DWSTRING' emitted
''
''     %8 = func.addr ptr _ZN1S8READLINEEv
''     call void _ZN..DWSTRINGaSERS0_(@wst, %8)
''
'' -- the function's MACHINE CODE as the source object. It verified, and tiko-editor
'' died at the next allocation. fbc calls it.
''
'' ONLY THAT SPELLING WAS WRONG, so all four are here: the initialiser form and both
'' '( )' forms already worked. fbc prints "a line" four times.
type D
    as long n
    declare constructor( )
    declare constructor( byval k as long )
    declare destructor( )
    declare operator let( byref d as D )

end type
constructor D( ) : n = 0 : end constructor
constructor D( byval k as long ) : n = k : end constructor
destructor D( ) : end destructor
operator D.let( byref d as D ) : n = d.n : end operator


type S
    as long tag
    declare function ReadLine( ) as D
end type
function S.ReadLine( ) as D
    return D( 42 )
end function

dim as S strm
print "A init-no-parens    : ";
dim as D w1 = strm.ReadLine
print w1.n
print "B init-with-parens  : ";
dim as D w2 = strm.ReadLine( )
print w2.n
print "C assign-with-parens: ";
dim as D w3
w3 = strm.ReadLine( )
print w3.n
print "D assign-no-parens  : ";
dim as D w4
w4 = strm.ReadLine
print w4.n
