'' std/chrono, a real module: types, a static member, a nested namespace and the tick
'' constants, qualified and through 'using'.
#import "std/chrono"
private function DayNo( byref d as chrono.LocalDate ) as long
    return d.DayNumber
end function
dim as chrono.LocalDate d = chrono.LocalDate( 2026, 9, 28 )
print d.Year; d.Month; d.Day; DayNo( d ) - DayNo( chrono.LocalDate( 2026, 9, 27 ) )
dim as chrono.TimeSpan t = chrono.TimeSpan.FromMinutes( 90 )
print t = chrono.TimeSpan( 1, 30, 0 ); " "; chrono.WallClock.Today( ).Year >= 2026
scope
    using chrono
    print DT_TICKS_PER_SECOND; " "; LocalDate( 2026, 10, 10 ).ToIsoString( )
end scope
