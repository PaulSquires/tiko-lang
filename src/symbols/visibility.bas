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

'' '.' AND '->' ARE NOT INTERCHANGEABLE. Measured, over 'x as UDT', 'p as UDT ptr' and
'' 'pp as UDT ptr ptr':
''
''     x.i        OK        p.i        error 265   a DOT through a pointer
''     p->i       OK        x->i       error 28    an ARROW through a value
''     (*p).i     OK        pp->i      error 24    the pointee is not a UDT
''     (*pp)->i   OK        (*pp).i    error 265
''
'' 'this' IS EXEMPT FROM THE DOT RULE. tiko-lang types it as a POINTER because that is
'' what the ABI passes -- fbc's own C spells the receiver 'struct $1T*' -- so 'this.i'
'' looks exactly like a dot through a pointer and is the commonest line in any method.
''
'' AN ARROW THROUGH A UDT IS NOT REPORTED, only through a builtin: a type may overload
'' 'operator ->', and that question is not measured here.
private function IsThisBase_ ( byref c as Ctx, byval n as NodeId ) as boolean
    if n = NODE_NONE then return false
    if c.ast->Kind( n ) <> N_IDENT then return false
    dim as InternId nm = _
        c.ast->idents[cast( long, c.ast->nodes[cast( long, n )].data )].name
    return c.names->Fold( nm ) = c.names->Fold( c.names->GetString( "this" ) )
end function

private sub CheckDeref_ ( byref c as Ctx, byval id as NodeId )
    dim as BinaryPayload ptr mp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as TokenKind op = cast( TokenKind, mp->op )
    if (op <> TK_DOT) andalso (op <> TK_ARROW) then return
    if mp->lhs = NODE_NONE then return
    dim as TypeId bt = c.info->TypeOf_( mp->lhs )
    '' UNTYPED IS NOT AN ERROR: a namespace-qualified name has no type at all, and an
    '' expression that declined earlier would be blamed for someone else's mistake.
    if bt = TYPE_NONE then return
    dim as TypeId u = c.types->Unqualify( bt )
    dim as boolean isPtr = (c.types->Kind( u ) = TK_POINTER)

    if op = TK_DOT then
        if isPtr = false then return
        if IsThisBase_( c, mp->lhs ) then return
        c.diags->Report( TKO0630, PointRange( c.ast->Loc( id ) ) )
        return
    end if

    if isPtr = false then
        if c.types->Kind( u ) <> TK_BUILTIN then return
        c.diags->Report( TKO0631, PointRange( c.ast->Loc( id ) ) )
        return
    end if
    dim as TypeId pointee = c.types->Unqualify( c.types->Inner( u ) )
    if pointee = TYPE_NONE then return
    if c.types->Kind( pointee ) = TK_UDT then return
    c.diags->Report( TKO0631, PointRange( c.ast->Loc( id ) ) )
end sub

'' A PRIVATE CONSTRUCTOR OR DESTRUCTOR IS REACHED BY DECLARING THE TYPE -- fbc's error
'' 204, "The default constructor has no public access", and 206 for the destructor.
''
'' No member access is written anywhere: 'dim as T x' CALLS T's default constructor and
'' its destructor, and if either is private the declaration is refused. The corpus names
'' the shapes '<vis>-<member>-<from>-<what>', and the <from> half is the ordinary member
'' rule -- 'private-ctor-protected-local' is an error because a DERIVED type cannot reach
'' a PRIVATE constructor, while 'protected-ctor-protected-local' is fine.
''
'' A POINTER IS NOT A DECLARATION OF ONE. 'dim as T ptr p' constructs nothing; only 'new T'
'' does, and that names its type in an expression where no symbol carries it.
private function StructorOf_ _
    ( byref c as Ctx, byval udt as TypeId, byref nm as string ) as Symbol ptr

    if udt = TYPE_NONE then return 0
    if c.types->Kind( udt ) <> TK_UDT then return 0
    dim as InternId tn = c.types->NameOf( udt )
    if tn = 0 then return 0
    dim as ScopeId ds = cast( ScopeId, c.types->DeclScopeOf( udt ) )
    dim as SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    dim as Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return 0
    if s->inner = SCOPE_NONE then return 0
    return c.syms->SymbolAt( c.syms->LookupLocal( s->inner, _
                                                  c.names->Fold( c.names->GetString( nm ) ) ) )
end function

'' The type whose procedures this SCOPE sits inside, or TYPE_NONE at module level.
private function EnclosingTypeOf_ _
    ( byref c as Ctx, byval scope_ as ScopeId ) as TypeId

    dim as ScopeId cur = scope_
    dim as long guard = 0
    while (cur <> SCOPE_NONE) andalso (guard < 1000)
        guard += 1
        dim as SymScope ptr sc = c.syms->ScopeAt( cur )
        if sc = 0 then return TYPE_NONE
        if sc->kind = cast( ubyte, SCOPEK_TYPE ) then
            dim as Symbol ptr owner = c.syms->SymbolAt( sc->owner )
            if owner = 0 then return TYPE_NONE
            return owner->type_
        end if
        if sc->kind = cast( ubyte, SCOPEK_PROC ) then
            dim as Symbol ptr pr = c.syms->SymbolAt( sc->owner )
            if pr = 0 then return TYPE_NONE
            dim as SymScope ptr ps = c.syms->ScopeAt( pr->parent )
            if ps = 0 then return TYPE_NONE
            if ps->kind <> cast( ubyte, SCOPEK_TYPE ) then return TYPE_NONE
            dim as Symbol ptr owner2 = c.syms->SymbolAt( ps->owner )
            if owner2 = 0 then return TYPE_NONE
            return owner2->type_
        end if
        cur = sc->parent
    wend
    return TYPE_NONE
end function

'' How many parameters this declaration REQUIRES -- a defaulted one is not required, and
'' neither is an ellipsis. A constructor that requires none is a DEFAULT constructor, and
'' it is the one a bare 'dim as T x' calls.
private function RequiredParams_ ( byref c as Ctx, byval decl as NodeId ) as long
    if decl = NODE_NONE then return -1
    if c.ast->Kind( decl ) <> N_PROC then return -1
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, decl )].data )]
    dim as long n = 0
    for i as long = 0 to sp->count - 1
        dim as NodeId prm = cast( NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( prm ) <> N_PARAM then continue for
        dim as StmtPayload ptr psp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, prm )].data )]
        if psp->op = cast( ushort, TK_ELLIPSIS ) then continue for
        if psp->b <> NODE_NONE then continue for
        n += 1
    next
    return n
end function

private function StructorReachable_ _
    ( byref c as Ctx, byval st as Symbol ptr, byval udt as TypeId, _
      byval here as TypeId ) as boolean

    dim as boolean isPriv = ((st->flags and SYMF_MEMB_PRIVATE) <> 0)
    dim as boolean isProt = ((st->flags and SYMF_MEMB_PROTECTED) <> 0)
    if (isPriv = false) andalso (isProt = false) then return true
    if here = TYPE_NONE then return false
    if isPriv then return (here = udt)
    return DerivesFrom_( c, here, udt )
end function

'' THE WHOLE OVERLOAD CHAIN, not its head. fb/comptr.bi's ComInit declares a PRIVATE copy
'' constructor first and a PUBLIC default one after it -- "they exist to be rejected", its
'' own comment says -- and reading only the head refused 'dim as ComInit co', which fbc
'' accepts. What a bare declaration calls is the constructor that REQUIRES NO ARGUMENT,
'' and the type is fine if any such constructor is reachable.
private sub CheckOneStructor_ _
    ( byref c as Ctx, byval udt as TypeId, byref nm as string, _
      byval here as TypeId, byval at as SourceLoc, byval vnm as InternId )

    dim as Symbol ptr st = StructorOf_( c, udt, nm )
    if st = 0 then return
    dim as boolean sawDefault = false
    dim as Symbol ptr walk = st
    dim as long guard = 0
    while (walk <> 0) andalso (guard < 1000)
        guard += 1
        dim as long req = RequiredParams_( c, cast( NodeId, walk->payload ) )
        '' A DESTRUCTOR takes none by definition, and one whose declaration cannot be
        '' read at all is counted rather than skipped: not knowing is not permission.
        if (req = 0) orelse (req = -1) then
            sawDefault = true
            if StructorReachable_( c, walk, udt, here ) then return
        end if
        walk = c.syms->SymbolAt( walk->nextOverload )
    wend
    if sawDefault = false then return
    c.diags->Report( TKO0633, PointRange( at ), c.names->Spelling( vnm ) )
end sub

private sub CheckImplicitStructors_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        dim as SymbolKind k = cast( SymbolKind, s->kind )
        if (k <> SYM_VARIABLE) andalso (k <> SYM_FIELD) then continue for
        if s->type_ = TYPE_NONE then continue for
        '' An ARRAY of them constructs every element; a POINTER constructs nothing.
        dim as TypeId u = c.types->Unqualify( s->type_ )
        dim as long guard = 0
        while (c.types->Kind( u ) = TK_ARRAY) andalso (guard < 16)
            guard += 1
            u = c.types->Unqualify( c.types->Inner( u ) )
        wend
        if c.types->Kind( u ) <> TK_UDT then continue for
        '' THE BASE FIELD IS THE 'extends', not a declaration of one: a derived type
        '' constructs its base whatever the base's constructor says.
        if (k = SYM_FIELD) andalso (s->name = c.baseName) then continue for
        dim as TypeId here = EnclosingTypeOf_( c, s->parent )
        CheckOneStructor_( c, u, "__ctor", here, s->loc, s->name )
        CheckOneStructor_( c, u, "__dtor", here, s->loc, s->name )
    next
end sub

'' 'delete' TAKES A POINTER -- fbc error 28, "Expected pointer". Measured over an
'' integer and a single alike; a pointer of any pointee is accepted.
''
'' Checked here rather than in lowering, which merely DECLINED: a declined statement is
'' counted as not-lowered and says nothing, so 'delete a' over an integer compiled clean.
private sub CheckDelete_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->a = NODE_NONE then return
    dim as TypeId t = c.info->TypeOf_( sp->a )
    '' UNTYPED IS NOT AN ERROR: something earlier declined, and reporting would blame
    '' the wrong line.
    if t = TYPE_NONE then return
    dim as TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) = TK_POINTER then return
    c.diags->Report( TKO0629, PointRange( c.ast->Loc( sp->a ) ) )
end sub

private sub Walk_ ( byref c as Ctx, byval id as NodeId, byval here as TypeId )
    if id = NODE_NONE then return
    dim as NodeKind k = c.ast->Kind( id )
    dim as TypeId inner = here
    if k = N_PROC then inner = ProcOwner_( c, id )
    if k = N_MEMBER then CheckMember_( c, id, here )
    if k = N_DELETE_STMT then CheckDelete_( c, id )
    if k = N_MEMBER then CheckDeref_( c, id )

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

'' A VAR-LEN STRING WITH STATIC STORAGE CANNOT BE INITIALISED -- fbc error 87,
'' "Var-len strings cannot be initialized". A static string's storage is written by the
'' LOADER, and a var-len string is a descriptor whose data has to be allocated at run
'' time; there is nothing for an initialiser to write.
''
'' IT IS THE STORAGE THAT DECIDES, NOT THE SCOPE, and a scope test gets it backwards both
'' ways. Measured:
''
''     dim shared s as string = "foo"           error 87
''     static s as string = "foo"               error 87    inside a sub
''     var shared s = "foo"                     error 87
''     namespace ns : dim s as string = "foo"   error 87    a NAMESPACE is static storage
''     extern s as string : dim s as ... = ...  error 87    the extern makes it shared
''     dim s as string = "foo"                  OK          at MODULE level
''     dim s as string = "foo"                  OK          inside a sub
''     dim shared z as zstring * 8 = "foo"      OK          a FIXED string is not one
''
'' OVER THE SYMBOL TABLE, after the walk, because half of these are 'var' -- the type is
'' INFERRED from the initialiser and does not exist while the declaration is being walked.
private function ScopeIsStatic_ _
    ( byref c as Ctx, byval scope_ as ScopeId ) as boolean

    dim as ScopeId cur = scope_
    dim as long guard = 0
    while (cur <> SCOPE_NONE) andalso (guard < 1000)
        guard += 1
        dim as SymScope ptr sc = c.syms->ScopeAt( cur )
        if sc = 0 then return false
        '' A NAMESPACE gives its variables static storage; a plain MODULE does not.
        if sc->kind = cast( ubyte, SCOPEK_NAMESPACE ) then return true
        if sc->kind = cast( ubyte, SCOPEK_TYPE ) then return true
        if sc->kind = cast( ubyte, SCOPEK_PROC ) then return false
        cur = sc->parent
    wend
    return false
end function

private sub CheckStaticStringInits( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_VARIABLE ) then continue for
        if s->type_ = TYPE_NONE then continue for
        dim as TypeId u = c.types->Unqualify( s->type_ )
        '' A FIXED string is an ARRAY of a character builtin and is NOT this: it has
        '' storage of its own, and the loader can fill it.
        if c.types->Kind( u ) <> TK_BUILTIN then continue for
        if c.types->BuiltinOf( u ) <> TY_STRING then continue for

        dim as boolean flagged = ((s->flags and (SYMF_SHARED or _
            SYMF_STATIC or SYMF_EXTERN)) <> 0)
        if flagged = false then
            if ScopeIsStatic_( c, s->parent ) = false then continue for
        end if

        '' The declaration item, which is where the initialiser hangs.
        if s->payload = 0 then continue for
        dim as NodeId item = cast( NodeId, s->payload )
        if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
        dim as StmtPayload ptr ip = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
        if ip->b = NODE_NONE then continue for
        c.diags->Report( TKO0628, PointRange( c.ast->Loc( item ) ), _
                         c.names->Spelling( s->name ) )
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
    '' The OTHER thing that needs Check to have finished: half the shapes are 'var', and
    '' an inferred type does not exist until Check has run.
    CheckStaticStringInits( c )
    CheckImplicitStructors_( c )
end sub


end namespace
