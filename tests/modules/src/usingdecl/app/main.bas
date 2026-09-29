#import "acme/top"
#import "acme/shapes"
dim as top.Holder h
h.b.v = 1
h.t.n = 2
dim as shapes.Box x = top.Make( 4 )
print h.Sum( x )
print shapes.GREEN; shapes.Colour.RED
