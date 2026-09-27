'' An importer naming what its modules export: through the alias, through 'as', through
'' 'using'; a function, a type from a module it also imports, a generic it instantiates, a
'' const, an enum, a namespace member, two shared variables and a public operator.
#import "acme/net/http"
#import "acme/text/esc" as e
'' An interface's names are not the importer's: 'defined( )' does not see them.
#ifdef Quote
#error "an interface name leaked into the importer's preprocessor"
#endif
dim as e.Url u = http.Fetch( "a" )
print u.s
print ( u + u ).s
print http.HTTP_PORT
print http.Verb.POST_
print http.Inner.Ping( )
print str( http.hits ) & " " & str( e.calls )
dim as http.Box( of long ) b
b.v = 21
print b.Twice( )
using http
print Fetch( "bc" ).s & " " & str( e.calls )
