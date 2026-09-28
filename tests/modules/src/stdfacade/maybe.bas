'' std/maybe (RFC-0009): generic types and generic procedures through the facade, beside
'' fb/optional.bi included directly -- a maybe.Optional IS an FB.Optional.
#import "std/maybe"
#include once "fb/optional.bi"
private function ValueOf( byref o as FB.Optional( of long ) ) as long
    return o.ValueOr( -1 )
end function
dim as maybe.Optional( of long ) a = maybe.Some( of long )( 5 )
dim as maybe.Optional( of long ) b = maybe.None( of long )( )
print ValueOf( a ); ValueOf( b ); " "; a.HasValue( ); " "; b.HasValue( )
dim as maybe.Result( of long, string ) r = maybe.Ok( of long, string )( 7 )
print r.IsOk( ); " "; r.Value( )
