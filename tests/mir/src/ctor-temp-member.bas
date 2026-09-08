'' 'UDT( ).getI( )' -- A MEMBER CALL ON A CONSTRUCTOR TEMPORARY, in every spelling
'' structs/anon-access.bas writes. fbc accepts the empty 'T( )' exactly when T has a
'' constructor at all, and measurably so:
''
''   type Q : a as integer     : b as integer : end type   Q( ) is fbc's error 42
''   type Q : a as integer = 5 : b as integer : end type   Q( ) is accepted
''   type Q : a as integer     : s as string  : end type   Q( ) is accepted
''
'' -- a field initialiser or a string field gives it one. Asking only for a WRITTEN
'' constructor built the temporary, never constructed it, and emitted the member call
'' with NO RECEIVER. 'P( 3 ).getv( )' worked all along, which is what kept it looking
'' like a member-call problem rather than an empty-argument-list one.
dim shared globali as integer

type UDT
    i as integer = 123
    declare function getI( ) as integer
    declare sub copyToGlobal( )
end type

function UDT.getI( ) as integer
    return i
end function

sub UDT.copyToGlobal( )
    globali = i
end sub

'' A WRITTEN constructor taking arguments -- the case that always worked, kept beside
'' the others so a fix that traded one for the other cannot pass.
type P
    v as integer
    declare constructor( byval n as integer )
    declare function getv( ) as integer
end type

constructor P( byval n as integer )
    v = n
end constructor

function P.getv( ) as integer
    return v
end function

print UDT( ).getI( ), UDT( ).i, P( 3 ).getv( ), P( 3 ).v
print type<UDT>( ).getI( )

globali = 0 : UDT( ).copyToGlobal( )            : print globali
globali = 0 : (UDT( )).copyToGlobal( )          : print globali
'' 'type<...>' AT THE HEAD OF A STATEMENT. TYPE starts a declaration, so this line went
'' to the declaration parser and came back as TKO0406 -- while the identical expression
'' inside the PRINT above parsed and lowered.
globali = 0 : type<UDT>( ).copyToGlobal( )      : print globali
globali = 0 : (type<UDT>( )).copyToGlobal( )    : print globali
