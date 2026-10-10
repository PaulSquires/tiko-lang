'' std/strings, a real module: Split's Array -- std/containers' -- Repeat's count first.
#import "std/strings"
#import "std/containers"
private function PartCount( byref a as containers.Array( of string ) ) as long
    return a.Count( )
end function
dim as containers.Array( of string ) parts = strings.Split( "a,b,c" )
print PartCount( parts ); strings.Tally( "a,b,c", "," ); " "; strings.PadLeft( "7", 3, "0" ); " "; strings.Repeat( 2, "xy" )
print strings.Replace( "Paul Squires", "P", "Z" ); " "; strings.Reverse( "tiko" ); " "; strings.StartsWith( "Tiko", "ti", true )
