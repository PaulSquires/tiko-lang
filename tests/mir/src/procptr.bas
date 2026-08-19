declare sub F cdecl ( byval x as long )
declare sub G( byval p as sub cdecl ( byval x as long ) )
sub F cdecl ( byval x as long ) : end sub
G( procptr( F ) )
