'' T47: a method that overrides is virtual only if it also says 'virtual' -- fbc's rule.
'' Each line is one measured case; the output is fbc-modern's for the same program.

'' B overrides without 'virtual', C writes F again: C HIDES it.
type A1 extends Object
    declare virtual function F( ) as string
end type
function A1.F( ) as string : return "A" : end function
type B1 extends A1
    declare function F( ) as string override
end type
function B1.F( ) as string : return "B" : end function
type C1 extends B1
    declare function F( ) as string
end type
function C1.F( ) as string : return "C" : end function

'' B 'virtual ... override': C overrides it.
type A2 extends Object
    declare virtual function F( ) as string
end type
function A2.F( ) as string : return "A" : end function
type B2 extends A2
    declare virtual function F( ) as string override
end type
function B2.F( ) as string : return "B" : end function
type C2 extends B2
    declare function F( ) as string
end type
function C2.F( ) as string : return "C" : end function

'' C 'virtual' over a closed slot opens a NEW slot; A's still reaches B.
type C3 extends B1
    declare virtual function F( ) as string
end type
function C3.F( ) as string : return "C3" : end function

'' B declares nothing: A's slot is still open, and C overrides it.
type B4 extends A1
    pad as long
end type
type C4 extends B4
    declare function F( ) as string
end type
function C4.F( ) as string : return "C4" : end function

'' B's F( long ) hides A's F( string ): C's F( string ) does not override it.
type A5 extends Object
    declare virtual function G( byval n as long ) as string
    declare virtual function G( byref s as string ) as string
end type
function A5.G( byval n as long ) as string : return "A.n" : end function
function A5.G( byref s as string ) as string : return "A.s" : end function
type B5 extends A5
    declare function G( byval n as long ) as string override
end type
function B5.G( byval n as long ) as string : return "B.n" : end function
type C5 extends B5
    declare function G( byref s as string ) as string
end type
function C5.G( byref s as string ) as string : return "C.s" : end function

'' Destructors: only a direct base's VIRTUAL destructor is overridden.
type DA extends Object
    declare virtual destructor( )
end type
destructor DA( ) : print "~A"; : end destructor
type DB extends DA
    declare destructor( )
    pad as long
end type
destructor DB( ) : print " ~B"; : end destructor
type DC extends DB
    declare destructor( )
    pad2 as long
end type
destructor DC( ) : print " ~C"; : end destructor
type DD extends DA
    pad as long
end type
type DE extends DD
    declare destructor( )
    pad2 as long
end type
destructor DE( ) : print " ~E"; : end destructor
type DF extends DA
    declare virtual destructor( )
end type
destructor DF( ) : print " ~F"; : end destructor
type DG extends DF
    declare destructor( )
    pad2 as long
end type
destructor DG( ) : print " ~G"; : end destructor

dim as C1 o1 : dim as A1 ptr p1 = @o1
dim as C2 o2 : dim as A2 ptr p2 = @o2
dim as C3 o3 : dim as A1 ptr p3 = @o3 : dim as C3 ptr q3 = @o3
dim as C4 o4 : dim as A1 ptr p4 = @o4
dim as C5 o5 : dim as A5 ptr p5 = @o5
print "override, then plain:   "; p1->F( )
print "virtual override, plain: "; p2->F( )
print "virtual over closed:     "; p3->F( ); " "; q3->F( )
print "skip a level:            "; p4->F( )
print "hidden overload:         "; p5->G( 1 ); " "; p5->G( "x" )
dim as DA ptr d
d = new DC : print "plain middle: "; : delete d : print
d = new DE : print "no middle:   "; : delete d : print
d = new DG : print "virtual mid: "; : delete d : print
