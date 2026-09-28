'' std/strings (RFC-0009): the facade over fb/string.bi -- Split's Array, Repeat's count
'' first -- and std/strings' own generic Surround, beside the header included directly.
#import "std/strings"
#include once "fb/string.bi"
private function PartCount( byref a as FB.Array( of string ) ) as long
    return a.Count( )
end function
dim as FB.Array( of string ) parts = strings.Split( "a,b,c" )
print PartCount( parts ); strings.Tally( "a,b,c", "," ); " "; strings.PadLeft( "7", 3, "0" ); " "; strings.Repeat( 2, "xy" )
print strings.Replace( "Paul Squires", "P", "Z" ); " "; strings.Surround( 7, "(", ")" ); " "; strings.StartsWith( "Tiko", "ti", true )
