'' An importer that does not include windows.bi before its imports: the header geo's
'' interface names comes with it, its RECT is the importer's RECT, and reading it for
'' the import does not end the importer's header -- the next '#import' is still allowed.
'' Including it again afterwards is the same file, once.
#import "acme/geo"
#import "acme/tiny"
#include once "windows.bi"
dim as RECT r
r.left = 1 : r.top = 2 : r.right = 4 : r.bottom = 7
print geo.Area( r )
print geo.Handle0( ) = 0
print tiny.ANSWER
