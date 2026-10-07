'' A typedef of a typedef the walk has not reached yet -- win/commctrl.bi's
'' 'type TOOLINFOW as TTTOOLINFOW' above 'type TTTOOLINFOW as tagTOOLINFOW'. The
'' parameter's type is known only after the backpatch; its body is walked before.
type BPTR as AREC
type AREC as CREC
type CREC
    as long x, y
end type

sub SetX( byval p as BPTR ptr, byval v as long )
    if v < 600 then p->x = 64 else p->x = 72
    p->y = v
end sub

function GetX( byval p as BPTR ptr ) as long
    return p->x + p->y
end function

dim as CREC r
SetX( @r, 700 )
print r.x; r.y; GetX( @r )
SetX( @r, 5 )
print r.x; r.y; GetX( @r )
