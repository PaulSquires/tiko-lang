'' A NAME USED ABOVE ITS DECLARATION IS UNDECLARED THERE -- fbc reads a file once, top to
'' bottom, so every use below is error 42 on fbc-modern 1.20 and 1.10.1 alike
'' (2026-09-19), and 'procptr' of one is error 8. tiko-lang declared everything before
'' binding anything and accepted them all.

x1 = 1
dim as integer n = sizeof( TLater ) + len( TLater2 )
print K1
print E1
subLater( )
n = fnLater( )
dim as any ptr p = @subLater2
dim as any ptr q = procptr( subLater3 )
arr( 1 ) = 2
n = sizeof( ELater ) + sizeof( TDLater )
print NLater.v
n = K2
print g1

sub early( )
    print g2
    dim as integer w = vLocal
    dim as integer vLocal
end sub

type TM
    a as integer
    declare sub m( )
end type
sub TM.m( )
    print g3
end sub

dim as integer x1
type TLater
    a as integer
end type
type TLater2
    a as integer
end type
const K1 = 1
enum
    E1
end enum
sub subLater( )
end sub
function fnLater( ) as integer
    return 1
end function
sub subLater2( )
end sub
sub subLater3( )
end sub
dim as integer arr( 5 )
enum ELater
    el1
end enum
type TDLater as integer
namespace NLater
    dim as integer v
end namespace
const K2 = K3 + 1
const K3 = 2
extern g1 as integer
dim shared as integer g1, g2, g3

'' ACCEPTED: a declaration sees itself from its own initialiser, and a procedure or a
'' type sees itself from inside; an earlier name is found past a later one in an inner
'' scope, and a TYPE past a later value of the same spelling.
dim as integer self1 = self1 + 1
function recurse( byval d as integer ) as integer
    if d > 0 then return recurse( d - 1 )
    recurse = 0
end function
type TSelf
    a as integer
    b as integer = sizeof( TSelf )
end type
dim shared as integer outer1 = 1
namespace NS
    sub useOuter( )
        print outer1
    end sub
    dim as integer outer1 = 2
end namespace
namespace ST
type Stamp
    t as integer
    declare static function Make( ) as Stamp
    declare static function Zero( ) as Stamp
end type
function Stamp.Make( ) as Stamp
    dim as Stamp r
    return r
end function
function Stamp.Zero( ) as Stamp
    return Stamp.Make( )
end function
end namespace
declare function stamp( byval v as integer ) as integer
