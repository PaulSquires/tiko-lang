'' Four small frontend gaps that shared nothing but their size.
''
'' '__FUNCTION__' IS A STRING LITERAL, folded to the enclosing procedure's name. The
'' VALUE path knew that and every STRING path bypassed it, so 'print __FUNCTION__',
'' 'dim s as string = __FUNCTION__' and 'len( __FUNCTION__ )' all asked a predeclared
'' name for an address it has not got, and all three declined. Measured: fbc folds the
'' whole thing at compile time, and folds a concatenation containing one to a single
'' literal.
''
'' A CONVERSION INTRINSIC IS ITS OWN TYPE when a generic argument is inferred from it.
'' 'csng( x )' parses as a CALL over an identifier that has no symbol at all -- it is a
'' builtin -- so the ordinary-call lookup answered nothing and the type argument was
'' never inferred: 'Some( csng( dd ) )' declined while 'Some( cast( single, dd ) )' and
'' 'dim s as single = csng( dd ) : Some( s )' beside it both worked. 'csign' and 'cunsg'
'' are deliberately NOT included: their result depends on the operand's type, which that
'' pass runs too early to know.
''
'' A STRING LITERAL IS AN ADDRESS in a BYREF RESULT. 'function = "also good"' out of a
'' 'byref as zstring' is measured as the literal's own address with no temporary
'' anywhere, and the wide half is the same thing at a different width.
''
'' A NAMED TYPE'S IDENTITY INCLUDES THE SCOPE IT WAS DECLARED IN. Adding or stripping a
'' const re-found the type by NAME alone, so two sibling namespaces each declaring a
'' 'T1' made 'const B.T1 ptr' come back as 'const A.T1 ptr' -- and no argument matched
'' it. Declaration order decided which one won.
namespace nsA
    type T1 extends object
    end type
end namespace

namespace nsB
    type T1 extends object
    end type
    function pick overload( byval p as const T1 ptr ) as integer
        return 1
    end function
end namespace

function nameOf( ) as string
    return __FUNCTION__
end function

dim shared as integer gi = 123

function refZ( ) byref as zstring
    function = "also good"
end function

function refI( ) byref as integer
    function = gi
end function

sub s1( )
    dim as string t = __FUNCTION__
    print t, len( __FUNCTION__ ), __FUNCTION__
    print nameOf( )
    print refZ( ), refI( )
    dim as nsB.T1 x
    print nsB.pick( @x )
end sub

s1( )
