'' visibility.bas -- 'private:' AND 'protected:' INSIDE A TYPE.
''
'' fbc error 202, "Illegal member access". A PRIVATE member may be named only from inside
'' its own type's procedures; a PROTECTED one from those and from a DERIVED type's.
''
'' A PASS OF ITS OWN, after Check, and that is the whole reason it exists at all. The
'' question needs two things at once: WHICH MEMBER -- which only Check knows, because a
'' field means nothing until its base has a type -- and WHICH PROCEDURE ENCLOSES THE USE,
'' which Check does not track and Resolve cannot answer for a field. Walking the tree once
'' more, carrying the enclosing procedure down, gets both.
''
'' A DEFINITION CARRIES NO VISIBILITY. 'sub T.f( )' is written outside the type body, so
'' only the DECLARE inside it records 'private'. That is why Collect ORs the flag onto the
'' symbol rather than assigning it: the definition would otherwise clear what the
'' declaration said.
''
'' NOT SYMF_PRIVATE, which is module linkage and an unrelated question: a private MODULE
'' procedure is visible to its whole file, and a private MEMBER only inside its own type.

#include once "symbols/visibility.bi"
#include once "diag/diagids.bi"

namespace Tko.Vis

type Ctx
    as AstArena ptr         ast
    as SymbolTable ptr      syms
    as TypeContext ptr      types
    as Interner ptr         names
    as DiagnosticEngine ptr diags
    as SemanticInfo ptr     info
    as InternId             baseName
end type

'' The TYPE a symbol was declared in, or TYPE_NONE. A member's scope is the type's own.
private function OwningType_ _
    ( byref c as Ctx, byval s as Symbol ptr ) as TypeId

    if s = 0 then return TYPE_NONE
    dim as SymScope ptr sc = c.syms->ScopeAt( s->parent )
    if sc = 0 then return TYPE_NONE
    if sc->kind <> cast( ubyte, SCOPEK_TYPE ) then return TYPE_NONE
    dim as Symbol ptr owner = c.syms->SymbolAt( sc->owner )
    if owner = 0 then return TYPE_NONE
    if owner->kind <> cast( ubyte, SYM_UDT ) then return TYPE_NONE
    return owner->type_
end function

'' 'extends' is a FIELD NAMED 'base' at offset 0 -- the same fact vtable.bas leans on --
'' so the base type is that field's type.
private function BaseOf_ ( byref c as Ctx, byval t as TypeId ) as TypeId
    if t = TYPE_NONE then return TYPE_NONE
    if c.types->Kind( t ) <> TK_UDT then return TYPE_NONE
    dim as InternId tn = c.types->NameOf( t )
    if tn = 0 then return TYPE_NONE
    dim as ScopeId ds = cast( ScopeId, c.types->DeclScopeOf( t ) )
    dim as SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    dim as Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return TYPE_NONE
    if s->inner = SCOPE_NONE then return TYPE_NONE
    dim as SymbolId bf = c.syms->LookupLocal( s->inner, c.baseName )
    if bf = SYMBOL_NONE then return TYPE_NONE
    dim as Symbol ptr b = c.syms->SymbolAt( bf )
    if b = 0 then return TYPE_NONE
    if b->kind <> cast( ubyte, SYM_FIELD ) then return TYPE_NONE
    return b->type_
end function

private function DerivesFrom_ _
    ( byref c as Ctx, byval derived as TypeId, byval base_ as TypeId ) as boolean

    dim as TypeId cur = derived
    dim as long guard = 0
    while (cur <> TYPE_NONE) andalso (guard < 64)
        guard += 1
        if cur = base_ then return true
        cur = BaseOf_( c, cur )
    wend
    return false
end function

'' The type whose procedures this node sits inside, or TYPE_NONE at module level.
private function ProcOwner_ ( byref c as Ctx, byval id as NodeId ) as TypeId
    dim as SymbolId psid = c.info->RefOf( id )
    if psid = SYMBOL_NONE then return TYPE_NONE
    return OwningType_( c, c.syms->SymbolAt( psid ) )
end function

private sub CheckMember_ _
    ( byref c as Ctx, byval id as NodeId, byval here as TypeId )

    dim as SymbolId sid = c.info->RefOf( id )
    if sid = SYMBOL_NONE then return
    dim as Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return
    dim as boolean isPriv = ((s->flags and SYMF_MEMB_PRIVATE) <> 0)
    dim as boolean isProt = ((s->flags and SYMF_MEMB_PROTECTED) <> 0)
    if (isPriv = false) andalso (isProt = false) then return

    dim as TypeId owner = OwningType_( c, s )
    if owner = TYPE_NONE then return
    '' UNKNOWN CONTEXT IS NOT AN ERROR. If the enclosing procedure could not be resolved
    '' to a type, saying nothing is the honest answer: the alternative refuses legal code
    '' on a lookup this pass got wrong.
    if here = TYPE_NONE then
        c.diags->Report( TKO0625, PointRange( c.ast->Loc( id ) ), _
                         c.names->Spelling( s->name ) )
        return
    end if
    if isPriv then
        if here <> owner then
            c.diags->Report( TKO0625, PointRange( c.ast->Loc( id ) ), _
                             c.names->Spelling( s->name ) )
        end if
        return
    end if
    '' PROTECTED reaches down the derivation chain and no further.
    if DerivesFrom_( c, here, owner ) = false then
        c.diags->Report( TKO0625, PointRange( c.ast->Loc( id ) ), _
                         c.names->Spelling( s->name ) )
    end if
end sub

private sub Walk_ ( byref c as Ctx, byval id as NodeId, byval here as TypeId )
    if id = NODE_NONE then return
    dim as NodeKind k = c.ast->Kind( id )
    dim as TypeId inner = here
    if k = N_PROC then inner = ProcOwner_( c, id )
    if k = N_MEMBER then CheckMember_( c, id, here )

    '' EVERY SHAPE OF CHILD LIST, because a member access hides under all of them. The
    '' arena stores three, and a walk that knew only about statements missed every
    '' expression -- which is where member accesses actually live.
    select case NodeKindCategory( k )
    case NCAT_EXPR
        select case k
        case N_BINARY
            dim as BinaryPayload ptr bp = _
                @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
            Walk_( c, bp->lhs, inner )
            Walk_( c, bp->rhs, inner )
            return
        case N_MEMBER
            dim as BinaryPayload ptr mp = _
                @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
            '' ONLY THE BASE. The right-hand side is the member NAME, and Check bound it
            '' to the same symbol -- walking it would report the same access twice.
            Walk_( c, mp->lhs, inner )
            return
        case N_UNARY, N_ADDROF, N_DEREF
            dim as UnaryPayload ptr up = _
                @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
            Walk_( c, up->operand, inner )
            return
        '' THE LIST KINDS, SPELLED OUT. 'data' is an index into ONE OF FOUR POOLS and
        '' the node kind is the only thing that says which -- the payload-pool mistake
        '' this codebase has now made eight times. Reading a CAST or a SIZEOF as a list
        '' indexed the list pool with a unary's offset and took the compiler down with
        '' an access violation, in 23 tests at once.
        case N_CALL, N_INDEX, N_PAREN, N_TUPLE, N_INITIALIZER, N_STRCAT
            dim as ListPayload ptr lp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
            Walk_( c, lp->target, inner )
            for i as long = 0 to lp->count - 1
                Walk_( c, cast( NodeId, c.ast->children[lp->first + i] ), inner )
            next
            return
        case else
            '' EVERYTHING ELSE STOPS HERE -- a literal, an identifier, and also 'new T',
            '' a closure and the intrinsic-shaped expressions. Guessing which pool one of
            '' those indexes is how the crash above happened, and a member access inside
            '' a 'new' going unchecked is a miss rather than a wrong answer.
            return
        end select
    case NCAT_TYPE
        return
    end select

    if (k = N_MODULE) orelse (k = N_BLOCK) then
        dim as ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        for i as long = 0 to lp->count - 1
            Walk_( c, cast( NodeId, c.ast->children[lp->first + i] ), inner )
        next
        return
    end if

    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    Walk_( c, sp->a, inner )
    Walk_( c, sp->b, inner )
    Walk_( c, sp->c, inner )
    for i as long = 0 to sp->count - 1
        Walk_( c, cast( NodeId, c.ast->children[sp->first + i] ), inner )
    next
end sub

sub Run _
    ( byref ast as AstArena, byval root as NodeId, byref syms as SymbolTable, _
      byref types as TypeContext, byref names as Interner, _
      byref diags as DiagnosticEngine, byref info as SemanticInfo )

    dim as Ctx c
    c.ast = @ast
    c.syms = @syms
    c.types = @types
    c.names = @names
    c.diags = @diags
    c.info = @info
    c.baseName = names.GetString( "base" )
    Walk_( c, root, TYPE_NONE )
end sub

end namespace
