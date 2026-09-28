'' std/tui (RFC-0009): types, procedures, an enum member and the public trailing-'_' names
'' through the facade, beside fb/tui.bi included directly -- a tui.TuiRect IS an FB.TuiRect.
'' Nothing here touches the terminal.
#import "std/tui"
#include once "fb/tui.bi"
private function Area( byref r as FB.TuiRect ) as long
    return r.w * r.h
end function
dim as tui.TuiRect r = tui.TuiRectOf( 1, 2, 3, 4 )
dim as tui.TuiConstraint k = tui.TuiMin_( 5 )
dim as tui.TuiColor col = tui.TuiRgb( 1, 2, 3 )
print Area( r ); tui.TuiStringWidth( "abc" ); " "; tui.TUIKEY_END_ = FB.TuiKeyCode.TUIKEY_END_
