'' collinit.bas -- the AST side table for COLLECTION INITIALISERS (a tiko extension).
''
''     dim a as containers.Array( of integer ) = { 10, 20, 30 }
''
'' Resolve turns a brace list on a type that needs construction into one method call per
'' element -- symbols/collinit.bas has the rule -- gathers them in an N_BLOCK of their
'' own, and records here which block belongs to which declarator, so Check's tree walk
'' and lowering can reach statements no list in the tree holds. Triples of (item,
'' original N_INITIALIZER, block) in the shared child pool, scanned linearly: they are
'' rare.
''
'' Its own module because the AST's other side tables are defined in parser/expr.bas,
'' which sits at the 1500-line cap.

#import "std/containers"
#include once "ast/nodes.bi"

namespace Tko

sub RecordCollInit _
    ( byref ast as AstArena, byval item as NodeId, byval braces as NodeId, _
      byval block as NodeId )
    if item = NODE_NONE then return
    ast.collInit.Push( cast( ulong, item ) )
    ast.collInit.Push( cast( ulong, braces ) )
    ast.collInit.Push( cast( ulong, block ) )
end sub

'' NODE_NONE when 'item' is not a collection initialiser, which is the normal case. A
'' declarator with an empty '{ }' IS one, and its block is empty.
function CollInitOf( byref ast as AstArena, byval item as NodeId ) as NodeId
    if item = NODE_NONE then return NODE_NONE
    for i as long = ast.collInit.Count - 3 to 0 step -3
        if cast( NodeId, ast.collInit[i] ) = item then return cast( NodeId, ast.collInit[i + 2] )
    next
    return NODE_NONE
end function

end namespace
