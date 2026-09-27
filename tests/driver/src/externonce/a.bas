#include "t.bi"
dim shared made_ as long
constructor T( )
    made_ += 1
    s = "set" & made_
end constructor
destructor T( )
    print "dtor of " & s
end destructor
dim shared g as T
function Made( ) as long
    return made_
end function
declare sub show( )
show( )
