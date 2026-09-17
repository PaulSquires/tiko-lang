'' THE CONVERTING HALF of the paren-less-call rule. A same-type assignment goes through
'' lowerassign.bas; an assignment that needs a CONVERTING 'operator let' goes through
'' LowerUserLetConv_ instead, and that path asked LowerAddr for the value's address --
'' which, for a node naming a PROCEDURE, is the procedure's:
''
''     %8 = func.addr ptr _ZN1S8READLINEEv
''     call void _ZN..7BSTRINGaSERNS_8DWSTRINGE(@wst, %8)
''
'' tiko-editor read its localization file with 'wst = pStream.ReadLine' -- wst a
'' BSTRING, ReadLine returning a DWSTRING -- and died at the next allocation.
'' fbc prints 42 for all four spellings.
type B
    as long n
    declare constructor( )
    declare constructor( byval k as long )
    declare destructor( )
end type
constructor B( ) : n = 0 : end constructor
constructor B( byval k as long ) : n = k : end constructor
destructor B( ) : end destructor

type A
    as long n
    declare constructor( )
    declare destructor( )
    declare operator let( byref b as B )
end type
constructor A( ) : n = -1 : end constructor
destructor A( ) : end destructor
operator A.let( byref b as B ) : n = b.n : end operator

type S
    as long tag
    declare function ReadLine( ) as B
end type
function S.ReadLine( ) as B
    return B( 42 )
end function

dim as S strm
dim as A a1
a1 = strm.ReadLine( )
print "converted, parens   : "; a1.n
dim as A a2
a2 = strm.ReadLine
print "converted, no parens: "; a2.n
