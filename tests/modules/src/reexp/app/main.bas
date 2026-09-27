'' Imports only acme.web, and reaches acme.core through it.
#import "acme/web"
dim as web.core.Tag t = web.core.MakeTag( "x" )
print web.Wrap( t )
