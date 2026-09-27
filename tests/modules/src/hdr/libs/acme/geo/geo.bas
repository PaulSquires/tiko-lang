'' A module whose public declarations name a classic header's types.
#module "geo"
#include once "windows.bi"
public function Area( byref r as RECT ) as long
    return (r.right - r.left) * (r.bottom - r.top)
end function
public function Handle0( ) as HWND
    return 0
end function
