'' resolve.bas -- see resolve.bi

#include once "symbols/resolve.bi"
#include once "lexer/keywords.bi"

namespace Fbx

'' -------------------------------------------------------------- side tables

sub SemanticInfo.Resize( byval nodeCount as long )
    dim as long want = nodeCount + 1
    while this.refSymbol.Count < want
        this.refSymbol.Push( 0 )
        this.nodeType.Push( 0 )
        this.nodeScope.Push( 0 )
        this.ambiguous.Push( 0 )
    wend
end sub

sub SemanticInfo.SetRef( byval n as NodeId, byval s as SymbolId )
    if cast( long, n ) < this.refSymbol.Count then
        this.refSymbol[cast( long, n )] = cast( ulong, s )
    end if
end sub

function SemanticInfo.RefOf( byval n as NodeId ) as SymbolId
    if cast( long, n ) >= this.refSymbol.Count then return SYMBOL_NONE
    return cast( SymbolId, this.refSymbol[cast( long, n )] )
end function

sub SemanticInfo.SetType( byval n as NodeId, byval t as TypeId )
    if cast( long, n ) < this.nodeType.Count then
        this.nodeType[cast( long, n )] = cast( ulong, t )
    end if
end sub

function SemanticInfo.TypeOf_( byval n as NodeId ) as TypeId
    if cast( long, n ) >= this.nodeType.Count then return TYPE_NONE
    return cast( TypeId, this.nodeType[cast( long, n )] )
end function

sub SemanticInfo.SetScope( byval n as NodeId, byval s as ScopeId )
    if cast( long, n ) < this.nodeScope.Count then
        this.nodeScope[cast( long, n )] = cast( ulong, s )
    end if
end sub

function SemanticInfo.ScopeOf( byval n as NodeId ) as ScopeId
    if cast( long, n ) >= this.nodeScope.Count then return SCOPE_NONE
    return cast( ScopeId, this.nodeScope[cast( long, n )] )
end function

sub SemanticInfo.SetAmbiguous( byval n as NodeId, byval a as AmbiguousResolution )
    if cast( long, n ) < this.ambiguous.Count then
        this.ambiguous[cast( long, n )] = cast( ubyte, a )
    end if
end sub

function SemanticInfo.AmbiguousOf( byval n as NodeId ) as AmbiguousResolution
    if cast( long, n ) >= this.ambiguous.Count then return AMB_UNRESOLVED
    return cast( AmbiguousResolution, this.ambiguous[cast( long, n )] )
end function

end namespace

namespace Fbx.Resolve

type Ctx
    as Fbx.AstArena ptr     ast
    as Fbx.SymbolTable ptr  syms
    as Fbx.TypeContext ptr  types
    as Fbx.Interner ptr     names
    as Fbx.DiagnosticEngine ptr diags
    as Fbx.SemanticInfo ptr info
    as Stats ptr            st
    as Fbx.SymbolId         currentProc
end type

private function StmtOf _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.StmtPayload ptr
    if id = Fbx.NODE_NONE then return 0
    return @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
end function

private function ListOf _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.ListPayload ptr
    if id = Fbx.NODE_NONE then return 0
    return @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
end function

private function IdentNameOf _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.InternId
    if c.ast->Kind( id ) <> Fbx.N_IDENT then return Fbx.INTERN_NONE
    return c.ast->idents[cast( long, c.ast->nodes[cast( long, id )].data )].name
end function

'' ------------------------------------------------------------- type references

'' A syntactic TypeRef becomes a semantic TypeId. Builtin spellings map straight to
'' the fixed builtin ids; a named type is looked up.
private function ResolveTypeRef _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval scope_ as Fbx.ScopeId ) as Fbx.TypeId

    if id = Fbx.NODE_NONE then return Fbx.TYPE_NONE
    if c.ast->Kind( id ) <> Fbx.N_TYPEREF then return Fbx.TYPE_NONE

    dim as Fbx.AstNode ptr n = @c.ast->nodes[cast( long, id )]
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    c.st->typeRefs += 1

    '' A pointer level wraps whatever it contains.
    if (n->flags and Fbx.NF_PTR) <> 0 then
        dim as Fbx.TypeId inner = ResolveTypeRef( c, sp->a, scope_ )
        dim as Fbx.TypeId t = c.types->Pointer_( inner )
        if (n->flags and Fbx.NF_CONST) <> 0 then t = c.types->Qualify( t, Fbx.TF_CONST )
        c.info->SetType( id, t )
        return t
    end if

    '' 'as sub( ... )' / 'as function( ... ) as T'. In FreeBASIC a procedure type is
    '' already a POINTER -- 'sub( ) ptr' is PPFvvE, one P for the type itself and one
    '' for the written 'ptr' -- so the pointer is built in here, not by the caller.
    if (n->flags and Fbx.NF_PROC_TYPE) <> 0 then
        dim as Fbx.TypeId ret = Fbx.TYPE_NONE
        if sp->a <> Fbx.NODE_NONE then
            ret = ResolveTypeRef( c, sp->a, scope_ )
        else
            ret = c.types->Builtin( Fbx.TY_VOID )
        end if
        dim as Fbx.TypeIdVec2 ps
        for i as long = 0 to sp->count - 1
            dim as Fbx.NodeId prm = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
            if c.ast->Kind( prm ) <> Fbx.N_PARAM then continue for
            dim as Fbx.StmtPayload ptr pp = StmtOf( c, prm )
            dim as Fbx.TypeId pt = ResolveTypeRef( c, pp->a, scope_ )
            if (c.ast->nodes[cast( long, prm )].flags and Fbx.NF_BYREF) <> 0 then
                pt = c.types->Reference( pt )
            end if
            ps.Push( cast( ulong, pt ) )
        next
        dim as Fbx.TypeId pf = c.types->Pointer_( c.types->ProcType( ret, ps ) )
        if (n->flags and Fbx.NF_CONST) <> 0 then
            pf = c.types->Qualify( pf, Fbx.TF_CONST )
        end if
        c.info->SetType( id, pf )
        return pf
    end if

    dim as Fbx.TypeId base_ = Fbx.TYPE_NONE
    dim as Fbx.TokenKind k = cast( Fbx.TokenKind, sp->op )

    select case k
    case Fbx.KW_BYTE     : base_ = c.types->Builtin( Fbx.TY_BYTE )
    case Fbx.KW_UBYTE    : base_ = c.types->Builtin( Fbx.TY_UBYTE )
    case Fbx.KW_SHORT    : base_ = c.types->Builtin( Fbx.TY_SHORT )
    case Fbx.KW_USHORT   : base_ = c.types->Builtin( Fbx.TY_USHORT )
    case Fbx.KW_LONG     : base_ = c.types->Builtin( Fbx.TY_LONG )
    case Fbx.KW_ULONG    : base_ = c.types->Builtin( Fbx.TY_ULONG )
    case Fbx.KW_INTEGER  : base_ = c.types->Builtin( Fbx.TY_INTEGER )
    case Fbx.KW_UINTEGER : base_ = c.types->Builtin( Fbx.TY_UINTEGER )
    case Fbx.KW_LONGINT  : base_ = c.types->Builtin( Fbx.TY_LONGINT )
    case Fbx.KW_ULONGINT : base_ = c.types->Builtin( Fbx.TY_ULONGINT )
    case Fbx.KW_SINGLE   : base_ = c.types->Builtin( Fbx.TY_SINGLE )
    case Fbx.KW_DOUBLE   : base_ = c.types->Builtin( Fbx.TY_DOUBLE )
    case Fbx.KW_BOOLEAN  : base_ = c.types->Builtin( Fbx.TY_BOOLEAN )
    case Fbx.KW_STRING   : base_ = c.types->Builtin( Fbx.TY_STRING )
    case Fbx.KW_ZSTRING  : base_ = c.types->Builtin( Fbx.TY_ZSTRING )
    case Fbx.KW_WSTRING  : base_ = c.types->Builtin( Fbx.TY_WSTRING )
    case Fbx.KW_USTRING  : base_ = c.types->Builtin( Fbx.TY_USTRING )
    case Fbx.KW_ANY      : base_ = c.types->Builtin( Fbx.TY_ANY )
    case else
        '' A named type. Not finding it is NOT reported here: a type may come from a
        '' header this build did not parse, and drowning the output in those would
        '' hide the real signal. Check reports what it can prove.
        dim as Fbx.SymbolId sid = c.syms->Lookup( scope_, sp->name )
        if sid <> Fbx.SYMBOL_NONE then
            c.info->SetRef( id, sid )
            dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
            if s->type_ <> Fbx.TYPE_NONE then base_ = s->type_
        end if
    end select

    if (n->flags and Fbx.NF_CONST) <> 0 then
        base_ = c.types->Qualify( base_, Fbx.TF_CONST )
    end if
    c.info->SetType( id, base_ )
    return base_
end function

'' ------------------------------------------------------------------- walking

declare sub WalkStmt _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval scope_ as Fbx.ScopeId )

'' Give a just-declared name its type. The symbol is found by NAME in the scope
'' Collect recorded, rather than by threading a SymbolId through the AST: the
'' declaration and its symbol are in the same scope by construction.
private sub BindDeclType _
    ( byref c as Ctx, byval scope_ as Fbx.ScopeId, byval nm as Fbx.InternId, _
      byval t as Fbx.TypeId )

    if (nm = 0) orelse (t = Fbx.TYPE_NONE) then return
    dim as Fbx.SymbolId sid = c.syms->LookupLocal( scope_, nm )
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return
    if s->type_ = Fbx.TYPE_NONE then s->type_ = t
end sub

'' Bind identifiers inside an expression. A member name after a dot is NOT resolved
'' here: it needs the base's type, which is Check's business.
private sub WalkExpr _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval scope_ as Fbx.ScopeId )

    if id = Fbx.NODE_NONE then return
    dim as Fbx.NodeKind k = c.ast->Kind( id )
    dim as Fbx.AstNode ptr n = @c.ast->nodes[cast( long, id )]

    select case k
    case Fbx.N_IDENT
        dim as Fbx.InternId nm = IdentNameOf( c, id )
        dim as Fbx.SymbolId sid = c.syms->Lookup( scope_, nm )
        if sid <> Fbx.SYMBOL_NONE then
            c.info->SetRef( id, sid )
            c.st->references += 1
        elseif cast( long, nm ) <= FBX_KEYWORD_COUNT then
            '' A keyword used in expression position -- LEN, ASC, SIN. It is a
            '' BUILTIN, not an undefined name. This is free to detect because the
            '' keyword spellings are interned FIRST and so occupy ids 1..N
            '' contiguously (see lexer/token.bi).
            c.st->builtins += 1
        else
            c.st->undefined_ += 1
            if c.st->unresolvedNames.Count < 200000 then
                c.st->unresolvedNames.Push( cast( ulong, nm ) )
            end if
        end if

    case Fbx.N_UNARY, Fbx.N_ADDROF, Fbx.N_DEREF
        WalkExpr( c, c.ast->unaries[cast( long, n->data )].operand, scope_ )

    case Fbx.N_BINARY
        dim as Fbx.BinaryPayload ptr bp = @c.ast->binaries[cast( long, n->data )]
        WalkExpr( c, bp->lhs, scope_ )
        WalkExpr( c, bp->rhs, scope_ )

    case Fbx.N_MEMBER
        '' Only the base: the member name needs the base's type.
        WalkExpr( c, c.ast->binaries[cast( long, n->data )].lhs, scope_ )

    case Fbx.N_CALL, Fbx.N_INDEX, Fbx.N_PAREN, Fbx.N_TUPLE, Fbx.N_INITIALIZER, _
         Fbx.N_STRCAT
        dim as Fbx.ListPayload ptr lp = ListOf( c, id )
        WalkExpr( c, lp->target, scope_ )
        for i as long = 0 to lp->count - 1
            WalkExpr( c, cast( Fbx.NodeId, c.ast->children[lp->first + i] ), scope_ )
        next
    end select
end sub

'' The parser's three-way ambiguity, decided now that the target's symbol is known
'' (docs/plan/07 section 8). The payoff is the diagnostic: where fbc reports a syntax
'' error, fbx can say what the name actually is.
private sub ResolveAmbiguous _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval scope_ as Fbx.ScopeId )

    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    WalkExpr( c, sp->a, scope_ )
    WalkExpr( c, sp->b, scope_ )
    for i as long = 0 to sp->count - 1
        WalkExpr( c, cast( Fbx.NodeId, c.ast->children[sp->first + i] ), scope_ )
    next

    dim as boolean isAssign = (sp->op <> 0)

    '' The target's head symbol: for a.b.c the head is a.
    dim as Fbx.NodeId head = sp->a
    dim as long guard = 0
    while guard < 64
        guard += 1
        dim as Fbx.NodeKind hk = c.ast->Kind( head )
        if hk = Fbx.N_MEMBER then
            head = c.ast->binaries[cast( long, c.ast->nodes[cast( long, head )].data )].lhs
        elseif (hk = Fbx.N_CALL) orelse (hk = Fbx.N_INDEX) then
            head = ListOf( c, head )->target
        else
            exit while
        end if
    wend

    dim as Fbx.SymbolId sid = c.info->RefOf( head )
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )

    if isAssign then
        '' Assigning to the enclosing function name is BASIC's result assignment.
        dim as boolean isResult = (c.currentProc <> Fbx.SYMBOL_NONE) andalso _
                                  (sid = c.currentProc)
        if isResult then
            c.info->SetAmbiguous( id, Fbx.AMB_RESULT )
        else
            c.info->SetAmbiguous( id, Fbx.AMB_ASSIGN )
        end if
        c.st->assigns += 1
        return
    end if

    if s = 0 then
        c.info->SetAmbiguous( id, Fbx.AMB_CALL )
        c.st->calls += 1
        return
    end if

    select case cast( Fbx.SymbolKind, s->kind )
    case Fbx.SYM_PROC
        c.info->SetAmbiguous( id, Fbx.AMB_CALL )
        c.st->calls += 1
    case Fbx.SYM_UDT, Fbx.SYM_ENUM, Fbx.SYM_TYPEDEF, Fbx.SYM_NAMESPACE
        '' This is the diagnostic the ambiguous node exists to make possible.
        dim as Fbx.SourceRange r = Fbx.PointRange( c.ast->Loc( id ) )
        c.diags->Report( Fbx.FBX0602, r, c.names->Spelling( s->name ), _
                         Fbx.SymbolKindName( cast( Fbx.SymbolKind, s->kind ) ) )
        c.info->SetAmbiguous( id, Fbx.AMB_ERROR )
    case else
        c.info->SetAmbiguous( id, Fbx.AMB_CALL )
        c.st->calls += 1
    end select
end sub

sub WalkStmt _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval scope_ as Fbx.ScopeId )

    if id = Fbx.NODE_NONE then return
    dim as Fbx.NodeKind k = c.ast->Kind( id )
    dim as Fbx.NodeCategory cat = Fbx.NodeKindCategory( k )

    '' Collect recorded the scope for anything that opened one; otherwise inherit.
    dim as Fbx.ScopeId here = c.info->ScopeOf( id )
    if here = Fbx.SCOPE_NONE then here = scope_

    if cat = Fbx.NCAT_EXPR then
        WalkExpr( c, id, here )
        return
    end if

    select case k
    case Fbx.N_MODULE, Fbx.N_BLOCK
        dim as Fbx.ListPayload ptr lp = ListOf( c, id )
        for i as long = 0 to lp->count - 1
            WalkStmt( c, cast( Fbx.NodeId, c.ast->children[lp->first + i] ), here )
        next
        return

    case Fbx.N_AMBIGUOUS
        ResolveAmbiguous( c, id, here )
        return

    case Fbx.N_TYPEREF
        ResolveTypeRef( c, id, here )
        return

    case Fbx.N_VAR, Fbx.N_CONST
        '' Resolving a declaration's TypeRef is not enough: the SYMBOL has to carry
        '' the result, or every later use of the name is untyped. Collect could not
        '' do this -- a type may be declared after the variable that uses it, which
        '' is exactly why type references are resolved in this pass and not that one.
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        if sp->op = cast( ushort, Fbx.KW_REDIM ) then return
        for i as long = 0 to sp->count - 1
            dim as Fbx.NodeId item = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
            if c.ast->Kind( item ) <> Fbx.N_VAR_ITEM then continue for
            dim as Fbx.StmtPayload ptr ip = StmtOf( c, item )
            dim as Fbx.TypeId t = ResolveTypeRef( c, ip->a, here )
            BindDeclType( c, here, ip->name, t )
            WalkStmt( c, ip->b, here )
        next
        return

    case Fbx.N_PARAM
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        dim as Fbx.TypeId t = ResolveTypeRef( c, sp->a, here )
        if (t <> Fbx.TYPE_NONE) andalso _
           ((c.ast->nodes[cast( long, id )].flags and Fbx.NF_BYREF) <> 0) then
            t = c.types->Reference( t )
        end if
        BindDeclType( c, here, sp->name, t )
        WalkStmt( c, sp->b, here )
        return

    case Fbx.N_FIELD
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        dim as Fbx.TypeId t = ResolveTypeRef( c, sp->a, here )
        BindDeclType( c, here, sp->name, t )
        return

    case Fbx.N_PROC
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        dim as Fbx.SymbolId saved = c.currentProc
        c.currentProc = c.info->RefOf( id )
        ResolveTypeRef( c, sp->a, here )
        for i as long = 0 to sp->count - 1
            WalkStmt( c, cast( Fbx.NodeId, c.ast->children[sp->first + i] ), here )
        next
        WalkStmt( c, sp->b, here )
        c.currentProc = saved
        return
    end select

    '' Everything else: recurse through the general slots.
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    if sp = 0 then return
    WalkStmt( c, sp->a, here )
    WalkStmt( c, sp->b, here )
    WalkStmt( c, sp->c, here )
    for i as long = 0 to sp->count - 1
        WalkStmt( c, cast( Fbx.NodeId, c.ast->children[sp->first + i] ), here )
    next
end sub

sub Run _
    ( byref ast as Fbx.AstArena, byval root as Fbx.NodeId, _
      byref syms as Fbx.SymbolTable, byref types as Fbx.TypeContext, _
      byref names as Fbx.Interner, byref diags as Fbx.DiagnosticEngine, _
      byref info as Fbx.SemanticInfo, byref st as Stats )

    dim as Ctx c
    c.ast = @ast
    c.syms = @syms
    c.types = @types
    c.names = @names
    c.diags = @diags
    c.info = @info
    c.st = @st
    c.currentProc = Fbx.SYMBOL_NONE

    info.Resize( ast.Count( ) )
    WalkStmt( c, root, Fbx.SCOPE_GLOBAL )
end sub

function Dump _
    ( byref ast as Fbx.AstArena, byref syms as Fbx.SymbolTable, _
      byref types as Fbx.TypeContext, byref names as Fbx.Interner, _
      byref info as Fbx.SemanticInfo, byref st as Stats ) as string

    dim as string outp = ""
    outp += "resolved: " & st.references & " references, " & st.builtins & _
            " builtins, " & st.undefined_ & " unresolved, " & st.typeRefs & _
            " type refs, " & st.calls & " calls, " & st.assigns & _
            " assignments" & chr( 10 )

    for i as long = 0 to st.unresolvedNames.Count - 1
        outp += "  unresolved: " & _
                names.Spelling( cast( Fbx.InternId, st.unresolvedNames[i] ) ) & chr( 10 )
    next

    for i as long = 1 to ast.Count( )
        dim as Fbx.NodeId n = cast( Fbx.NodeId, i )
        dim as Fbx.NodeKind k = ast.Kind( n )

        if k = Fbx.N_TYPEREF then
            dim as Fbx.TypeId t = info.TypeOf_( n )
            if t <> Fbx.TYPE_NONE then
                outp += "  typeref #" & i & " -> " & types.Name( t ) & chr( 10 )
            end if
        elseif k = Fbx.N_AMBIGUOUS then
            dim as string what = "?"
            select case info.AmbiguousOf( n )
            case Fbx.AMB_CALL   : what = "call"
            case Fbx.AMB_ASSIGN : what = "assign"
            case Fbx.AMB_RESULT : what = "function-result"
            case Fbx.AMB_ERROR  : what = "error"
            end select
            outp += "  stmt #" & i & " -> " & what & chr( 10 )
        end if
    next
    return outp
end function

end namespace
