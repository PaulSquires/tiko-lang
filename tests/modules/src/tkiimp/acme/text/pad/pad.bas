#module "pad"
#import "acme/config"
public function Cell( byval s as string ) as string
    return left( s & space( config.Columns( ) ), config.Columns( ) )
end function
