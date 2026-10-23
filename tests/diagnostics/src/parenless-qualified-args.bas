'' A QUALIFIED procedure with a required parameter named WITHOUT PARENTHESES -- fbc's
'' error 1, "Argument count mismatch", on lines 38 to 43 (fbc-modern 1.20). Lines 45 to
'' 51 are accepted: a defaulted parameter, a statement call that passes the argument, the
'' overload that needs none, a call, and the name addressed rather than read.
namespace ns
    function f( byval n as long ) as long
        return n
    end function
    function g( byval n as long = 5 ) as long
        return n
    end function
    sub s( byval n as long )
        print n
    end sub
    function h overload ( byval n as long ) as long
        return 1
    end function
    function h( ) as long
        return 2
    end function
end namespace
type T
    dim as long x
    declare function m( byval n as long ) as long
    declare static function sm( byval n as long ) as long
    declare function d( byval n as long = 7 ) as long
end type
function T.m( byval n as long ) as long
    return n
end function
function T.sm( byval n as long ) as long
    return n
end function
function T.d( byval n as long = 7 ) as long
    return n
end function
dim as T t1
print ns.f
dim as long y = ns.f + 1
ns.s
print t1.m
print T.sm
print ns.f; T.sm

print ns.g
ns.s 5
print ns.h
print t1.d
print ns.f( 3 ); t1.m( 4 ); T.sm( 5 )
dim as any ptr p = @ns.f
