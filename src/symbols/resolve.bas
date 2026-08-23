'' resolve.bas -- see resolve.bi

#include once "symbols/resolvectx.bi"
#include once "symbols/mangle.bi"
#include once "symbols/check.bi"
#include once "lexer/keywords.bi"

namespace Tko

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

namespace Tko.Resolve


'' The scope '..' names. NOT SCOPE_GLOBAL, which holds only the builtins -- a module's
'' own declarations live in a SCOPEK_MODULE scope one level inside it, so looking in
'' the global scope found nothing and '..x' bound to no symbol at all.
''
'' Walking outward rather than caching an id keeps this correct if a file ever opens
'' more than one module scope.
'' Defined below; ResolveTypeRef above it resolves a 'typeof' operand expression.
declare sub WalkExpr _
    ( byref c as Ctx, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId )

'' A procedure symbol declared STATIC. Static-ness lives on the AST payload, not on the
'' symbol, so it is read back through 'payload' -- which for a proc is its N_PROC node.
private function IsStaticProc_ _
    ( byref c as Ctx, byval sid as Tko.SymbolId ) as boolean

    if sid = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return false
    if s->kind <> cast( ubyte, Tko.SYM_PROC ) then return false
    dim as Tko.NodeId n = cast( Tko.NodeId, s->payload )
    if n = Tko.NODE_NONE then return false
    if cast( long, n ) >= c.ast->nodes.Count then return false
    if c.ast->Kind( n ) <> Tko.N_PROC then return false
    dim as Tko.StmtPayload ptr sp = StmtOf( c, n )
    return ((sp->extra and Tko.PF_STATIC) <> 0)
end function

private function FileScopeOf_ _
    ( byref c as Ctx, byval from_ as Tko.ScopeId ) as Tko.ScopeId

    dim as Tko.ScopeId sc = from_
    dim as long guard = 0
    while (sc <> Tko.SCOPE_NONE) andalso (guard < 256)
        guard += 1
        dim as Tko.SymScope ptr s_ = c.syms->ScopeAt( sc )
        if s_ = 0 then exit while
        if s_->kind = cast( ubyte, Tko.SCOPEK_MODULE ) then return sc
        sc = s_->parent
    wend
    return Tko.SCOPE_GLOBAL
end function

function StmtOf _
    ( byref c as Ctx, byval id as Tko.NodeId ) as Tko.StmtPayload ptr
    if id = Tko.NODE_NONE then return 0
    return @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
end function

function ListOf _
    ( byref c as Ctx, byval id as Tko.NodeId ) as Tko.ListPayload ptr
    if id = Tko.NODE_NONE then return 0
    return @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
end function

function IdentNameOf _
    ( byref c as Ctx, byval id as Tko.NodeId ) as Tko.InternId
    if c.ast->Kind( id ) <> Tko.N_IDENT then return Tko.INTERN_NONE
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
    ( byref c as Ctx, byval t as Tko.TypeId ) as Tko.TypeId

    if t = Tko.TYPE_NONE then return Tko.TYPE_NONE
    if c.types->Kind( t ) <> Tko.TK_BUILTIN then return Tko.TYPE_NONE
    select case c.types->BuiltinOf( t )
    case Tko.TY_BYTE, Tko.TY_UBYTE         : return c.types->Builtin( Tko.TY_UBYTE )
    case Tko.TY_SHORT, Tko.TY_USHORT       : return c.types->Builtin( Tko.TY_USHORT )
    case Tko.TY_LONG, Tko.TY_ULONG         : return c.types->Builtin( Tko.TY_ULONG )
    case Tko.TY_INTEGER, Tko.TY_UINTEGER   : return c.types->Builtin( Tko.TY_UINTEGER )
    case Tko.TY_LONGINT, Tko.TY_ULONGINT   : return c.types->Builtin( Tko.TY_ULONGINT )
    end select
    return Tko.TYPE_NONE
end function

function ResolveTypeRef _
    ( byref c as Ctx, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId ) as Tko.TypeId

    if id = Tko.NODE_NONE then return Tko.TYPE_NONE
    if c.ast->Kind( id ) <> Tko.N_TYPEREF then return Tko.TYPE_NONE

    dim as Tko.AstNode ptr n = @c.ast->nodes[cast( long, id )]
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    c.st->typeRefs += 1

    '' A pointer level wraps whatever it contains.
    if (n->flags and Tko.NF_PTR) <> 0 then
        dim as Tko.TypeId inner = ResolveTypeRef( c, sp->a, scope_ )
        dim as Tko.TypeId t = c.types->Pointer_( inner )
        if (n->flags and Tko.NF_CONST) <> 0 then t = c.types->Qualify( t, Tko.TF_CONST )
        c.info->SetType( id, t )
        return t
    end if

    '' 'as sub( ... )' / 'as function( ... ) as T'. In FreeBASIC a procedure type is
    '' already a POINTER -- 'sub( ) ptr' is PPFvvE, one P for the type itself and one
    '' for the written 'ptr' -- so the pointer is built in here, not by the caller.
    if (n->flags and Tko.NF_PROC_TYPE) <> 0 then
        dim as Tko.TypeId ret = Tko.TYPE_NONE
        if sp->a <> Tko.NODE_NONE then
            ret = ResolveTypeRef( c, sp->a, scope_ )
        else
            ret = c.types->Builtin( Tko.TY_VOID )
        end if
        dim as Tko.TypeIdVec2 ps
        for i as long = 0 to sp->count - 1
            dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[sp->first + i] )
            if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
            dim as Tko.StmtPayload ptr pp = StmtOf( c, prm )
            dim as Tko.TypeId pt = ResolveTypeRef( c, pp->a, scope_ )
            if (c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) <> 0 then
                pt = c.types->Reference( pt )
            end if
            ps.Push( cast( ulong, pt ) )
        next
        dim as Tko.TypeId pf = c.types->Pointer_( c.types->ProcType( ret, ps ) )
        if (n->flags and Tko.NF_CONST) <> 0 then
            pf = c.types->Qualify( pf, Tko.TF_CONST )
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
    if cast( Tko.TokenKind, sp->op ) = Tko.TK_LPAREN then
        dim as string key = "$tup"
        dim as FB.Array( of ulong ) elemTypes
        for i as long = 0 to sp->count - 1
            dim as Tko.NodeId e = cast( Tko.NodeId, c.ast->children[sp->first + i] )
            dim as Tko.TypeId et = ResolveTypeRef( c, e, scope_ )
            if et = Tko.TYPE_NONE then
                '' An element that does not resolve yet: no type rather than a wrong
                '' one. Every use declines, which is the honest outcome.
                return Tko.TYPE_NONE
            end if
            elemTypes.Push( cast( ulong, et ) )
            key += ":" & str( cast( long, et ) )
        next
        if elemTypes.Count = 0 then return Tko.TYPE_NONE

        dim as Tko.InternId tnm = c.names->Fold( c.names->GetString( key ) )
        dim as Tko.SymbolId prev = c.syms->LookupLocalTyped( Tko.SCOPE_GLOBAL, tnm, true )
        dim as Tko.Symbol ptr ps = c.syms->SymbolAt( prev )
        if ps <> 0 then
            c.info->SetType( id, ps->type_ )
            return ps->type_
        end if

        dim as boolean dup = false
        dim as Tko.SymbolId tsid = c.syms->DeclareSym( Tko.SCOPE_GLOBAL, tnm, _
            Tko.SYM_UDT, c.ast->Loc( id ), dup )
        dim as Tko.Symbol ptr ts = c.syms->SymbolAt( tsid )
        if ts = 0 then return Tko.TYPE_NONE
        dim as Tko.ScopeId tin = c.syms->OpenScope( Tko.SCOPEK_TYPE, Tko.SCOPE_GLOBAL, tsid )
        ts->inner = tin
        ts->type_ = c.types->NamedType( Tko.TK_UDT, tnm, cast( ulong, Tko.SCOPE_GLOBAL ) )
        for i as long = 0 to elemTypes.Count - 1
            dim as Tko.InternId fnm = c.names->Fold( c.names->GetString( "_" & str( i + 1 ) ) )
            dim as boolean fdup = false
            dim as Tko.SymbolId fsid = c.syms->DeclareSym( tin, fnm, Tko.SYM_FIELD, _
                c.ast->Loc( id ), fdup )
            dim as Tko.Symbol ptr fs = c.syms->SymbolAt( fsid )
            if fs <> 0 then fs->type_ = cast( Tko.TypeId, elemTypes[i] )
        next
        c.info->SetType( id, ts->type_ )
        return ts->type_
    end if

    dim as Tko.TypeId base_ = Tko.TYPE_NONE
    dim as Tko.TokenKind k = cast( Tko.TokenKind, sp->op )

    select case k
    case Tko.KW_BYTE     : base_ = c.types->Builtin( Tko.TY_BYTE )
    case Tko.KW_UBYTE    : base_ = c.types->Builtin( Tko.TY_UBYTE )
    case Tko.KW_SHORT    : base_ = c.types->Builtin( Tko.TY_SHORT )
    case Tko.KW_USHORT   : base_ = c.types->Builtin( Tko.TY_USHORT )
    case Tko.KW_LONG     : base_ = c.types->Builtin( Tko.TY_LONG )
    case Tko.KW_ULONG    : base_ = c.types->Builtin( Tko.TY_ULONG )
    case Tko.KW_INTEGER  : base_ = c.types->Builtin( Tko.TY_INTEGER )
    case Tko.KW_UINTEGER : base_ = c.types->Builtin( Tko.TY_UINTEGER )
    case Tko.KW_LONGINT  : base_ = c.types->Builtin( Tko.TY_LONGINT )
    case Tko.KW_ULONGINT : base_ = c.types->Builtin( Tko.TY_ULONGINT )
    case Tko.KW_SINGLE   : base_ = c.types->Builtin( Tko.TY_SINGLE )
    case Tko.KW_DOUBLE   : base_ = c.types->Builtin( Tko.TY_DOUBLE )
    case Tko.KW_BOOLEAN  : base_ = c.types->Builtin( Tko.TY_BOOLEAN )
    case Tko.KW_STRING   : base_ = c.types->Builtin( Tko.TY_STRING )
    case Tko.KW_ZSTRING  : base_ = c.types->Builtin( Tko.TY_ZSTRING )
    case Tko.KW_WSTRING  : base_ = c.types->Builtin( Tko.TY_WSTRING )
    case Tko.KW_USTRING  : base_ = c.types->Builtin( Tko.TY_USTRING )
    case Tko.KW_ANY      : base_ = c.types->Builtin( Tko.TY_ANY )
    case Tko.KW_UNSIGNED
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
        dim as Tko.SymbolId usid = c.syms->LookupTyped( scope_, sp->name, true )
        if usid <> Tko.SYMBOL_NONE then
            c.info->SetRef( id, usid )
            dim as Tko.Symbol ptr us = c.syms->SymbolAt( usid )
            if us->type_ <> Tko.TYPE_NONE then
                base_ = UnsignedCounterpart( c, us->type_ )
            end if
        end if

    case Tko.KW_TYPEOF
        '' AN EXPRESSION OPERAND IS STILL AN EXPRESSION and has to be resolved, or the
        '' names in it bind to nothing and Check can say nothing about its type.
        '' 'typeof( n + n )' came out untyped for exactly that reason while
        '' 'typeof( cuint( n ) )' worked -- a conversion intrinsic's result type does
        '' not depend on its operand, so it hid the gap.
        if sp->b <> Tko.NODE_NONE then WalkExpr( c, sp->b, scope_ )

        '' 'typeof( x )' AS A TYPE. The parser keeps the operand when it is a bare
        '' name, which is what the corpus writes; the type is whatever that name has,
        '' a variable's or a type's alike. fbc agrees on both: '#print typeof( s )'
        '' over 'dim s as double' is DOUBLE, and over a UDT name it is the UDT.
        ''
        '' A more complicated operand was discarded by the parser and stays unresolved
        '' here, which is what it was before.
        if sp->rawName <> 0 then
            dim as Tko.SymbolId tsid2 = c.syms->Lookup( scope_, sp->rawName )
            dim as Tko.Symbol ptr ts2 = c.syms->SymbolAt( tsid2 )
            if ts2 <> 0 then
                if ts2->type_ <> Tko.TYPE_NONE then
                    base_ = ts2->type_
                    '' A REFERENCE is transparent: 'typeof( n )' over a byref
                    '' parameter is the referent's type, as it is in an expression.
                    if c.types->Kind( base_ ) = Tko.TK_REFERENCE then
                        base_ = c.types->Inner( base_ )
                    end if
                end if
            end if
        end if

    case else
        '' 'cva_list' IS A PREDEFINED TYPE NAME, not a keyword. fbc treats it as an
        '' ordinary identifier -- 'dim as long cva_list' is error 4, DUPLICATED
        '' DEFINITION, not a syntax error -- so it is resolved here, where a named type
        '' is, rather than in the keyword switch above. Anything the program declares
        '' under that name is found by the lookup below and wins, which is what makes
        '' this a PREDEFINITION rather than a reserved word.
        ''
        '' Its width is target-dependent and lives in TargetLayout; see TY_CVA_LIST.
        if sp->ownerName = 0 then
            if c.syms->LookupTyped( scope_, sp->name, true ) = Tko.SYMBOL_NONE then
                if Tko.Text.LowerAscii( c.names->Spelling( sp->name ) ) = "cva_list" then
                    base_ = c.types->Builtin( Tko.TY_CVA_LIST )
                end if
            end if
        end if

        '' A named type. Not finding it is NOT reported here: a type may come from a
        '' header this build did not parse, and drowning the output in those would
        '' hide the real signal. Check reports what it can prove.
        ''
        '' QUALIFIED first: 'dim as nsab.T1 v' names a type in a namespace, and an
        '' ordinary lookup walks only PARENT scopes -- it never descends into one. The
        '' qualifier is what the parser now keeps in 'ownerName'.
        '' A TYPE PARAMETER, inside a generic being instantiated. It shadows anything
        '' of the same spelling, which is what 'typeparam-shadowing' is about: a
        '' variable named 't' anywhere in scope must not capture 'as T'.
        for gi as long = c.gparamName.Count - 1 to 0 step -1
            if cast( Tko.InternId, c.gparamName[gi] ) = sp->name then
                base_ = cast( Tko.TypeId, c.gparamType[gi] )
                c.info->SetType( id, base_ )
                return base_
            end if
        next

        dim as Tko.SymbolId sid = Tko.SYMBOL_NONE
        if sp->ownerName <> 0 then
            '' The qualifier may be a PATH -- 'a.b.c' -- which the parser keeps dotted
            '' in one field. Walk it a component at a time: only the FIRST component is
            '' visible from the current scope, and each later one is looked up INSIDE
            '' what the previous one opened.
            dim as string qpath = c.names->Spelling( sp->ownerName )
            dim as Tko.ScopeId sc = scope_
            dim as boolean first_ = true
            dim as boolean ok = true
            dim as long at = 0
            while at <= len( qpath )
                dim as long dot = instr( at + 1, qpath, "." )
                dim as long stop_ = dot
                if stop_ = 0 then stop_ = len( qpath ) + 1
                dim as string comp = mid( qpath, at + 1, stop_ - at - 1 )
                if len( comp ) = 0 then
                    ok = false
                    exit while
                end if
                dim as Tko.InternId cid = c.names->GetString( comp )
                dim as Tko.SymbolId qsid
                if first_ then
                    qsid = c.syms->Lookup( sc, cid )
                else
                    qsid = c.syms->LookupLocalTyped( sc, cid, true )
                end if
                dim as Tko.Symbol ptr qs = c.syms->SymbolAt( qsid )
                if qs = 0 then
                    ok = false
                    exit while
                end if
                dim as boolean qualifies = _
                    (qs->kind = cast( ubyte, Tko.SYM_NAMESPACE )) orelse _
                    (qs->kind = cast( ubyte, Tko.SYM_UDT ))
                if (qualifies = false) orelse (qs->inner = Tko.SCOPE_NONE) then
                    ok = false
                    exit while
                end if
                sc = qs->inner
                first_ = false
                if dot = 0 then exit while
                at = dot
            wend
            if ok andalso (first_ = false) then
                sid = c.syms->LookupLocalTyped( sc, sp->name, true )
            end if
        end if
        if sid = Tko.SYMBOL_NONE then sid = c.syms->LookupTyped( scope_, sp->name, true )

        '' AN INSTANTIATION -- 'Box( of long )'. One type per (generic, arguments),
        '' cached, built in the GLOBAL scope. See InstantiateGeneric_.
        ''
        '' TRIED AFTER THE LOOKUP, and given the symbol it found. It used to look the
        '' generic up itself, unqualified, from the use site's scope -- so
        '' 'FB.Array( of long )' found nothing, instantiated nothing, and bound to the
        '' GENERIC instead. Every container in the runtime headers lives in a namespace,
        '' so that was all of them.
        if sp->count > 0 then
            dim as Tko.TypeId inst = InstantiateGeneric_( c, id, sp, scope_, sid )
            if inst <> Tko.TYPE_NONE then
                c.info->SetType( id, inst )
                return inst
            end if
        end if

        if sid <> Tko.SYMBOL_NONE then
            c.info->SetRef( id, sid )
            dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
            '' A TYPEDEF STILL HOLDING ITS PLACEHOLDER is not resolved. Collect gives
            '' every typedef a TK_TYPEDEF named type with nothing behind it. Taking that
            '' here made 'dim as t i', where t aliases a type declared LATER, bind to
            '' something that lowers to VOID -- and the declaration never looked
            '' unresolved, so nothing came back to it.
            dim as boolean ready = (s->type_ <> Tko.TYPE_NONE)
            if ready then ready = (c.types->Kind( s->type_ ) <> Tko.TK_TYPEDEF)
            if ready then base_ = s->type_
        end if
    end select

    '' 'zstring * 5' is FIVE BYTES, and 'wstring * 4' is four code units -- eight
    '' bytes on Windows, sixteen on Linux. Both are modelled as an ARRAY of the
    '' element, which is exactly what they are, so the layout falls out of the array
    '' rule instead of needing its own.
    if (sp->c <> Tko.NODE_NONE) andalso (base_ <> Tko.TYPE_NONE) then
        select case k
        case Tko.KW_ZSTRING, Tko.KW_WSTRING, Tko.KW_USTRING, Tko.KW_STRING
            '' 'string * N' IS NOT 'string'. It is the FIXED-LENGTH, space-padded
            '' flavour -- N raw bytes, no descriptor -- and resolving it to the plain
            '' string builtin gave it a 24-byte descriptor where fbc has N bytes, so
            '' every one was the wrong size and every access read the wrong thing.
            dim as Tko.Check.ConstVal lv = _
                Tko.Check.ConstOf( *c.ast, sp->c, *c.srcMgr, *c.names, _
                                   c.types->target.pointerBits, c.syms, scope_ )
            if lv.known andalso (lv.value > 0) then
                if k = Tko.KW_STRING then base_ = c.types->Builtin( Tko.TY_FIXSTR )
                '' 'ustring * N' NEEDS ITS OWN ELEMENT for the same reason 'string * N'
                '' does: the plain builtin is a 24-byte DESCRIPTOR, so an array of N of
                '' them is N descriptors rather than N characters. Measured -- fbc gives
                '' 'as ustring * 4' a sizeof of 8 and this gave it 96.
                if k = Tko.KW_USTRING then base_ = c.types->Builtin( Tko.TY_FIXUSTR )
                base_ = c.types->ArrayOf( base_, 1, cast( long, lv.value ) )
            end if
        end select
    end if

    if (n->flags and Tko.NF_CONST) <> 0 then
        base_ = c.types->Qualify( base_, Tko.TF_CONST )
    end if
    c.info->SetType( id, base_ )
    return base_
end function

'' ------------------------------------------------------------------- walking


'' A possibly-dotted name -- 'UDT', 'ns.UDT', 'a.b.UDT' -- resolved to its symbol.
''
'' Only the FIRST component is visible from the starting scope; each later one is looked
'' up INSIDE what the previous opened. Shared by qualified type references and by
'' BindThis, which needs the same walk for a structor defined outside its namespace.
private function LookupDottedType_ _
    ( byref c as Ctx, byval scope_ as Tko.ScopeId, _
      byval path as Tko.InternId ) as Tko.SymbolId

    dim as string qpath = c.names->Spelling( path )
    dim as Tko.ScopeId sc = scope_
    dim as boolean first_ = true
    dim as long at = 0
    dim as Tko.SymbolId found = Tko.SYMBOL_NONE

    while at <= len( qpath )
        dim as long dot = instr( at + 1, qpath, "." )
        dim as long stop_ = dot
        if stop_ = 0 then stop_ = len( qpath ) + 1
        dim as string comp = mid( qpath, at + 1, stop_ - at - 1 )
        if len( comp ) = 0 then return Tko.SYMBOL_NONE
        dim as Tko.InternId cid = c.names->GetString( comp )

        dim as Tko.SymbolId sid
        if first_ then
            sid = c.syms->Lookup( sc, cid )
        else
            sid = c.syms->LookupLocalTyped( sc, cid, true )
        end if
        dim as Tko.Symbol ptr sym = c.syms->SymbolAt( sid )
        if sym = 0 then return Tko.SYMBOL_NONE
        found = sid
        first_ = false

        if dot = 0 then exit while
        '' Only a NAMESPACE or a UDT opens a scope to descend into.
        dim as boolean opens = _
            (sym->kind = cast( ubyte, Tko.SYM_NAMESPACE )) orelse _
            (sym->kind = cast( ubyte, Tko.SYM_UDT ))
        if (opens = false) orelse (sym->inner = Tko.SCOPE_NONE) then
            return Tko.SYMBOL_NONE
        end if
        sc = sym->inner
        at = dot
    wend
    return found
end function

'' THIS, inside a method body. Collect declares the parameter -- it is never written, so
'' nothing else would -- and this gives it the owning type. Without it 'this.v' was
'' untyped, 'this.M( )' lowered with no receiver at all, and every unqualified reference
'' to a sibling member had nothing to resolve against.
''
'' The type comes from the enclosing scope chain rather than from the procedure's name:
'' a member DEFINITION opens its scope inside the TYPE's, which is what makes 'this', the
'' sibling fields and the mangled name all come out of one arrangement.
private sub BindThis _
    ( byref c as Ctx, byval procScope as Tko.ScopeId, _
      byval ownerName as Tko.InternId = 0 )
    dim as Tko.SymbolId tsid = _
        c.syms->LookupLocal( procScope, c.names->Fold( c.names->GetString( "this" ) ) )
    if tsid = Tko.SYMBOL_NONE then return
    dim as Tko.Symbol ptr ts = c.syms->SymbolAt( tsid )
    if ts = 0 then return
    if ts->type_ <> Tko.TYPE_NONE then return

    dim as Tko.ScopeId cur = procScope
    while cur <> Tko.SCOPE_NONE
        dim as Tko.SymScope ptr s = c.syms->ScopeAt( cur )
        if s = 0 then exit while
        if s->kind = cast( ubyte, Tko.SCOPEK_TYPE ) then
            '' A POINTER to the type, not the type: the ABI passes an address, fbc's
            '' own C spells the parameter 'struct $1T*', and every member access
            '' already reaches through a pointer base.
            dim as Tko.Symbol ptr owner = c.syms->SymbolAt( s->owner )
            if owner <> 0 then
                if owner->type_ <> Tko.TYPE_NONE then
                    ts->type_ = c.types->Pointer_( owner->type_ )
                end if
            end if
            exit while
        end if
        cur = s->parent
    wend

    '' NO TYPE SCOPE ANYWHERE UP THE CHAIN. A member DEFINED OUTSIDE its namespace --
    ''
    ''     namespace ns : type UDT : ... : end type : end namespace
    ''     constructor ns.UDT( ) : ... : end constructor
    ''
    '' -- opens its body at MODULE scope, so the walk above finds nothing and 'this'
    '' stays untyped. It then gets a VOID slot, and the receiver store into it is what
    '' the MIR verifier had been reporting for twelve corpus files.
    ''
    '' The procedure's own qualified name is what says which type it belongs to. It may
    '' be a PATH -- 'a.b.UDT' -- so it walks the same way a qualified TYPE REFERENCE
    '' does.
    if (ts->type_ = Tko.TYPE_NONE) andalso (ownerName <> 0) then
        dim as Tko.SymbolId osid = LookupDottedType_( c, procScope, ownerName )
        dim as Tko.Symbol ptr os = c.syms->SymbolAt( osid )
        if os <> 0 then
            if os->type_ <> Tko.TYPE_NONE then
                ts->type_ = c.types->Pointer_( os->type_ )
            end if
        end if
    end if
end sub

'' Give a just-declared name its type. The symbol is found by NAME in the scope
'' Collect recorded, rather than by threading a SymbolId through the AST: the
'' declaration and its symbol are in the same scope by construction.
sub BindDeclType _
    ( byref c as Ctx, byval scope_ as Tko.ScopeId, byval nm as Tko.InternId, _
      byval t as Tko.TypeId )

    if (nm = 0) orelse (t = Tko.TYPE_NONE) then return
    '' A VALUE's type. If a type name shares the spelling, the slot may hold either
    '' one, so the class is asked for rather than assumed.
    dim as Tko.SymbolId sid = c.syms->LookupLocalTyped( scope_, nm, false )
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return
    if s->type_ = Tko.TYPE_NONE then s->type_ = t
end sub

'' Bind identifiers inside an expression. A member name after a dot is NOT resolved
'' here: it needs the base's type, which is Check's business.
private sub WalkExpr _
    ( byref c as Ctx, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId )

    if id = Tko.NODE_NONE then return
    dim as Tko.NodeKind k = c.ast->Kind( id )
    dim as Tko.AstNode ptr n = @c.ast->nodes[cast( long, id )]

    select case k
    case Tko.N_IDENT
        dim as Tko.InternId nm = IdentNameOf( c, id )
        '' A name in EXPRESSION position wants the VALUE, not a type of the same
        '' spelling. 'sub UDT1( )' beside 'type UDT1' is legal -- the two live in
        '' different classes -- and the slot holds whichever came first, so a plain
        '' lookup found the TYPE and reported "'udt1' is a type, not a procedure" for
        '' a call to the SUB.
        ''
        '' LookupTyped falls back to the plain lookup when no value of that name
        '' exists, so a type reference that does reach here still resolves.
        dim as Tko.SymbolId sid = c.syms->LookupTyped( scope_, nm, false )
        if sid <> Tko.SYMBOL_NONE then
            c.info->SetRef( id, sid )
            c.st->references += 1
            '' __FUNCTION__ types PER USE -- 'zstring * n' where n is the length of the
            '' enclosing procedure's name -- so it is settled here, where the scope is
            '' in hand. Check cannot: Collect records scopes and never walks a
            '' procedure BODY, so ScopeOf on an expression node inside one is
            '' SCOPE_NONE. At module level there is no enclosing procedure and the node
            '' stays untyped, which is fbc's answer too: it expands __FUNCTION__ to the
            '' undeclared __FB_MAINPROC__ and reports error 42.
            dim as Tko.Symbol ptr fs = c.syms->SymbolAt( sid )
            if fs <> 0 then
                if (fs->flags and Tko.SYMF_FUNCNAME) <> 0 then
                    dim as string fn = Tko.Mangle.EnclosingProcName( _
                        *c.syms, scope_, *c.names )
                    c.info->SetType( id, c.types->ArrayOf( _
                        c.types->Builtin( Tko.TY_ZSTRING ), 1, len( fn ) + 1 ) )
                end if
            end if
        elseif cast( long, nm ) <= TKO_KEYWORD_COUNT then
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

    case Tko.N_UNARY, Tko.N_ADDROF, Tko.N_DEREF
        WalkExpr( c, c.ast->unaries[cast( long, n->data )].operand, scope_ )

    case Tko.N_BINARY
        dim as Tko.BinaryPayload ptr bp = @c.ast->binaries[cast( long, n->data )]
        WalkExpr( c, bp->lhs, scope_ )
        WalkExpr( c, bp->rhs, scope_ )

    case Tko.N_MEMBER
        '' Only the base: the member name needs the base's type.
        dim as Tko.BinaryPayload ptr mb = @c.ast->binaries[cast( long, n->data )]

        '' '.field' WITH NO BASE is the WITH shorthand, and the base it wants is the
        '' subject of the innermost open WITH. The parser cannot supply it -- it does
        '' not track which WITH is open -- so it is filled in here, by pointing the
        '' member at the subject's own node.
        ''
        '' That makes the tree a DAG: one expression node reached from two places, and
        '' lowered once per use. Which is why only an LVALUE is accepted as a subject
        '' (see WalkStmt's N_WITH) -- re-evaluating 'p' or '*q' is free and gives the
        '' same answer, while re-evaluating a CALL would run it once per '.field', and
        '' fbc runs it once.
        if mb->lhs = Tko.NODE_NONE then
            if c.withSubject.Count > 0 then
                mb->lhs = cast( Tko.NodeId, _
                                c.withSubject[c.withSubject.Count - 1] )
            end if
        end if
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
        if c.ast->Kind( mb->lhs ) = Tko.N_GLOBALSCOPE then
            if c.ast->Kind( mb->rhs ) = Tko.N_IDENT then
                dim as Tko.SymbolId gsid = _
                    c.syms->LookupLocal( FileScopeOf_( c, scope_ ), IdentNameOf( c, mb->rhs ) )
                if gsid <> Tko.SYMBOL_NONE then
                    c.info->SetRef( mb->rhs, gsid )
                    c.info->SetRef( id, gsid )
                end if
            end if
            return
        end if

        dim as Tko.SymbolId bsid = c.info->RefOf( mb->lhs )
        dim as Tko.Symbol ptr bs = c.syms->SymbolAt( bsid )
        if bs <> 0 then
            if bs->kind = cast( ubyte, Tko.SYM_NAMESPACE ) then
                if c.ast->Kind( mb->rhs ) = Tko.N_IDENT then
                    '' IdentNameOf, not StmtOf: an N_IDENT is not a statement payload,
                    '' and reading it as one is the pool mistake this codebase keeps
                    '' making.
                    dim as Tko.SymbolId msid = _
                        c.syms->LookupLocal( bs->inner, IdentNameOf( c, mb->rhs ) )
                    if msid <> Tko.SYMBOL_NONE then
                        c.info->SetRef( mb->rhs, msid )
                        c.info->SetRef( id, msid )
                    end if
                end if
            elseif bs->kind = cast( ubyte, Tko.SYM_UDT ) then
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
                if c.ast->Kind( mb->rhs ) = Tko.N_IDENT then
                    dim as Tko.SymbolId msid = _
                        c.syms->LookupLocal( bs->inner, IdentNameOf( c, mb->rhs ) )

                    '' A CONSTANT declared inside a TYPE is reached the same way and
                    '' takes no receiver at all: 'type T : const c0 = 7 : end type'
                    '' then 'T.c0' is 7 to fbc, and 'var w = T.c0' is an INTEGER.
                    '' Only procedures were bound here, so every such reference was
                    '' untyped -- 270 of the corpus's remaining verifier failures are
                    '' one file doing exactly this, 'var i00 = T0.c0'.
                    '' A NESTED TYPE is bound for the same reason: 'T0.T1.c1' is
                    '' one member access on another, and the inner one has to resolve
                    '' to the nested UDT before the outer can look inside it. Neither
                    '' takes a receiver, which is what separates both from an
                    '' instance member.
                    dim as Tko.Symbol ptr ms = c.syms->SymbolAt( msid )
                    dim as boolean isConstMember = false
                    if ms <> 0 then
                        select case cast( Tko.SymbolKind, ms->kind )
                        case Tko.SYM_CONSTANT, Tko.SYM_ENUMCONST, Tko.SYM_UDT, _
                             Tko.SYM_ENUM, Tko.SYM_TYPEDEF
                            isConstMember = true
                        end select
                    end if

                    if IsStaticProc_( c, msid ) orelse isConstMember then
                        c.info->SetRef( mb->rhs, msid )
                        c.info->SetRef( id, msid )
                    end if
                end if
            end if
        end if

    case Tko.N_NEW
        '' 'new T' -- the TARGET IS A TYPE, not a value, so it is resolved as a type
        '' reference and the ordinary WalkExpr below would find nothing to bind.
        dim as Tko.ListPayload ptr np = ListOf( c, id )
        if np->target <> Tko.NODE_NONE then
            dim as Tko.TypeId nt = ResolveTypeRef( c, np->target, scope_ )
            if nt <> Tko.TYPE_NONE then c.info->SetType( np->target, nt )
        end if
        for i as long = 0 to np->count - 1
            WalkExpr( c, cast( Tko.NodeId, c.ast->children[np->first + i] ), scope_ )
        next
        return

    case Tko.N_CALL, Tko.N_INDEX, Tko.N_PAREN, Tko.N_TUPLE, Tko.N_INITIALIZER, _
         Tko.N_STRCAT
        dim as Tko.ListPayload ptr lp = ListOf( c, id )
        '' 'type<P>( 5, 6 )' PUTS A TYPE IN THE TARGET, not an expression. Walking it
        '' as one leaves the literal with no type at all, and every use of it -- an
        '' initialiser, an argument, a parameter default -- then has nothing to build.
        if (lp->target <> Tko.NODE_NONE) andalso _
           (c.ast->Kind( lp->target ) = Tko.N_TYPEREF) then
            ResolveTypeRef( c, lp->target, scope_ )
        else
            WalkExpr( c, lp->target, scope_ )
        end if

        '' THE CALL NODE CARRIES ITS CALLEE, which lowering reads off it. A direct
        '' call gets one because the target's own binding is copied up elsewhere; a
        '' call THROUGH A PROCEDURE POINTER did not, so 'dim as sub( ) p = procptr( f )
        '' : p( )' reached lowering with no callee at all and was counted as unbound.
        '' The target is a VARIABLE here, and that is exactly what says the call is
        '' indirect.
        if c.ast->Kind( id ) = Tko.N_CALL then
            '' 'Ok( of Decimal, FinanceError )( v )' -- A GENERIC PROCEDURE, whose type
            '' arguments the parser recorded against this node. Tried BEFORE the
            '' ordinary binding below: the target names the GENERIC, and copying that
            '' binding up would point the call at a procedure with no code.
            dim as Tko.SymbolId gpi = InstantiateGenericProc_( c, id, scope_ )
            if gpi <> Tko.SYMBOL_NONE then
                c.info->SetRef( id, gpi )
                c.info->SetRef( lp->target, gpi )
            elseif c.info->RefOf( id ) = Tko.SYMBOL_NONE then
                c.info->SetRef( id, c.info->RefOf( lp->target ) )
            end if
        end if
        for i as long = 0 to lp->count - 1
            dim as Tko.NodeId arg = cast( Tko.NodeId, c.ast->children[lp->first + i] )
            '' 'cast( long, x )' and 'cptr( any ptr, x )' put a TYPE in argument
            '' position. WalkExpr has nothing to say about one, and leaving it
            '' unresolved left every cast untyped -- the type argument IS the result.
            if c.ast->Kind( arg ) = Tko.N_TYPEREF then
                ResolveTypeRef( c, arg, scope_ )
            else
                WalkExpr( c, arg, scope_ )
            end if
        next
    end select
end sub

'' The parser's three-way ambiguity, decided now that the target's symbol is known
'' (docs/plan/07 section 8). The payoff is the diagnostic: where fbc reports a syntax
'' error, tiko-lang can say what the name actually is.

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
function InitCountAt _
    ( byref c as Ctx, byval init as Tko.NodeId, byval depth as long ) as long

    dim as Tko.NodeId n = init
    for level as long = 0 to depth
        if n = Tko.NODE_NONE then return -1
        if c.ast->Kind( n ) <> Tko.N_INITIALIZER then return -1
        dim as Tko.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
        if level = depth then return lp->count
        if lp->count = 0 then return -1
        n = cast( Tko.NodeId, c.ast->children[lp->first] )
    next
    return -1
end function




'' N_FIELD: flat (lo, hi) children.
function ArrayFromBounds _
    ( byref c as Ctx, byval base_ as Tko.TypeId, byval first as long, _
      byval count as long ) as Tko.TypeId

    dim as FB.Array( of ulong ) los, his
    dim as long i = 0
    while i + 1 < count + 1 andalso i + 1 <= count - 1
        los.Push( c.ast->children[first + i] )
        his.Push( c.ast->children[first + i + 1] )
        i += 2
    wend
    return ArrayFromPairs( c, base_, los, his )
end function




private sub ResolveAmbiguous _
    ( byref c as Ctx, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId )

    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    WalkExpr( c, sp->a, scope_ )
    WalkExpr( c, sp->b, scope_ )
    for i as long = 0 to sp->count - 1
        WalkExpr( c, cast( Tko.NodeId, c.ast->children[sp->first + i] ), scope_ )
    next

    dim as boolean isAssign = (sp->op <> 0)

    '' 'function = expr' names no symbol, so it cannot reach the lookup below -- but it
    '' is the SAME statement as 'f = expr' inside f, and both belong in one bucket. The
    '' keyword form used to decline at a different line from the name form, which is
    '' the shape that made 'amb other' mislead for four commits.
    if c.ast->Kind( sp->a ) = Tko.N_FUNCRESULT then
        c.info->SetAmbiguous( id, Tko.AMB_RESULT )
        c.st->assigns += 1
        return
    end if

    '' The target's head symbol: for a.b.c the head is a.
    dim as Tko.NodeId head = sp->a
    dim as long guard = 0
    while guard < 64
        guard += 1
        dim as Tko.NodeKind hk = c.ast->Kind( head )
        if hk = Tko.N_MEMBER then
            head = c.ast->binaries[cast( long, c.ast->nodes[cast( long, head )].data )].lhs
        elseif (hk = Tko.N_CALL) orelse (hk = Tko.N_INDEX) then
            head = ListOf( c, head )->target
        else
            exit while
        end if
    wend

    '' A QUALIFIED name binds on the MEMBER node itself, so prefer that over the head:
    '' for 'ns.Greet( 1 )' the head is the namespace and tells us nothing useful, while
    '' the member resolved to the procedure.
    dim as Tko.SymbolId sid = c.info->RefOf( head )
    if c.ast->Kind( sp->a ) = Tko.N_MEMBER then
        dim as Tko.SymbolId qsid = c.info->RefOf( sp->a )
        if qsid <> Tko.SYMBOL_NONE then sid = qsid
    elseif c.ast->Kind( sp->a ) = Tko.N_CALL then
        dim as Tko.NodeId callee = ListOf( c, sp->a )->target
        if c.ast->Kind( callee ) = Tko.N_MEMBER then
            dim as Tko.SymbolId qsid = c.info->RefOf( callee )
            if qsid <> Tko.SYMBOL_NONE then sid = qsid
        end if
    end if
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )

    if isAssign then
        '' Assigning to the enclosing function name is BASIC's result assignment.
        dim as boolean isResult = (c.currentProc <> Tko.SYMBOL_NONE) andalso _
                                  (sid = c.currentProc)
        if isResult then
            c.info->SetAmbiguous( id, Tko.AMB_RESULT )
        else
            c.info->SetAmbiguous( id, Tko.AMB_ASSIGN )
        end if
        c.st->assigns += 1
        return
    end if

    if s = 0 then
        c.info->SetAmbiguous( id, Tko.AMB_CALL )
        c.st->calls += 1
        return
    end if

    select case cast( Tko.SymbolKind, s->kind )
    case Tko.SYM_PROC
        c.info->SetAmbiguous( id, Tko.AMB_CALL )
        c.st->calls += 1
    case Tko.SYM_UDT, Tko.SYM_ENUM, Tko.SYM_TYPEDEF, Tko.SYM_NAMESPACE
        '' This is the diagnostic the ambiguous node exists to make possible.
        dim as Tko.SourceRange r = Tko.PointRange( c.ast->Loc( id ) )
        c.diags->Report( Tko.TKO0602, r, c.names->Spelling( s->name ), _
                         Tko.SymbolKindName( cast( Tko.SymbolKind, s->kind ) ) )
        c.info->SetAmbiguous( id, Tko.AMB_ERROR )
    case else
        c.info->SetAmbiguous( id, Tko.AMB_CALL )
        c.st->calls += 1
    end select
end sub

sub WalkStmt _
    ( byref c as Ctx, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId )

    if id = Tko.NODE_NONE then return
    dim as Tko.NodeKind k = c.ast->Kind( id )
    dim as Tko.NodeCategory cat = Tko.NodeKindCategory( k )

    '' Collect recorded the scope for anything that opened one; otherwise inherit.
    dim as Tko.ScopeId here = c.info->ScopeOf( id )
    if here = Tko.SCOPE_NONE then here = scope_

    if cat = Tko.NCAT_EXPR then
        WalkExpr( c, id, here )
        return
    end if

    select case k
    case Tko.N_MODULE, Tko.N_BLOCK
        '' FIRST AND COUNT SNAPSHOTTED, and the pending instantiations drained BETWEEN
        '' statements -- see WalkBlock_ for why both.
        WalkBlock_( c, id, here )
        return

    case Tko.N_ASSERT
        '' '#assert expr' -- a COMPILE-TIME check, not a runtime one, and not a
        '' preprocessor directive either: its expression is ordinary FreeBASIC and may
        '' name constants, enum members and sizeof, which the preprocessor cannot see.
        ''
        '' Measured against fbc: '#assert 1 = 2' is error 308, "#ASSERT condition
        '' failed"; '#assert sizeof(integer) = 8' and '#assert B = 1' over an enum
        '' member pass; and a condition that is NOT constant -- '#assert i = 1' over a
        '' variable -- is error 11, "Expected constant". So an unfoldable condition is
        '' a diagnostic in its own right, not something to pass over quietly.
        ''
        '' 720 of these stood unlowered, which said nothing about them being unchecked:
        '' they emit no code either way, so the decline was the only trace that the
        '' check itself was missing.
        dim as Tko.StmtPayload ptr asp = StmtOf( c, id )
        WalkExpr( c, asp->a, here )
        dim as Tko.Check.ConstVal av = Tko.Check.ConstOf( _
            *c.ast, asp->a, *c.srcMgr, *c.names, _
            c.types->target.pointerBits, c.syms, here )
        '' REPORTED ONLY WHEN THE ANSWER IS KNOWN AND FALSE. fbc also rejects a
        '' condition that is not constant at all -- '#assert i = 1' over a variable is
        '' its error 11 -- but tiko-lang's constant evaluator cannot fold 'sizeof( T )', and
        '' '#assert sizeof( integer ) = 8' appears in seventeen corpus files. Reporting
        '' every unfoldable condition would turn all of them into errors fbc does not
        '' have, so the check stays SILENT where it cannot tell. A missing diagnostic
        '' is a gap; a false one is a wrong compiler. TKO0605 is spelled and left for
        '' when sizeof folds.
        if av.known andalso (av.value = 0) then
            c.diags->Report( Tko.TKO0604, Tko.PointRange( c.ast->Loc( id ) ) )
        end if
        return

    case Tko.N_USING
        '' 'using FB' makes a namespace's names visible unqualified from here on. It
        '' was PARSED and then dropped -- 175 statements that did nothing -- which is
        '' why the runtime headers have to write 'FB.FB_RTERROR_ILLEGALFUNCTIONCALL' in
        '' full and say so in their own comments.
        ''
        '' Registered against the scope the USING appears in, so it applies for the
        '' rest of that scope and no further, and searched after the scope's own names
        '' and before its parent's -- a local declaration beats an import, an import
        '' beats an outer name.
        ''
        '' A DOTTED path 'using a.b' only reaches here as its LAST component, because
        '' the parser overwrites the name per component. Single-name imports, which is
        '' every one in the corpus and the headers, are exact.
        dim as Tko.StmtPayload ptr usp = StmtOf( c, id )
        if usp->name <> 0 then
            dim as Tko.SymbolId nsid = c.syms->Lookup( here, usp->name )
            dim as Tko.Symbol ptr nss = c.syms->SymbolAt( nsid )
            if nss <> 0 then
                if nss->kind = cast( ubyte, Tko.SYM_NAMESPACE ) then
                    c.syms->AddUsing( here, nss->inner )
                end if
            end if
        end if
        return

    case Tko.N_WITH
        '' 'with expr' ... '.field' ... 'end with'. The subject is resolved once, then
        '' pushed so every baseless member inside takes it as a base.
        ''
        '' ONLY AN LVALUE. The base is shared by pointing at the subject's node, so the
        '' subject is lowered once per use inside the body; that is free for a variable
        '' or a dereference and WRONG for anything with a side effect. A subject that
        '' is not an lvalue leaves the stack alone, the members stay baseless, and the
        '' body declines exactly as it did before -- which is the honest outcome, not a
        '' silently doubled call.
        dim as Tko.StmtPayload ptr wsp = StmtOf( c, id )
        WalkExpr( c, wsp->a, here )
        dim as boolean pushed = false
        if wsp->a <> Tko.NODE_NONE then
            select case c.ast->Kind( wsp->a )
            case Tko.N_IDENT, Tko.N_MEMBER, Tko.N_DEREF, Tko.N_INDEX
                c.withSubject.Push( cast( ulong, wsp->a ) )
                pushed = true
            end select
        end if
        WalkStmt( c, wsp->b, here )
        if pushed then c.withSubject.Pop( )
        return

    case Tko.N_AMBIGUOUS
        ResolveAmbiguous( c, id, here )
        return

    case Tko.N_TYPEREF
        ResolveTypeRef( c, id, here )
        return

    case Tko.N_ENUM
        '' THE MEMBERS' VALUES. Nothing computed them: every enum constant in the tree
        '' was ZERO. 'error( FB.FB_RTERROR_ILLEGALFUNCTIONCALL )' raised error 0, and
        '' every SELECT CASE over an enum compared against 0 -- lowered, verified, and
        '' wrong, with nothing to report.
        ''
        '' The rule, measured by RUNNING fbc: numbering starts at 0, an explicit
        '' '= expr' sets the running value, and each later member is the previous plus
        '' one. 'A, B, C = 10, D, F = K + 1, G' with 'const K = 7' prints 0 1 10 11 8 9.
        '' The initialiser is a constant EXPRESSION and may name another constant, which
        '' is why this is here and not in Collect: folding it needs the symbol table
        '' populated and a SourceManager, and Collect has neither at that point.
        dim as Tko.StmtPayload ptr esp = StmtOf( c, id )
        dim as longint enumNext = 0
        for i as long = 0 to esp->count - 1
            dim as Tko.NodeId it = cast( Tko.NodeId, c.ast->children[esp->first + i] )
            if c.ast->Kind( it ) <> Tko.N_ENUM_ITEM then continue for
            dim as Tko.StmtPayload ptr ip = StmtOf( c, it )
            if ip->b <> Tko.NODE_NONE then
                dim as Tko.Check.ConstVal ev = Tko.Check.ConstOf( _
                    *c.ast, ip->b, *c.srcMgr, *c.names, 64, c.syms, here )
                '' An initialiser that will not fold leaves the running value alone:
                '' wrong by ONE member rather than by all of them.
                if ev.known then enumNext = ev.value
            end if
            dim as Tko.SymbolId esid = c.syms->LookupLocal( here, ip->name )
            dim as Tko.Symbol ptr es = c.syms->SymbolAt( esid )
            if es <> 0 then
                if es->kind = cast( ubyte, Tko.SYM_ENUMCONST ) then
                    '' On a SYM_ENUMCONST 'payload' is THE VALUE ITSELF, not a node id.
                    es->payload = cast( long, enumNext )
                    '' And its TYPE is the enum, which is what fbc says: '#print
                    '' typeof( B )' for a member of 'enum E2' prints E2. Without it the
                    '' member was untyped and anything reading it -- a PRINT item, a
                    '' comparison -- had nothing to work from. An ANONYMOUS enum has no
                    '' name to make a type from and keeps its members untyped; fbc gives
                    '' them a generated one, which tiko-lang has no equivalent of.
                    if esp->name <> 0 then
                        es->type_ = c.types->NamedType( Tko.TK_ENUM, esp->name, _
                                                        cast( ulong, here ) )
                    end if
                end if
            end if
            enumNext += 1
        next
        return

    case Tko.N_VAR, Tko.N_CONST
        '' Resolving a declaration's TypeRef is not enough: the SYMBOL has to carry
        '' the result, or every later use of the name is untyped. Collect could not
        '' do this -- a type may be declared after the variable that uses it, which
        '' is exactly why type references are resolved in this pass and not that one.
        dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
        if sp->op = cast( ushort, Tko.KW_REDIM ) then
            '' EXCEPT WITH AN 'AS' CLAUSE, which declares the array as well as sizing
            '' it: 'redim foo( 1 to 2 ) as integer' is how a dynamic array is brought
            '' into existence in one line, and the corpus's own redim test writes
            '' nothing else. Collect now declares those, and they need a TYPE here for
            '' the same reason a DIM does -- the bounds path below only walks the
            '' bounds. A DYNAMIC array type, whatever bounds were written: the whole
            '' point of the form is that they are set at run time.
            dim as boolean declares = false
            for i as long = 0 to sp->count - 1
                dim as Tko.NodeId it3 = cast( Tko.NodeId, c.ast->children[sp->first + i] )
                if c.ast->Kind( it3 ) <> Tko.N_VAR_ITEM then continue for
                dim as Tko.StmtPayload ptr ip3 = StmtOf( c, it3 )
                if ip3->a = Tko.NODE_NONE then continue for
                declares = true
                dim as Tko.TypeId bt3 = ResolveTypeRef( c, ip3->a, here )
                if bt3 = Tko.TYPE_NONE then continue for
                dim as long ndim = 1
                if ip3->c <> Tko.NODE_NONE then
                    if c.ast->Kind( ip3->c ) = Tko.N_BLOCK then
                        ndim = c.ast->lists[cast( long, _
                            c.ast->nodes[cast( long, ip3->c )].data )].count
                    end if
                end if
                if ndim < 1 then ndim = 1
                BindDeclType( c, here, ip3->name, c.types->DynArrayOf( bt3, ndim ) )
            next

            '' A REDIM declares nothing -- the array already exists -- but its BOUNDS
            '' are ordinary runtime expressions and have to be resolved like any
            '' other. Returning here without walking them left 'redim a(0 to n)' with
            '' an unbound 'n', so lowering could not produce a value for it and the
            '' whole statement declined. Only a redim to CONSTANT bounds worked, which
            '' is the least interesting kind.
            for i as long = 0 to sp->count - 1
                dim as Tko.NodeId item = cast( Tko.NodeId, c.ast->children[sp->first + i] )
                if c.ast->Kind( item ) <> Tko.N_VAR_ITEM then continue for
                dim as Tko.StmtPayload ptr rp = StmtOf( c, item )
                '' 'redim x.array( 0 to 9 )' and 'redim ( a )( 0 to 9 )' name their
                '' array through an EXPRESSION, which the parser puts in the slot a
                '' REDIM otherwise leaves empty. It is an ordinary lvalue and has to be
                '' resolved like one, or lowering has an unbound name to take the
                '' address of.
                if rp->extra = cast( ushort, Tko.KW_REDIM ) then
                    if rp->b <> Tko.NODE_NONE then WalkStmt( c, rp->b, here )
                end if
                if rp->c = Tko.NODE_NONE then continue for
                if c.ast->Kind( rp->c ) <> Tko.N_BLOCK then continue for
                dim as Tko.ListPayload ptr rl = _
                    @c.ast->lists[cast( long, c.ast->nodes[cast( long, rp->c )].data )]
                for d as long = 0 to rl->count - 1
                    WalkStmt( c, cast( Tko.NodeId, c.ast->children[rl->first + d] ), here )
                next
            next
            return
        end if
        for i as long = 0 to sp->count - 1
            dim as Tko.NodeId item = cast( Tko.NodeId, c.ast->children[sp->first + i] )
            if c.ast->Kind( item ) <> Tko.N_VAR_ITEM then continue for
            dim as Tko.StmtPayload ptr ip = StmtOf( c, item )
            dim as Tko.TypeId t = ResolveTypeRef( c, ip->a, here )
            '' 'dim as long a(0 to 9)' is an ARRAY of long, not a long. Without this a
            '' local array reserved one ELEMENT -- four bytes where forty were needed --
            '' which nothing noticed only because indexing was not lowered either.
            t = ArrayFromBoundsNode( c, t, ip->c, ip->b )
            '' 'dim BYREF rb as integer = a' ALIASES a. Its type is a REFERENCE, which
            '' is the same shape a byref PARAMETER has -- and every piece of the model
            '' already follows from that one fact: the slot lowers to a pointer, and
            '' AddrOfVar loads it, so every read, write and '@' goes through the
            '' indirection. Only the DECLARATION had to learn to store an address.
            if (c.ast->nodes[cast( long, id )].flags and Tko.NF_BYREF) <> 0 then
                if t <> Tko.TYPE_NONE then t = c.types->Reference( t )
            end if
            if t = Tko.TYPE_NONE then
                '' A DECLARATION WITH NO TYPE AND NO INITIALISER is the DEFAULT-TYPE
                '' feature -- 'dim a', 'dim b%', 'byval s$'. fbc refuses those outside
                '' -lang deprecated/fblite/qb (its error 147), and tiko-lang implements
                '' #lang "fb" only. Reported rather than left untyped: the symbol
                '' otherwise reaches lowering with no type, gets a VOID SLOT, and the
                '' store into it is a verify failure three passes later with nothing
                '' to say where it came from.
                ''
                '' Only when there is no TYPE REFERENCE at all. An unresolved type NAME
                '' stays silent, deliberately -- it may come from a header this build
                '' did not read.
                if (ip->a = Tko.NODE_NONE) andalso (ip->b = Tko.NODE_NONE) then
                    c.diags->Report( Tko.TKO0320, _
                        Tko.PointRange( c.ast->Loc( item ) ), _
                        c.names->Spelling( ip->name ) )
                end if
                c.pendingItem.Push( cast( ulong, item ) )
                c.pendingScope.Push( cast( ulong, here ) )
            end if
            BindDeclType( c, here, ip->name, t )
            WalkStmt( c, ip->b, here )
        next
        return

    case Tko.N_PARAM
        dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
        dim as Tko.TypeId t = ResolveTypeRef( c, sp->a, here )
        '' 'sub Q( a( ) as long )' TAKES AN ARRAY, not a long. The parser records the
        '' empty subscript as NF_ARRAY and nothing read it, so the parameter was typed
        '' as its ELEMENT: 'redim a( ... )' inside the body found no array to
        '' re-dimension and 'a( 0 ) = 1' had no descriptor to index through. A DYNAMIC
        '' array, because bounds set by the caller are exactly what a bydesc parameter
        '' does not know.
        if (t <> Tko.TYPE_NONE) andalso _
           ((c.ast->nodes[cast( long, id )].flags and Tko.NF_ARRAY) <> 0) then
            t = c.types->DynArrayOf( t, 1 )
        end if
        if (t <> Tko.TYPE_NONE) andalso _
           ((c.ast->nodes[cast( long, id )].flags and Tko.NF_BYREF) <> 0) then
            t = c.types->Reference( t )
        end if
        BindDeclType( c, here, sp->name, t )
        WalkStmt( c, sp->b, here )
        return

    case Tko.N_TYPEDEF
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
        dim as Tko.StmtPayload ptr tsp = StmtOf( c, id )
        c.typedefNode.Push( cast( ulong, id ) )
        c.typedefScope.Push( cast( ulong, here ) )
        dim as Tko.TypeId aliased = ResolveTypeRef( c, tsp->a, here )
        if (aliased <> Tko.TYPE_NONE) andalso (tsp->name <> 0) then
            '' The TYPEDEF, not a variable of the same name -- when the variable was
            '' declared first it holds the slot, and the typedef never got its type.
            dim as Tko.SymbolId tsid = c.syms->LookupLocalTyped( here, tsp->name, true )
            dim as Tko.Symbol ptr tsym = c.syms->SymbolAt( tsid )
            if tsym <> 0 then
                if tsym->kind = cast( ubyte, Tko.SYM_TYPEDEF ) then tsym->type_ = aliased
            end if
        end if
        '' The extra names of 'type as integer a, b'.
        for i as long = 0 to tsp->count - 1
            WalkStmt( c, cast( Tko.NodeId, c.ast->children[tsp->first + i] ), here )
        next
        return

    case Tko.N_FIELD
        dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
        dim as Tko.TypeId t = ResolveTypeRef( c, sp->a, here )
        '' A field declared with bounds is an ARRAY of that type. The bounds are
        '' low/high pairs and the element count is their product -- which the layout
        '' needs, and which was simply lost while the bounds were being skipped.
        t = ArrayFromBounds( c, t, sp->first, sp->count )
        BindDeclType( c, here, sp->name, t )

        '' A BITFIELD is marked, not modelled. 'b' holds the width expression; the
        '' declared type is the storage UNIT's, not the field's, so reading or writing
        '' it as an ordinary field of that type would touch the whole unit and clobber
        '' the fields packed beside it. Until the packed layout and the masked access
        '' exist, the mark is what makes lowering decline instead.
        if sp->b <> Tko.NODE_NONE then
            dim as Tko.SymbolId fsid = c.syms->LookupLocal( here, sp->name )
            dim as Tko.Symbol ptr fs = c.syms->SymbolAt( fsid )
            if fs <> 0 then
                '' On a SYM_FIELD carrying SYMF_BITFIELD, 'payload' is THE WIDTH IN
                '' BITS. Nothing else uses a field's payload, and the layout needs a
                '' number rather than an expression to place the field at all.
                dim as Tko.Check.ConstVal wv = Tko.Check.ConstOf( _
                    *c.ast, sp->b, *c.srcMgr, *c.names, 64, c.syms, here )
                if wv.known andalso (wv.value > 0) andalso (wv.value <= 64) then
                    fs->flags or= Tko.SYMF_BITFIELD
                    fs->payload = cast( long, wv.value )
                end if
            end if
        end if
        return

    case Tko.N_FOR, Tko.N_FOREACH
        '' 'for i as integer' DECLARES i, and Collect named it -- but nothing bound
        '' its TYPE, so every use of the counter came out untyped. The 'as' clause
        '' is in 'c', which is also what told Collect it was a declaration.
        dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
        if sp->c <> Tko.NODE_NONE then
            dim as Tko.TypeId t = ResolveTypeRef( c, sp->c, here )
            if (sp->a <> Tko.NODE_NONE) andalso _
               (c.ast->Kind( sp->a ) = Tko.N_IDENT) then
                dim as Tko.IdentPayload ptr ip = _
                    @c.ast->idents[cast( long, c.ast->nodes[cast( long, sp->a )].data )]
                BindDeclType( c, here, ip->name, t )
            end if
        end if
        '' The SEQUENCE first, so its type is known before the variable is bound.
        for i as long = 0 to sp->count - 1
            WalkStmt( c, cast( Tko.NodeId, c.ast->children[sp->first + i] ), here )
        next

        '' FOR EACH WITH NO 'as' CLAUSE takes the sequence's ELEMENT type. Without
        '' this the loop variable was declared and untyped, and the whole statement
        '' declined for want of a slot to load the element into.
        WalkExpr( c, sp->a, here )

        '' Bound through the RESOLVED REFERENCE, not by looking the name up again:
        '' the variable lives in the loop's OWN scope, which is not the scope this
        '' walk is carrying, so a name lookup here binds nothing and the loop
        '' variable stays untyped -- which is what it did.
        if (k = Tko.N_FOREACH) andalso (sp->c = Tko.NODE_NONE) andalso _
           (sp->count = 1) andalso (sp->a <> Tko.NODE_NONE) then
            dim as Tko.SymbolId vsid = c.info->RefOf( sp->a )
            dim as Tko.Symbol ptr vsym = c.syms->SymbolAt( vsid )
            if vsym <> 0 then
                if vsym->type_ = Tko.TYPE_NONE then
                    '' From the sequence's SYMBOL, not from TypeOf_: an
                    '' expression's type is CHECK's to record and Check has not run,
                    '' so asking here returns nothing for every sequence there is.
                    '' That is what left the variable untyped even once it was
                    '' correctly declared.
                    dim as Tko.NodeId seqE = cast( Tko.NodeId, c.ast->children[sp->first] )
                    dim as Tko.TypeId seqT = Tko.TYPE_NONE
                    dim as Tko.Symbol ptr ssym = c.syms->SymbolAt( c.info->RefOf( seqE ) )
                    if ssym <> 0 then seqT = ssym->type_
                    '' A BYREF PARAMETER IS A REFERENCE TO THE CONTAINER. Testing
                    '' the reference's own kind found neither an array nor a UDT, so
                    '' 'for each e in a' over a 'byref a as Array( of T )' left the
                    '' loop variable untyped -- and fbc's own stats.bi takes every
                    '' container that way.
                    if seqT <> Tko.TYPE_NONE then
                        seqT = c.types->Unqualify( seqT )
                        if c.types->Kind( seqT ) = Tko.TK_REFERENCE then
                            seqT = c.types->Unqualify( c.types->Inner( seqT ) )
                        end if
                    end if
                    if seqT <> Tko.TYPE_NONE then
                        if c.types->Kind( seqT ) = Tko.TK_ARRAY then
                            vsym->type_ = c.types->Inner( seqT )
                        elseif c.types->Kind( seqT ) = Tko.TK_UDT then
                            '' A USER COLLECTION -- the RFC-0002 iterator protocol.
                            '' Its element type is the return type of the ITERATOR's
                            '' Value( ), two lookups away: GetIterator gives the
                            '' iterator's type and Value gives the element's.
                            ''
                            '' Typed HERE and not in lowering, which is where it used
                            '' to happen. Check runs in between, so a variable typed
                            '' during lowering is untyped for the whole of Check --
                            '' and 'if y = 20' inside the loop body then produced NO
                            '' CONDITION at all, which went out as a conditional
                            '' branch with nothing to branch on.
                            vsym->type_ = IterElemType_( c, seqT )
                        end if
                    end if
                end if
            end if
        end if

        WalkStmt( c, sp->b, here )
        return

    case Tko.N_PROC
        dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
        dim as Tko.SymbolId saved = c.currentProc
        c.currentProc = c.info->RefOf( id )
        '' The RETURN type belongs on the procedure's symbol, or a call to it can
        '' never be typed. Parameters are bound by the N_PARAM case below.
        dim as Tko.TypeId ret = ResolveTypeRef( c, sp->a, here )
        dim as Tko.Symbol ptr ps = c.syms->SymbolAt( c.currentProc )
        if (ps <> 0) andalso (ret <> Tko.TYPE_NONE) andalso _
           (ps->type_ = Tko.TYPE_NONE) then
            ps->type_ = ret
        end if
        BindThis( c, here, sp->ownerName )
        for i as long = 0 to sp->count - 1
            WalkStmt( c, cast( Tko.NodeId, c.ast->children[sp->first + i] ), here )
        next
        WalkStmt( c, sp->b, here )
        c.currentProc = saved
        return
    end select

    '' Everything else: recurse through the general slots.
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    if sp = 0 then return
    WalkStmt( c, sp->a, here )
    WalkStmt( c, sp->b, here )
    WalkStmt( c, sp->c, here )
    for i as long = 0 to sp->count - 1
        WalkStmt( c, cast( Tko.NodeId, c.ast->children[sp->first + i] ), here )
    next
end sub

sub Run _
    ( byref ast as Tko.AstArena, byval root as Tko.NodeId, _
      byref syms as Tko.SymbolTable, byref types as Tko.TypeContext, _
      byref names as Tko.Interner, byref diags as Tko.DiagnosticEngine, _
      byref src as Tko.SourceManager, _
      byref info as Tko.SemanticInfo, byref st as Stats, _
      byval parser as any ptr )

    dim as Ctx c
    c.parser = parser
    c.srcMgr = @src
    c.ast = @ast
    c.syms = @syms
    c.types = @types
    c.names = @names
    c.diags = @diags
    c.info = @info
    c.st = @st
    c.currentProc = Tko.SYMBOL_NONE

    info.Resize( ast.Count( ) )

    DiscoverInstantiations_( c, ast, root, diags, info )
    WalkStmt( c, root, Tko.SCOPE_GLOBAL )
    InstantiatePending_( c )
    InstantiatePendingProcs_( c )
    BackpatchTypedefs( c )
end sub
#include once "symbols/resolvedump.bas"

end namespace
