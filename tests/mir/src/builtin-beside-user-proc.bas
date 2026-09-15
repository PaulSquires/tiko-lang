'' A PROCEDURE OF THE PROGRAM'S OWN, SPELLED LIKE A BUILTIN THAT IS NOT A KEYWORD: which runs.
'' The rule was limited to keyword spellings (and LEFT/RIGHT), so a user 'hex overload' made
'' '..hex( 255 )' a false TKO0698. Where the procedure is declared decides it, measured:
''
''   GLOBAL overload       joins the builtin's set; an EXACT argument match is the user's
''   ENCLOSING namespace   the procedure, always (also a member, and a nested namespace)
''   imported by USING     the builtin, always
''
'' fbc prints:
''   FF user:q user:q userdbl FF userU userU 10
''    42 99 42 99
''   userint 10
''   [  ]nsspace nsleft a nshex FF
''   nshex nsspace
''   nshex nsleft
''   [  ]Q[ ]
''   memberhex memberspace| |FF
type U
    as long v
end type
function hex overload ( byref s as string ) as string
    return "user:" & s
end function
function hex overload ( byval d as double ) as string
    return "userdbl"
end function
function hex overload ( byref u as U ) as string
    return "userU"
end function
function val overload ( byval n as long ) as double
    return 99
end function
function oct overload ( byval n as integer ) as string
    return "userint"
end function

namespace N
    function space( byval n as long ) as string
        return "nsspace"
    end function
    function left( byval s as string, byval n as long ) as string
        return "nsleft"
    end function
    function hex( byval n as long ) as string
        return "nshex"
    end function
    sub T( )
        print "[" & ..space( 2 ) & "]"; space( 1 ); " "; left( "abc", 1 ); " "; ..left( "abc", 1 ); " "; hex( 255 ); " "; ..hex( 255 )
    end sub
    namespace M
        sub T2( )
            print hex( 255 ); " "; space( 3 )
        end sub
    end namespace
    declare sub T3( )
end namespace
sub N.T3( )
    print hex( 255 ); " "; left( "xyz", 2 )
end sub

namespace NsUse
    function space( byval n as long ) as string
        return "ispace"
    end function
    function ucase( byval s as string ) as string
        return "iucase"
    end function
end namespace

type T
    as long v
    declare function hex( byval n as long ) as string
    declare function space( byval n as long ) as string
    declare sub Go( )
end type
function T.hex( byval n as long ) as string
    return "memberhex"
end function
function T.space( byval n as long ) as string
    return "memberspace"
end function
sub T.Go( )
    print hex( 255 ); " "; space( 1 ); "|"; ..space( 1 ); "|"; ..hex( 255 )
end sub

dim as U x
dim as double d = 1.5
dim as integer k = 8
print ..hex( 255 ); " "; ..hex( "q" ); " "; hex( "q" ); " "; hex( d ); " "; hex( 255 ); " "; hex( x ); " "; ..hex( x ); " "; ..hex( 16 )
print val( "42" ); val( 7 ); ..val( "42" ); ..val( 7 )
print oct( k ); " "; oct( cbyte( 8 ) )
N.T( )
N.M.T2( )
N.T3( )
using NsUse
print "["; space( 2 ); "]"; ucase( "q" ); "["; ..space( 1 ); "]"
dim as T tt
tt.Go( )
