'' Three things that were each silently wrong.

'' 1. '@proc' HAD NO CASE, so it fell through to the ordinary variable path and got a
'' FRAME SLOT named after the procedure. 'p = @mysub' then stored the address of that
'' fresh stack slot and 'p()' called into stack garbage:
''
''     local void mysub          <-- a stack slot for a PROCEDURE
''     store @p, @mysub
''     call.ind void %6()
''
'' The VERIFIER WAVES THAT THROUGH, because the destination is a well-typed pointer --
'' it is the source that is nonsense.
sub mysub( )
end sub

dim p as sub( )
p = @mysub
p( )

'' 2. 'operator = ( a, b ) as T' is a DEFINITION. It was being read as a result
'' assignment and rejected with 'expected )', and the recovery then left the
'' declarations after it untyped -- one wrong rejection producing verify failures
'' three lines away.
''
'' But a '(' alone does not decide it: inside an operator body 'operator = ( v + 1 )'
'' IS a result assignment of a parenthesised expression. What separates them is a
'' PARAMETER LIST -- AS, BYREF or BYVAL at paren depth one.
namespace nsx
    type mytype
        as integer value
        declare operator cast( ) as integer
    end type

    operator = ( byref a as mytype, byref b as mytype ) as string
        return "eq"
    end operator

    operator mytype.cast( ) as integer
        operator = ( value + 1 )
    end operator

    sub all_( )
        dim as mytype a = ( 1 ), b = ( 2 )
    end sub
end namespace

'' 3. 'var a = 1' as THE LAST SYMBOL IN THE TABLE stayed untyped: the inference pass
'' looped 'to Count( ) - 1' when Count already returns the last valid id, so it never
'' visited it. The same line with any declaration after it worked.
var lastOne = 1
