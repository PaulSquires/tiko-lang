'' len-ns-call's source: 'len( NS.F( ) )' looks F up UNQUALIFIED, as fbc does (its error 42),
'' because a qualified name inside len may begin a type. The note says so; parentheses
'' make it an expression, and that line compiles.
namespace stamp
    function Greet( ) as string
        return "hello"
    end function
end namespace
print len( stamp.Greet( ) )
print len( (stamp.Greet( )) )
