'' A STATEMENT-LIFETIME TEMPORARY DIES WHERE FBC FLUSHES ITS DESTRUCTOR LIST, which is not
'' the end of the statement. fbc keeps one list per top-level tree it emits and runs it,
'' newest first, as that tree is done:
''
''   PRINT / WRITE / PRINT USING   after each item, after the channel, after USING's Init
''   DIM / VAR                     after each declarator
''   FOR                           after the start, after the limit, after the step
''   IF / ELSEIF, SELECT, CASE     after the condition, the stored subject, each case
''                                 value -- before the branch
''   WHILE / DO / LOOP             after the condition (tiko already did this)
''
'' Inside ONE tree nothing is released early: an argument's temporary outlives the call
'' that consumed it until the whole item is printed, so 'takeR( mkH( 1 ) ) + takeR(
'' mkH( 2 ) ) + cnt( )' reads the count before either destructor. A short-circuit's right
'' side and an IIF arm keep their own lists (tiko already did this too).
''
'' A BYVAL COPY and a CONVERSION TEMPORARY -- byval, byref, or an operator's operand -- are
'' on the same list, registered as they are made (a call's hidden result before its
'' arguments), so 'f2( nm, mkFrom( b ) )' destroys the copy of mkFrom's result, mkFrom's
'' own argument copy, mkFrom's result, then nm's copy. tiko destroyed those straight
'' after the call and everything else at the end of the whole statement.
''
'' ONE DELIBERATE DIVERGENCE, not exercised here: fbc puts a CASE value's destructor on
'' the MATCH edge only, leaking the temporary of a value that does not match (and a
'' 'case lo to hi' destroys hi's on the edge that never built it). tiko destroys it on
'' both edges.
''
'' fbc-modern prints:
''
''    p1: 1[~1] n= 1
''    p2: 3[~3] n= 1
''    p3: 3[~3] n= 1
''    p4: 207[~107][~7][~7][~107][~207] n= 5
''    p5: 3[~2][~1] n= 2
''    p6: 0[~3] n= 1
''    [~0]p7: 1
''    p8:            5            [~5] 1
''    1,[~1]1,2,[~2]2
''    u1: 3 [~3] 1  4 [~4] 2
''    [~5]5: 1  1
''    c1: 7[~7] n= 1
''    c2: 172[~102][~2][~102][~7] n= 4
''    c3: 5[~W5] n= 1
''    c4: 1001[~DW1001] n= 1
''    c5: 10[~W9] n= 1
''    c6:[~7]-1 n= 1
''    [~6]d1: y1= 1
''    [~0][~1]i1: elseif n= 2
''    [~0]i2: else n= 1
''    [~7][~7]s1: case n= 2
''    [~s5]s2: case n= 1
''    [~1][~5][~2]f1: i= 1 n= 3
''    f1: i= 5 n= 3
''    [~0]w1: k= 0 n= 1
''    [~1]w1: k= 1 n= 2
''    [~2]end
''    [~W1][~7][~2][~1]
''

type H
    p as long ptr
    declare constructor( byval v as long )
    declare constructor( byref o as H )
    declare destructor( )
end type

type W
    i as long
    declare constructor( byval v as long )
    declare destructor( )
end type

type DW
    i as long
    declare constructor( byref b as H )
    declare destructor( )
end type

type S
    s as string
    declare constructor( byval v as long )
    declare destructor( )
end type

dim shared as long hdtor

constructor H( byval v as long )
    p = callocate( sizeof( long ) )
    *p = v
end constructor

constructor H( byref o as H )
    p = callocate( sizeof( long ) )
    *p = *o.p
end constructor

destructor H( )
    hdtor += 1
    print "[~" & *p & "]";
    deallocate( p )
end destructor

constructor W( byval v as long )
    i = v
end constructor

destructor W( )
    hdtor += 1
    print "[~W" & i & "]";
end destructor

constructor DW( byref b as H )
    i = *b.p + 1000
end constructor

destructor DW( )
    hdtor += 1
    print "[~DW" & i & "]";
end destructor

constructor S( byval v as long )
    s = "s" & v
end constructor

destructor S( )
    hdtor += 1
    print "[~" & s & "]";
end destructor

function mkH( byval v as long ) as H
    return H( v )
end function

function makeS( byval v as long ) as S
    return S( v )
end function

function takeR( byref hh as H ) as long
    return *hh.p
end function

function takeV( byval hh as H ) as long
    return *hh.p
end function

function mkFrom( byval hh as H ) as H
    return H( *hh.p + 100 )
end function

function f2( byval a as H, byval b as H ) as long
    return *a.p * 10 + *b.p
end function

function takeWV( byval wv as W ) as long
    return wv.i
end function

function takeDW( byref d as DW ) as long
    return d.i
end function

function cnt( ) as long
    return hdtor
end function

operator + ( byref a as H, byref b as H ) as H
    return H( *a.p + *b.p )
end operator

operator + ( byref a as W, byref b as W ) as long
    return a.i + b.i
end operator

sub main( )
    dim as H a = H( 1 ), b = H( 2 ), nm = H( 7 )
    dim as W w1 = W( 1 )

    '' PRINT: each item, and the channel, is a statement of its own
    print "p1:"; takeR( mkH( 1 ) ); " n="; cnt( )
    hdtor = 0
    print "p2:"; takeR( a + b ); " n="; cnt( )
    hdtor = 0
    print "p3:"; *(a + b).p; " n="; cnt( )
    hdtor = 0
    print "p4:"; takeR( mkFrom( mkFrom( mkH( 7 ) ) ) ); " n="; cnt( )
    hdtor = 0
    print "p5:"; takeR( mkH( 1 ) ) + takeR( mkH( 2 ) ) + cnt( ); " n="; cnt( )
    hdtor = 0
    print "p6:"; iif( takeR( mkH( 3 ) ) = 3, cnt( ), -1 ); " n="; cnt( )
    hdtor = 0
    print #takeR( mkH( 0 ) ), "p7:"; cnt( )
    hdtor = 0
    print "p8:", takeR( mkH( 5 ) ), cnt( )
    hdtor = 0

    '' WRITE and PRINT USING
    write takeR( mkH( 1 ) ), cnt( ), takeR( mkH( 2 ) ), cnt( )
    hdtor = 0
    print using "u1:## ## ## ##"; takeR( mkH( 3 ) ); cnt( ); takeR( mkH( 4 ) ); cnt( )
    hdtor = 0
    print using str( takeR( mkH( 5 ) ) ) & ":## ##"; cnt( ); cnt( )
    hdtor = 0

    '' byval copies and conversion temporaries are statement temporaries
    print "c1:"; takeV( nm ) + cnt( ); " n="; cnt( )
    hdtor = 0
    print "c2:"; f2( nm, mkFrom( b ) ); " n="; cnt( )
    hdtor = 0
    print "c3:"; takeWV( 5 ) + cnt( ); " n="; cnt( )
    hdtor = 0
    print "c4:"; takeDW( a ) + cnt( ); " n="; cnt( )
    hdtor = 0
    print "c5:"; ( w1 + 9 ) + cnt( ); " n="; cnt( )
    hdtor = 0
    print "c6:"; ( cnt( ) = 0 ) andalso ( takeV( nm ) = 7 ); " n="; cnt( )
    hdtor = 0

    '' DIM: each declarator
    dim as long x1 = takeR( mkH( 6 ) ), y1 = cnt( )
    print "d1: y1="; y1
    hdtor = 0

    '' IF / ELSEIF: before the branch
    if takeR( mkH( 0 ) ) = 1 then
        print "i1: then"
    elseif takeR( mkH( 1 ) ) = 1 then
        print "i1: elseif n="; cnt( )
    end if
    hdtor = 0
    if takeR( mkH( 0 ) ) = 1 then print "i2: then" else print "i2: else n="; cnt( )
    hdtor = 0

    '' SELECT: the subject once stored, each case value before its branch
    select case takeR( mkH( 7 ) )
    case takeR( mkH( 7 ) ) + cnt( ) - 1
        print "s1: case n="; cnt( )
    end select
    hdtor = 0
    select case makeS( 5 ).s
    case "s5"
        print "s2: case n="; cnt( )
    end select
    hdtor = 0

    '' FOR: start, limit and step
    for i as long = takeR( mkH( 1 ) ) to takeR( mkH( 5 ) ) + cnt( ) step takeR( mkH( 2 ) ) + cnt( )
        print "f1: i="; i; " n="; cnt( )
    next
    hdtor = 0

    '' loops were already right
    dim as long k = 0
    while takeR( mkH( k ) ) < 2
        print "w1: k="; k; " n="; cnt( )
        k += 1
    wend
    hdtor = 0
    print "end"
end sub

main( )
