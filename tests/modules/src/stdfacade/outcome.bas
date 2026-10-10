'' std/outcome, a real module: generic types and generic procedures, qualified and through
'' 'using'.
#import "std/outcome"
private function ValueOf( byref o as outcome.Optional( of long ) ) as long
    return o.ValueOr( -1 )
end function
dim as outcome.Optional( of long ) a = outcome.Some( of long )( 5 )
dim as outcome.Optional( of long ) b = outcome.None( of long )( )
print ValueOf( a ); ValueOf( b ); " "; a.HasValue( ); " "; b.HasValue( )
dim as outcome.Result( of long, string ) r = outcome.Ok( of long, string )( 7 )
print r.IsOk( ); " "; r.Value( )
scope
    using outcome
    dim as Result( of long, string ) f = Fail( of long, string )( "no" )
    print f.IsOk( ); " "; f.Failure( )
end scope
