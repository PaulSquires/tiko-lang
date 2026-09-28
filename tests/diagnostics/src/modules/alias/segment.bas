'' A path segment written where the alias belongs: 'net' is not bound by the first
'' import, and 'esc' is not by the second, which is bound as 'e'.
#import "acme/net/http"
#import "acme/text/esc" as e
print net.HTTP_PORT
print esc.calls
print zz
