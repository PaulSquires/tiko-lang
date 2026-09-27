#module "middle"
#import "acme/leaf"
public function Twice( ) as long
    return leaf.Seed( ) * 2
end function
