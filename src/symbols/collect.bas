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
declare function Effective_( byval c as Fbx.CallConv ) as Fbx.CallConv
declare sub BindCallConv _
    ( byref w as Walker, byval s as Fbx.Symbol ptr, _
      byval sp as Fbx.StmtPayload ptr, byval id as Fbx.NodeId, _
      byval firstSighting as boolean )
declare function ProcArity _
    ( byref w as Walker, byval sp as Fbx.StmtPayload ptr ) as long
declare function UndefinedProcWithArity _
    ( byref w as Walker, byval scope_ as Fbx.ScopeId, byval nm as Fbx.InternId, _
      byval want as long ) as Fbx.SymbolId

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
            if sp->extra > 0 then
                w.types->SetPacking( s->type_, cast( long, sp->extra ) )
            end if
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
        '' 'type as integer a, b' -- every name after the first is a child N_TYPEDEF
        '' sharing the same type reference.
        for i as long = 0 to sp->count - 1
            WalkNode( w, cast( Fbx.NodeId, w.ast->children[sp->first + i] ), scope_ )
        next

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
        '' A constructor or destructor has no name of its own -- 'declare
        '' constructor( )' names nothing and 'constructor T( )' names the TYPE -- so
        '' neither was ever declared as a symbol, and nothing could find them. They
        '' get a synthetic name in the type's scope, which also makes overloaded
        '' constructors chain like any other overload set.
        dim as Fbx.InternId declName = sp->name
        if isCtorDtor then
            if sp->op = cast( ushort, Fbx.KW_CONSTRUCTOR ) then
                declName = w.names->Fold( w.names->GetString( "__ctor" ) )
            else
                declName = w.names->Fold( w.names->GetString( "__dtor" ) )
            end if
        end if

        dim as Fbx.SymbolId sid = Fbx.SYMBOL_NONE
        if isMemberDef = false then
            '' A DEFINITION joins its DECLARE rather than chaining beside it. Without
            '' this, 'declare sub F( byval x as long )' followed by 'sub F( byval x as
            '' long )' produced TWO symbols with identical signatures, so every call to
            '' F was AMBIGUOUS and resolved to nothing -- which is most real programs,
            '' and went unnoticed because the corpus's procedures are declared in a
            '' header and defined in a library it never compiles.
            if sp->b <> Fbx.NODE_NONE then
                sid = UndefinedProcWithArity( w, scope_, declName, ProcArity( w, sp ) )
            end if
            if sid = Fbx.SYMBOL_NONE then
                sid = Declare_( w, scope_, declName, Fbx.SYM_PROC, w.ast->Loc( id ) )
            end if
        end if
        dim as Fbx.Symbol ptr s = w.syms->SymbolAt( sid )
        if s <> 0 then
            if sp->b = Fbx.NODE_NONE then
                s->flags or= Fbx.SYMF_DECLARED
            else
                s->flags or= Fbx.SYMF_DEFINED
            end if
            '' The DECLARATION's node stays the payload: it carries the signature every
            '' call site mangles against, and a declaration mangles identically to its
            '' definition. Its absence is also how the FIRST sighting is recognised,
            '' which is what BindCallConv needs -- the first one records, later ones
            '' must agree.
            dim as boolean firstSighting = (s->payload = 0)
            if firstSighting then s->payload = cast( long, id )
            BindCallConv( w, s, sp, id, firstSighting )
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
                '' The owner is a TYPE name -- 'sub Widget.Draw( )' -- so a variable
                '' sharing the spelling must not be picked up instead.
                dim as Fbx.SymbolId osid = w.syms->LookupTyped( scope_, ownerNm, true )
                dim as Fbx.Symbol ptr os = w.syms->SymbolAt( osid )
                if os <> 0 then
                    if os->inner <> Fbx.SCOPE_NONE then parentScope = os->inner
                end if
            end if
        end if

        '' A ctor/dtor DEFINITION joins the declaration that is already in the
        '' type's scope, so a call site finds one symbol with a body rather than two
        '' halves of one.
        if isCtorDtor andalso (sid = Fbx.SYMBOL_NONE) then
            '' A DECLARATION always creates a link, so the overloads chain and each
            '' keeps its own signature. Looking one up first made every 'declare
            '' constructor( ... )' reuse the first symbol, leaving a chain of one and
            '' every constructor call resolving to whichever came first.
            ''
            '' A DEFINITION attaches to what is already there instead, so a call site
            '' finds one symbol rather than two halves of one.
            if sp->b = Fbx.NODE_NONE then
                sid = Declare_( w, parentScope, declName, Fbx.SYM_PROC, _
                                w.ast->Loc( id ) )
            else
                sid = w.syms->LookupLocal( parentScope, declName )
                if sid = Fbx.SYMBOL_NONE then
                    sid = Declare_( w, parentScope, declName, Fbx.SYM_PROC, _
                                    w.ast->Loc( id ) )
                end if
            end if
            s = w.syms->SymbolAt( sid )
            if s <> 0 then
                BindCallConv( w, s, sp, id, (s->payload = 0) )
                s->flags or= Fbx.SYMF_DEFINED
                '' The payload is NOT overwritten. Every 'constructor T( ... )'
                '' definition looks up the same head-of-chain symbol, so writing the
                '' node here made all three overloads point at whichever was defined
                '' last -- and every constructor call resolved to that one. The
                '' DECLARATIONS carry the signatures, and a declaration node mangles
                '' identically to its definition, so they are what call sites use.
                if s->payload = 0 then s->payload = cast( long, id )
            end if
        end if

        '' Parameters and locals live in the procedure's own scope.
        ''
        '' A member DEFINITION -- 'sub T.M( )' -- declares nothing: the declaration
        '' inside the type already carries the symbol, its flags and its payload. But
        '' the scope still needs an OWNER, or it is a proc scope belonging to no
        '' procedure, and anything walking outward to ask "which procedure am I in"
        '' gets no answer. __FUNCTION__ inside a method is what found this.
        dim as Fbx.SymbolId scopeOwner = sid
        if (scopeOwner = Fbx.SYMBOL_NONE) andalso (declName <> 0) then
            scopeOwner = w.syms->LookupLocal( parentScope, declName )
        end if
        dim as Fbx.ScopeId inner = w.syms->OpenScope( Fbx.SCOPEK_PROC, parentScope, _
                                                      scopeOwner )
        '' The DEFINITION's scope is the one that owns THIS and the locals, so it is the
        '' one the symbol points at. A member definition declares no symbol of its own,
        '' so 's' is null there and only 'scopeOwner' names it -- and without this the
        '' body's scope was reachable from nothing and 'this' could not be found.
        if s <> 0 then
            s->inner = inner
        elseif scopeOwner <> Fbx.SYMBOL_NONE then
            dim as Fbx.Symbol ptr os = w.syms->SymbolAt( scopeOwner )
            if os <> 0 then os->inner = inner
        end if
        '' A member definition body may say 'this'. The receiver is implicit -- it is
        '' never written as a parameter -- so nothing else would ever declare it.
        '' Giving it the OWNING type is Resolve's job; existing is Collect's.
        if isMemberDef then
            Declare_( w, inner, w.names->Fold( w.names->GetString( "this" ) ), _
                      Fbx.SYM_PARAMETER, w.ast->Loc( id ) )
        end if
        w.info->SetScope( id, inner )
        '' 'scopeOwner', not 'sid': a member DEFINITION declares no symbol of its own,
        '' so sid is NONE there and the node would carry no reference at all. Lowering
        '' reads this to find the procedure it is in, and without it __FUNCTION__ inside
        '' a method lowered to an UNDEF that the call around it happily passed.
        if scopeOwner <> Fbx.SYMBOL_NONE then w.info->SetRef( id, scopeOwner )
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

'' How many parameters a procedure declaration writes.
private function ProcArity _
    ( byref w as Walker, byval sp as Fbx.StmtPayload ptr ) as long

    dim as long n = 0
    for i as long = 0 to sp->count - 1
        dim as Fbx.NodeId prm = cast( Fbx.NodeId, w.ast->children[sp->first + i] )
        if w.ast->Kind( prm ) = Fbx.N_PARAM then n += 1
    next
    return n
end function

'' The one DECLARED-but-not-yet-defined overload of this name taking 'want' parameters,
'' or SYMBOL_NONE when there is not exactly one.
''
'' Arity, not the full signature: Collect runs before any type is resolved, so it cannot
'' compare parameter TYPES. Requiring exactly one candidate is what keeps that
'' approximation safe -- two same-arity overloads leave the definition to declare itself,
'' which is the behaviour this replaces rather than a new way to be wrong.
private function UndefinedProcWithArity _
    ( byref w as Walker, byval scope_ as Fbx.ScopeId, byval nm as Fbx.InternId, _
      byval want as long ) as Fbx.SymbolId

    dim as Fbx.SymbolId found = Fbx.SYMBOL_NONE
    dim as long hits = 0
    dim as Fbx.SymbolId cur = w.syms->LookupLocal( scope_, nm )
    while cur <> Fbx.SYMBOL_NONE
        dim as Fbx.Symbol ptr s = w.syms->SymbolAt( cur )
        if s = 0 then exit while
        if s->kind <> cast( ubyte, Fbx.SYM_PROC ) then exit while
        if (s->flags and Fbx.SYMF_DEFINED) = 0 then
            dim as Fbx.NodeId pn = cast( Fbx.NodeId, s->payload )
            if (pn <> Fbx.NODE_NONE) andalso (w.ast->Kind( pn ) = Fbx.N_PROC) then
                if ProcArity( w, StmtOf( w, pn ) ) = want then
                    found = cur
                    hits += 1
                end if
            end if
        end if
        cur = s->nextOverload
    wend
    if hits = 1 then return found
    return Fbx.SYMBOL_NONE
end function

'' The calling convention across a DECLARE and its definition. The rule is ASYMMETRIC,
'' and measured on both targets rather than reasoned about:
''
''   declare cdecl  + definition (none)     inherits cdecl, emits '_A' on win32
''   declare (none) + definition stdcall    accepted -- ABSENT MEANS STDCALL
''   declare (none) + definition cdecl      error 41
''   declare (none) + definition pascal     error 41
''
'' So absence on the DEFINITION inherits, while absence on the DECLARATION is stdcall
'' and anything else contradicts it. fbc reports the same error on win64, where the
'' convention has no effect on any emitted name at all, so this is a syntactic rule and
'' not a target one.
private function Effective_( byval c as Fbx.CallConv ) as Fbx.CallConv
    if c = Fbx.CC_NONE then return Fbx.CC_STDCALL
    return c
end function

private sub BindCallConv _
    ( byref w as Walker, byval s as Fbx.Symbol ptr, _
      byval sp as Fbx.StmtPayload ptr, byval id as Fbx.NodeId, _
      byval firstSighting as boolean )

    dim as Fbx.CallConv here = Fbx.CallConvOf( sp->extra )
    if here = Fbx.CC_NONE then return
    if firstSighting then
        s->callConv = cast( ubyte, here )
        return
    end if
    dim as Fbx.CallConv had = cast( Fbx.CallConv, s->callConv )
    if Effective_( had ) = here then
        s->callConv = cast( ubyte, here )
        return
    end if
    dim as Fbx.SourceRange r = Fbx.PointRange( w.ast->Loc( id ) )
    w.diags->Report( Fbx.FBX0603, r, w.names->Spelling( s->name ) )
    w.diags->AddNote( Fbx.FBX0901, Fbx.PointRange( s->loc ) )
end sub

private function DeclareGlobal _
    ( byref syms as Fbx.SymbolTable, byref names as Fbx.Interner, _
      byref diags as Fbx.DiagnosticEngine, byval spelling as string ) as Fbx.SymbolId

    dim as boolean dup = false
    return syms.DeclareSym( Fbx.SCOPE_GLOBAL, _
                            names.Fold( names.GetString( spelling ) ), _
                            Fbx.SYM_CONSTANT, Fbx.LOC_NONE, dup )
end function

'' 'true' and 'false' are predeclared CONSTANTS carrying a built-in value: BOOLEAN,
'' and -1 and 0. Every part of that is measured -- 'typeof( true )' is BOOLEAN,
'' 'cint( true )' is -1 and 'sizeof( true )' is 1 -- because a language where a true
'' comparison is -1 is not one where 'true' can be assumed to be 1.
'' __FUNCTION__, whose value depends on WHERE it is used. Collect cannot know that, so
'' it only plants the marker; Check fills in the name and the type.
private sub DeclareFuncName _
    ( byref syms as Fbx.SymbolTable, byref names as Fbx.Interner, _
      byref diags as Fbx.DiagnosticEngine, byval spelling as string )

    dim as Fbx.SymbolId sid = DeclareGlobal( syms, names, diags, spelling )
    dim as Fbx.Symbol ptr s = syms.SymbolAt( sid )
    if s <> 0 then s->flags or= Fbx.SYMF_FUNCNAME
end sub

private sub DeclareBuiltinConst _
    ( byref syms as Fbx.SymbolTable, byref names as Fbx.Interner, _
      byref types as Fbx.TypeContext, byref diags as Fbx.DiagnosticEngine, _
      byval spelling as string, byval value as long )

    dim as Fbx.SymbolId sid = DeclareGlobal( syms, names, diags, spelling )
    dim as Fbx.Symbol ptr s = syms.SymbolAt( sid )
    if s = 0 then return
    s->flags or= Fbx.SYMF_BUILTIN
    s->type_ = types.Builtin( Fbx.TY_BOOLEAN )
    s->payload = value
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
    DeclareBuiltinConst( syms, names, types, diags, "true", -1 )
    DeclareBuiltinConst( syms, names, types, diags, "false", 0 )
    DeclareFuncName( syms, names, diags, "__function__" )
    '' __FUNCTION_NQ__ does NOT exist in -lang fb -- fbc reports a syntax error for it
    '' -- so it is declared and left untyped rather than given a value it cannot have.
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
            if (s->flags and Fbx.SYMF_BUILTIN) <> 0 then row += " builtin"
            if s->callConv <> cast( ubyte, Fbx.CC_NONE ) then
                row += " " & Fbx.CallConvName( cast( Fbx.CallConv, s->callConv ) )
            end if
            if (s->flags and Fbx.SYMF_FUNCNAME) <> 0 then row += " funcname"
            if s->nextOverload <> Fbx.SYMBOL_NONE then row += " +overloads"
            outp += row & chr( 10 )
            cur = s->nextInScope
        wend
    next
    return outp
end function

end namespace
