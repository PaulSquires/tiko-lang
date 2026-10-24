'' std/tui, a real module: types, procedures, an enum member and the public trailing-'_'
'' names, qualified and through 'using'. Nothing here touches the terminal.
#import "std/tui"
private function Area( byref r as tui.TuiRect ) as long
    return r.w * r.h
end function
dim as tui.TuiRect r = tui.TuiRectOf( 1, 2, 3, 4 )
dim as tui.TuiConstraint k = tui.TuiAtLeast( 5 )
dim as tui.TuiColor col = tui.TuiRgb( 1, 2, 3 )
print Area( r ); tui.TuiStringWidth( "abc" ); " "; tui.TUIKEY_END = tui.TuiKeyCode.TUIKEY_END
scope
    using tui
    print TuiStringWidth( "ab" ); " "; TUI_UCD_VERSION
end scope
