'' modcache-clock's root. The call goes through a local: len( stamp.BuiltAt( ) ) is TKO0743,
'' a separate bug in len( ) over a module-qualified call.
#import "acme/stamp"
#import "acme/plain"
dim as string t = stamp.BuiltAt( )
print len( t ); plain.Two( )
