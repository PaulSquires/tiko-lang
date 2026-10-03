'' The classic date functions keep a date as a double: whole days since
'' 30 December 1899, with the time of day as the fraction.
#include once "vbcompat.bi"

dim as double d = dateserial( 2025, 3, 4 ) + timeserial( 14, 30, 0 )
print "serial:"; d
print "parts:"; year( d ); month( d ); day( d ); hour( d ); minute( d )
print "weekday:"; weekday( d ); "  (1 = Sunday)"
print "formatted: "; format( d, "yyyy-mm-dd hh:nn:ss" )

'' Adding months clamps at the end of the month; differences in days.
dim as double jan31 = dateserial( 2025, 1, 31 )
dim as double feb = dateadd( "m", 1, jan31 )
print "Jan 31 + 1 month: "; format( feb, "yyyy-mm-dd" )
dim as double today = dateserial( 2025, 3, 4 )
dim as double xmas = dateserial( 2025, 12, 25 )
print "days to Christmas:"; datediff( "d", today, xmas )

'' DATE and TIME are the clock, as text: "mm-dd-yyyy" and "hh:mm:ss".
print "date is"; len( date ); " characters, time is"; len( time )
