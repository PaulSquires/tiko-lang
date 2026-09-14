'' A BYREF UDT PARAMETER GIVEN AN ARGUMENT OF ANOTHER TYPE IS A CONVERSION: the parameter
'' type's constructor builds a temporary, its address is bound, and it dies with the
'' statement's other temporaries. Measured, over 'constructor W( byval v as long )' and
'' 'byref wr as W':
''
''     takeWR( 6 )     _ZN1WC1Ei( &TMP$15$0, 6 );  int32 vr$4 = TAKEWR( &TMP$15$0 );
''     takeWR( d )     _ZN1WC1Ei( &TMP$23$0, fb_D2I( D$0 ) );
''     takeWS( "q" )   fb_StrAssign( &TMP$32$0, -1, "q", 2, 0 );
''                     _ZN2WSC1ER8FBSTRING( &TMP$33$0, &TMP$32$0 );
''     X( 13 )         _ZN1WC1Ei( &TMP$38$0, 13 );  _ZN1XC1ER1W( &XX$0, &TMP$38$0 );
''
'' -- a literal, a variable, an expression, a double, a short, an enum, a boolean and a
'' paren-less call; 'byref as const W'; a SUB called as a statement and a method; a
'' constructor overloaded on LONG and STRING; a constructor over 'byref as const wstring'
'' fed narrow and wide text; and a constructor's own byref parameter spelled 'X( 13 )',
'' 'dim as X x2 = 14', 'new X( n )', 'return v' from a function returning X and an array
'' brace initialiser. A derived object passed to its base and a
'' same-type rvalue are not conversions and still bind directly.
''
'' Before the fix tiko converted only a UDT argument. A variable handed the callee its
'' own address to read as a W, a literal went into a bare W-sized temporary with no
'' constructor run -- 'a1: 6 c= 0 d= 0', 'a4: 1717986918' -- a string literal was stored
'' as a pointer into a descriptor-sized slot and the program crashed at s1, and
'' 'dim as X x2 = 14' declined: no constructor was viable.
''
'' Not covered: a defaulted 'byref wr as W = 3'. fbc never constructs the default and
'' prints garbage; tiko constructs W( 3 ).
''
'' fbc-modern prints:
''
''    a1: 6[~W6] c= 1 d= 1
''    a2: 6[~W6] c= 2 d= 2
''    a3: 7[~W7] c= 3 d= 3
''    a4: 8[~W8] c= 4 d= 4
''    a5: 8[~W8] c= 5 d= 5
''    a6: 9[~W9] c= 6 d= 6
''    a7: 4[~W4] -1[~W-1] c= 8 d= 8
''    a8: 7[~W7] c= 9 d= 9
''    setWR 10 11[~W10]
''    a9: 24[~W12] c= 11 d= 11
''    s1:n5[~n5] sq[~sq] szz
''    [~szz]s2:szzx[~szzx] s5[~s5] sp
''    [~sp]w1:<abc>[~DWS] <wide>[~DWS] <wz>[~DWS] <zz>
''    [~DWS][~W13]x1: 13 c= 12 d= 12
''    [~W14]x2: 14 c= 13 d= 13
''    [~W6]x3: 6 c= 14 d= 14
''    u1: 21  5[~W5] c= 15 d= 15
''    r1:[~W16] 16 c= 16 d= 16
''    [~W6][~W18]r2: 18 6 c= 18 d= 18
''    [~W7]r3: 7 c= 19 d= 19
''    end
''

type W
    i as long
    declare constructor( byval v as long )
    declare constructor( byref o as W )
    declare destructor( )
end type

type WS
    s as string
    declare constructor( byval v as long )
    declare constructor( byref t as string )
    declare destructor( )
end type

type DWS
    w as wstring * 32
    declare constructor( byref s as const wstring )
    declare destructor( )
end type

type X
    j as long
    declare constructor( byref w as W )
end type

type B2
    b as long
end type

type D2 extends B2
    d as long
end type

enum E
    e1 = 4
end enum

type K
    k as long
    declare function m( byref wr as W ) as long
end type

dim shared as long nctor, ndtor

constructor W( byval v as long )
    i = v
    nctor += 1
end constructor

constructor W( byref o as W )
    i = o.i + 1000
    nctor += 1
end constructor

destructor W( )
    ndtor += 1
    print "[~W" & i & "]";
end destructor

constructor WS( byval v as long )
    s = "n" & v
end constructor

constructor WS( byref t as string )
    s = "s" & t
end constructor

destructor WS( )
    print "[~" & s & "]";
end destructor

constructor DWS( byref s as const wstring )
    w = "<" & s & ">"
end constructor

destructor DWS( )
    print "[~DWS]";
end destructor

constructor X( byref w as W )
    j = w.i
end constructor

function K.m( byref wr as W ) as long
    return wr.i * 2
end function

function takeWR( byref wr as W ) as long
    return wr.i
end function

function takeWC( byref wr as const W ) as long
    return wr.i
end function

function takeWS( byref t as WS ) as string
    return t.s
end function

function takeWSv( byval t as WS ) as string
    return t.s
end function

function takeDWS( byref t as DWS ) as string
    return str( t.w )
end function

function takeB( byref b as B2 ) as long
    return b.b
end function

sub setWR( byref wr as W, byval kv as long )
    print "setWR"; wr.i; kv;
end sub

function getSeven( ) as long
    return 7
end function

function rX( byval v as long ) as X
    return v
end function

sub main( )
    dim as long n = 6
    dim as double d = 7.6
    dim as short sh = 8
    dim as string st = "zz"
    dim as wstring * 10 wz = "wz"
    dim as K kk
    dim as D2 dd
    dd.b = 21
    dd.d = 22

    print "a1:"; takeWR( 6 ); " c="; nctor; " d="; ndtor
    print "a2:"; takeWR( n ); " c="; nctor; " d="; ndtor
    print "a3:"; takeWR( n + 1 ); " c="; nctor; " d="; ndtor
    print "a4:"; takeWR( d ); " c="; nctor; " d="; ndtor
    print "a5:"; takeWR( sh ); " c="; nctor; " d="; ndtor
    print "a6:"; takeWC( 9 ); " c="; nctor; " d="; ndtor
    print "a7:"; takeWR( e1 ); " "; takeWR( true ); " c="; nctor; " d="; ndtor
    print "a8:"; takeWR( getSeven ); " c="; nctor; " d="; ndtor
    setWR( 10, 11 )
    print
    print "a9:"; kk.m( 12 ); " c="; nctor; " d="; ndtor

    print "s1:"; takeWS( 5 ); " "; takeWS( "q" ); " "; takeWS( st )
    print "s2:"; takeWS( st & "x" ); " "; takeWS( str( 5 ) ); " "; takeWSv( "p" )
    print "w1:"; takeDWS( "abc" ); " "; takeDWS( wstr( "wide" ) ); " "; takeDWS( wz ); " "; takeDWS( st )

    dim as X x1 = X( 13 )
    print "x1:"; x1.j; " c="; nctor; " d="; ndtor
    dim as X x2 = 14
    print "x2:"; x2.j; " c="; nctor; " d="; ndtor
    dim as X ptr px = new X( n )
    print "x3:"; px->j; " c="; nctor; " d="; ndtor
    delete px

    print "u1:"; takeB( dd ); " "; takeWR( W( 5 ) ); " c="; nctor; " d="; ndtor
    print "r1:"; rX( 16 ).j; " c="; nctor; " d="; ndtor
    dim as X xa( 0 to 1 ) = { 18, n }
    print "r2:"; xa( 0 ).j; xa( 1 ).j; " c="; nctor; " d="; ndtor
    dim as X xb = X( n + 1 )
    print "r3:"; xb.j; " c="; nctor; " d="; ndtor
    print "end"
end sub

main( )
