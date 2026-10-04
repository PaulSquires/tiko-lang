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
        '' 'redim shared' INSIDE A SCOPE OR A PROCEDURE over an array declared elsewhere --
        '' 'common array( )' above it, say -- is fbc's 96 (61 in a procedure), as a new one
        '' is (dim/redim-shared-in-a-scope-with-a-common-above). CheckSharedInBlock_ judges
        '' the SYMBOLS a shared declaration makes, and this one makes none.
        if (op = KW_REDIM) andalso ((c.ast->nodes[cast( long, id )].flags and NF_SHARED) <> 0) then
            dim as SymScope ptr rsc = c.syms->ScopeAt( c.info->ScopeOf( id ) )
            if (rsc <> 0) andalso ((rsc->kind = cast( ubyte, SCOPEK_BLOCK )) orelse (rsc->kind = cast( ubyte, SCOPEK_PROC ))) then
                dim as Symbol ptr rs = c.syms->SymbolAt( c.info->RefOf( item ) )
                if rs = 0 then rs = c.syms->SymbolAt( c.syms->LookupTyped( c.info->ScopeOf( id ), ip->name, false ) )
                if (rs <> 0) andalso (rs->payload <> cast( ulong, item )) then
                    c.diags->Report( TKO0726, PointRange( c.ast->Loc( item ) ), nm )
                    continue for
                end if
            end if
        end if
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
        '' AN ARRAY OF A TYPE WHOSE DESTRUCTOR IS STDCALL OR PASCAL: fbc's 172 for a REDIM and
        '' 175 for a DIM, fixed or dynamic -- the runtime destroys elements through a cdecl
        '' callback (fbc-modern 1.20, 2026-09-29; dim/redim-array-dtor-mismatch). A cdecl one
        '' written out is fine, and so is a scalar.
        if (((c.ast->nodes[cast( long, item )].flags and NF_ARRAY) <> 0) orelse (op = KW_REDIM)) andalso (ip->a <> NODE_NONE) then
            dim as TypeId et = c.types->Unqualify( c.info->TypeOf_( ip->a ) )
            if c.types->Kind( et ) = TK_UDT then
                dim as Symbol ptr dts = StructorOf_( c, et, "__dtor" )
                if (dts <> 0) andalso (dts->payload <> 0) then
                    dim as NodeId dd = cast( NodeId, dts->payload )
                    if c.ast->Kind( dd ) = N_PROC then
                        if (c.ast->stmts[cast( long, c.ast->nodes[cast( long, dd )].data )].extra and (PF_STDCALL or PF_PASCAL)) <> 0 then
                            c.diags->Report( TKO0913, PointRange( c.ast->Loc( item ) ), nm, c.names->Spelling( c.types->NameOf( et ) ) )
                            continue for
                        end if
                    end if
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

'' A POINTER INTO AN INTEGER OF ANOTHER SIZE, measured on fbc-modern 1.20, 2026-09-29, 64-bit:
''
''     dim shared a as long = @i  /  dim a as byte = @i  /  as ulong    error 24
''     a = @i  (a as long)                                            error 181
''     dim a as integer = @i  /  as ulongint  /  as any ptr           fine
''
'' dim/global-init-nonptrsizedint-from-offset writes the first. A float is TKO0670's.
private function PtrIntNarrow_ ( byref c as Ctx, byval lt as TypeId, byval rt as TypeId, byval rhs as NodeId ) as boolean
    if (lt = TYPE_NONE) orelse (rt = TYPE_NONE) then return false
    '' ONLY A RUN-TIME POINTER: an address, a variable or a field. 'b = cptr( any ptr, 0 )' is a
    '' constant null, and fbc takes it into a byte (numbers/cast-nullptr.bas).
    for up as long = 0 to 15
        if (rhs = NODE_NONE) orelse (c.ast->Kind( rhs ) <> N_PAREN) then exit for
        dim as ListPayload ptr pp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, rhs )].data )]
        if pp->count <> 1 then exit for
        rhs = cast( NodeId, c.ast->children[pp->first] )
    next
    if rhs = NODE_NONE then return false
    select case c.ast->Kind( rhs )
    case N_ADDROF, N_IDENT, N_MEMBER
    case else
        return false
    end select
    dim as TypeId lu = c.types->Unqualify( lt ), ru = c.types->Unqualify( rt )
    if c.types->Kind( lu ) = TK_REFERENCE then lu = c.types->Unqualify( c.types->Inner( lu ) )
    if c.types->Kind( ru ) = TK_REFERENCE then ru = c.types->Unqualify( c.types->Inner( ru ) )
    if (c.types->Kind( ru ) <> TK_POINTER) orelse (c.types->Kind( lu ) <> TK_BUILTIN) then return false
    select case c.types->BuiltinOf( lu )
    case TY_BYTE, TY_UBYTE, TY_SHORT, TY_USHORT, TY_LONG, TY_ULONG, TY_INTEGER, TY_UINTEGER, TY_LONGINT, TY_ULONGINT
        return (c.types->Layout( lu ).size * 8) <> c.types->target.pointerBits
    end select
    return false
end function

private sub CheckPtrIntWidth_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if c.ast->Kind( id ) = N_AMBIGUOUS then
        if c.info->AmbiguousOf( id ) <> AMB_ASSIGN then return
        if (sp->a = NODE_NONE) orelse (sp->b = NODE_NONE) then return
        if PtrIntNarrow_( c, c.info->TypeOf_( sp->a ), c.info->TypeOf_( sp->b ), sp->b ) then
            c.diags->Report( TKO0910, PointRange( c.ast->Loc( id ) ), c.types->Name( c.types->Unqualify( c.info->TypeOf_( sp->a ) ) ) )
        end if
        return
    end if
    for k as long = 0 to sp->count - 1
        dim as NodeId item = cast( NodeId, c.ast->children[sp->first + k] )
        if (item = NODE_NONE) orelse (c.ast->Kind( item ) <> N_VAR_ITEM) then continue for
        dim as StmtPayload ptr ip = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
        if (ip->a = NODE_NONE) orelse (ip->b = NODE_NONE) then continue for
        if (c.ast->nodes[cast( long, item )].flags and NF_ARRAY) <> 0 then continue for
        if PtrIntNarrow_( c, c.info->TypeOf_( ip->a ), c.info->TypeOf_( ip->b ), ip->b ) then
            c.diags->Report( TKO0910, PointRange( c.ast->Loc( item ) ), c.types->Name( c.types->Unqualify( c.info->TypeOf_( ip->a ) ) ) )
        end if
    next
end sub

'' A TYPE LITERAL THAT BUILDS NOTHING, measured the same day:
''
''     type<UDT>( ) / type<UDT> / type( ), UDT of plain fields         error 9    (structs/anon-
''     ...over a UDT with a constructor, a string field, or OBJECT      fine        missing-initializer)
''     type<UDT>( 1 ) / type( 1 ), UDT extends OBJECT, no constructor   error 99   (structs/anon-
''     ...over a plain UDT, or one that only has a destructor           fine        ctorcall-no-match)
''
'' An empty literal over a type fbc has no constructor for has nothing to build; a type that
'' extends OBJECT has a vtable, so it is constructed and never filled field by field. A type
'' holding a string is TKO0757's where it is an initializer, and is not judged here.
'' ExtendsObject_ is latechecks.bas's.
'' Does a field of this type, or of one it extends, have a default initializer -- so fbc
'' writes the type a constructor? 'i as integer = 123' is one (structs/anon-access.bas).
private function FieldHasInit_ ( byref c as Ctx, byval t as TypeId ) as boolean
    for guard as long = 0 to 31
        if (t = TYPE_NONE) orelse (c.types->Kind( t ) <> TK_UDT) then return false
        dim as Symbol ptr us = UdtSymbolOf_( c, t )
        if (us = 0) orelse (us->inner = SCOPE_NONE) then return false
        dim as SymScope ptr sc = c.syms->ScopeAt( us->inner )
        dim as SymbolId cur = iif( sc <> 0, sc->firstSym, SYMBOL_NONE )
        for g2 as long = 0 to 9999
            if cur = SYMBOL_NONE then exit for
            dim as Symbol ptr f = c.syms->SymbolAt( cur )
            if f = 0 then exit for
            if (f->kind = cast( ubyte, SYM_FIELD )) andalso (f->payload <> 0) then
                dim as NodeId fn = cast( NodeId, f->payload )
                if c.ast->Kind( fn ) = N_FIELD then
                    dim as StmtPayload ptr fp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, fn )].data )]
                    if fp->c <> NODE_NONE then return true
                    if (fp->b <> NODE_NONE) andalso ((f->flags and SYMF_BITFIELD) = 0) then return true
                end if
            end if
            cur = f->nextInScope
        next
        t = BaseOf_( c, t )
    next
    return false
end function

private sub CheckTypeLiteral_ ( byref c as Ctx, byval id as NodeId )
    if (c.ast->nodes[cast( long, id )].flags and NF_TYPE_LITERAL) = 0 then return
    dim as ListPayload ptr lp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as TypeId t = TYPE_NONE
    if lp->target <> NODE_NONE then t = c.info->TypeOf_( lp->target )
    if t = TYPE_NONE then t = c.info->TypeOf_( id )
    if t = TYPE_NONE then return
    t = c.types->Unqualify( t )
    if c.types->Kind( t ) = TK_REFERENCE then t = c.types->Unqualify( c.types->Inner( t ) )
    if c.types->Kind( t ) <> TK_UDT then return
    dim as InternId tn = c.types->NameOf( t )
    if tn = 0 then return
    dim as string h = left( c.names->Spelling( tn ), 1 )
    if (h = "(") orelse (h = "$") orelse (h = "~") then return
    if instr( c.names->Spelling( tn ), "<" ) > 0 then return
    if StructorOf_( c, t, "__ctor" ) <> 0 then return
    if lp->count = 0 then
        if TcNeedsCtor_( c, t, 0 ) orelse FieldHasInit_( c, t ) then return
        c.diags->Report( TKO0911, PointRange( c.ast->Loc( id ) ), c.names->Spelling( tn ) )
    elseif ExtendsObject_( c, t ) then
        c.diags->Report( TKO0912, PointRange( c.ast->Loc( id ) ), c.names->Spelling( tn ) )
    end if
end sub

'' A WHOLE ARRAY AS THE DATA OF A FILE GET OR PUT -- fbc's error 73, "Array access, index
'' expected": 'put #0, , values' over 'dim values( 0 to 0 )', a dynamic one the same (fbc-modern
'' 1.20, 2026-09-29; expressions/nidxarray-3). 'values( )' writes the whole array and
'' 'values( 0 )' one element; a fixed-length string is not this. The GRAPHICS forms take a bare
'' array and are not judged: bit 1 of 'extra' marks the file form.
private sub CheckFileGetPutArray_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    select case cast( TokenKind, sp->op )
    case KW_GET, KW_PUT
    case else
        return
    end select
    if (sp->extra and 1) = 0 then return
    for i as long = 0 to sp->count - 1
        dim as NodeId ch = cast( NodeId, c.ast->children[sp->first + i] )
        if (ch = NODE_NONE) orelse (c.ast->Kind( ch ) <> N_IDENT) then continue for
        dim as Symbol ptr vs = c.syms->SymbolAt( c.info->RefOf( ch ) )
        if (vs = 0) orelse (vs->kind <> cast( ubyte, SYM_VARIABLE )) orelse (vs->type_ = TYPE_NONE) then continue for
        dim as TypeId vt = c.types->Unqualify( vs->type_ )
        if c.types->Kind( vt ) = TK_REFERENCE then vt = c.types->Unqualify( c.types->Inner( vt ) )
        if c.types->Kind( vt ) <> TK_ARRAY then continue for
        if Tko.Check.FixedStringElem( vt, *c.types ) <> TYPE_NONE then continue for
        c.diags->Report( TKO0914, PointRange( c.ast->Loc( ch ) ), c.names->Spelling( vs->name ) )
    next
end sub

'' 'UDT( )' OVER A TYPE WITH NOTHING TO CONSTRUCT -- fbc's error 42, "Variable not declared",
'' measured on fbc-modern 1.20, 2026-09-30: 'DtorUdt( )' and 'DtorUdt( 1 )' over a type with
'' only a destructor, and 'P( )' over one of plain fields, in an initializer or as a
'' parameter's default (functions/paraminit-undeclared-1). A type with a constructor, a
'' string field, a field initializer or OBJECT is constructed, and the call is fine.
private sub CheckUdtCallNoCtor_ ( byref c as Ctx, byval id as NodeId )
    dim as ListPayload ptr lp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if (lp->target = NODE_NONE) orelse (c.ast->Kind( lp->target ) <> N_IDENT) then return
    dim as Symbol ptr ts = c.syms->SymbolAt( c.info->RefOf( lp->target ) )
    if ts = 0 then return
    if (ts->kind <> cast( ubyte, SYM_UDT )) andalso (ts->kind <> cast( ubyte, SYM_TYPEDEF )) then return
    dim as TypeId t = c.types->Unqualify( c.info->TypeOf_( id ) )
    if (t = TYPE_NONE) orelse (c.types->Kind( t ) <> TK_UDT) then return
    dim as InternId tn = c.types->NameOf( t )
    if tn = 0 then return
    dim as string h = left( c.names->Spelling( tn ), 1 )
    if (h = "(") orelse (h = "$") orelse (h = "~") then return
    if instr( c.names->Spelling( tn ), "<" ) > 0 then return
    if StructorOf_( c, t, "__ctor" ) <> 0 then return
    if TcNeedsCtor_( c, t, 0 ) orelse FieldHasInit_( c, t ) then return
    c.diags->Report( TKO0917, PointRange( c.ast->Loc( lp->target ) ), c.names->Spelling( tn ) )
end sub

'' '*@type<UDT>( 1 ) = x' -- A STORE THROUGH THE ADDRESS OF A TEMPORARY, fbc's error 24
'' (structs/anon-invalid-initializer-2). '@type<UDT>( 1 )' read, or taken into a pointer,
'' is fbc's.
private function StripParens_ ( byref c as Ctx, byval n as NodeId ) as NodeId
    for up as long = 0 to 15
        if (n = NODE_NONE) orelse (c.ast->Kind( n ) <> N_PAREN) then exit for
        dim as ListPayload ptr pp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
        if pp->count <> 1 then exit for
        n = cast( NodeId, c.ast->children[pp->first] )
    next
    return n
end function

private sub CheckAssignTempDeref_ ( byref c as Ctx, byval id as NodeId )
    if c.info->AmbiguousOf( id ) <> AMB_ASSIGN then return
    dim as StmtPayload ptr sp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as NodeId d = StripParens_( c, sp->a )
    if (d = NODE_NONE) orelse (c.ast->Kind( d ) <> N_DEREF) then return
    dim as NodeId ad = StripParens_( c, c.ast->unaries[cast( long, c.ast->nodes[cast( long, d )].data )].operand )
    if (ad = NODE_NONE) orelse (c.ast->Kind( ad ) <> N_ADDROF) then return
    dim as NodeId lit = StripParens_( c, c.ast->unaries[cast( long, c.ast->nodes[cast( long, ad )].data )].operand )
    if (lit = NODE_NONE) orelse (c.ast->Kind( lit ) <> N_TUPLE) then return
    if (c.ast->nodes[cast( long, lit )].flags and NF_TYPE_LITERAL) = 0 then return
    c.diags->Report( TKO0918, PointRange( c.ast->Loc( id ) ) )
end sub

'' A STRING LITERAL FOR A POINTER IN AN ARRAY'S '{ }' INITIALIZER -- fbc refuses it, with
'' error 24 for a 'zstring ptr' element and 14 or 3 for a UDT field of one, measured on
'' fbc-modern 1.20, 2026-09-30 (dim/udt-init-bad-1). '@"a"' is the spelling; and a SCALAR
'' 'dim u as UDT = ( "a" )' is fine to fbc, so only an array's elements are judged.
private function PtrStrElemBad_ ( byref c as Ctx, byval el as TypeId, byval e as NodeId ) as NodeId
    if e = NODE_NONE then return NODE_NONE
    if c.types->Kind( el ) = TK_POINTER then
        e = StripParens_( c, e )
        if (e <> NODE_NONE) andalso (c.ast->Kind( e ) = N_STRING_LIT) then return e
        return NODE_NONE
    end if
    '' A UDT's element is its OWN parenthesised list -- '( "a" )' is one field's value, so
    '' the parens are not stripped here.
    if c.types->Kind( el ) <> TK_UDT then return NODE_NONE
    dim as NodeKind ek = c.ast->Kind( e )
    if (ek <> N_TUPLE) andalso (ek <> N_PAREN) then
        return NODE_NONE
    end if
    dim as Symbol ptr us = UdtSymbolOf_( c, el )
    if (us = 0) orelse (us->inner = SCOPE_NONE) then return NODE_NONE
    dim as ListPayload ptr lp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, e )].data )]
    dim as SymScope ptr sc = c.syms->ScopeAt( us->inner )
    dim as SymbolId cur = iif( sc <> 0, sc->firstSym, SYMBOL_NONE )
    dim as long k = 0
    for guard as long = 0 to 9999
        if (cur = SYMBOL_NONE) orelse (k >= lp->count) then exit for
        dim as Symbol ptr f = c.syms->SymbolAt( cur )
        if f = 0 then exit for
        if (f->kind = cast( ubyte, SYM_FIELD )) andalso ((f->flags and SYMF_STATIC) = 0) andalso (f->name <> c.baseName) then
            dim as NodeId fe = StripParens_( c, cast( NodeId, c.ast->children[lp->first + k] ) )
            k += 1
            if (fe <> NODE_NONE) andalso (c.ast->Kind( fe ) = N_STRING_LIT) andalso (f->type_ <> TYPE_NONE) then
                if c.types->Kind( c.types->Unqualify( f->type_ ) ) = TK_POINTER then return fe
            end if
        end if
        cur = f->nextInScope
    next
    return NODE_NONE
end function

private sub CheckPtrStringInit_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    for k as long = 0 to sp->count - 1
        dim as NodeId item = cast( NodeId, c.ast->children[sp->first + k] )
        if (item = NODE_NONE) orelse (c.ast->Kind( item ) <> N_VAR_ITEM) then continue for
        dim as StmtPayload ptr ip = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
        if (ip->b = NODE_NONE) orelse (c.ast->Kind( ip->b ) <> N_INITIALIZER) then continue for
        if ip->a = NODE_NONE then continue for
        dim as TypeId el = c.types->Unqualify( c.info->TypeOf_( ip->a ) )
        if el = TYPE_NONE then continue for
        dim as ListPayload ptr lp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, ip->b )].data )]
        for j as long = 0 to lp->count - 1
            dim as NodeId bad = PtrStrElemBad_( c, el, cast( NodeId, c.ast->children[lp->first + j] ) )
            if bad <> NODE_NONE then
                '' fbc reports a UDT element's bad field where it chokes: the next element's '('.
                dim as NodeId at_ = bad
                if (c.types->Kind( el ) = TK_UDT) andalso (j + 1 < lp->count) then at_ = cast( NodeId, c.ast->children[lp->first + j + 1] )
                c.diags->Report( TKO0653, PointRange( c.ast->Loc( at_ ) ), c.names->Spelling( ip->name ) )
                exit for
            end if
        next
    next
end sub

'' 'for i as foo ptr = 0 to 3' OVER A FORWARD TYPE -- fbc's error 71 at the NEXT: the step is
'' pointer arithmetic, and the pointee has no size (compound/for-ptr-fwdref). Reported at the
'' body block, which is the NEXT line when the body is empty and the first statement otherwise.
private sub CheckForPtrFwd_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->a = NODE_NONE then return
    dim as TypeId t = TYPE_NONE
    if sp->c <> NODE_NONE then t = c.info->TypeOf_( sp->c )
    if t = TYPE_NONE then t = c.info->TypeOf_( sp->a )
    if t = TYPE_NONE then return
    t = c.types->Unqualify( t )
    if c.types->Kind( t ) = TK_REFERENCE then t = c.types->Unqualify( c.types->Inner( t ) )
    if c.types->Kind( t ) <> TK_POINTER then return
    dim as TypeId pt = c.types->Unqualify( c.types->Inner( t ) )
    if c.types->Kind( pt ) <> TK_FORWARD then return
    dim as NodeId at_ = iif( sp->b <> NODE_NONE, sp->b, id )
    c.diags->Report( TKO0810, PointRange( c.ast->Loc( at_ ) ), c.names->Spelling( c.types->NameOf( pt ) ) )
end sub

'' A FOR WRITES ITS COUNTER, so a const one is fbc's 119: 'dim as const integer c' then
'' 'for c = 1 to 2' ran the loop. A counter declared by the FOR itself is new storage.
'' A FOR COUNTER IS A SCALAR VARIABLE -- fbc's 52, "Expected scalar counter", for a field
'' ('for t.x = 1 to 3'), an array element, a byref parameter, and its 14 for '*p'. tiko
'' ran none of those loops (MIR-7), and since F-01 stopped them as unlowered. A UDT
'' variable is a counter too -- its 'operator for' / 'next' -- and a byval parameter is.
private sub CheckForScalarCounter_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if (sp->a = NODE_NONE) orelse (sp->c <> NODE_NONE) then return
    dim as boolean bad = (c.ast->Kind( sp->a ) <> N_IDENT)
    if bad = false then
        dim as Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( sp->a ) )
        if s = 0 then return
        select case cast( SymbolKind, s->kind )
        case SYM_VARIABLE
        case SYM_PARAMETER
            bad = ((s->flags and SYMF_BYREF) <> 0) orelse (c.types->Kind( s->type_ ) = TK_REFERENCE)
        case SYM_FIELD
            bad = true
        case else
            return
        end select
    end if
    if bad then c.diags->Report( TKO0953, PointRange( c.ast->Loc( sp->a ) ) )
end sub

private sub CheckForConstCounter_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if (sp->a = NODE_NONE) orelse (sp->c <> NODE_NONE) then return
    if c.ast->Kind( sp->a ) <> N_IDENT then return
    dim as Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( sp->a ) )
    if s = 0 then return
    dim as boolean k = cbool( (s->flags and SYMF_CONST) <> 0 ) orelse _
                       cbool( cast( SymbolKind, s->kind ) = SYM_CONSTANT ) orelse c.types->IsConst( s->type_ )
    if k = false then return
    c.diags->Report( TKO0617, PointRange( c.ast->Loc( sp->a ) ), c.names->Spelling( s->name ) )
end sub

'' A CAPTURING LAMBDA WHOSE PARAMETER IS THE ENCLOSING GENERIC'S TYPE PARAMETER -- fbc's error
'' 59 at the generic, measured on fbc-modern 1.20, 2026-09-30 (generics/fail-lambda-capture-
'' typaram): the closure's invoke member is built outside the binding that gives T a meaning.
'' A non-capturing lambda, or a capturing one with concrete parameters, is fine. tiko lowers
'' the case, but fbc's limitation is the one to match. The lifted procedure carries the
'' generic's type parameters in 'c' and the closure as its first parameter, '__tko_cl'.
private sub CheckLambdaTypeParam_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if left( lcase( c.names->Spelling( sp->name ) ), 13 ) <> "__tko_lambda_" then return
    if (sp->c = NODE_NONE) orelse (c.ast->Kind( sp->c ) <> N_BLOCK) then return
    dim as ListPayload ptr tp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, sp->c )].data )]
    if tp->count = 0 then return
    dim as boolean capturing = false
    for i as long = 0 to sp->count - 1
        dim as NodeId pn = cast( NodeId, c.ast->children[sp->first + i] )
        if (pn = NODE_NONE) orelse (c.ast->Kind( pn ) <> N_PARAM) then continue for
        dim as StmtPayload ptr pp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, pn )].data )]
        if lcase( c.names->Spelling( pp->name ) ) = "__tko_cl" then
            capturing = true
            continue for
        end if
        if capturing = false then continue for
        if (pp->a = NODE_NONE) orelse (c.ast->Kind( pp->a ) <> N_TYPEREF) then continue for
        if (c.ast->nodes[cast( long, pp->a )].flags and (NF_PTR or NF_PROC_TYPE)) <> 0 then continue for
        dim as InternId pt = c.ast->stmts[cast( long, c.ast->nodes[cast( long, pp->a )].data )].name
        if pt = 0 then continue for
        for j as long = 0 to tp->count - 1
            dim as NodeId tn = cast( NodeId, c.ast->children[tp->first + j] )
            if (tn = NODE_NONE) orelse (c.ast->Kind( tn ) <> N_IDENT) then continue for
            if c.names->Fold( c.ast->idents[cast( long, c.ast->nodes[cast( long, tn )].data )].name ) = c.names->Fold( pt ) then
                c.diags->Report( TKO0921, PointRange( c.ast->Loc( sp->c ) ), c.names->Spelling( pp->name ), c.names->Spelling( pt ) )
                return
            end if
        next
    next
end sub

'' A NAME TWO USINGS BOTH REACH -- fbc's error 255, "Ambiguous symbol access, explicit scope
'' resolution required", measured on fbc-modern 1.20, 2026-09-30 (namespace/dups_fail):
''
''     using a : using b : print foo            a.foo and b.foo           error 255
''     using c : print foo                      c.foo, and a.foo through c's own 'using a'
''     ...with 'dim as integer foo' declared in the scope first            fine
''
'' A USING applies from where it is written, so each one is taken at its node id (source
'' order), against the scope it sits in. Resolve records the namespace on the N_USING node.
private sub CollectNsNamed_ ( byref c as Ctx, byval ns as ScopeId, byval nm as InternId, _
                              byref got as FB.Array( of ulong ), byval depth as long )
    if (ns = SCOPE_NONE) orelse (depth > 8) then return
    dim as SymbolId sid = c.syms->LookupLocal( ns, nm )
    if sid <> SYMBOL_NONE then
        dim as boolean seen = false
        for i as long = 0 to got.Count - 1
            if got[i] = cast( ulong, sid ) then seen = true
        next
        if seen = false then got.Push( cast( ulong, sid ) )
    end if
    for i as long = 0 to c.syms->usingAt.Count - 1
        if c.syms->usingAt[i] <> cast( ulong, ns ) then continue for
        CollectNsNamed_( c, cast( ScopeId, c.syms->usingInner[i] ), nm, got, depth + 1 )
    next
end sub

private sub CheckUsingAmbiguity_ ( byref c as Ctx )
    dim as FB.Array( of ulong ) uNode, uScope, uInner
    dim as long total = c.ast->Count( )
    for n as long = 1 to total - 1
        if c.ast->Kind( cast( NodeId, n ) ) <> N_USING then continue for
        dim as Symbol ptr ns = c.syms->SymbolAt( c.info->RefOf( cast( NodeId, n ) ) )
        if (ns = 0) orelse (ns->kind <> cast( ubyte, SYM_NAMESPACE )) orelse (ns->inner = SCOPE_NONE) then continue for
        uNode.Push( cast( ulong, n ) )
        uScope.Push( cast( ulong, c.info->ScopeOf( cast( NodeId, n ) ) ) )
        uInner.Push( cast( ulong, ns->inner ) )
    next
    if uNode.Count < 1 then return
    '' The right side of a member access is qualified, and not this question.
    dim as FB.Array( of ubyte ) qualified
    for n as long = 0 to total
        qualified.Push( 0 )
    next
    for n as long = 1 to total - 1
        if c.ast->Kind( cast( NodeId, n ) ) <> N_MEMBER then continue for
        dim as NodeId r = c.ast->binaries[cast( long, c.ast->nodes[n].data )].rhs
        if (r > 0) andalso (cast( long, r ) < total) then qualified[cast( long, r )] = 1
    next
    for n as long = 1 to total - 1
        dim as NodeId x = cast( NodeId, n )
        if c.ast->Kind( x ) <> N_IDENT then continue for
        if qualified[n] <> 0 then continue for
        dim as Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( x ) )
        if s = 0 then continue for
        select case cast( SymbolKind, s->kind )
        case SYM_VARIABLE, SYM_CONSTANT, SYM_PROC, SYM_ENUMCONST
        case else
            continue for
        end select
        dim as SymScope ptr home = c.syms->ScopeAt( s->parent )
        if (home = 0) orelse (home->kind <> cast( ubyte, SCOPEK_NAMESPACE )) then continue for
        dim as InternId nm = c.ast->idents[cast( long, c.ast->nodes[n].data )].name
        '' AN EXPRESSION'S NAME HAS NO SCOPE RECORDED; its statement does, and is built after
        '' it -- the first node past it with a scope is the statement it sits in.
        dim as ScopeId sc = c.info->ScopeOf( x )
        for f as long = n + 1 to total - 1
            if sc <> SCOPE_NONE then exit for
            sc = c.info->ScopeOf( cast( NodeId, f ) )
        next
        '' A NAME DECLARED ANYWHERE ON THE CHAIN, above the use, is what the use means: it
        '' beats every using (T58, Lookup). Otherwise the usings of EVERY scope on the chain
        '' are asked together -- fbc's 255 names an inner using's and an outer one's alike.
        dim as boolean declared = false
        dim as ScopeId walk = sc
        for guard as long = 0 to 255
            if walk = SCOPE_NONE then exit for
            dim as Symbol ptr loc_ = c.syms->SymbolAt( c.syms->LookupLocal( walk, nm ) )
            if loc_ <> 0 then
                if (loc_->declAt = 0) orelse (loc_->declAt < cast( ulong, n )) then declared = true
            end if
            if declared then exit for
            dim as SymScope ptr ss = c.syms->ScopeAt( walk )
            if ss = 0 then exit for
            walk = ss->parent
        next
        if declared then continue for
        dim as FB.Array( of ulong ) got
        for guard as long = 0 to 255
            if sc = SCOPE_NONE then exit for
            for u as long = 0 to uNode.Count - 1
                if uScope[u] <> cast( ulong, sc ) then continue for
                if uNode[u] >= cast( ulong, n ) then continue for
                CollectNsNamed_( c, cast( ScopeId, uInner[u] ), nm, got, 0 )
            next
            dim as SymScope ptr ss = c.syms->ScopeAt( sc )
            if ss = 0 then exit for
            sc = ss->parent
        next
        if got.Count >= 2 then
            c.diags->Report( TKO0919, PointRange( c.ast->Loc( x ) ), c.names->Spelling( nm ) )
        end if
    next
end sub

'' A BARE 'type( ... )' WITH NO SINGLE TYPE TO BUILD -- fbc's error 71, "Incomplete type",
'' measured on fbc-modern 1.20, 2026-09-30:
''
''     f( type( 0 ) ) over an OVERLOADED f                      structs/anon-ambigious-argument
''     if type( 0 ) then                                        expressions/typeini-error-recovery-2
''     f( type( 0 ) ) over one 'byref as integer' f             fine: the parameter is the type
''
'' tiko reached emission with no type for the literal: an internal error for the first, and
'' IR clang refused for the second. One passed to a single procedure takes its parameter's.
private sub CheckBareTypeLiterals_ ( byref c as Ctx )
    dim as long total = c.ast->Count( )
    dim as FB.Array( of ubyte ) argOf
    for n as long = 0 to total
        argOf.Push( 0 )
    next
    for n as long = 1 to total - 1
        if c.ast->Kind( cast( NodeId, n ) ) <> N_CALL then continue for
        dim as ListPayload ptr lp = @c.ast->lists[cast( long, c.ast->nodes[n].data )]
        if lp->target = NODE_NONE then continue for
        dim as Symbol ptr hs = c.syms->SymbolAt( c.info->RefOf( lp->target ) )
        if hs = 0 then hs = c.syms->SymbolAt( c.info->RefOf( cast( NodeId, n ) ) )
        dim as ubyte mark = 1
        if (hs <> 0) andalso (hs->kind = cast( ubyte, SYM_PROC )) andalso (hs->nextOverload <> SYMBOL_NONE) then mark = 2
        for i as long = 0 to lp->count - 1
            dim as NodeId a = cast( NodeId, c.ast->children[lp->first + i] )
            if (a > 0) andalso (cast( long, a ) < total) then argOf[cast( long, a )] = mark
        next
    next
    '' ...AND WHERE NOTHING SUPPLIES ONE: a condition, or the object of a member access. Check
    '' types a context-less literal as an anonymous TUPLE, so its having a type says nothing
    '' there ('print x.i = type( 1, 2 ).i' is fbc's 71 too). Only these positions are judged:
    '' an assignment, a return, 'function =' or a nested '{ }' initializer takes a type from
    '' what it fills, and 'no type recorded' was wrong for several of those (the corpus).
    for n as long = 1 to total - 1
        dim as NodeId cn = NODE_NONE, cn2 = NODE_NONE
        select case c.ast->Kind( cast( NodeId, n ) )
        case N_IF_BRANCH, N_WHILE, N_DO
            cn = c.ast->stmts[cast( long, c.ast->nodes[n].data )].a
        case N_MEMBER
            cn = c.ast->binaries[cast( long, c.ast->nodes[n].data )].lhs
        end select
        if (cn > 0) andalso (cast( long, cn ) < total) then argOf[cast( long, cn )] = 3
        if (cn2 > 0) andalso (cast( long, cn2 ) < total) then argOf[cast( long, cn2 )] = 3
    next
    for n as long = 1 to total - 1
        dim as NodeId id = cast( NodeId, n )
        if c.ast->Kind( id ) <> N_TUPLE then continue for
        if (c.ast->nodes[n].flags and NF_TYPE_LITERAL) = 0 then continue for
        if c.ast->lists[cast( long, c.ast->nodes[n].data )].target <> NODE_NONE then continue for
        dim as boolean bad = (argOf[n] = 2) orelse (argOf[n] = 3)
        if bad then c.diags->Report( TKO0925, PointRange( c.ast->Loc( id ) ) )
    next
end sub
