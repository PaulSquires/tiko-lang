'' checkbase.bas -- COPYING EACH UDT'S BASE INTO THE TYPE TABLE.
''
'' Split out of check.bas at the 1500-line cap and included from it in the same place,
'' before ConversionCost, whose derived-to-base tier is the only reason this exists.
'' Nothing in it changed in the move.

'' COPY EACH UDT'S BASE INTO THE TYPE TABLE, once, before anything is typed.
''
'' 'extends T' is a field named 'base' in the type's own scope, which is where the fact
'' belongs and where every other pass reads it. ConversionCost cannot: it is handed a
'' TypeContext and nothing else, on purpose, and asking it to carry a SymbolTable so it
'' could answer one question would give it a reason to ask others.
private sub RecordUdtBases_( byref c as Ctx )
    dim as Tko.InternId baseNm = c.names->GetString( "base" )
    for i as long = 1 to c.types->Count( )
        dim as Tko.TypeId t = cast( Tko.TypeId, i )
        if c.types->Kind( t ) <> Tko.TK_UDT then continue for
        dim as Tko.InternId tn = c.types->NameOf( t )
        if tn = 0 then continue for
        dim as Tko.ScopeId ds = cast( Tko.ScopeId, c.types->DeclScopeOf( t ) )
        dim as Tko.SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
        if ts = Tko.SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
        dim as Tko.Symbol ptr s = c.syms->SymbolAt( ts )
        if s = 0 then continue for
        if s->inner = Tko.SCOPE_NONE then continue for
        dim as Tko.SymbolId bf = c.syms->LookupLocal( s->inner, baseNm )
        if bf = Tko.SYMBOL_NONE then continue for
        dim as Tko.Symbol ptr b = c.syms->SymbolAt( bf )
        if b = 0 then continue for
        if b->type_ = Tko.TYPE_NONE then continue for
        '' A type is never its own base; a cycle here would be a parse error upstream,
        '' but BaseDistance's depth cap does not depend on that being true.
        if c.types->Unqualify( b->type_ ) = t then continue for
        c.types->SetBase( t, c.types->Unqualify( b->type_ ) )
    next
end sub

'' WHAT A DERIVED-TO-BASE ARGUMENT COSTS, or CONV_NONE when the two are unrelated.
''
'' A UDT reached NOTHING but its own type in the conversion table, so passing a T2 to a
'' 'byref x as T1' scored CONV_NONE -- and with one candidate as with several, that is
'' not a diagnostic: the callee still binds, the call is emitted with a VOID result, and
'' whatever consumed it declines.
''
'' Measured from fbc: the exact type wins, then the NEAREST base. Offered
'' { object, T1, T2 } a T3 argument takes T2, and offered { object, T1 } it takes T1.
private function UdtBaseCost_ _
    ( byval from_ as Tko.TypeId, byval to_ as Tko.TypeId, _
      byref types as Tko.TypeContext ) as long

    dim as long ud = types.BaseDistance( from_, to_ )
    if ud <= 0 then return CONV_NONE
    '' ...to a CONST base from a non-const argument: one tier down -- CONV_UDT_CONST_ADD.
    if types.IsConst( to_ ) andalso (types.IsConst( from_ ) = false) then
        return CONV_UDT_CONST_ADD + ud
    end if
    return CONV_UDT_BASE + (ud - 1) * CONV_UDT_LINK
end function

'' '@x' IS A POINTER TO x -- EXCEPT '@this', which is the receiver's own address. 'this'
'' is typed as the pointer it is held as, so wrapping it again made '@this' inside a
'' method a 'T ptr ptr': overload resolution found no candidate for 'g.DrawImage( @this,
'' @rc )' (TKO0632, where fbc calls the GpRect one), 'cast( CGpImage ptr, @this )' was
'' refused, and lowering -- which always passed the right address -- was never asked.
'' AfxNova's CGpBitmap.MakeTransparent is the shape, and PsCalendar reached it.
''
'' '@"lit"' IS A 'zstring ptr', not a 'string ptr': a literal is a ZSTRING to fbc, and Check
'' types it STRING. Measured, fbc-modern: 'typeof( @"abc" )', 'typeof( @(("abc")) )' and
'' 'typeof( iif( c, @"wb", @"rb" ) )' are all 'ZSTRING * 8 PTR', and only 'dim sp as string
'' ptr = @"x"' draws its warning 4. As 'string ptr' tiko warned TKO0833 at every
'' 'iif( .., @"wb", @"rb" )' and macro '@(lit)' handed to a 'zstring ptr' parameter
'' (tiko-rt's io/devstd, io/devcomopen, dt/intldrv) and was silent on the one fbc warns
'' about -- ptrwarn.bas patched the type over for the plain shapes only (PwLitAddr_, now
'' gone). A WIDE literal is not a STRING and keeps the type it has.
private function AddrOfType_ _
    ( byref c as Ctx, byval operand as Tko.NodeId, byval inner as Tko.TypeId ) as Tko.TypeId

    if c.types->Unqualify( inner ) = c.types->Builtin( Tko.TY_STRING ) then
        dim as Tko.NodeId lo = operand
        for guard as long = 0 to 15
            if lo = Tko.NODE_NONE then exit for
            if c.ast->Kind( lo ) <> Tko.N_PAREN then exit for
            dim as Tko.ListPayload ptr pp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, lo )].data )]
            if pp->count <> 1 then exit for
            lo = cast( Tko.NodeId, c.ast->children[pp->first] )
        next
        if lo <> Tko.NODE_NONE then
            dim as boolean isLit = false
            select case c.ast->Kind( lo )
            case Tko.N_STRING_LIT, Tko.N_STRCAT
                isLit = true
            case Tko.N_IDENT, Tko.N_MEMBER
                dim as Tko.Symbol ptr ks = c.syms->SymbolAt( c.info->RefOf( lo ) )
                if ks <> 0 then isLit = (ks->kind = cast( ubyte, Tko.SYM_CONSTANT ))
            end select
            if isLit then return c.types->Pointer_( c.types->Builtin( Tko.TY_ZSTRING ) )
        end if
    end if

    if c.ast->Kind( operand ) = Tko.N_IDENT then
        dim as Tko.Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( operand ) )
        if s <> 0 then
            if s->kind = cast( ubyte, Tko.SYM_PARAMETER ) then
                if s->name = c.names->Fold( c.names->GetString( "this" ) ) then
                    if c.types->Kind( c.types->Unqualify( inner ) ) = Tko.TK_POINTER then return inner
                end if
            end if
        end if
    end if
    return c.types->Pointer_( inner )
end function

'' A MEMBER THROUGH A VALUE OF AN ENUM TYPE -- fbc's error 265, "Symbol not a CLASS, ENUM,
'' TYPE or UNION type". Measured: 'v.EB' over a VARIABLE of type E, and 'p.EB' over a
'' PARAMETER, are refused -- and so is 'E.EA' inside 'f( byval e as E )', because there 'e'
'' IS the parameter -- while the nested 'x.IE.I1', a member access that names the type,
'' compiles. tiko bound the member and printed it. Reports TKO0835 and answers true for a
'' plain name bound to a variable or parameter whose type is an enum; false otherwise.
private function EnumValueBase_ _
    ( byref c as Ctx, byval b as Tko.NodeId, byval bt as Tko.TypeId ) as boolean

    if bt = Tko.TYPE_NONE then return false
    dim as Tko.TypeId u = c.types->Unqualify( bt )
    if c.types->Kind( u ) = Tko.TK_REFERENCE then u = c.types->Unqualify( c.types->Inner( u ) )
    if c.types->Kind( u ) <> Tko.TK_ENUM then return false
    if c.ast->Kind( b ) <> Tko.N_IDENT then return false
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( b ) )
    if s = 0 then return false
    select case cast( Tko.SymbolKind, s->kind )
    case Tko.SYM_VARIABLE, Tko.SYM_PARAMETER
    case else
        return false
    end select
    '' ONCE: an untyped node is typed again on every visit -- TypeOf_ caches only a type
    '' it found -- so the same member was reported twice.
    dim as Tko.SourceLoc bl = c.ast->Loc( b )
    for i as long = 0 to c.diags->pending.Count - 1
        if (c.diags->pending[i].id = Tko.TKO0835) andalso (c.diags->pending[i].range.first = bl) then return true
    next
    c.diags->Report( Tko.TKO0835, Tko.PointRange( bl ), c.names->Spelling( s->name ) )
    return true
end function

'' 'this' AS AN ARGUMENT IS THE OBJECT, not the pointer it is held in -- the same fact
'' AddrOfType_ answers for '@this'. Costed as a 'T ptr', it was viable for no 'byref as
'' T' or 'byval as T' parameter, so 'x = getctr( this )' came out UNTYPED and lowering
'' dropped the statement with nothing said; over 'byref as T' beside 'byval as T ptr'
'' it picked the pointer one. Measured, fbc-modern: 'ovl( this )' calls the byref T
'' overload and 'ovl( @this )' the pointer one, and 'f( this )' against a lone
'' 'byval as T ptr' is error 58. Anything that is not 'this' keeps the type it has.
private function ThisArgType_ _
    ( byref c as Ctx, byval a as Tko.NodeId, byval at as Tko.TypeId ) as Tko.TypeId

    if c.ast->Kind( a ) <> Tko.N_IDENT then return at
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( a ) )
    if s = 0 then return at
    if s->kind <> cast( ubyte, Tko.SYM_PARAMETER ) then return at
    if s->name <> c.names->Fold( c.names->GetString( "this" ) ) then return at
    dim as Tko.TypeId u = c.types->Unqualify( at )
    if c.types->Kind( u ) <> Tko.TK_POINTER then return at
    return c.types->Inner( u )
end function

'' A METHOD NAMED WITHOUT PARENTHESES OVER AN OVERLOAD SET IS A CALL OF THE ONE OVERLOAD
'' THAT NEEDS NO ARGUMENT -- none, or a default for every parameter -- not of the chain's
'' head. Measured on fbc-modern, over 'GetX( byval p as GD ptr ) as long' declared before
'' 'GetX( ) as GD': 'this.GetX', 'GetX' inside a method, 't1.GetX', 'TakeGD( this.GetX )'
'' and the static 'T.SX' all call the zero-parameter one, and over 'GetY( byval q as
'' integer )' beside 'GetY( byval k as long = 5 )' the defaulted one. tiko typed the member
'' from the head: AfxNova's 'dim rguid as GUID = this.GetRawFormat' was a GpStatus, TKO0738.
''
'' A name that is CALLED, addressed or assigned is left alone (NF_CALL_TARGET): overload
'' resolution picks for a call, and the reference it is handed must stay the chain head.
'' Nothing changes unless exactly ONE overload qualifies. The pick is recorded on the node,
'' which is what lowering reads to make the call.
private function ParenlessMethodOf_ _
    ( byref c as Ctx, byval sid as Tko.SymbolId, byval id as Tko.NodeId ) as Tko.SymbolId

    if sid = Tko.SYMBOL_NONE then return sid
    if (c.ast->nodes[cast( long, id )].flags and Tko.NF_CALL_TARGET) <> 0 then return sid
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return sid
    if s->kind <> cast( ubyte, Tko.SYM_PROC ) then return sid
    if s->nextOverload = Tko.SYMBOL_NONE then return sid

    dim as Tko.SymbolId pick = Tko.SYMBOL_NONE
    dim as long found = 0
    dim as Tko.SymbolId cur = sid
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 256)
        guard += 1
        dim as Tko.Symbol ptr cs = c.syms->SymbolAt( cur )
        if cs = 0 then exit while
        dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
        if pn = Tko.NODE_NONE then return sid
        if c.ast->Kind( pn ) <> Tko.N_PROC then return sid
        dim as Tko.StmtPayload ptr pp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, pn )].data )]
        '' A SUB OR A FUNCTION; a property already has PropertyReadAccessor_.
        select case cast( Tko.TokenKind, pp->op )
        case Tko.KW_SUB, Tko.KW_FUNCTION
        case else
            return sid
        end select
        dim as boolean callable = true
        for i as long = 0 to pp->count - 1
            dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
            if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
            dim as Tko.StmtPayload ptr prp = _
                @c.ast->stmts[cast( long, c.ast->nodes[cast( long, prm )].data )]
            if prp->op = cast( ushort, Tko.TK_ELLIPSIS ) then continue for
            if prp->b = Tko.NODE_NONE then
                callable = false
                exit for
            end if
        next
        if callable then
            found += 1
            pick = cur
        end if
        cur = cs->nextOverload
    wend
    if found <> 1 then return sid
    if pick = sid then return sid
    c.info->SetRef( id, pick )
    if c.ast->Kind( id ) = Tko.N_MEMBER then
        c.info->SetRef( c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )].rhs, pick )
    end if
    return pick
end function

'' A TYPE OF THE PROGRAM'S OWN IS NOT THE INTRINSIC IT IS SPELLED LIKE, and unlike a
'' procedure (see IntrinsicCallType_) there is no builtin-argument exception. Measured on
'' fbc-modern beside 'type Str' with a zstring constructor: 'str( 42 )' is error 58 against
'' that constructor, and '#print typeof' of 'Str( "abc" )', 'str( "abc" )' and 'str( 42 )'
'' is STR for all three. tiko typed the call STRING, so 'a.s = Str( "abc" )' over 'operator
'' let( byref o as Str )' missed the same-type let, reached the converting-let path, and
'' passed the temporary's LOADED bytes where the reference belonged -- clang: "defined with
'' type '[8 x i8]' but expected 'ptr'" -- and nothing destroyed the temporary.
private function UdtShadowsIntrinsic_ _
    ( byref c as Ctx, byval bsym as Tko.Symbol ptr ) as boolean

    if bsym = 0 then return false
    if bsym->kind <> cast( ubyte, Tko.SYM_UDT ) then return false
    if bsym->type_ = Tko.TYPE_NONE then return false
    return (c.types->Kind( c.types->Unqualify( bsym->type_ ) ) = Tko.TK_UDT)
end function

'' A UDT ARGUMENT NOTHING CAN CONVERT, for the no-overload-matches report (overload.bas),
'' which otherwise declines every UDT argument: a user cast, a parameter type's
'' constructor, a base-class conversion or a generic instantiation may be the path the
'' scoring does not model. None applies when the argument's type -- a named, non-generic
'' UDT -- declares no 'operator cast' in itself or what it extends, and every candidate's
'' parameters are builtins or pointers. Measured on fbc-modern 1.20, 2026-09-30: 'g( u )'
'' over 'g( long )' and 'g( double )', and 'hashOf( k )' over fb/hash.bi's builtin
'' overloads (generics/fail-container-nohash, -set), are fbc's error 99.
declare function UdtMemberSym_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref nm as string ) as Tko.SymbolId

declare function UdtReachable_ _
    ( byref c as Ctx, byval u as Tko.TypeId, byval p as Tko.TypeId ) as boolean

private function UdtArgInert_ _
    ( byref c as Ctx, byval u as Tko.TypeId, byval callee as Tko.SymbolId ) as boolean
    if c.types->Kind( u ) <> Tko.TK_UDT then return false
    dim as Tko.InternId tn = c.types->NameOf( u )
    if tn = 0 then return false
    dim as string tsp = c.names->Spelling( tn )
    dim as string h = left( tsp, 1 )
    if (h = "(") orelse (h = "$") orelse (h = "~") orelse (instr( tsp, "<" ) > 0) then return false
    dim as Tko.TypeId t = u
    for guard as long = 0 to 31
        if (t = Tko.TYPE_NONE) orelse (c.types->Kind( t ) <> Tko.TK_UDT) then exit for
        if UdtMemberSym_( c, t, "cast" ) <> Tko.SYMBOL_NONE then return false
        t = c.types->BaseOf( t )
    next
    dim as Tko.SymbolId ck = callee
    for guard as long = 0 to 999
        if ck = Tko.SYMBOL_NONE then exit for
        dim as Tko.Symbol ptr cs = c.syms->SymbolAt( ck )
        if cs = 0 then exit for
        dim as Tko.NodeId cn = cast( Tko.NodeId, cs->payload )
        if (cn = Tko.NODE_NONE) orelse (c.ast->Kind( cn ) <> Tko.N_PROC) then return false
        dim as Tko.StmtPayload ptr cp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, cn )].data )]
        for i as long = 0 to cp->count - 1
            dim as Tko.NodeId pn = cast( Tko.NodeId, c.ast->children[cp->first + i] )
            if c.ast->Kind( pn ) <> Tko.N_PARAM then continue for
            dim as Tko.NodeId pa = c.ast->stmts[cast( long, c.ast->nodes[cast( long, pn )].data )].a
            if pa = Tko.NODE_NONE then return false
            dim as Tko.TypeId pt = c.types->Unqualify( c.info->TypeOf_( pa ) )
            if c.types->Kind( pt ) = Tko.TK_REFERENCE then pt = c.types->Unqualify( c.types->Inner( pt ) )
            select case c.types->Kind( pt )
            case Tko.TK_BUILTIN, Tko.TK_POINTER
            case Tko.TK_UDT
                '' ...OR A UDT NOTHING REACHES FROM THE ARGUMENT: not its type or one it
                '' extends, and with no constructor to build one from it. std/containers'
                '' 'HashOf( byref k as Hashable )' beside the builtin overloads is the case:
                '' a key type with no hash was an internal error, not the TKO0632 it is.
                if UdtReachable_( c, u, pt ) then return false
            case else
                return false
            end select
        next
        ck = cs->nextOverload
    next
    return true
end function

'' Can an argument of UDT 'u' reach a parameter of UDT 'p' -- p is u or a base of it, or p
'' has a constructor (which some argument might build it through)? See UdtArgInert_.
private function UdtReachable_ _
    ( byref c as Ctx, byval u as Tko.TypeId, byval p as Tko.TypeId ) as boolean
    if c.types->NameOf( p ) = 0 then return true
    dim as string psp = c.names->Spelling( c.types->NameOf( p ) )
    if (left( psp, 1 ) = "(") orelse (left( psp, 1 ) = "$") orelse (instr( psp, "<" ) > 0) then return true
    if UdtMemberSym_( c, p, "__ctor" ) <> Tko.SYMBOL_NONE then return true
    dim as Tko.TypeId t = u
    for guard as long = 0 to 31
        if (t = Tko.TYPE_NONE) orelse (c.types->Kind( t ) <> Tko.TK_UDT) then exit for
        if t = p then return true
        t = c.types->BaseOf( t )
    next
    return false
end function

'' TWO INTEGER BUILTINS OF ONE WIDTH AND SIGNEDNESS are one type to a BYREF parameter --
'' measured on fbc-modern 1.20, 2026-09-30, 64-bit: an INTEGER variable for 'byref as
'' longint' binds, and so does the reverse, alone or among overloads ('g( v )' over 'long'
'' and 'longint' takes the longint one). The overload scoring's byref-exactness rule
'' refused every such pair, so 'screeninfo w, h' over INTEGERs matched no overload once the
'' prelude's 64-bit half took LONGINT, as fbc's does (gfx/screeninfo-params).
private function ByrefSameInt_ _
    ( byref c as Ctx, byval a as Tko.TypeId, byval b as Tko.TypeId ) as boolean
    dim as Tko.TypeId ua = c.types->Unqualify( a ), ub = c.types->Unqualify( b )
    if (c.types->Kind( ua ) <> Tko.TK_BUILTIN) orelse (c.types->Kind( ub ) <> Tko.TK_BUILTIN) then return false
    dim as long sa = 0, sb = 0
    select case c.types->BuiltinOf( ua )
    case Tko.TY_BYTE, Tko.TY_SHORT, Tko.TY_LONG, Tko.TY_INTEGER, Tko.TY_LONGINT : sa = 1
    case Tko.TY_UBYTE, Tko.TY_USHORT, Tko.TY_ULONG, Tko.TY_UINTEGER, Tko.TY_ULONGINT : sa = 2
    end select
    select case c.types->BuiltinOf( ub )
    case Tko.TY_BYTE, Tko.TY_SHORT, Tko.TY_LONG, Tko.TY_INTEGER, Tko.TY_LONGINT : sb = 1
    case Tko.TY_UBYTE, Tko.TY_USHORT, Tko.TY_ULONG, Tko.TY_UINTEGER, Tko.TY_ULONGINT : sb = 2
    end select
    if (sa = 0) orelse (sa <> sb) then return false
    return c.types->Layout( ua ).size = c.types->Layout( ub ).size
end function

'' A TIE WHOSE UDT ARGUMENTS EACH CONVERT THROUGH TWO OR MORE 'operator cast's (T42) -- one
'' the overload scoring models, so it is reported like any other tie. Measured on
'' fbc-modern 1.20, 2026-10-02: a type casting to double AND to longint, passed to
'' 'Take( double )' / 'Take( longint )', is error 99 -- each overload is reached exactly,
'' through a different cast -- and tiko bound one in silence, because a UDT argument
'' otherwise keeps the tie report quiet (overload.bas says why). A builtin or pointer
'' argument beside it is fine; any other UDT argument still keeps it quiet.
function UdtCastTie_( byref c as Ctx, byref argT as FB.Array( of ulong ) ) as boolean
    dim as boolean any_ = false
    for i as long = 0 to argT.Count - 1
        dim as Tko.TypeId a = c.types->Unqualify( cast( Tko.TypeId, argT[i] ) )
        if a = Tko.TYPE_NONE then return false
        if c.types->Kind( a ) = Tko.TK_REFERENCE then a = c.types->Unqualify( c.types->Inner( a ) )
        select case c.types->Kind( a )
        case Tko.TK_BUILTIN, Tko.TK_POINTER
        case Tko.TK_UDT
            dim as Tko.SymbolId cs = UdtMemberSym_( c, a, "cast" )
            if cs = Tko.SYMBOL_NONE then return false
            dim as Tko.Symbol ptr s = c.syms->SymbolAt( cs )
            if (s = 0) orelse (s->nextOverload = Tko.SYMBOL_NONE) then return false
            any_ = true
        case else
            return false
        end select
    next
    return any_
end function

'' '@x.f' OVER A BYREF PROPERTY GETTER is the address of its answer, typed 'integer ptr' --
'' measured, fbc prints '@x.f = @x.i' as -1 (functions/return-byref.bas). Not a procptr.
private function ByrefPropOperand_ _
    ( byref c as Ctx, byval operand as Tko.NodeId, byval psym as Tko.Symbol ptr ) as boolean
    if c.ast->Kind( operand ) <> Tko.N_MEMBER then return false
    dim as Tko.NodeId ppn = cast( Tko.NodeId, psym->payload )
    if (ppn = Tko.NODE_NONE) orelse (c.ast->Kind( ppn ) <> Tko.N_PROC) then return false
    if c.ast->stmts[cast( long, c.ast->nodes[cast( long, ppn )].data )].op <> cast( ushort, Tko.KW_PROPERTY ) then return false
    return ((c.ast->nodes[cast( long, ppn )].flags and Tko.NF_BYREF) <> 0)
end function
