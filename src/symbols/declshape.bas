'' declshape.bas -- WHAT AN ARRAY OR CONST DECLARATION MAY NOT SAY, beyond CheckArrayDeclShapes_
'' (latesweeps.bas): CheckDeclShape_, asked of every N_VAR.
''
'' Included from latesweeps2.bas, below staticdef.bas, in the same namespace and over the same Ctx.
''
'' Measured on fbc-modern 1.20, 2026-09-29:
''
''     common array(0) as integer               error 136   COMMON's array is dynamic: no bounds
''     common array(0 to 3), common shared ...  error 136   (dim/common-with-subscript)
''     common array() / (any) as integer        fine        an EXTERN takes bounds, too
''
''     extern array(0 to ...) as integer        error 281   '...' needs an initializer to count
''     dim array(0 to ...) as integer           error 281   (dim/extern-array-init-3)
''     dim array(0 to ...) as integer = {1, 2}  fine
''
''     redim array(0 to ...) => { 1, 2 }        error 76    '...' on a DYNAMIC array
''     redim array(0 to ...) [as integer]       error 76    (dim/dynamic-ellipsis-2)
''
''     dim as const integer foo = any           error 237   a const needs a real value
''     static ... / foo(0 to 1) the same        error 237   (const/any_const)
''     dim as integer foo = any                 fine
''
'' tiko accepted each refused line.

'' Is this node the bare word 'any'.
private function IsAnyNode_ ( byref c as Ctx, byval n as NodeId ) as boolean
    if (n = NODE_NONE) orelse (c.ast->Kind( n ) <> N_IDENT) then return false
    return lcase( SpellOf_( c, n ) ) = "any"
end function

private sub CheckDeclShape_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as TokenKind op = cast( TokenKind, sp->op )
    for k as long = 0 to sp->count - 1
        dim as NodeId item = cast( NodeId, c.ast->children[sp->first + k] )
        if (item = NODE_NONE) orelse (c.ast->Kind( item ) <> N_VAR_ITEM) then continue for
        dim as StmtPayload ptr ip = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
        dim as string nm = c.names->Spelling( ip->name )
        '' THE BOUNDS: none, all 'any', or written -- and whether one is '...'.
        dim as boolean written = false, ell = false
        if (ip->c <> NODE_NONE) andalso (c.ast->Kind( ip->c ) = N_BLOCK) then
            dim as ListPayload ptr bl = @c.ast->lists[cast( long, c.ast->nodes[cast( long, ip->c )].data )]
            for b as long = 0 to bl->count - 1
                dim as NodeId bn = cast( NodeId, c.ast->children[bl->first + b] )
                if bn = NODE_NONE then continue for
                if IsAnyNode_( c, bn ) = false then written = true
                if c.ast->Kind( bn ) = N_ELLIPSIS then ell = true
                if c.ast->Kind( bn ) = N_CASE_RANGE then
                    '' A declaration's range is a STATEMENT payload, 'a' to 'b' (decl.bas).
                    dim as StmtPayload ptr rp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, bn )].data )]
                    if (rp->a <> NODE_NONE) andalso (c.ast->Kind( rp->a ) = N_ELLIPSIS) then ell = true
                    if (rp->b <> NODE_NONE) andalso (c.ast->Kind( rp->b ) = N_ELLIPSIS) then ell = true
                end if
            next
        end if
        if (op = KW_COMMON) andalso written then
            c.diags->Report( TKO0894, PointRange( c.ast->Loc( item ) ), nm )
            continue for
        end if
        if ell then
            if op = KW_REDIM then
                c.diags->Report( TKO0896, PointRange( c.ast->Loc( item ) ), nm )
                continue for
            end if
            if (ip->b = NODE_NONE) orelse (op = KW_EXTERN) then
                c.diags->Report( TKO0895, PointRange( c.ast->Loc( item ) ), nm )
                continue for
            end if
        end if
        '' '= any' OVER A CONST: the const is on the type reference the item was declared with.
        if (op <> KW_REDIM) andalso IsAnyNode_( c, ip->b ) andalso (ip->a <> NODE_NONE) then
            if (c.ast->nodes[cast( long, ip->a )].flags and NF_CONST) <> 0 then
                c.diags->Report( TKO0897, PointRange( c.ast->Loc( ip->b ) ), nm )
            end if
        end if
    next
end sub
