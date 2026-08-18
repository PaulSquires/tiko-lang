'' collect.bas -- declaration collection.
''
'' The first of the three name-resolution sub-phases (docs/plan/07 section 1). It
'' walks the AST and creates a symbol for every declaration, wiring up scopes. It
'' does NOT resolve types or look inside procedure bodies for references: that is
'' Resolve's job, and keeping the two apart is what gives FreeBASIC's
'' order-independence for free.
''
'' Contract:
''   - May report "duplicate declaration".
''   - May NOT report undefined symbols, type errors, or anything needing a lookup of
''     something that might be declared later.

#include once "symbols/collect.bi"

namespace Fbx.Collect

type Walker
    as Fbx.AstArena ptr     ast
    as Fbx.SymbolTable ptr  syms
    as Fbx.DiagnosticEngine ptr diags
    as Fbx.Interner ptr     names
    as Fbx.TypeContext ptr  types
    as Fbx.SemanticInfo ptr info
    as boolean              inUnion
    as long                 duplicates
end type

private function StmtOf _
    ( byref w as Walker, byval id as Fbx.NodeId ) as Fbx.StmtPayload ptr

    if id = Fbx.NODE_NONE then return 0
    dim as Fbx.AstNode ptr n = @w.ast->nodes[cast( long, id )]
    return @w.ast->stmts[cast( long, n->data )]
end function

private function ListOf _
    ( byref w as Walker, byval id as Fbx.NodeId ) as Fbx.ListPayload ptr

    if id = Fbx.NODE_NONE then return 0
    dim as Fbx.AstNode ptr n = @w.ast->nodes[cast( long, id )]
    return @w.ast->lists[cast( long, n->data )]
end function

private function Declare_ _
    ( byref w as Walker, byval scope_ as Fbx.ScopeId, byval nm as Fbx.InternId, _
      byval k as Fbx.SymbolKind, byval loc as Fbx.SourceLoc ) as Fbx.SymbolId

    if nm = Fbx.INTERN_NONE then return Fbx.SYMBOL_NONE
    dim as boolean dup = false
    dim as Fbx.SymbolId id = w.syms->DeclareSym( scope_, nm, k, loc, dup )
    if dup then
        w.duplicates += 1
        dim as Fbx.SourceRange r = Fbx.PointRange( loc )
        w.diags->Report( Fbx.FBX0600, r, w.names->Spelling( nm ) )
        dim as Fbx.Symbol ptr prev = w.syms->SymbolAt( id )
        if prev <> 0 then
            w.diags->AddNote( Fbx.FBX0901, Fbx.PointRange( prev->loc ) )
        end if
    end if
    return id
end function

declare sub WalkNode _
    ( byref w as Walker, byval id as Fbx.NodeId, byval scope_ as Fbx.ScopeId )

private sub WalkChildren _
    ( byref w as Walker, byval first as long, byval count as long, _
      byval scope_ as Fbx.ScopeId )

    for i as long = 0 to count - 1
        WalkNode( w, cast( Fbx.NodeId, w.ast->children[first + i] ), scope_ )
    next
end sub

sub WalkNode _
    ( byref w as Walker, byval id as Fbx.NodeId, byval scope_ as Fbx.ScopeId )

    if id = Fbx.NODE_NONE then return
    dim as Fbx.NodeKind k = w.ast->Kind( id )
    dim as Fbx.AstNode ptr n = @w.ast->nodes[cast( long, id )]

    '' Resolve re-walks this tree and must land in the SAME scopes. Recording them
    '' here is cheaper and far less fragile than duplicating the traversal rules.
    w.info->SetScope( id, scope_ )

    select case k
    case Fbx.N_MODULE, Fbx.N_BLOCK
        dim as Fbx.ListPayload ptr lp = ListOf( w, id )
        WalkChildren( w, lp->first, lp->count, scope_ )

    case Fbx.N_VAR, Fbx.N_CONST
        '' The items carry the names; the declaration itself carries the storage.
        dim as Fbx.StmtPayload ptr sp = StmtOf( w, id )
        '' REDIM re-dimensions an EXISTING array. It is not a declaration, and
        '' treating it as one reported every 'redim a(...)' as a duplicate.
        if sp->op = cast( ushort, Fbx.KW_REDIM ) then return
        for i as long = 0 to sp->count - 1
            dim as Fbx.NodeId item = cast( Fbx.NodeId, w.ast->children[sp->first + i] )
            if w.ast->Kind( item ) <> Fbx.N_VAR_ITEM then continue for
            dim as Fbx.AstNode ptr itemNode = @w.ast->nodes[cast( long, item )]
            '' 'dim UDT.i as integer' DEFINES a static member declared inside the
            '' type; it does not declare 'i' out here.
            if (itemNode->flags and Fbx.NF_QUALIFIED) <> 0 then continue for
            dim as Fbx.StmtPayload ptr ip = StmtOf( w, item )
            dim as Fbx.SymbolKind sk = Fbx.SYM_VARIABLE
            if k = Fbx.N_CONST then sk = Fbx.SYM_CONSTANT
            dim as Fbx.SymbolId sid = Declare_( w, scope_, ip->name, sk, _
                                                w.ast->Loc( item ) )
            dim as Fbx.Symbol ptr s = w.syms->SymbolAt( sid )
            if s <> 0 then
                if (n->flags and Fbx.NF_SHARED) <> 0 then s->flags or= Fbx.SYMF_SHARED
                if (n->flags and Fbx.NF_STATIC) <> 0 then s->flags or= Fbx.SYMF_STATIC
                if k = Fbx.N_CONST then s->flags or= Fbx.SYMF_CONST
                s->payload = cast( long, item )
            end if
        next

    case Fbx.N_TYPE
        dim as Fbx.StmtPayload ptr sp = StmtOf( w, id )
        '' An ANONYMOUS union or type declares nothing and opens no scope: its
        '' members are members of the ENCLOSING aggregate, which is the whole point
        '' of writing one.
        if sp->name = 0 then
            '' An anonymous UNION's members overlap; an anonymous TYPE's are
            '' sequential. The distinction has to survive the splice, or the layout
            '' pass cannot tell them apart afterwards.
            dim as boolean saved = w.inUnion
            if (n->flags and Fbx.NF_IS_UNION) <> 0 then w.inUnion = true
            WalkChildren( w, sp->first, sp->count, scope_ )
            w.inUnion = saved
            return
        end if
        dim as Fbx.SymbolId sid = Declare_( w, scope_, sp->name, Fbx.SYM_UDT, _
                                            w.ast->Loc( id ) )
        dim as Fbx.ScopeId inner = w.syms->OpenScope( Fbx.SCOPEK_TYPE, scope_, sid )
        dim as Fbx.Symbol ptr s = w.syms->SymbolAt( sid )
        if s <> 0 then
            s->inner = inner
            '' The TypeId exists from the DECLARATION, not from the first use: a
            '' member's signature can name its own type, so waiting would deadlock.
            s->type_ = w.types->NamedType( Fbx.TK_UDT, sp->name, cast( ulong, scope_ ) )
        end if
        w.info->SetScope( id, inner )
        WalkChildren( w, sp->first, sp->count, inner )

    case Fbx.N_FIELD
        dim as Fbx.StmtPayload ptr sp = StmtOf( w, id )
        dim as Fbx.SymbolId fid = Declare_( w, scope_, sp->name, Fbx.SYM_FIELD, _
                                            w.ast->Loc( id ) )
        if w.inUnion then
            dim as Fbx.Symbol ptr fs = w.syms->SymbolAt( fid )
            if fs <> 0 then fs->flags or= Fbx.SYMF_UNION
        end if

    case Fbx.N_ENUM
        dim as Fbx.StmtPayload ptr sp = StmtOf( w, id )
        dim as Fbx.SymbolId sid = Declare_( w, scope_, sp->name, Fbx.SYM_ENUM, _
                                            w.ast->Loc( id ) )
        '' Enum constants land in the ENCLOSING scope, as in FreeBASIC: 'Red' is
        '' usable without qualification.
        dim as Fbx.Symbol ptr s = w.syms->SymbolAt( sid )
        if s <> 0 then
            s->inner = scope_
            s->type_ = w.types->NamedType( Fbx.TK_ENUM, sp->name, cast( ulong, scope_ ) )
        end if
        WalkChildren( w, sp->first, sp->count, scope_ )

    case Fbx.N_ENUM_ITEM
        dim as Fbx.StmtPayload ptr sp = StmtOf( w, id )
        Declare_( w, scope_, sp->name, Fbx.SYM_ENUMCONST, w.ast->Loc( id ) )

    case Fbx.N_TYPEDEF
        dim as Fbx.StmtPayload ptr sp = StmtOf( w, id )
        dim as Fbx.SymbolId tid = Declare_( w, scope_, sp->name, Fbx.SYM_TYPEDEF, _
                                            w.ast->Loc( id ) )
        dim as Fbx.Symbol ptr ts = w.syms->SymbolAt( tid )
        if ts <> 0 then ts->type_ = w.types->NamedType( Fbx.TK_TYPEDEF, sp->name, cast( ulong, scope_ ) )

    case Fbx.N_PROC
        dim as Fbx.StmtPayload ptr sp = StmtOf( w, id )
        '' 'sub Stack.Push( )' DEFINES a member declared elsewhere; it does not
        '' declare 'Push' in the enclosing scope. Binding it to the right type is
        '' Resolve's job, so Collect only opens a scope for its parameters.
        '' A constructor or destructor names its TYPE. There is no dot to mark it
        '' qualified, so the keyword is what identifies it as a member definition.
        dim as boolean isCtorDtor = (sp->op = cast( ushort, Fbx.KW_CONSTRUCTOR )) orelse _
                                    (sp->op = cast( ushort, Fbx.KW_DESTRUCTOR ))
        dim as boolean isMemberDef = ((n->flags and Fbx.NF_QUALIFIED) <> 0) orelse isCtorDtor
        dim as Fbx.SymbolId sid = Fbx.SYMBOL_NONE
        if isMemberDef = false then
            sid = Declare_( w, scope_, sp->name, Fbx.SYM_PROC, w.ast->Loc( id ) )
        end if
        dim as Fbx.Symbol ptr s = w.syms->SymbolAt( sid )
        if s <> 0 then
            if sp->b = Fbx.NODE_NONE then
                s->flags or= Fbx.SYMF_DECLARED
            else
                s->flags or= Fbx.SYMF_DEFINED
            end if
            s->payload = cast( long, id )
        end if

        '' 'sub Widget.Method( )' defines a member: its scope PARENT is the type's
        '' scope, not the module's. That is what makes 'this', the sibling fields and
        '' the mangled name _ZN6WIDGET6METHODEi all come out right -- an unqualified
        '' member body resolves its own fields by ordinary scope lookup.
        dim as Fbx.ScopeId parentScope = scope_
        if isMemberDef then
            dim as Fbx.InternId ownerNm = sp->ownerName
            if isCtorDtor andalso (ownerNm = 0) then ownerNm = sp->name
            if ownerNm <> 0 then
                dim as Fbx.SymbolId osid = w.syms->Lookup( scope_, ownerNm )
                dim as Fbx.Symbol ptr os = w.syms->SymbolAt( osid )
                if os <> 0 then
                    if os->inner <> Fbx.SCOPE_NONE then parentScope = os->inner
                end if
            end if
        end if

        '' Parameters and locals live in the procedure's own scope.
        dim as Fbx.ScopeId inner = w.syms->OpenScope( Fbx.SCOPEK_PROC, parentScope, sid )
        if s <> 0 then s->inner = inner
        '' A member definition body may say 'this'. The receiver is implicit -- it is
        '' never written as a parameter -- so nothing else would ever declare it.
        '' Giving it the OWNING type is Resolve's job; existing is Collect's.
        if isMemberDef then
            Declare_( w, inner, w.names->Fold( w.names->GetString( "this" ) ), _
                      Fbx.SYM_PARAMETER, w.ast->Loc( id ) )
        end if
        w.info->SetScope( id, inner )
        if sid <> Fbx.SYMBOL_NONE then w.info->SetRef( id, sid )
        WalkChildren( w, sp->first, sp->count, inner )
        if sp->b <> Fbx.NODE_NONE then WalkNode( w, sp->b, inner )

    case Fbx.N_PARAM
        dim as Fbx.StmtPayload ptr sp = StmtOf( w, id )
        Declare_( w, scope_, sp->name, Fbx.SYM_PARAMETER, w.ast->Loc( id ) )

    case Fbx.N_NAMESPACE
        dim as Fbx.StmtPayload ptr sp = StmtOf( w, id )
        '' A namespace REOPENS rather than redeclares: if the name is already a
        '' namespace in this scope, keep collecting into its existing scope.
        dim as Fbx.SymbolId sid = w.syms->LookupLocal( scope_, sp->name )
        dim as Fbx.Symbol ptr s = w.syms->SymbolAt( sid )
        dim as boolean reopen = (s <> 0) andalso (s->kind = cast( ubyte, Fbx.SYM_NAMESPACE ))
        if reopen = false then
            sid = Declare_( w, scope_, sp->name, Fbx.SYM_NAMESPACE, w.ast->Loc( id ) )
            s = w.syms->SymbolAt( sid )
            if s <> 0 then
                s->inner = w.syms->OpenScope( Fbx.SCOPEK_NAMESPACE, scope_, sid )
            end if
        end if
        if s <> 0 then
            w.info->SetScope( id, s->inner )
            WalkChildren( w, sp->first, sp->count, s->inner )
        end if

    case Fbx.N_EXTERN_BLOCK
        dim as Fbx.StmtPayload ptr sp = StmtOf( w, id )
        '' A linkage block declares into the ENCLOSING scope; it is not a scope.
        WalkChildren( w, sp->first, sp->count, scope_ )

    case Fbx.N_LABEL
        dim as Fbx.StmtPayload ptr sp = StmtOf( w, id )
        Declare_( w, scope_, sp->name, Fbx.SYM_LABEL, w.ast->Loc( id ) )

    case Fbx.N_SCOPE, Fbx.N_IF, Fbx.N_IF_BRANCH, Fbx.N_FOR, Fbx.N_FOREACH, _
         Fbx.N_DO, Fbx.N_WHILE, Fbx.N_WITH, Fbx.N_SELECT, Fbx.N_CASE
        '' Compound statements introduce a block scope for their bodies. Declarations
        '' inside are collected; expressions are ignored until Resolve.
        dim as Fbx.StmtPayload ptr sp = StmtOf( w, id )
        dim as Fbx.ScopeId inner = w.syms->OpenScope( Fbx.SCOPEK_BLOCK, scope_, _
                                                      Fbx.SYMBOL_NONE )
        w.info->SetScope( id, inner )
        '' 'a' is the FOR counter and the FOR EACH loop variable -- a DECLARATION,
        '' and the reason 14,565 uses of 'i' resolved to nothing. For the other
        '' compound statements 'a' is the condition, which this walk ignores.
        '' 'for i as integer' DECLARES i; 'for i =' uses an existing i. The 'as'
        '' clause is the whole difference, and it is what 'c' holds here. The
        '' counter arrives as an expression, not a declaration node, so Collect
        '' names it directly rather than waiting for a shape that never comes.
        if ((k = Fbx.N_FOR) orelse (k = Fbx.N_FOREACH)) andalso _
           (sp->c <> Fbx.NODE_NONE) andalso (sp->a <> Fbx.NODE_NONE) andalso _
           (w.ast->Kind( sp->a ) = Fbx.N_IDENT) then
            dim as Fbx.IdentPayload ptr ip = _
                @w.ast->idents[cast( long, w.ast->nodes[cast( long, sp->a )].data )]
            Declare_( w, inner, ip->name, Fbx.SYM_VARIABLE, w.ast->Loc( sp->a ) )
        end if
        WalkNode( w, sp->a, inner )
        WalkNode( w, sp->b, inner )
        WalkNode( w, sp->c, inner )
        WalkChildren( w, sp->first, sp->count, inner )
    end select
end sub

private sub DeclareGlobal _
    ( byref syms as Fbx.SymbolTable, byref names as Fbx.Interner, _
      byref diags as Fbx.DiagnosticEngine, byval spelling as string )

    dim as boolean dup = false
    syms.DeclareSym( Fbx.SCOPE_GLOBAL, names.Fold( names.GetString( spelling ) ), _
                     Fbx.SYM_CONSTANT, Fbx.LOC_NONE, dup )
end sub

function Run _
    ( byref ast as Fbx.AstArena, byval root as Fbx.NodeId, _
      byref syms as Fbx.SymbolTable, byref names as Fbx.Interner, _
      byref types as Fbx.TypeContext, byref diags as Fbx.DiagnosticEngine, _
      byref info as Fbx.SemanticInfo ) as long

    dim as Walker w
    w.types = @types
    w.ast = @ast
    w.syms = @syms
    w.diags = @diags
    w.names = @names
    w.info = @info
    w.duplicates = 0
    info.Resize( ast.Count( ) )

    '' fbc predeclares these in the global scope -- 'dim as integer true' is a
    '' DUPLICATED DEFINITION to fbc, not a syntax error, so they are symbols and not
    '' keywords. typeof(true) is BOOLEAN, measured. __FUNCTION__ is fbc's
    '' compile-time procedure name; giving it the enclosing proc's name is Check's
    '' job, being declared at all is this one's.
    DeclareGlobal( syms, names, diags, "true" )
    DeclareGlobal( syms, names, diags, "false" )
    DeclareGlobal( syms, names, diags, "__function__" )
    DeclareGlobal( syms, names, diags, "__function_nq__" )

    dim as Fbx.ScopeId moduleScope = syms.OpenScope( Fbx.SCOPEK_MODULE, _
                                                     Fbx.SCOPE_GLOBAL, Fbx.SYMBOL_NONE )
    WalkNode( w, root, moduleScope )
    return w.duplicates
end function

'' ----------------------------------------------------------------------- dump

function Dump _
    ( byref syms as Fbx.SymbolTable, byref names as Fbx.Interner, _
      byref types as Fbx.TypeContext ) as string

    dim as string outp = ""
    outp += "scopes: " & syms.ScopeCount( ) & "  symbols: " & syms.Count( ) & chr( 10 )

    for i as long = 1 to syms.ScopeCount( )
        dim as Fbx.SymScope ptr sc = syms.ScopeAt( cast( Fbx.ScopeId, i ) )
        if sc->count = 0 then continue for

        dim as string owner = ""
        if sc->owner <> Fbx.SYMBOL_NONE then
            owner = " of '" & names.Spelling( syms.SymbolAt( sc->owner )->name ) & "'"
        end if
        outp += "scope " & i & " " & Fbx.ScopeKindName( cast( Fbx.ScopeKind, sc->kind ) ) & _
                owner & " parent=" & sc->parent & " (" & sc->count & ")" & chr( 10 )

        '' Declaration order, which is the order destruction will reverse.
        dim as Fbx.SymbolId cur = sc->firstSym
        while cur <> Fbx.SYMBOL_NONE
            dim as Fbx.Symbol ptr s = syms.SymbolAt( cur )
            dim as string row = "    " & _
                left( Fbx.SymbolKindName( cast( Fbx.SymbolKind, s->kind ) ) & "         ", 10 ) & _
                "'" & names.Spelling( s->name ) & "'"
            if (s->flags and Fbx.SYMF_SHARED) <> 0 then row += " shared"
            if (s->flags and Fbx.SYMF_STATIC) <> 0 then row += " static"
            if (s->flags and Fbx.SYMF_CONST) <> 0 then row += " const"
            if (s->flags and Fbx.SYMF_DECLARED) <> 0 then row += " declared"
            if (s->flags and Fbx.SYMF_DEFINED) <> 0 then row += " defined"
            if s->nextOverload <> Fbx.SYMBOL_NONE then row += " +overloads"
            outp += row & chr( 10 )
            cur = s->nextInScope
        wend
    next
    return outp
end function

end namespace
