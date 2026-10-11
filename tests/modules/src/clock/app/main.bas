'' modcache-clock's root. The call goes through a local: inside len( ), 'stamp.BuiltAt'
'' would be looked up unqualified, as fbc does (see diagnostics/len-ns-call).
#import "acme/stamp"
#import "acme/plain"
dim as string t = stamp.BuiltAt( )
print len( t ); plain.Two( )
