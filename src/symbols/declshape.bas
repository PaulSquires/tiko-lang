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

'' TWO MORE A VARIABLE'S TYPE MAY NOT BE, measured the same day:
''
''     dim x as any  /  static x as any  /  dim as any a, b    error 24   (dim/dim-bad-datatype-1
''     dim byref x as any = ...                               error 24    writes one with an
''     dim x as any ptr                                       fine        alias "char")
''
''     type t as t : dim as t x                               error 24   (typedef/void)
''     type t as u : type u as t : dim as t x                 error 71
''     type t as t : dim as t ptr p                           fine
''
'' A typedef whose chain comes back to itself has no type at all; tiko gave the variable none
'' and said nothing.
private function TypedefCycles_ ( byref c as Ctx, byval tr as NodeId, byval scope_ as ScopeId ) as boolean
    dim as StmtPayload ptr tp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, tr )].data )]
    dim as SymbolId sid = c.info->RefOf( tr )
    if (sid = SYMBOL_NONE) andalso (tp->name <> 0) andalso (tp->ownerName = 0) then sid = c.syms->LookupTyped( scope_, tp->name, true )
    dim as FB.Array( of ulong ) seen
    for hop as long = 0 to 31
        dim as Symbol ptr sy = c.syms->SymbolAt( sid )
        if (sy = 0) orelse (sy->kind <> cast( ubyte, SYM_TYPEDEF )) then return false
        for s as long = 0 to seen.Count - 1
            if seen[s] = cast( ulong, sid ) then return true
        next
        seen.Push( cast( ulong, sid ) )
        dim as NodeId ta = cast( NodeId, sy->payload )
        if (ta = NODE_NONE) orelse (c.ast->Kind( ta ) <> N_TYPEREF) then return false
        if (c.ast->nodes[cast( long, ta )].flags and (NF_PTR or NF_ARRAY or NF_PROC_TYPE)) <> 0 then return false
        dim as StmtPayload ptr tap = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, ta )].data )]
        if (tap->ownerName <> 0) orelse (tap->count <> 0) orelse (tap->name = 0) then return false
        dim as SymbolId nsid = c.info->RefOf( ta )
        if nsid = SYMBOL_NONE then nsid = c.syms->LookupTyped( cast( ScopeId, sy->parent ), tap->name, true )
        sid = nsid
    next
    return false
end function

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
        '' A VARIABLE OF TYPE ANY, and one whose typedef is itself (see TypedefCycles_).
        if (ip->a <> NODE_NONE) andalso (c.ast->Kind( ip->a ) = N_TYPEREF) andalso (op <> KW_REDIM) then
            if (c.ast->nodes[cast( long, ip->a )].flags and (NF_PTR or NF_PROC_TYPE)) = 0 then
                if cast( TokenKind, c.ast->stmts[cast( long, c.ast->nodes[cast( long, ip->a )].data )].op ) = KW_ANY then
                    c.diags->Report( TKO0898, PointRange( c.ast->Loc( item ) ), nm )
                    continue for
                end if
                if TypedefCycles_( c, ip->a, c.info->ScopeOf( id ) ) then
                    c.diags->Report( TKO0899, PointRange( c.ast->Loc( item ) ), _
                                     c.names->Spelling( c.ast->stmts[cast( long, c.ast->nodes[cast( long, ip->a )].data )].name ) )
                    continue for
                end if
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

'' TWO THINGS A PROCEDURE MAY NOT SAY, measured on fbc-modern 1.20, 2026-09-29:
''
''     constructor T( ) : print "foo" : constructor( 5 )      error 169  (structs/ctor-chain-
''     ...after a 'dim', after another chain call, in an IF    error 169   not-first-1)
''     constructor T( ) : constructor( 5 ) : print "foo"      fine
''
''     operator ->( byref x as UDT ) as integer               error 141  (overload/op-fieldderef-
''     ...'as UDT ptr', 'as integer ptr'                      error 141   bad-result-type)
''     ...'as UDT', 'byref as UDT'                            fine
''
'' The chain call is an N_AMBIGUOUS over a call to the bare name 'constructor'. The '->'
'' result is judged only where it is WRITTEN a pointer or a builtin: fb/comptr.bi and
'' fb/sharedptr.bi define a generic 'byref as T', which fbc accepts for a scalar T until
'' the arrow is used. tiko accepted every refused line.
private sub CheckProcShape_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    select case cast( TokenKind, sp->op )
    case KW_CONSTRUCTOR
        if (sp->b = NODE_NONE) orelse (c.ast->Kind( sp->b ) <> N_BLOCK) then return
        dim as ListPayload ptr bp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, sp->b )].data )]
        dim as NodeId first_ = NODE_NONE
        if bp->count > 0 then first_ = cast( NodeId, c.ast->children[bp->first] )
        '' Every chain call inside the body: node ids run in source order, and the body's
        '' own nodes lie between the procedure's first parameter and the block.
        for i as long = cast( long, sp->b ) - 1 to 1 step -1
            dim as NodeKind nk = c.ast->Kind( cast( NodeId, i ) )
            if (nk = N_PROC) orelse (nk = N_TYPE) orelse (nk = N_MODULE) then exit for
            if nk <> N_AMBIGUOUS then continue for
            dim as NodeId ca = c.ast->stmts[cast( long, c.ast->nodes[i].data )].a
            if (ca = NODE_NONE) orelse (c.ast->Kind( ca ) <> N_CALL) then continue for
            dim as NodeId ct = c.ast->lists[cast( long, c.ast->nodes[cast( long, ca )].data )].target
            if (ct = NODE_NONE) orelse (c.ast->Kind( ct ) <> N_IDENT) then continue for
            if lcase( SpellOf_( c, ct ) ) <> "constructor" then continue for
            if cast( NodeId, i ) = first_ then continue for
            c.diags->Report( TKO0908, PointRange( c.ast->Loc( cast( NodeId, i ) ) ) )
        next
    case KW_OPERATOR
        if (sp->extra and PF_GENERIC_PROC) <> 0 then return
        if Text.LowerAscii( c.names->Spelling( sp->name ) ) <> "->" then return
        if ProcOwner_( c, id ) <> TYPE_NONE then return
        if (sp->a = NODE_NONE) orelse (c.ast->Kind( sp->a ) <> N_TYPEREF) then return
        dim as ushort rf = c.ast->nodes[cast( long, sp->a )].flags
        if (rf and NF_PROC_TYPE) <> 0 then return
        dim as boolean bad = ((rf and NF_PTR) <> 0)
        if bad = false then
            dim as TokenKind rk = cast( TokenKind, c.ast->stmts[cast( long, c.ast->nodes[cast( long, sp->a )].data )].op )
            bad = IsTypeKeyword( rk ) andalso (rk <> KW_CONST)
        end if
        if bad then c.diags->Report( TKO0909, PointRange( c.ast->Loc( id ) ) )
    end select
end sub
