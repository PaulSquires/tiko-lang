'' Re-exports acme.core: its importers need not import it themselves.
#module "web"
#import "acme/core" public
public function Wrap( byref t as core.Tag ) as string
    return "<" & t.s & ">"
end function
