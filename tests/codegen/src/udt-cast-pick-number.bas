'' A UDT in a NUMBER's place: fbc's condition takes the most precise simple cast -- double >
'' long > byref wstring > byref zstring (its first character) -- then a pointer against
'' 'any ptr'; 'u + 1' and 'u * 2' take the number nearest the other operand, else the character.
type T0
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) byref as zstring
end type
operator T0.cast( ) byref as zstring : print "<BZ>"; : return this.z : end operator
type T1
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) byref as wstring
end type
operator T1.cast( ) byref as wstring : print "<BW>"; : return this.w : end operator
type T2
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) byref as zstring
    declare operator cast( ) byref as wstring
end type
operator T2.cast( ) byref as zstring : print "<BZ>"; : return this.z : end operator
operator T2.cast( ) byref as wstring : print "<BW>"; : return this.w : end operator
type T3
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) byref as wstring
    declare operator cast( ) byref as zstring
end type
operator T3.cast( ) byref as wstring : print "<BW>"; : return this.w : end operator
operator T3.cast( ) byref as zstring : print "<BZ>"; : return this.z : end operator
type T4
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) as zstring ptr
    declare operator cast( ) byref as zstring
end type
operator T4.cast( ) as zstring ptr : print "<ZP>"; : return @this.z : end operator
operator T4.cast( ) byref as zstring : print "<BZ>"; : return this.z : end operator
type T5
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) byref as zstring
    declare operator cast( ) as any ptr
end type
operator T5.cast( ) byref as zstring : print "<BZ>"; : return this.z : end operator
operator T5.cast( ) as any ptr : print "<AP>"; : return @this.z : end operator
type T6
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) byref as wstring
    declare operator cast( ) as long
end type
operator T6.cast( ) byref as wstring : print "<BW>"; : return this.w : end operator
operator T6.cast( ) as long : print "<L>"; : return 7 : end operator
type T7
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) as long
    declare operator cast( ) byref as wstring
end type
operator T7.cast( ) as long : print "<L>"; : return 7 : end operator
operator T7.cast( ) byref as wstring : print "<BW>"; : return this.w : end operator
type T8
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) as long
    declare operator cast( ) as double
end type
operator T8.cast( ) as long : print "<L>"; : return 7 : end operator
operator T8.cast( ) as double : print "<D>"; : return 2.5 : end operator
type T9
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) as double
    declare operator cast( ) as long
end type
operator T9.cast( ) as double : print "<D>"; : return 2.5 : end operator
operator T9.cast( ) as long : print "<L>"; : return 7 : end operator
type T10
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) as zstring ptr
    declare operator cast( ) as any ptr
end type
operator T10.cast( ) as zstring ptr : print "<ZP>"; : return @this.z : end operator
operator T10.cast( ) as any ptr : print "<AP>"; : return @this.z : end operator
type T11
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) as string
    declare operator cast( ) byref as zstring
end type
operator T11.cast( ) as string : print "<S>"; : return "s" : end operator
operator T11.cast( ) byref as zstring : print "<BZ>"; : return this.z : end operator
scope
    dim as T0 v0
    print "BZ:";
    if v0 then print " if:T"; else print " if:F";
    print " plus:"; v0 + 1;
    print " times:"; v0 * 2;
    print
end scope
scope
    dim as T1 v1
    print "BW:";
    if v1 then print " if:T"; else print " if:F";
    print " plus:"; v1 + 1;
    print " times:"; v1 * 2;
    print
end scope
scope
    dim as T2 v2
    print "BZ_BW:";
    if v2 then print " if:T"; else print " if:F";
    print " plus:"; v2 + 1;
    print " times:"; v2 * 2;
    print
end scope
scope
    dim as T3 v3
    print "BW_BZ:";
    if v3 then print " if:T"; else print " if:F";
    print " plus:"; v3 + 1;
    print " times:"; v3 * 2;
    print
end scope
scope
    dim as T4 v4
    print "ZP_BZ:";
    if v4 then print " if:T"; else print " if:F";
    print " plus:"; v4 + 1;
    print " times:"; v4 * 2;
    print
end scope
scope
    dim as T5 v5
    print "BZ_AP:";
    if v5 then print " if:T"; else print " if:F";
    print " plus:"; v5 + 1;
    print " times:"; v5 * 2;
    print
end scope
scope
    dim as T6 v6
    print "BW_L:";
    if v6 then print " if:T"; else print " if:F";
    print " plus:"; v6 + 1;
    print " times:"; v6 * 2;
    print
end scope
scope
    dim as T7 v7
    print "L_BW:";
    if v7 then print " if:T"; else print " if:F";
    print " plus:"; v7 + 1;
    print " times:"; v7 * 2;
    print
end scope
scope
    dim as T8 v8
    print "L_D:";
    if v8 then print " if:T"; else print " if:F";
    print " plus:"; v8 + 1;
    print " times:"; v8 * 2;
    print
end scope
scope
    dim as T9 v9
    print "D_L:";
    if v9 then print " if:T"; else print " if:F";
    print " plus:"; v9 + 1;
    print " times:"; v9 * 2;
    print
end scope
scope
    dim as T10 v10
    print "ZP_AP:";
    if v10 then print " if:T"; else print " if:F";
    print
end scope
scope
    dim as T11 v11
    print "S_BZ:";
    if v11 then print " if:T"; else print " if:F";
    print " plus:"; v11 + 1;
    print " times:"; v11 * 2;
    print
end scope
