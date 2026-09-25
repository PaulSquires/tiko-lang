'' LEN / SIZEOF / TYPEOF over a leading 'NS.proc' with no 'proc' in view: fbc refuses all but
'' the last line, reading the name after 'NS.' unqualified -- 42 for each alone, 9 for 17 to
'' 19 after 16. The last line's 'NS.v' is a variable, which keeps its prefix: accepted.
namespace NS
    function F( ) as long
        return 1
    end function
    namespace In2
        function M( ) as short
            return 1
        end function
    end namespace
    dim as long v
end namespace

print len( NS.F( ) )
print sizeof( NS.F( ) + 1 )
dim as typeof( NS.F( ) ) q
print len( .NS.F( ) )
print len( NS.In2.M( ) )
print len( NS.v )
