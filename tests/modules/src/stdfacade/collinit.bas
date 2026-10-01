'' std/containers with collection initialisers -- the spelling the feature was asked for.
#import "std/containers"

dim b as containers.Array( of integer ) = { 10, 20, 30 }
dim l as containers.LinkedList( of ustring ) = { "x", "y" }
dim m as containers.Map( of ustring, integer ) = { {"a", 1}, {"b", 2} }
print b.Count( ); b[0]; b[2]; l.Count( ); m.Count( ); m["b"]
