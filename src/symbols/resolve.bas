'' resolve.bas -- see resolve.bi

#include once "symbols/resolve.bi"
#include once "symbols/mangle.bi"
#include once "symbols/check.bi"
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
    as Fbx.SourceManager ptr srcMgr    '' only for the constant evaluator
    as Fbx.DiagnosticEngine ptr diags
    as Fbx.SemanticInfo ptr info
    as Stats ptr            st
    as Fbx.SymbolId         currentProc
end type

'' The scope '..' names. NOT SCOPE_GLOBAL, which holds only the builtins -- a module's
'' own declarations live in a SCOPEK_MODULE scope one level inside it, so looking in
'' the global scope found nothing and '..x' bound to no symbol at all.
''
'' Walking outward rather than caching an id keeps this correct if a file ever opens
'' more than one module scope.
declare function StmtOf _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.StmtPayload ptr

'' A procedure symbol declared STATIC. Static-ness lives on the AST payload, not on the
'' symbol, so it is read back through 'payload' -- which for a proc is its N_PROC node.
private function IsStaticProc_ _
    ( byref c as Ctx, byval sid as Fbx.SymbolId ) as boolean

    if sid = Fbx.SYMBOL_NONE then return false
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return false
    if s->kind <> cast( ubyte, Fbx.SYM_PROC ) then return false
    dim as Fbx.NodeId n = cast( Fbx.NodeId, s->payload )
    if n = Fbx.NODE_NONE then return false
    if cast( long, n ) >= c.ast->nodes.Count then return false
    if c.ast->Kind( n ) <> Fbx.N_PROC then return false
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, n )
    return ((sp->extra and Fbx.PF_STATIC) <> 0)
end function

private function FileScopeOf_ _
    ( byref c as Ctx, byval from_ as Fbx.ScopeId ) as Fbx.ScopeId

    dim as Fbx.ScopeId sc = from_
    dim as long guard = 0
    while (sc <> Fbx.SCOPE_NONE) andalso (guard < 256)
        guard += 1
        dim as Fbx.SymScope ptr s_ = c.syms->ScopeAt( sc )
        if s_ = 0 then exit while
        if s_->kind = cast( ubyte, Fbx.SCOPEK_MODULE ) then return sc
        sc = s_->parent
    wend
    return Fbx.SCOPE_GLOBAL
end function

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

'' The unsigned counterpart of an integer type, or TYPE_NONE when there is not one.
''
'' TYPE_NONE rather than the original: 'unsigned' applied to something with no unsigned
'' form is an error, and returning the signed type would compile a declaration whose type
'' is not what was written.
private function UnsignedCounterpart _
    ( byref c as Ctx, byval t as Fbx.TypeId ) as Fbx.TypeId

    if t = Fbx.TYPE_NONE then return Fbx.TYPE_NONE
    if c.types->Kind( t ) <> Fbx.TK_BUILTIN then return Fbx.TYPE_NONE
    select case c.types->BuiltinOf( t )
    case Fbx.TY_BYTE, Fbx.TY_UBYTE         : return c.types->Builtin( Fbx.TY_UBYTE )
    case Fbx.TY_SHORT, Fbx.TY_USHORT       : return c.types->Builtin( Fbx.TY_USHORT )
    case Fbx.TY_LONG, Fbx.TY_ULONG         : return c.types->Builtin( Fbx.TY_ULONG )
    case Fbx.TY_INTEGER, Fbx.TY_UINTEGER   : return c.types->Builtin( Fbx.TY_UINTEGER )
    case Fbx.TY_LONGINT, Fbx.TY_ULONGINT   : return c.types->Builtin( Fbx.TY_ULONGINT )
    end select
    return Fbx.TYPE_NONE
end function

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

    '' A TUPLE type: 'as (long, string)'. DESUGARED into a synthetic UDT with fields
    '' '_1'.._N, because that is exactly what fbc says it is -- the corpus test asserts
    '' the layout equals the equivalent hand-written TYPE, field for field.
    ''
    '' Building a symbol rather than a bare type is what makes the layout free: this
    '' runs BEFORE ComputeUdtLayouts, which walks symbols, so the tuple goes through
    '' the same offset and alignment code as everything else.
    ''
    '' Identity is STRUCTURAL, through a name built from the element type ids: two
    '' '(long, string)' written apart are one type, which is what makes them assignable
    '' to each other.
    if cast( Fbx.TokenKind, sp->op ) = Fbx.TK_LPAREN then
        dim as string key = "$tup"
        dim as FB.Array( of ulong ) elemTypes
        for i as long = 0 to sp->count - 1
            dim as Fbx.NodeId e = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
            dim as Fbx.TypeId et = ResolveTypeRef( c, e, scope_ )
            if et = Fbx.TYPE_NONE then
                '' An element that does not resolve yet: no type rather than a wrong
                '' one. Every use declines, which is the honest outcome.
                return Fbx.TYPE_NONE
            end if
            elemTypes.Push( cast( ulong, et ) )
            key += ":" & str( cast( long, et ) )
        next
        if elemTypes.Count = 0 then return Fbx.TYPE_NONE

        dim as Fbx.InternId tnm = c.names->Fold( c.names->GetString( key ) )
        dim as Fbx.SymbolId prev = c.syms->LookupLocalTyped( Fbx.SCOPE_GLOBAL, tnm, true )
        dim as Fbx.Symbol ptr ps = c.syms->SymbolAt( prev )
        if ps <> 0 then
            c.info->SetType( id, ps->type_ )
            return ps->type_
        end if

        dim as boolean dup = false
        dim as Fbx.SymbolId tsid = c.syms->DeclareSym( Fbx.SCOPE_GLOBAL, tnm, _
            Fbx.SYM_UDT, c.ast->Loc( id ), dup )
        dim as Fbx.Symbol ptr ts = c.syms->SymbolAt( tsid )
        if ts = 0 then return Fbx.TYPE_NONE
        dim as Fbx.ScopeId tin = c.syms->OpenScope( Fbx.SCOPEK_TYPE, Fbx.SCOPE_GLOBAL, tsid )
        ts->inner = tin
        ts->type_ = c.types->NamedType( Fbx.TK_UDT, tnm, cast( ulong, Fbx.SCOPE_GLOBAL ) )
        for i as long = 0 to elemTypes.Count - 1
            dim as Fbx.InternId fnm = c.names->Fold( c.names->GetString( "_" & str( i + 1 ) ) )
            dim as boolean fdup = false
            dim as Fbx.SymbolId fsid = c.syms->DeclareSym( tin, fnm, Fbx.SYM_FIELD, _
                c.ast->Loc( id ), fdup )
            dim as Fbx.Symbol ptr fs = c.syms->SymbolAt( fsid )
            if fs <> 0 then fs->type_ = cast( Fbx.TypeId, elemTypes[i] )
        next
        c.info->SetType( id, ts->type_ )
        return ts->type_
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
    case Fbx.KW_UNSIGNED
        '' 'unsigned <typedef>'. The parser put the typedef's name here and left the
        '' keyword in 'op'; the type is whatever that name resolves to, made unsigned.
        ''
        '' If it cannot be made unsigned -- a UDT, a pointer, something not integral --
        '' the result is left as TYPE_NONE rather than falling back to the SIGNED type.
        '' A wrong type that compiles is worse than a type error: the parse failure this
        '' replaces was at least visible.
        '' A TYPE name, so the lookup asks for the type-name class: 'dim as ubyte ptr pb'
        '' followed by 'type pb as ubyte' puts the VARIABLE in the slot, and a plain
        '' lookup then typed 'dim as pb v' as a POINTER where fbc gives one byte.
        dim as Fbx.SymbolId usid = c.syms->LookupTyped( scope_, sp->name, true )
        if usid <> Fbx.SYMBOL_NONE then
            c.info->SetRef( id, usid )
            dim as Fbx.Symbol ptr us = c.syms->SymbolAt( usid )
            if us->type_ <> Fbx.TYPE_NONE then
                base_ = UnsignedCounterpart( c, us->type_ )
            end if
        end if

    case else
        '' A named type. Not finding it is NOT reported here: a type may come from a
        '' header this build did not parse, and drowning the output in those would
        '' hide the real signal. Check reports what it can prove.
        dim as Fbx.SymbolId sid = c.syms->LookupTyped( scope_, sp->name, true )
        if sid <> Fbx.SYMBOL_NONE then
            c.info->SetRef( id, sid )
            dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
            if s->type_ <> Fbx.TYPE_NONE then base_ = s->type_
        end if
    end select

    '' 'zstring * 5' is FIVE BYTES, and 'wstring * 4' is four code units -- eight
    '' bytes on Windows, sixteen on Linux. Both are modelled as an ARRAY of the
    '' element, which is exactly what they are, so the layout falls out of the array
    '' rule instead of needing its own.
    if (sp->c <> Fbx.NODE_NONE) andalso (base_ <> Fbx.TYPE_NONE) then
        select case k
        case Fbx.KW_ZSTRING, Fbx.KW_WSTRING, Fbx.KW_USTRING
            dim as Fbx.Check.ConstVal lv = _
                Fbx.Check.ConstOf( *c.ast, sp->c, *c.srcMgr, *c.names, _
                                   c.types->target.pointerBits )
            if lv.known andalso (lv.value > 0) then
                base_ = c.types->ArrayOf( base_, 1, cast( long, lv.value ) )
            end if
        end select
    end if

    if (n->flags and Fbx.NF_CONST) <> 0 then
        base_ = c.types->Qualify( base_, Fbx.TF_CONST )
    end if
    c.info->SetType( id, base_ )
    return base_
end function

'' ------------------------------------------------------------------- walking

'' THIS, inside a method body. Collect declares the parameter -- it is never written, so
'' nothing else would -- and this gives it the owning type. Without it 'this.v' was
'' untyped, 'this.M( )' lowered with no receiver at all, and every unqualified reference
'' to a sibling member had nothing to resolve against.
''
'' The type comes from the enclosing scope chain rather than from the procedure's name:
'' a member DEFINITION opens its scope inside the TYPE's, which is what makes 'this', the
'' sibling fields and the mangled name all come out of one arrangement.
private sub BindThis( byref c as Ctx, byval procScope as Fbx.ScopeId )
    dim as Fbx.SymbolId tsid = _
        c.syms->LookupLocal( procScope, c.names->Fold( c.names->GetString( "this" ) ) )
    if tsid = Fbx.SYMBOL_NONE then return
    dim as Fbx.Symbol ptr ts = c.syms->SymbolAt( tsid )
    if ts = 0 then return
    if ts->type_ <> Fbx.TYPE_NONE then return

    dim as Fbx.ScopeId cur = procScope
    while cur <> Fbx.SCOPE_NONE
        dim as Fbx.SymScope ptr s = c.syms->ScopeAt( cur )
        if s = 0 then exit while
        if s->kind = cast( ubyte, Fbx.SCOPEK_TYPE ) then
            '' A POINTER to the type, not the type: the ABI passes an address, fbc's
            '' own C spells the parameter 'struct $1T*', and every member access
            '' already reaches through a pointer base.
            dim as Fbx.Symbol ptr owner = c.syms->SymbolAt( s->owner )
            if owner <> 0 then
                if owner->type_ <> Fbx.TYPE_NONE then
                    ts->type_ = c.types->Pointer_( owner->type_ )
                end if
            end if
            exit while
        end if
        cur = s->parent
    wend
end sub

declare sub WalkStmt _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval scope_ as Fbx.ScopeId )

'' Give a just-declared name its type. The symbol is found by NAME in the scope
'' Collect recorded, rather than by threading a SymbolId through the AST: the
'' declaration and its symbol are in the same scope by construction.
private sub BindDeclType _
    ( byref c as Ctx, byval scope_ as Fbx.ScopeId, byval nm as Fbx.InternId, _
      byval t as Fbx.TypeId )

    if (nm = 0) orelse (t = Fbx.TYPE_NONE) then return
    '' A VALUE's type. If a type name shares the spelling, the slot may hold either
    '' one, so the class is asked for rather than assumed.
    dim as Fbx.SymbolId sid = c.syms->LookupLocalTyped( scope_, nm, false )
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
        '' A name in EXPRESSION position wants the VALUE, not a type of the same
        '' spelling. 'sub UDT1( )' beside 'type UDT1' is legal -- the two live in
        '' different classes -- and the slot holds whichever came first, so a plain
        '' lookup found the TYPE and reported "'udt1' is a type, not a procedure" for
        '' a call to the SUB.
        ''
        '' LookupTyped falls back to the plain lookup when no value of that name
        '' exists, so a type reference that does reach here still resolves.
        dim as Fbx.SymbolId sid = c.syms->LookupTyped( scope_, nm, false )
        if sid <> Fbx.SYMBOL_NONE then
            c.info->SetRef( id, sid )
            c.st->references += 1
            '' __FUNCTION__ types PER USE -- 'zstring * n' where n is the length of the
            '' enclosing procedure's name -- so it is settled here, where the scope is
            '' in hand. Check cannot: Collect records scopes and never walks a
            '' procedure BODY, so ScopeOf on an expression node inside one is
            '' SCOPE_NONE. At module level there is no enclosing procedure and the node
            '' stays untyped, which is fbc's answer too: it expands __FUNCTION__ to the
            '' undeclared __FB_MAINPROC__ and reports error 42.
            dim as Fbx.Symbol ptr fs = c.syms->SymbolAt( sid )
            if fs <> 0 then
                if (fs->flags and Fbx.SYMF_FUNCNAME) <> 0 then
                    dim as string fn = Fbx.Mangle.EnclosingProcName( _
                        *c.syms, scope_, *c.names )
                    c.info->SetType( id, c.types->ArrayOf( _
                        c.types->Builtin( Fbx.TY_ZSTRING ), 1, len( fn ) + 1 ) )
                end if
            end if
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
        dim as Fbx.BinaryPayload ptr mb = @c.ast->binaries[cast( long, n->data )]
        WalkExpr( c, mb->lhs, scope_ )

        '' EXCEPT when the base is a NAMESPACE. 'ns.Greet' is a QUALIFIED NAME, not a
        '' member access on a value, so the member is looked up in the namespace's own
        '' scope and bound here -- there is no base type to wait for.
        ''
        '' Without this the head of 'ns.Greet( 1 )' was a namespace and the call was
        '' reported as "'ns' is a namespace, not a procedure". fbcunit's CU_ASSERT
        '' expands to exactly that shape, which is why it accounted for the bulk of
        '' every unlowered count in the corpus.
        '' '..x' -- the base is the GLOBAL SCOPE itself, so the member is looked up
        '' there. A chain '..a.b.v' needs nothing more: '..a' binds to the namespace
        '' here, and the enclosing member access then takes the namespace path below.
        if c.ast->Kind( mb->lhs ) = Fbx.N_GLOBALSCOPE then
            if c.ast->Kind( mb->rhs ) = Fbx.N_IDENT then
                dim as Fbx.SymbolId gsid = _
                    c.syms->LookupLocal( FileScopeOf_( c, scope_ ), IdentNameOf( c, mb->rhs ) )
                if gsid <> Fbx.SYMBOL_NONE then
                    c.info->SetRef( mb->rhs, gsid )
                    c.info->SetRef( id, gsid )
                end if
            end if
            return
        end if

        dim as Fbx.SymbolId bsid = c.info->RefOf( mb->lhs )
        dim as Fbx.Symbol ptr bs = c.syms->SymbolAt( bsid )
        if bs <> 0 then
            if bs->kind = cast( ubyte, Fbx.SYM_NAMESPACE ) then
                if c.ast->Kind( mb->rhs ) = Fbx.N_IDENT then
                    '' IdentNameOf, not StmtOf: an N_IDENT is not a statement payload,
                    '' and reading it as one is the pool mistake this codebase keeps
                    '' making.
                    dim as Fbx.SymbolId msid = _
                        c.syms->LookupLocal( bs->inner, IdentNameOf( c, mb->rhs ) )
                    if msid <> Fbx.SYMBOL_NONE then
                        c.info->SetRef( mb->rhs, msid )
                        c.info->SetRef( id, msid )
                    end if
                end if
            elseif bs->kind = cast( ubyte, Fbx.SYM_UDT ) then
                '' 'T.foo( )' where T is the TYPE, not a variable of it: a STATIC
                '' member, qualified by its type exactly as a namespace member is by
                '' its namespace. The base being the UDT SYMBOL is what tells this from
                '' 'obj.foo( )', whose base is a VARIABLE.
                ''
                '' Bound ONLY when the member is actually static. fbc rejects a
                '' non-static one -- error 214, 'Member isn't static' -- and binding it
                '' here would lower a member call with NO RECEIVER, silently. Leaving
                '' it unbound keeps the existing diagnostic: the wrong message for the
                '' right outcome, which is the safe half to be wrong on.
                if c.ast->Kind( mb->rhs ) = Fbx.N_IDENT then
                    dim as Fbx.SymbolId msid = _
                        c.syms->LookupLocal( bs->inner, IdentNameOf( c, mb->rhs ) )
                    if IsStaticProc_( c, msid ) then
                        c.info->SetRef( mb->rhs, msid )
                        c.info->SetRef( id, msid )
                    end if
                end if
            end if
        end if

    case Fbx.N_CALL, Fbx.N_INDEX, Fbx.N_PAREN, Fbx.N_TUPLE, Fbx.N_INITIALIZER, _
         Fbx.N_STRCAT
        dim as Fbx.ListPayload ptr lp = ListOf( c, id )
        WalkExpr( c, lp->target, scope_ )
        for i as long = 0 to lp->count - 1
            dim as Fbx.NodeId arg = cast( Fbx.NodeId, c.ast->children[lp->first + i] )
            '' 'cast( long, x )' and 'cptr( any ptr, x )' put a TYPE in argument
            '' position. WalkExpr has nothing to say about one, and leaving it
            '' unresolved left every cast untyped -- the type argument IS the result.
            if c.ast->Kind( arg ) = Fbx.N_TYPEREF then
                ResolveTypeRef( c, arg, scope_ )
            else
                WalkExpr( c, arg, scope_ )
            end if
        next
    end select
end sub

'' The parser's three-way ambiguity, decided now that the target's symbol is known
'' (docs/plan/07 section 8). The payoff is the diagnostic: where fbc reports a syntax
'' error, fbx can say what the name actually is.

'' An array type from a declaration's bounds, or the base type unchanged when there are
'' none.
''
'' THE PARSER SPELLS BOUNDS TWO DIFFERENT WAYS, which is why this takes node lists
'' rather than a payload:
''
''   N_FIELD      flat (lo, hi) children          as long f(0 to 3)
''   N_VAR_ITEM   an N_BLOCK of N_CASE_RANGE      dim as long a(0 to 9)
''
'' Both are collected into (lo, hi) pairs here so the arithmetic exists once. Assuming
'' the field shape for both is what left every LOCAL array typed as its element -- four
'' bytes where forty were needed -- and that went unnoticed only because indexing was
'' not lowered either.
''
'' A missing low bound means 0: 'a(9)' is 'a(0 to 9)'. BOUNDS ARE RETAINED, not just
'' their product, because indexing needs each dimension's stride and its lbound bias.
'' Nothing is folded when any bound is non-constant.
'' How many elements the initializer has at nesting level 'depth'. N_INITIALIZER is a
'' LIST node, so its children come from the list pool -- reading a statement payload
'' here would land on an unrelated node, which is the mistake this codebase has made
'' six times.
private function InitCountAt _
    ( byref c as Ctx, byval init as Fbx.NodeId, byval depth as long ) as long

    dim as Fbx.NodeId n = init
    for level as long = 0 to depth
        if n = Fbx.NODE_NONE then return -1
        if c.ast->Kind( n ) <> Fbx.N_INITIALIZER then return -1
        dim as Fbx.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
        if level = depth then return lp->count
        if lp->count = 0 then return -1
        n = cast( Fbx.NodeId, c.ast->children[lp->first] )
    next
    return -1
end function

'' 'init' is the declaration's initializer, or NODE_NONE. It is needed because an
'' ellipsis bound takes its size from there and from nowhere else -- fbc refuses
'' 'dim a(0 to ...)' with no initializer outright (error 281).
''
'' Getting this wrong would not be a decline. An unknown bound makes this return the
'' ELEMENT type, so the array becomes eight bytes where twenty-four were needed and
'' nothing says so -- which is exactly what parsing '...' without inferring it did.
private function ArrayFromPairs _
    ( byref c as Ctx, byval base_ as Fbx.TypeId, _
      byref los as FB.Array( of ulong ), byref his as FB.Array( of ulong ), _
      byval init as Fbx.NodeId = Fbx.NODE_NONE ) as Fbx.TypeId

    if los.Count = 0 then return base_
    if base_ = Fbx.TYPE_NONE then return base_

    dim as long total = 1
    dim as boolean known = true
    dim as FB.Array( of longint ) bounds
    for i as long = 0 to los.Count - 1
        dim as longint lo = 0
        dim as Fbx.NodeId loN = cast( Fbx.NodeId, los[i] )
        if loN <> Fbx.NODE_NONE then
            dim as Fbx.Check.ConstVal lv = _
                Fbx.Check.ConstOf( *c.ast, loN, *c.srcMgr, *c.names, _
                                   c.types->target.pointerBits )
            if lv.known then lo = lv.value else known = false
        end if
        dim as longint hi = lo - 1
        dim as Fbx.NodeId hiN = cast( Fbx.NodeId, his[i] )
        if (hiN <> Fbx.NODE_NONE) andalso (c.ast->Kind( hiN ) = Fbx.N_ELLIPSIS) then
            '' The bound the initializer implies: lbound + count - 1, per dimension.
            dim as long got = InitCountAt( c, init, i )
            if got > 0 then hi = lo + got - 1 else known = false
        elseif hiN <> Fbx.NODE_NONE then
            dim as Fbx.Check.ConstVal hv = _
                Fbx.Check.ConstOf( *c.ast, hiN, *c.srcMgr, *c.names, _
                                   c.types->target.pointerBits )
            if hv.known then hi = hv.value else known = false
        else
            known = false
        end if
        if known then total *= cast( long, hi - lo + 1 )
        bounds.Push( lo )
        bounds.Push( hi )
    next
    if (known = false) orelse (total <= 0) then return base_
    return c.types->ArrayOf( base_, los.Count, total, @bounds )
end function

'' N_FIELD: flat (lo, hi) children.
private function ArrayFromBounds _
    ( byref c as Ctx, byval base_ as Fbx.TypeId, byval first as long, _
      byval count as long ) as Fbx.TypeId

    dim as FB.Array( of ulong ) los, his
    dim as long i = 0
    while i + 1 < count + 1 andalso i + 1 <= count - 1
        los.Push( c.ast->children[first + i] )
        his.Push( c.ast->children[first + i + 1] )
        i += 2
    wend
    return ArrayFromPairs( c, base_, los, his )
end function

'' N_VAR_ITEM: an N_BLOCK of N_CASE_RANGE, one per dimension.
private function ArrayFromBoundsNode _
    ( byref c as Ctx, byval base_ as Fbx.TypeId, byval id as Fbx.NodeId, _
      byval init as Fbx.NodeId = Fbx.NODE_NONE ) as Fbx.TypeId

    if id = Fbx.NODE_NONE then return base_
    if c.ast->Kind( id ) <> Fbx.N_BLOCK then return base_
    dim as Fbx.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as FB.Array( of ulong ) los, his
    for i as long = 0 to lp->count - 1
        dim as Fbx.NodeId d = cast( Fbx.NodeId, c.ast->children[lp->first + i] )
        if c.ast->Kind( d ) = Fbx.N_CASE_RANGE then
            '' 'a(0 to 9)' -- both bounds written out.
            dim as Fbx.StmtPayload ptr dp = StmtOf( c, d )
            los.Push( cast( ulong, dp->a ) )
            his.Push( cast( ulong, dp->b ) )
        else
            '' 'a(9)' -- a bare expression, which is the UPPER bound with an implicit
            '' lower bound of 0. It is not an N_CASE_RANGE at all, so a loop that only
            '' accepts one silently gives the array no dimensions and drops it back to
            '' its element type.
            los.Push( cast( ulong, Fbx.NODE_NONE ) )
            his.Push( cast( ulong, d ) )
        end if
    next
    return ArrayFromPairs( c, base_, los, his, init )
end function



private sub ResolveAmbiguous _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval scope_ as Fbx.ScopeId )

    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    WalkExpr( c, sp->a, scope_ )
    WalkExpr( c, sp->b, scope_ )
    for i as long = 0 to sp->count - 1
        WalkExpr( c, cast( Fbx.NodeId, c.ast->children[sp->first + i] ), scope_ )
    next

    dim as boolean isAssign = (sp->op <> 0)

    '' 'function = expr' names no symbol, so it cannot reach the lookup below -- but it
    '' is the SAME statement as 'f = expr' inside f, and both belong in one bucket. The
    '' keyword form used to decline at a different line from the name form, which is
    '' the shape that made 'amb other' mislead for four commits.
    if c.ast->Kind( sp->a ) = Fbx.N_FUNCRESULT then
        c.info->SetAmbiguous( id, Fbx.AMB_RESULT )
        c.st->assigns += 1
        return
    end if

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

    '' A QUALIFIED name binds on the MEMBER node itself, so prefer that over the head:
    '' for 'ns.Greet( 1 )' the head is the namespace and tells us nothing useful, while
    '' the member resolved to the procedure.
    dim as Fbx.SymbolId sid = c.info->RefOf( head )
    if c.ast->Kind( sp->a ) = Fbx.N_MEMBER then
        dim as Fbx.SymbolId qsid = c.info->RefOf( sp->a )
        if qsid <> Fbx.SYMBOL_NONE then sid = qsid
    elseif c.ast->Kind( sp->a ) = Fbx.N_CALL then
        dim as Fbx.NodeId callee = ListOf( c, sp->a )->target
        if c.ast->Kind( callee ) = Fbx.N_MEMBER then
            dim as Fbx.SymbolId qsid = c.info->RefOf( callee )
            if qsid <> Fbx.SYMBOL_NONE then sid = qsid
        end if
    end if
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
            '' 'dim as long a(0 to 9)' is an ARRAY of long, not a long. Without this a
            '' local array reserved one ELEMENT -- four bytes where forty were needed --
            '' which nothing noticed only because indexing was not lowered either.
            t = ArrayFromBoundsNode( c, t, ip->c, ip->b )
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

    case Fbx.N_TYPEDEF
        '' 'type myint as long'. Collect gave the symbol a NAMED type of its own, with
        '' nothing behind it, so every 'dim as myint' resolved to nothing and lowered to
        '' void -- silently, since an unknown type name is deliberately not reported
        '' (it may come from a header this build did not read).
        ''
        '' A TYPEDEF IS TRANSPARENT. Measured from fbc: 'sub F( byval a as myint )' and
        '' 'sub G( byval a as long )' mangle to _Z1Fi and _Z1Gi -- the same encoding, so
        '' the alias leaves no trace in the ABI. Binding the symbol straight to the
        '' aliased type therefore gives the right answer for type checking, for layout
        '' and for mangling at once, rather than needing each to unwrap it.
        '' Set DIRECTLY rather than through BindDeclType, which only fills a type that
        '' is still TYPE_NONE. Collect has already put a placeholder named type here, so
        '' the ordinary bind is a silent no-op -- which is exactly what it did.
        dim as Fbx.StmtPayload ptr tsp = StmtOf( c, id )
        dim as Fbx.TypeId aliased = ResolveTypeRef( c, tsp->a, here )
        if (aliased <> Fbx.TYPE_NONE) andalso (tsp->name <> 0) then
            '' The TYPEDEF, not a variable of the same name -- when the variable was
            '' declared first it holds the slot, and the typedef never got its type.
            dim as Fbx.SymbolId tsid = c.syms->LookupLocalTyped( here, tsp->name, true )
            dim as Fbx.Symbol ptr tsym = c.syms->SymbolAt( tsid )
            if tsym <> 0 then
                if tsym->kind = cast( ubyte, Fbx.SYM_TYPEDEF ) then tsym->type_ = aliased
            end if
        end if
        '' The extra names of 'type as integer a, b'.
        for i as long = 0 to tsp->count - 1
            WalkStmt( c, cast( Fbx.NodeId, c.ast->children[tsp->first + i] ), here )
        next
        return

    case Fbx.N_FIELD
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        dim as Fbx.TypeId t = ResolveTypeRef( c, sp->a, here )
        '' A field declared with bounds is an ARRAY of that type. The bounds are
        '' low/high pairs and the element count is their product -- which the layout
        '' needs, and which was simply lost while the bounds were being skipped.
        t = ArrayFromBounds( c, t, sp->first, sp->count )
        BindDeclType( c, here, sp->name, t )
        return

    case Fbx.N_FOR, Fbx.N_FOREACH
        '' 'for i as integer' DECLARES i, and Collect named it -- but nothing bound
        '' its TYPE, so every use of the counter came out untyped. The 'as' clause
        '' is in 'c', which is also what told Collect it was a declaration.
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        if sp->c <> Fbx.NODE_NONE then
            dim as Fbx.TypeId t = ResolveTypeRef( c, sp->c, here )
            if (sp->a <> Fbx.NODE_NONE) andalso _
               (c.ast->Kind( sp->a ) = Fbx.N_IDENT) then
                dim as Fbx.IdentPayload ptr ip = _
                    @c.ast->idents[cast( long, c.ast->nodes[cast( long, sp->a )].data )]
                BindDeclType( c, here, ip->name, t )
            end if
        end if
        WalkExpr( c, sp->a, here )
        for i as long = 0 to sp->count - 1
            WalkStmt( c, cast( Fbx.NodeId, c.ast->children[sp->first + i] ), here )
        next
        WalkStmt( c, sp->b, here )
        return

    case Fbx.N_PROC
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        dim as Fbx.SymbolId saved = c.currentProc
        c.currentProc = c.info->RefOf( id )
        '' The RETURN type belongs on the procedure's symbol, or a call to it can
        '' never be typed. Parameters are bound by the N_PARAM case below.
        dim as Fbx.TypeId ret = ResolveTypeRef( c, sp->a, here )
        dim as Fbx.Symbol ptr ps = c.syms->SymbolAt( c.currentProc )
        if (ps <> 0) andalso (ret <> Fbx.TYPE_NONE) andalso _
           (ps->type_ = Fbx.TYPE_NONE) then
            ps->type_ = ret
        end if
        BindThis( c, here )
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
      byref src as Fbx.SourceManager, _
      byref info as Fbx.SemanticInfo, byref st as Stats )

    dim as Ctx c
    c.srcMgr = @src
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
