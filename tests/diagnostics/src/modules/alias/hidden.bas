'' Names the interface does not call 'public': qualified, and through 'using'.
#import "acme/net/http"
dim as long n = http.Add_( 1, 2 )
using http
print Add_( 3, 4 )
