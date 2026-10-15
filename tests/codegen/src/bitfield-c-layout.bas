' bitfield-c-layout.bas -- 'extern "c"' records, laid out by the target's C rule. Every
' field is written alone and the record's bytes dumped, then all together over a record of
' &hFF bytes and read back: a layout or a unit that is wrong shows in the bytes, and a write
' that clobbers a neighbour shows in the read-back. The expected output is a C twin's,
' compiled by clang for x86_64-pc-windows-msvc -- and, under WSL, by gcc for the same
' records on linux-x86_64, where tiko's output matched too.

sub dump( byval p as ubyte ptr, byval n as long )
    dim as string s
    for i as long = 0 to n - 1
        s &= lcase( hex( p[i], 2 ) )
    next
    print s;
end sub

type bf_mixed extern "c"
    a : 3 as ubyte
    b : 5 as ulong
end type
type bf_short_gap extern "c"
    s : 4 as ushort
    c as ubyte
    i : 7 as ulong
end type
type bf_wide extern "c"
    q : 40 as ulongint
    r : 10 as ulong
end type
type bf_after_char extern "c"
    c as ubyte
    q : 3 as ulongint
end type
type bf_tail extern "c"
    x : 3 as ulong
    y : 5 as ulong
    c as ubyte
end type
type bf_overflow extern "c"
    a : 30 as ulong
    b : 5 as ulong
end type
type bf_sizes extern "c"
    a : 3 as ubyte
    b : 3 as ushort
    c : 3 as ubyte
end type
type bf_into_char extern "c"
    x as ubyte
    a : 3 as ulong
end type
type bf_ll_middle extern "c"
    a : 3 as ulong
    b : 3 as ulongint
    c : 3 as ulong
end type
type bf_ull extern "c"
    a : 60 as ulongint
    b : 31 as ulong
    c : 33 as ulongint
end type
union bf_union extern "c"
    a : 3 as ubyte
    b : 5 as ulong
end union
type bf_pack1 field = 1 extern "c"
    a : 3 as ubyte
    b : 5 as ulong
end type
type bf_pack1_span field = 1 extern "c"
    p as ubyte
    a : 20 as ulong
    b : 14 as ushort
end type
type bf_pack1_end field = 1 extern "c"
    a : 4 as ubyte
    b : 20 as ulong
end type
type bf_pack2 field = 2 extern "c"
    a : 3 as ubyte
    b : 5 as ulong
    c as ubyte
end type

scope
    dim as bf_mixed v
    print "bf_mixed " & sizeof( bf_mixed )
    clear v, 0, sizeof( v )
    v.a = 5
    print "bf_mixed a ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.a )
    clear v, 0, sizeof( v )
    v.b = 22
    print "bf_mixed b ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.b )
    ' all fields at once: none may clobber another
    clear v, &hFF, sizeof( v )
    v.a = 6
    v.b = 27
    print "bf_mixed all ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print ""
    print "bf_mixed all.a " & str( v.a )
    print "bf_mixed all.b " & str( v.b )
end scope
scope
    dim as bf_short_gap v
    print "bf_short_gap " & sizeof( bf_short_gap )
    clear v, 0, sizeof( v )
    v.s = 13
    print "bf_short_gap s ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.s )
    clear v, 0, sizeof( v )
    v.c = 182
    print "bf_short_gap c ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.c )
    clear v, 0, sizeof( v )
    v.i = 91
    print "bf_short_gap i ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.i )
    ' all fields at once: none may clobber another
    clear v, &hFF, sizeof( v )
    v.s = 6
    v.c = 219
    v.i = 109
    print "bf_short_gap all ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print ""
    print "bf_short_gap all.s " & str( v.s )
    print "bf_short_gap all.c " & str( v.c )
    print "bf_short_gap all.i " & str( v.i )
end scope
scope
    dim as bf_wide v
    print "bf_wide " & sizeof( bf_wide )
    clear v, 0, sizeof( v )
    v.q = 942438538093
    print "bf_wide q ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.q )
    clear v, 0, sizeof( v )
    v.r = 438
    print "bf_wide r ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.r )
    ' all fields at once: none may clobber another
    clear v, &hFF, sizeof( v )
    v.q = 471219269046
    v.r = 731
    print "bf_wide all ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print ""
    print "bf_wide all.q " & str( v.q )
    print "bf_wide all.r " & str( v.r )
end scope
scope
    dim as bf_after_char v
    print "bf_after_char " & sizeof( bf_after_char )
    clear v, 0, sizeof( v )
    v.c = 109
    print "bf_after_char c ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.c )
    clear v, 0, sizeof( v )
    v.q = 6
    print "bf_after_char q ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.q )
    ' all fields at once: none may clobber another
    clear v, &hFF, sizeof( v )
    v.c = 182
    v.q = 3
    print "bf_after_char all ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print ""
    print "bf_after_char all.c " & str( v.c )
    print "bf_after_char all.q " & str( v.q )
end scope
scope
    dim as bf_tail v
    print "bf_tail " & sizeof( bf_tail )
    clear v, 0, sizeof( v )
    v.x = 5
    print "bf_tail x ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.x )
    clear v, 0, sizeof( v )
    v.y = 22
    print "bf_tail y ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.y )
    clear v, 0, sizeof( v )
    v.c = 219
    print "bf_tail c ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.c )
    ' all fields at once: none may clobber another
    clear v, &hFF, sizeof( v )
    v.x = 6
    v.y = 27
    v.c = 109
    print "bf_tail all ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print ""
    print "bf_tail all.x " & str( v.x )
    print "bf_tail all.y " & str( v.y )
    print "bf_tail all.c " & str( v.c )
end scope
scope
    dim as bf_overflow v
    print "bf_overflow " & sizeof( bf_overflow )
    clear v, 0, sizeof( v )
    v.a = 766958445
    print "bf_overflow a ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.a )
    clear v, 0, sizeof( v )
    v.b = 22
    print "bf_overflow b ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.b )
    ' all fields at once: none may clobber another
    clear v, &hFF, sizeof( v )
    v.a = 920350134
    v.b = 27
    print "bf_overflow all ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print ""
    print "bf_overflow all.a " & str( v.a )
    print "bf_overflow all.b " & str( v.b )
end scope
scope
    dim as bf_sizes v
    print "bf_sizes " & sizeof( bf_sizes )
    clear v, 0, sizeof( v )
    v.a = 5
    print "bf_sizes a ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.a )
    clear v, 0, sizeof( v )
    v.b = 6
    print "bf_sizes b ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.b )
    clear v, 0, sizeof( v )
    v.c = 3
    print "bf_sizes c ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.c )
    ' all fields at once: none may clobber another
    clear v, &hFF, sizeof( v )
    v.a = 6
    v.b = 3
    v.c = 5
    print "bf_sizes all ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print ""
    print "bf_sizes all.a " & str( v.a )
    print "bf_sizes all.b " & str( v.b )
    print "bf_sizes all.c " & str( v.c )
end scope
scope
    dim as bf_into_char v
    print "bf_into_char " & sizeof( bf_into_char )
    clear v, 0, sizeof( v )
    v.x = 109
    print "bf_into_char x ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.x )
    clear v, 0, sizeof( v )
    v.a = 6
    print "bf_into_char a ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.a )
    ' all fields at once: none may clobber another
    clear v, &hFF, sizeof( v )
    v.x = 182
    v.a = 3
    print "bf_into_char all ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print ""
    print "bf_into_char all.x " & str( v.x )
    print "bf_into_char all.a " & str( v.a )
end scope
scope
    dim as bf_ll_middle v
    print "bf_ll_middle " & sizeof( bf_ll_middle )
    clear v, 0, sizeof( v )
    v.a = 5
    print "bf_ll_middle a ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.a )
    clear v, 0, sizeof( v )
    v.b = 6
    print "bf_ll_middle b ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.b )
    clear v, 0, sizeof( v )
    v.c = 3
    print "bf_ll_middle c ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.c )
    ' all fields at once: none may clobber another
    clear v, &hFF, sizeof( v )
    v.a = 6
    v.b = 3
    v.c = 5
    print "bf_ll_middle all ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print ""
    print "bf_ll_middle all.a " & str( v.a )
    print "bf_ll_middle all.b " & str( v.b )
    print "bf_ll_middle all.c " & str( v.c )
end scope
scope
    dim as bf_ull v
    print "bf_ull " & sizeof( bf_ull )
    clear v, 0, sizeof( v )
    v.a = 823515360433462125
    print "bf_ull a ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.a )
    clear v, 0, sizeof( v )
    v.b = 920350134
    print "bf_ull b ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.b )
    clear v, 0, sizeof( v )
    v.c = 3681400539
    print "bf_ull c ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.c )
    ' all fields at once: none may clobber another
    clear v, &hFF, sizeof( v )
    v.a = 988218432520154550
    v.b = 1533916891
    v.c = 6135667565
    print "bf_ull all ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print ""
    print "bf_ull all.a " & str( v.a )
    print "bf_ull all.b " & str( v.b )
    print "bf_ull all.c " & str( v.c )
end scope
scope
    dim as bf_union v
    print "bf_union " & sizeof( bf_union )
    clear v, 0, sizeof( v )
    v.a = 5
    print "bf_union a ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.a )
    clear v, 0, sizeof( v )
    v.b = 22
    print "bf_union b ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.b )
    ' all fields at once: none may clobber another
    clear v, 0, sizeof( v )
end scope
scope
    dim as bf_pack1 v
    print "bf_pack1 " & sizeof( bf_pack1 )
    clear v, 0, sizeof( v )
    v.a = 5
    print "bf_pack1 a ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.a )
    clear v, 0, sizeof( v )
    v.b = 22
    print "bf_pack1 b ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.b )
    ' all fields at once: none may clobber another
    clear v, &hFF, sizeof( v )
    v.a = 6
    v.b = 27
    print "bf_pack1 all ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print ""
    print "bf_pack1 all.a " & str( v.a )
    print "bf_pack1 all.b " & str( v.b )
end scope
scope
    dim as bf_pack1_span v
    print "bf_pack1_span " & sizeof( bf_pack1_span )
    clear v, 0, sizeof( v )
    v.p = 109
    print "bf_pack1_span p ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.p )
    clear v, 0, sizeof( v )
    v.a = 748982
    print "bf_pack1_span a ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.a )
    clear v, 0, sizeof( v )
    v.b = 14043
    print "bf_pack1_span b ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.b )
    ' all fields at once: none may clobber another
    clear v, &hFF, sizeof( v )
    v.p = 182
    v.a = 898779
    v.b = 7021
    print "bf_pack1_span all ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print ""
    print "bf_pack1_span all.p " & str( v.p )
    print "bf_pack1_span all.a " & str( v.a )
    print "bf_pack1_span all.b " & str( v.b )
end scope
scope
    dim as bf_pack1_end v
    print "bf_pack1_end " & sizeof( bf_pack1_end )
    clear v, 0, sizeof( v )
    v.a = 13
    print "bf_pack1_end a ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.a )
    clear v, 0, sizeof( v )
    v.b = 748982
    print "bf_pack1_end b ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.b )
    ' all fields at once: none may clobber another
    clear v, &hFF, sizeof( v )
    v.a = 6
    v.b = 898779
    print "bf_pack1_end all ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print ""
    print "bf_pack1_end all.a " & str( v.a )
    print "bf_pack1_end all.b " & str( v.b )
end scope
scope
    dim as bf_pack2 v
    print "bf_pack2 " & sizeof( bf_pack2 )
    clear v, 0, sizeof( v )
    v.a = 5
    print "bf_pack2 a ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.a )
    clear v, 0, sizeof( v )
    v.b = 22
    print "bf_pack2 b ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.b )
    clear v, 0, sizeof( v )
    v.c = 219
    print "bf_pack2 c ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print " " & str( v.c )
    ' all fields at once: none may clobber another
    clear v, &hFF, sizeof( v )
    v.a = 6
    v.b = 27
    v.c = 109
    print "bf_pack2 all ";
    dump( cast( ubyte ptr, @v ), sizeof( v ) )
    print ""
    print "bf_pack2 all.a " & str( v.a )
    print "bf_pack2 all.b " & str( v.b )
    print "bf_pack2 all.c " & str( v.c )
end scope
