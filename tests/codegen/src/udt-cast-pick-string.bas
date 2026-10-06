'' Which 'operator cast' a string context calls: fbc scores each against the context's target
'' (STRING for print / '&' / string assignment and argument; USTRING or WSTRING for such a
'' destination fed directly) and takes the best, whatever the declaration order.
sub takeStr( byval s as string ) : end sub
type T0
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) byref as zstring
    declare operator cast( ) as string
end type
operator T0.cast( ) byref as zstring : print "<BZ>"; : return this.z : end operator
operator T0.cast( ) as string : print "<S>"; : return "s" : end operator
type T1
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) as string
    declare operator cast( ) byref as zstring
end type
operator T1.cast( ) as string : print "<S>"; : return "s" : end operator
operator T1.cast( ) byref as zstring : print "<BZ>"; : return this.z : end operator
type T2
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) as ustring
    declare operator cast( ) as string
end type
operator T2.cast( ) as ustring : print "<U>"; : return "u" : end operator
operator T2.cast( ) as string : print "<S>"; : return "s" : end operator
type T3
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) as ustring
    declare operator cast( ) byref as zstring
end type
operator T3.cast( ) as ustring : print "<U>"; : return "u" : end operator
operator T3.cast( ) byref as zstring : print "<BZ>"; : return this.z : end operator
type T4
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) byref as zstring
    declare operator cast( ) as ustring
end type
operator T4.cast( ) byref as zstring : print "<BZ>"; : return this.z : end operator
operator T4.cast( ) as ustring : print "<U>"; : return "u" : end operator
type T5
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) as string
    declare operator cast( ) byref as wstring
end type
operator T5.cast( ) as string : print "<S>"; : return "s" : end operator
operator T5.cast( ) byref as wstring : print "<BW>"; : return this.w : end operator
type T6
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) byref as wstring
    declare operator cast( ) as string
end type
operator T6.cast( ) byref as wstring : print "<BW>"; : return this.w : end operator
operator T6.cast( ) as string : print "<S>"; : return "s" : end operator
type T7
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) as ustring
    declare operator cast( ) byref as wstring
end type
operator T7.cast( ) as ustring : print "<U>"; : return "u" : end operator
operator T7.cast( ) byref as wstring : print "<BW>"; : return this.w : end operator
type T8
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) byref as wstring
    declare operator cast( ) as ustring
end type
operator T8.cast( ) byref as wstring : print "<BW>"; : return this.w : end operator
operator T8.cast( ) as ustring : print "<U>"; : return "u" : end operator
type T9
    z as zstring * 4 = "z"
    w as wstring * 4 = wstr( "w" )
    declare operator cast( ) as string
    declare operator cast( ) as ustring
end type
operator T9.cast( ) as string : print "<S>"; : return "s" : end operator
operator T9.cast( ) as ustring : print "<U>"; : return "u" : end operator
scope
    dim as T0 v0
    print "BZ_S:";
    print " p:"; v0
    dim as string a : a = v0 : print " a:"; a
    dim as string i = v0 : print " i:"; i
    print " f:"; : takeStr( v0 )
    dim as string c = "x" & v0 : print " c:"; c
    dim as wstring * 20 cw = v0 & wstr( "x" ) : print " cw"
    dim as ustring us = v0 : print " us:"; us
    dim as wstring * 20 ws = v0 : print " ws"
end scope
scope
    dim as T1 v1
    print "S_BZ:";
    print " p:"; v1
    dim as string a : a = v1 : print " a:"; a
    dim as string i = v1 : print " i:"; i
    print " f:"; : takeStr( v1 )
    dim as string c = "x" & v1 : print " c:"; c
    dim as wstring * 20 cw = v1 & wstr( "x" ) : print " cw"
    dim as ustring us = v1 : print " us:"; us
    dim as wstring * 20 ws = v1 : print " ws"
end scope
scope
    dim as T2 v2
    print "U_S:";
    print " p:"; v2
    dim as string a : a = v2 : print " a:"; a
    dim as string i = v2 : print " i:"; i
    print " f:"; : takeStr( v2 )
    dim as string c = "x" & v2 : print " c:"; c
    dim as wstring * 20 cw = v2 & wstr( "x" ) : print " cw"
    dim as ustring us = v2 : print " us:"; us
    dim as wstring * 20 ws = v2 : print " ws"
end scope
scope
    dim as T3 v3
    print "U_BZ:";
    print " p:"; v3
    dim as string a : a = v3 : print " a:"; a
    dim as string i = v3 : print " i:"; i
    print " f:"; : takeStr( v3 )
    dim as string c = "x" & v3 : print " c:"; c
    dim as wstring * 20 cw = v3 & wstr( "x" ) : print " cw"
    dim as ustring us = v3 : print " us:"; us
    dim as wstring * 20 ws = v3 : print " ws"
end scope
scope
    dim as T4 v4
    print "BZ_U:";
    print " p:"; v4
    dim as string a : a = v4 : print " a:"; a
    dim as string i = v4 : print " i:"; i
    print " f:"; : takeStr( v4 )
    dim as string c = "x" & v4 : print " c:"; c
    dim as wstring * 20 cw = v4 & wstr( "x" ) : print " cw"
    dim as ustring us = v4 : print " us:"; us
    dim as wstring * 20 ws = v4 : print " ws"
end scope
scope
    dim as T5 v5
    print "S_BW:";
    print " p:"; v5
    dim as string a : a = v5 : print " a:"; a
    dim as string i = v5 : print " i:"; i
    print " f:"; : takeStr( v5 )
    dim as string c = "x" & v5 : print " c:"; c
    dim as wstring * 20 cw = v5 & wstr( "x" ) : print " cw"
    dim as ustring us = v5 : print " us:"; us
    dim as wstring * 20 ws = v5 : print " ws"
end scope
scope
    dim as T6 v6
    print "BW_S:";
    print " p:"; v6
    dim as string a : a = v6 : print " a:"; a
    dim as string i = v6 : print " i:"; i
    print " f:"; : takeStr( v6 )
    dim as string c = "x" & v6 : print " c:"; c
    dim as wstring * 20 cw = v6 & wstr( "x" ) : print " cw"
    dim as ustring us = v6 : print " us:"; us
    dim as wstring * 20 ws = v6 : print " ws"
end scope
scope
    dim as T7 v7
    print "U_BW:";
    print " p:"; v7
    dim as string a : a = v7 : print " a:"; a
    dim as string i = v7 : print " i:"; i
    print " f:"; : takeStr( v7 )
    dim as string c = "x" & v7 : print " c:"; c
    dim as wstring * 20 cw = v7 & wstr( "x" ) : print " cw"
    dim as ustring us = v7 : print " us:"; us
    dim as wstring * 20 ws = v7 : print " ws"
end scope
scope
    dim as T8 v8
    print "BW_U:";
    print " p:"; v8
    dim as string a : a = v8 : print " a:"; a
    dim as string i = v8 : print " i:"; i
    print " f:"; : takeStr( v8 )
    dim as string c = "x" & v8 : print " c:"; c
    dim as wstring * 20 cw = v8 & wstr( "x" ) : print " cw"
    dim as ustring us = v8 : print " us:"; us
    dim as wstring * 20 ws = v8 : print " ws"
end scope
scope
    dim as T9 v9
    print "S_U:";
    print " p:"; v9
    dim as string a : a = v9 : print " a:"; a
    dim as string i = v9 : print " i:"; i
    print " f:"; : takeStr( v9 )
    dim as string c = "x" & v9 : print " c:"; c
    dim as wstring * 20 cw = v9 & wstr( "x" ) : print " cw"
    dim as ustring us = v9 : print " us:"; us
    dim as wstring * 20 ws = v9 : print " ws"
end scope
