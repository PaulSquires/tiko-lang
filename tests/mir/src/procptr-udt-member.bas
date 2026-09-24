'' A MEMBER OF A UDT RETURNED THROUGH A PROCEDURE POINTER.
''
'' 'select case p->fn( 7 ).kind' vanished -- the SELECT was not lowered -- and 'dim v =
'' fp( 5 ).kind' read the stack: a UDT returned by value through a procedure pointer had
'' no address to take the member from, where the same call through the named function
'' did. tiko-lang's C importer writes 'x.api->getCanonicalType( t ).kind' against its
'' libclang table, and the bootstrap's stage 1 dropped the statement. A 24-byte result
'' (through a hidden pointer) and an 8-byte one (in registers), at module level and in a
'' SUB; fbc prints what this file prints -- goldenrun executes it.
type Big
    as long kind
    as any ptr a, b
end type
type Small
    as long kind
    as long other
end type
function make_big( byval k as long ) as Big
    dim r as Big
    r.kind = k
    return r
end function
function make_small( byval k as long ) as Small
    dim r as Small
    r.kind = k : r.other = k * 10
    return r
end function
type Api
    fb as function( byval k as long ) as Big
    fs as function( byval k as long ) as Small
end type
dim api as Api
api.fb = @make_big : api.fs = @make_small
dim p as Api ptr = @api
dim fpb as function( byval k as long ) as Big = @make_big
select case p->fb( 7 ).kind
case 7 : print "big seven"
case else : print "big other"
end select
select case p->fs( 8 ).other
case 80 : print "small eighty"
case else : print "small other"
end select
dim as long v = fpb( 5 ).kind
dim as long w = p->fs( 6 ).other
print v, w
if p->fb( 2 ).kind = 2 then print "if ok"
sub inproc( byval q as Api ptr )
    print q->fb( 11 ).kind + q->fs( 12 ).kind
end sub
inproc( p )
