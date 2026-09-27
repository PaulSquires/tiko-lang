'' Imports acme.core WITHOUT 'public': its importers do not reach core through it.
#module "plain"
#import "acme/core"
public function Label( ) as string
    return core.MakeTag( "p" ).s
end function
