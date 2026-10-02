#module "rep"
#import "../util"
public function A( ) as long
    dim p as util.Pair
    p.a = 2
    return util.Twice( 1 ) + B( p )
end function
