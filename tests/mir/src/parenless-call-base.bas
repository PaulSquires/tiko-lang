type DT
    as longint ticks
    declare static function MaxValue( ) as DT
end type
function DT.MaxValue( ) as DT
    dim as DT r
    r.ticks = 5
    return r
end function
function mk( ) as DT
    dim as DT r
    r.ticks = 7
    return r
end function
print mk.ticks = 7
print mk( ).ticks = 7
print DT.MaxValue.Ticks = 5
dim as DT q = DT.MaxValue
print q.ticks
