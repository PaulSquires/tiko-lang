'' The bottom of the module-cache fixture: acme.middle imports it, main imports acme.middle.
#module "leaf"
#include once "../../../inc/leafcfg.bi"
public function Seed( ) as long
    return LEAF_BASE
end function
