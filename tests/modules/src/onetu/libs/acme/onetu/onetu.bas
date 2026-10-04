'' A module that keeps a one-unit header to itself: nothing public names it.
#module "onetu"
#include once "one.bi"
private dim shared as Counter c
public function Twice( ) as long
    c.Bump( )
    return c.Bump( )
end function
