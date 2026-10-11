'' name-arity's source: the FUNCTION form of NAME takes exactly two arguments.
'' Measured on fbc-modern 1.20, 2026-10-11: none is error 9, one is 16, three is 7.
'' tiko had no rule for it, and each line below was TKO0994, an internal compiler error.
namespace stamp
    function Name( ) as string
        return "hello"
    end function
end namespace
dim as long r
r = Name( )
r = Name( "a.txt" )
r = Name( "a", "b", "c" )
print len( stamp.Name( ) )
r = Name( "nofile.txt", "b.txt" )
