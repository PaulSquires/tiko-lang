'' std/chrono (RFC-0009): types, a static member and a nested namespace through the facade,
'' beside fb/chrono.bi included directly -- a chrono.LocalDate IS an FB.LocalDate.
#import "std/chrono"
#include once "fb/chrono.bi"
private function DayNo( byref d as FB.LocalDate ) as long
    return d.DayNumber
end function
dim as chrono.LocalDate d = chrono.LocalDate( 2026, 9, 28 )
print d.Year; d.Month; d.Day; DayNo( d ) - DayNo( chrono.LocalDate( 2026, 9, 27 ) )
dim as chrono.TimeSpan t = chrono.TimeSpan.FromMinutes( 90 )
print t = chrono.TimeSpan( 1, 30, 0 ); " "; chrono.WallClock.Today( ).Year >= 2026
