'' An importer naming what its modules export: through the alias, through 'as', through
'' 'using'; a function, a type from a module it also imports, a generic it instantiates, a
'' const, an enum, a namespace member and two shared variables.
#import "acme/net/http"
#import "acme/text/esc" as e
dim as e.Url u = http.Fetch( "a" )
print u.s
print http.HTTP_PORT
print http.Verb.POST_
print http.Inner.Ping( )
print str( http.hits ) & " " & str( e.calls )
dim as http.Box( of long ) b
b.v = 21
print b.Twice( )
using http
print Fetch( "bc" ).s & " " & str( e.calls )
