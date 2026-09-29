'' std/outcome (RFC-0009): generic types and generic procedures through the facade, beside
'' fb/optional.bi included directly -- a outcome.Optional IS an FB.Optional.
#import "std/outcome"
#include once "fb/optional.bi"
private function ValueOf( byref o as FB.Optional( of long ) ) as long
    return o.ValueOr( -1 )
end function
dim as outcome.Optional( of long ) a = outcome.Some( of long )( 5 )
dim as outcome.Optional( of long ) b = outcome.None( of long )( )
print ValueOf( a ); ValueOf( b ); " "; a.HasValue( ); " "; b.HasValue( )
dim as outcome.Result( of long, string ) r = outcome.Ok( of long, string )( 7 )
print r.IsOk( ); " "; r.Value( )
