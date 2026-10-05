'' AN ASSIGNMENT IS NOT A CONSTRUCTION. Measured on fbc-modern: T is built from S through S's
'' string cast in an initialiser (line 21), but 'q = s1' (22) and 'function = sv' (18) are
'' error 181 -- only a 'let' or a cast rescues an assignment; 'return sv' (16) is fine.
type S
    as long k
    declare operator cast( ) as string
end type
operator S.cast( ) as string : return str( k ) : end operator
type T
    as double v
    declare constructor( )
    declare constructor( byref x as string )
end type
constructor T( ) : end constructor
constructor T( byref x as string ) : v = val( x ) : end constructor
function mk( byref sv as S ) as T : return sv : end function
function mk2( byref sv as S ) as T
    function = sv
end function
dim as S s1
dim as T q = s1
q = s1
