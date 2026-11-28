'' sites.bas -- RFC 0018 P0: every site in the RFC's section 5.1, with copy/move counts.
''
'' Cases M* are sites the RFC says MOVE (V2) once P1 lands: their copies are expected to
'' fall to zero. Cases C* are sites the RFC says keep COPYING: their trace must not
'' change at all. Q4 is the RFC's open question 4 (function = local, then leave).
''
'' The baseline is p0.tiko-trace (today's tiko) and fbc.fbc-trace (fbc 1.20). Re-run with
'' build/movetrace.sh.

#include once "count.bi"

function Make( byval n as long ) as T
    dim as T r = T( n )
    return r
end function

function Chained( ) as T
    return Make( 4 )
end function

function Pass( byval p as T ) as T
    return p
end function

sub Take( byval x as T )
    print "  (in Take #" & x.id & ")"
end sub

operator + ( byref a as T, byref b as T ) as T
    return T( a.id + b.id )
end operator

function LeaveAfterAssign( ) as T
    dim as T r = T( 9 )
    function = r
    exit function
end function

'' ---- sources that outlive the statement: these keep copying

dim shared as T g
dim shared as T arr( 0 to 1 )

function RetShared( ) as T
    return g
end function

function RetByrefParam( byref p as T ) as T
    return p
end function

function RefG( ) byref as T
    return g
end function

type Holder
    as T m
    declare function Get( ) as T
end type
function Holder.Get( ) as T
    return this.m
end function

function RetElem( ) as T
    return arr( 1 )
end function

function RetDeref( byval p as T ptr ) as T
    return *p
end function

function AssignAndGoOn( ) as T
    dim as T r = T( 7 )
    function = r
    print "  (r still alive: #" & r.id & ")"
end function

type D extends T
    as long extra
end type

function MakeD( ) as D
    dim as D r
    return r
end function

function RetStatic( ) as T
    static as T s
    return s
end function

Report "init (shared g, arr)", 3

print "M1 dim a = Make( )"
scope
    dim as T a = Make( 1 )
end scope
Report "M1"

print "M2 b = Make( )"
scope
    dim as T b
    b = Make( 2 )
end scope
Report "M2"

print "M3 Take( Make( ) )"
scope
    Take( Make( 3 ) )
end scope
Report "M3"

print "M4 dim c = Chained( )  (return Make( ))"
scope
    dim as T c = Chained( )
end scope
Report "M4"

print "M5 return of a byval parameter"
scope
    dim as T x = T( 5 )
    dim as T y = Pass( x )
end scope
Report "M5"

print "M6 Take( T( 6 ) )  (type-constructor temporary)"
scope
    Take( T( 6 ) )
end scope
Report "M6"

print "M7 b = T( 7 )  (type-constructor temporary)"
scope
    dim as T b
    b = T( 7 )
end scope
Report "M7"

print "M8 c = a + b  (operator result)"
scope
    dim as T a = T( 1 ), b = T( 2 ), c
    c = a + b
end scope
Report "M8"

print "Q4 function = r : exit function"
scope
    dim as T q = LeaveAfterAssign( )
end scope
Report "Q4"

print "C1 return of a shared variable"
scope
    dim as T e = RetShared( )
end scope
Report "C1"

print "C2 return of a byref parameter"
scope
    dim as T x = T( 2 )
    dim as T e = RetByrefParam( x )
end scope
Report "C2"

print "C3 dim = byref-returning call"
scope
    dim as T e = RefG( )
end scope
Report "C3"

print "C4 return this.field"
scope
    dim as Holder h
    dim as T e = h.Get( )
end scope
Report "C4"

print "C5 return of an array element"
scope
    dim as T e = RetElem( )
end scope
Report "C5"

print "C6 return *ptr"
scope
    dim as T x = T( 6 )
    dim as T e = RetDeref( @x )
end scope
Report "C6"

print "C7 function = r, r still used afterwards"
scope
    dim as T e = AssignAndGoOn( )
end scope
Report "C7"

print "C8 base slice: dim as T = MakeD( )"
scope
    dim as T e = MakeD( )
end scope
Report "C8"

print "C9 return of a static local"
scope
    dim as T e = RetStatic( )
end scope
Report "C9", 1

print "C10 Take( a )  (an lvalue, still needed)"
scope
    dim as T a = T( 10 )
    Take( a )
end scope
Report "C10"

print "C11 b = a  (an lvalue, still needed)"
scope
    dim as T a = T( 11 ), b
    b = a
end scope
Report "C11"

print "-- end of main"
