'' A module exporting two macros: a one-line one calling a module-private helper, and a
'' '#macro' block.
#module "chk"
function Fail_( byref what as string ) as long
    print "failed: " & what
    return 1
end function
#define CHECK( x ) if ( x ) = 0 then Fail_( #x )
#macro TWICE( s )
    print s
    print s
#endmacro
#export CHECK, TWICE
public function Answer( ) as long
    return 42
end function
