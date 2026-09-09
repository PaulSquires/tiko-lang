'' lowerthread.bas -- 'threadcall f( a, b )'.
''
'' A THREAD CALL IS A MARSHALLED CALL, not a call. fbc hands fb_ThreadCall the
'' procedure's ADDRESS, its calling convention, a zero, the argument COUNT, and then a
'' (TYPE CODE, ADDRESS) PAIR for every argument -- no argument travels by value.
'' Measured, and the declaration is the one already in the runtime table:
''
''     void* fb_ThreadCall( void*, int32, int64, int32, ... );
''
''     threadcall NoArgs                fb_ThreadCall( (void*)&NOARGS, 0, 0ll, 0 )
''     threadcall Scal( 1, 2.5, 3 )     fb_ThreadCall( (void*)&SCAL, 0, 0ll, 3,
''                                          8ll, &TMP$4$0, 11ll, &TMP$5$0, 4ll, &TMP$6$0 )
''
'' THE TYPE CODES ARE MEASURED, one probe per type:
''
''     byte 2   ubyte 3   short 4   ushort 5   long 6   ulong 7
''     longint / integer(64) 8      ulongint 9    single 10   double 11
''     any ptr, zstring ptr, wstring ptr, string, ARRAY, and EVERY BYREF   13
''     an ENUM is its underlying integer, so 8 on win64 and 6 on win32
''
'' -- and the SECOND fixed argument is the CALLING CONVENTION: 1 for cdecl (and for a
'' procedure inside an EXTERN "C" block), 0 for stdcall and for the default. The third
'' never moved in any probe and is passed as the zero fbc passes.
''
'' A BYVAL UDT IS A COMPOSITE DESCRIPTOR, and the descriptor is a RUN of arguments
'' rather than one: the code 12, then the field COUNT, then one descriptor per field,
'' recursively -- and the ADDRESS comes ONCE, after the whole run. Measured on win64,
'' 2026-09-09, `fbc64 -r`; every line below is a probe's own output:
''
''     type One   : z as long : end type
''     type Two   : p as short : q as short : end type
''     type Three : a as Two : b as double : c as long : end type
''     type Deep  : x as One : y as integer : end type
''     type PtrF  : p as any ptr : q as byte : end type
''
''     sOne( o1 )     fb_ThreadCall( &SONE,   0, 0ll, 1,  6,                   &O1 )
''     sTwo( t2 )     fb_ThreadCall( &STWO,   0, 0ll, 1,  12,2, 4, 4,          &T2 )
''     sThree( t3 )   fb_ThreadCall( &STHREE, 0, 0ll, 1,  12,3, 12,2,4,4, 11,6,&T3 )
''     sDeep( dd )    fb_ThreadCall( &SDEEP,  0, 0ll, 1,  12,2, 6, 8,          &DD )
''     sPtrF( pf )    fb_ThreadCall( &SPTRF,  0, 0ll, 1,  12,2, 13, 2,         &PF )
''
'' THE COLLAPSE IS OF THE CODE, NOT OF THE DESCRIPTOR, and that distinction is the
'' whole of it. A UDT with exactly ONE field takes THAT FIELD'S code -- 'One' above is
'' 6, not '12,1,6' -- but when the single field is itself a MULTI-field UDT the code
'' collapses to 12 and the fields that are then written out are the OUTER type's:
''
''     type OneUdt : only as Two    : end type   12,1, 12,2,4,4
''     type OneOne : only as OneUdt : end type   12,1, 12,1, 12,2,4,4
''
'' -- count 1 each time. Reading it as "collapse the whole descriptor" would have
'' written '12,2,4,4' for OneUdt, which is a different struct.
''
'' 'EXTENDS' DOES NOT FLATTEN. The base is field number one, described like any other
'' UDT field: 'type Derived extends Two : d1 as double : end type' is '12,2, 12,2,4,4,
'' 11'. HANDOFF recorded the opposite; the probe says otherwise.
''
'' A METHOD IS NOT A FIELD ('12,2,6,6' for a two-field type declaring a constructor and
'' two subs), an rvalue argument gets the temporary hGetExprRef makes for it
'' ('&TMP$10$0' for 'threadcall sPar( mkPar( ) )'), and a variable gets its own address
'' with no temporary at all.
''
'' A 'zstring * N' FIELD IS DESCRIBED AS ONE UBYTE -- '12,2, 3, 6' for
'' '{ zs as zstring * 8, n as long }'. The runtime builds an ffi_type out of the run,
'' so 8 bytes are described as 1 and the marshalled copy is short. THAT IS AN fbc
'' DEFECT AND IT IS MATCHED ON PURPOSE: the ground truth here is fbc executed, and a
'' deliberate divergence would make a tiko-built program behave differently from an
'' fbc-built one for no measurement's sake. Recorded in HANDOFF as a decision either
'' way. A 'wstring * N' field, a 'string * N' field and a var-len 'string' field are
'' all fbc error 288 instead.
''
'' WHAT fbc REFUSES, each measured as error 288 and each a DECLINE here rather than a
'' diagnostic:
''
''     a UNION member, an ANONYMOUS union, a BITFIELD, a fixed ARRAY field, a
''     var-len STRING field, a 'string * N' or 'wstring * N' field, a BOOLEAN
''     field, and a type declared 'field = N' (any packing at all)
''
'' -- plus, outside the descriptor, a boolean argument, a byref wstring, a pascal
'' procedure, a variadic cdecl one, a FUNCTION rather than a sub, an
'' instance-qualified member call and a procedure POINTER.
''
'' AN ANONYMOUS TYPE is declined with the anonymous unions. fbc's test is
'' 'symbGetUDTHasAnonUnion', so an anonymous TYPE inside a struct may well be
'' accepted -- it was not probed, and the field walk below cannot reproduce fbc's
'' 'symbUdtGetFirstField' order for one, because tiko-lang's layout FLATTENS every
'' anonymous group into the parent's field list. Declining an unmeasured shape is the
'' rule; a guessed field count is a miscompile in a thread.

'' The UDT symbol a TypeId belongs to. Same lookup as vtable.bas's, local because the
'' one there is private to its module.
declare function ThreadUdtSym_ _
    ( byref c as Ctx, byval t as Tko.TypeId ) as Tko.SymbolId

private function ThreadUdtSym_ _
    ( byref c as Ctx, byval t as Tko.TypeId ) as Tko.SymbolId

    if t = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
    if c.types->Kind( t ) <> Tko.TK_UDT then return Tko.SYMBOL_NONE
    dim as Tko.InternId tn = c.types->NameOf( t )
    if tn = 0 then return Tko.SYMBOL_NONE
    dim as Tko.ScopeId ds = cast( Tko.ScopeId, c.types->DeclScopeOf( t ) )
    dim as Tko.SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = Tko.SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    return ts
end function

'' A UDT's fields in DECLARATION order, or false when fbc would refuse the type
'' outright. The walk is the one udtlayout.bas does -- the per-scope linked list --
'' rather than the computed layout, because the layout flattens anonymous groups and
'' loses the bitfield/anon flags this needs.
declare function ThreadUdtFields_ _
    ( byref c as Ctx, byval t as Tko.TypeId, _
      byref outFlds as FB.Array( of ulong ) ) as boolean

private function ThreadUdtFields_ _
    ( byref c as Ctx, byval t as Tko.TypeId, _
      byref outFlds as FB.Array( of ulong ) ) as boolean

    dim as Tko.Symbol ptr s = c.syms->SymbolAt( ThreadUdtSym_( c, t ) )
    if s = 0 then return false
    '' A UNION IS REFUSED, and so is any packing: fbc tests 'symbGetUDTIsUnion' and
    '' 'symbGetUDTAlign( ) <> 0' before it looks at a single field.
    if (s->flags and Tko.SYMF_UNION_KIND) <> 0 then return false
    if c.types->Packing( t ) <> 0 then return false

    dim as Tko.SymScope ptr sc = c.syms->ScopeAt( s->inner )
    if sc = 0 then return false
    dim as Tko.SymbolId cur = sc->firstSym
    while cur <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr f = c.syms->SymbolAt( cur )
        if f = 0 then exit while
        if f->kind = cast( ubyte, Tko.SYM_FIELD ) then
            '' ANY anonymous group -- see the header.
            if f->anonDepth <> 0 then return false
            outFlds.Push( cast( ulong, cur ) )
        end if
        cur = f->nextInScope
    wend
    '' A type with no fields at all describes nothing; fbc's walk would dereference
    '' NULL, so it cannot arise there either.
    return (outFlds.Count > 0)
end function

declare function ThreadTypeCode_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref ok as boolean, _
      byval inUdt as boolean = false, byval depth as long = 0 ) as longint

'' One FIELD's code. Separate from the type's because BITFIELD-ness lives on the field
'' symbol and not on its type, and fbc refuses a bitfield before it reads the type.
declare function ThreadFieldCode_ _
    ( byref c as Ctx, byval fs as Tko.Symbol ptr, byref ok as boolean, _
      byval depth as long ) as longint

private function ThreadFieldCode_ _
    ( byref c as Ctx, byval fs as Tko.Symbol ptr, byref ok as boolean, _
      byval depth as long ) as longint

    ok = false
    if fs = 0 then return 0
    if (fs->flags and Tko.SYMF_BITFIELD) <> 0 then return 0
    return ThreadTypeCode_( c, fs->type_, ok, true, depth )
end function

private function ThreadTypeCode_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref ok as boolean, _
      byval inUdt as boolean, byval depth as long ) as longint

    ok = false
    if t = Tko.TYPE_NONE then return 0
    '' A UDT cannot hold itself by value, so this can only trip on a type graph that
    '' is already broken -- and an unbounded recursion here would be a compiler hang.
    if depth > 64 then return 0
    dim as Tko.TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) = Tko.TK_REFERENCE then u = c.types->Unqualify( c.types->Inner( u ) )

    '' Everything that travels as a POINTER shares one code.
    select case c.types->Kind( u )
    case Tko.TK_POINTER, Tko.TK_PROC
        ok = true
        return 13
    case Tko.TK_ARRAY
        '' AN ARRAY ARGUMENT IS A POINTER; AN ARRAY FIELD IS A REFUSAL -- except that
        '' 'zstring * N', which tiko-lang models as an array of TY_ZSTRING and fbc does
        '' not model as an array at all, is one ubyte. See the header.
        if inUdt = false then
            ok = true
            return 13
        end if
        dim as Tko.TypeId el = c.types->Unqualify( c.types->Inner( u ) )
        while c.types->Kind( el ) = Tko.TK_ARRAY
            el = c.types->Unqualify( c.types->Inner( el ) )
        wend
        if c.types->Kind( el ) <> Tko.TK_BUILTIN then return 0
        if c.types->BuiltinOf( el ) <> Tko.TY_ZSTRING then return 0
        ok = true
        return 3
    case Tko.TK_ENUM
        u = c.types->Builtin( Tko.TY_INTEGER )
    case Tko.TK_UDT
        dim as FB.Array( of ulong ) flds
        if ThreadUdtFields_( c, u, flds ) = false then return 0
        if flds.Count = 1 then
            '' THE CODE COLLAPSES, THE DESCRIPTOR DOES NOT -- see the header.
            return ThreadFieldCode_( c, c.syms->SymbolAt( _
                cast( Tko.SymbolId, flds[0] ) ), ok, depth + 1 )
        end if
        ok = true
        return 12
    end select
    if c.types->Kind( u ) <> Tko.TK_BUILTIN then return 0

    dim as boolean is32 = (c.types->target.pointerBits = 32)
    select case c.types->BuiltinOf( u )
    case Tko.TY_BYTE     : ok = true : return 2
    case Tko.TY_UBYTE    : ok = true : return 3
    case Tko.TY_SHORT    : ok = true : return 4
    case Tko.TY_USHORT   : ok = true : return 5
    case Tko.TY_LONG     : ok = true : return 6
    case Tko.TY_ULONG    : ok = true : return 7
    case Tko.TY_LONGINT  : ok = true : return 8
    case Tko.TY_ULONGINT : ok = true : return 9
    case Tko.TY_SINGLE   : ok = true : return 10
    case Tko.TY_DOUBLE   : ok = true : return 11
    case Tko.TY_INTEGER
        ok = true
        return iif( is32, 6, 8 )
    case Tko.TY_UINTEGER
        ok = true
        return iif( is32, 7, 9 )
    case Tko.TY_STRING, Tko.TY_ZSTRING, Tko.TY_WSTRING, Tko.TY_FIXSTR
        '' A STRING ARGUMENT IS A POINTER; A STRING FIELD IS fbc ERROR 288, measured.
        '' The other three cannot be written as a bare field type, so refusing them
        '' inside a UDT costs nothing and guesses nothing.
        if inUdt then return 0
        ok = true
        return 13
    end select
    '' BOOLEAN lands here on purpose: fbc REFUSES it, error 288.
    return 0
end function

'' ONE ARGUMENT'S TYPE DESCRIPTION, pushed into the variadic tail. For everything but
'' a composite that is the single code; for code 12 it is the code, the field count and
'' one description per field, recursively. The type expanded is the one whose code was
'' asked for -- NOT the single field a collapse looked through. See the header.
declare function PushThreadDesc_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval code as longint, _
      byref args as FB.Array( of ulong ), byval depth as long = 0 ) as boolean

private function PushThreadDesc_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval code as longint, _
      byref args as FB.Array( of ulong ), byval depth as long ) as boolean

    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( cast( ulong, cast( long, code ) ) )
    if code <> 12 then return true
    if depth > 64 then return false

    dim as Tko.TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) = Tko.TK_REFERENCE then u = c.types->Unqualify( c.types->Inner( u ) )
    dim as FB.Array( of ulong ) flds
    if ThreadUdtFields_( c, u, flds ) = false then return false
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( cast( ulong, flds.Count ) )
    for i as long = 0 to flds.Count - 1
        dim as Tko.Symbol ptr f = c.syms->SymbolAt( cast( Tko.SymbolId, flds[i] ) )
        if f = 0 then return false
        dim as boolean fok = false
        dim as longint fc = ThreadFieldCode_( c, f, fok, depth + 1 )
        if fok = false then return false
        if PushThreadDesc_( c, f->type_, fc, args, depth + 1 ) = false then return false
    next
    return true
end function

'' The callee a 'threadcall' names, with its argument list. Both spellings reach here:
'' 'threadcall f( 1 )' is an N_CALL and 'threadcall f' a bare name.
declare function ThreadCalleeOf_ _
    ( byref c as Ctx, byval it as Tko.NodeId, byref outFirst as long, _
      byref outCount as long ) as Tko.SymbolId

private function ThreadCalleeOf_ _
    ( byref c as Ctx, byval it as Tko.NodeId, byref outFirst as long, _
      byref outCount as long ) as Tko.SymbolId

    outFirst = 0
    outCount = 0
    if it = Tko.NODE_NONE then return Tko.SYMBOL_NONE
    if c.ast->Kind( it ) = Tko.N_CALL then
        dim as Tko.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, it )].data )]
        if lp->target = Tko.NODE_NONE then return Tko.SYMBOL_NONE
        outFirst = lp->first
        outCount = lp->count
        '' A QUALIFIED CALLEE IS STILL A CALLEE, and the same namespace test applies.
        if c.ast->Kind( lp->target ) = Tko.N_MEMBER then
            dim as long qf, qc
            return ThreadCalleeOf_( c, lp->target, qf, qc )
        end if
        return c.info->RefOf( lp->target )
    end if
    if c.ast->Kind( it ) = Tko.N_IDENT then return c.info->RefOf( it )

    '' 'threadcall ThreadCallNS.ns' -- A NAMESPACE-QUALIFIED CALLEE, which is a member
    '' access over a namespace and not over an object. An INSTANCE-qualified one is
    '' fbc error 289, so the base has to be a namespace and not merely resolve to a
    '' procedure: 'bc.m( )' must keep declining rather than call the member with no
    '' receiver.
    if c.ast->Kind( it ) = Tko.N_MEMBER then
        dim as Tko.BinaryPayload ptr mb = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, it )].data )]
        dim as Tko.Symbol ptr bs = c.syms->SymbolAt( c.info->RefOf( mb->lhs ) )
        if bs = 0 then return Tko.SYMBOL_NONE
        if bs->kind <> cast( ubyte, Tko.SYM_NAMESPACE ) then return Tko.SYMBOL_NONE
        return c.info->RefOf( it )
    end if
    return Tko.SYMBOL_NONE
end function

function LowerThreadCall_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    if cast( Tko.TokenKind, sp->op ) <> Tko.KW_THREADCALL then return false
    if sp->count <> 1 then return false
    dim as Tko.NodeId it = cast( Tko.NodeId, c.ast->children[sp->first] )

    dim as long aFirst, aCount
    dim as Tko.SymbolId callee = ThreadCalleeOf_( c, it, aFirst, aCount )
    if callee = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr cs = c.syms->SymbolAt( callee )
    if cs = 0 then return false
    if cs->kind <> cast( ubyte, Tko.SYM_PROC ) then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
    if pn = Tko.NODE_NONE then return false
    if c.ast->Kind( pn ) <> Tko.N_PROC then return false

    '' A FUNCTION IS NOT A THREAD CALL -- fbc error 289, "Expected sub". Neither is a
    '' PASCAL one, error 288.
    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    if pp->a <> Tko.NODE_NONE then return false
    if (pp->extra and Tko.PF_PASCAL) <> 0 then return false

    dim as MirValue fa = FuncAddrOf( c, callee )
    if fa.kind = cast( ubyte, MV_NONE ) then return false

    '' EVERY ARGUMENT LOWERED BEFORE ANYTHING IS PUSHED. A thread call that gives up
    '' half way would leave its temporaries and its stores behind and read as lowered.
    dim as FB.Array( of ulong ) args
    dim as FB.Array( of ulong ) strTemps
    dim as FB.Array( of ulong ) strTempTypes
    args.Push( cast( ulong, fa.kind ) ) : args.Push( cast( ulong, fa.id ) )
    dim as long conv = 0
    if (pp->extra and Tko.PF_CDECL) <> 0 then conv = 1
    if (pp->extra and Tko.PF_FOREIGN) <> 0 then conv = 1
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, conv ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    '' THE COUNT COMES FROM THE CALLEE, not from the call. A DEFAULTED PARAMETER IS
    '' PASSED like any other: measured, 'sub two( byval a as integer, opt as integer
    '' = 13 )' called as 'threadcall two( 5 )' is
    ''
    ''     TMP$4$0 = 13ll;
    ''     fb_ThreadCall( &TWO, 0, 0ll, 2, 8ll, &TMP$3$0, 8ll, &TMP$4$0 )
    ''
    '' -- TWO arguments, the written one and the default. tiko-lang passed the
    '' written count and stopped there, and fb_ThreadCall is VARIADIC, so nothing
    '' complained: the thread read an uninitialised 'opt'. Lowered, verified, and
    '' wrong. The ordinary call path has done this since it was written.
    dim as long nparams = ParamCountOf( c, callee )
    dim as long slots = aCount
    if (nparams > slots) andalso (IsVariadicProc( c, callee ) = false) then
        slots = nparams
    end if
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, slots ) )

    dim as long pbytes = c.types->target.pointerBits \ 8
    for i as long = 0 to slots - 1
        dim as Tko.NodeId ae = Tko.NODE_NONE
        if i < aCount then ae = cast( Tko.NodeId, c.ast->children[aFirst + i] )
        if ae <> Tko.NODE_NONE then
            if c.ast->Kind( ae ) = Tko.N_ELIDED then ae = Tko.NODE_NONE
        end if
        if ae = Tko.NODE_NONE then ae = ParamDefaultAt( c, callee, i )
        if ae = Tko.NODE_NONE then return false
        '' 'byval expr' AT A CALL SITE IS AN N_UNARY, and it is transparent here: fbc
        '' writes the same 'fb_ThreadCall( &S3, 0, 0ll, 1, 13ll, &TMP$2$0 )' with the
        '' byval as without it. Unstripped, the argument was classified as a unary
        '' expression, LowerThreadCall_ returned false, and the whole assignment
        '' declined -- while the ordinary call path had stripped it since it was
        '' written. threads/threadcall.bas:166.
        '' ...AND AN EXPLICIT 'byval' AGAINST A BYREF PARAMETER MEANS THE VALUE IS
        '' THE REFERENCE, so it is remembered rather than merely stripped.
        dim as boolean forcedByval = false
        if c.ast->Kind( ae ) = Tko.N_UNARY then
            dim as Tko.UnaryPayload ptr tup = _
                @c.ast->unaries[cast( long, c.ast->nodes[cast( long, ae )].data )]
            if cast( Tko.TokenKind, tup->op ) = Tko.KW_BYVAL then
                forcedByval = true
                ae = tup->operand
            end if
        end if
        if c.ast->Kind( ae ) = Tko.N_ELIDED then return false
        dim as Tko.TypeId pt = ParamTypeAt( c, callee, i )
        if pt = Tko.TYPE_NONE then return false
        dim as boolean byref_ = ParamIsByref( c, callee, i )

        dim as boolean codeOk = false
        dim as longint code = 0
        if byref_ orelse ParamIsArray( c, callee, i ) then
            '' EVERY BYREF IS 13, whatever it refers to: the pointee type is erased.
            code = 13
            codeOk = true
        else
            code = ThreadTypeCode_( c, pt, codeOk )
        end if
        if codeOk = false then return false

        dim as MirValue av
        if ParamIsArray( c, callee, i ) then
            '' AN ARRAY TRAVELS AS ITS DESCRIPTOR, and the descriptor's ADDRESS goes in
            '' a pointer temporary like any other byref.
            dim as MirValue adv
            if ArrayDescArg_( c, ae, true, adv ) = false then return false
            dim as long aslot = NewTempLocal( c, MT_PTR, pbytes )
            if aslot < 0 then return false
            av.kind = cast( ubyte, MV_LOCAL )
            av.ty = cast( ubyte, MT_PTR )
            av.id = aslot
            StoreThrough( c, av, adv )
        elseif byref_ then
            '' A POINTER TEMPORARY HOLDING THE ADDRESS, and the temporary's own address
            '' is what is passed. Measured: 'int64* TMP$4$0; TMP$4$0 = &IV$0;
            '' fb_ThreadCall( ..., 13ll, &TMP$4$0 )'.
            '' 'byval @bv' HAS NO ADDRESS OF ITS OWN -- it IS one. Asking LowerAddr
            '' for the address of an address-of gave MV_NONE and the whole
            '' assignment declined; fbc stores the VALUE, 'TMP$3$0 = &BV$0'.
            '' threads/threadcall.bas:166 is exactly this argument.
            dim as MirValue ad
            if forcedByval then
                ad = LowerExpr( c, ae )
            else
                ad = LowerAddr( c, ae )
            end if
            if ad.kind = cast( ubyte, MV_NONE ) then return false
            dim as long rslot = NewTempLocal( c, MT_PTR, pbytes )
            if rslot < 0 then return false
            av.kind = cast( ubyte, MV_LOCAL )
            av.ty = cast( ubyte, MT_PTR )
            av.id = rslot
            StoreThrough( c, av, ad )
        elseif IsStringType( c, pt ) then
            '' A BYVAL STRING IS COPIED into a temporary and a POINTER temporary holds
            '' that copy's address. Measured, and the copy's fb_StrDelete sits directly
            '' after the fb_ThreadCall -- before any threadwait, which is fbc's own
            '' lifetime and not one invented here.
            dim as MirValue sv
            dim as long sslot = -1
            if ByvalStrTemp_( c, ae, pt, sv, sslot ) = false then return false
            strTemps.Push( cast( ulong, sslot ) )
            strTempTypes.Push( cast( ulong, pt ) )
            dim as long qslot = NewTempLocal( c, MT_PTR, pbytes )
            if qslot < 0 then return false
            av.kind = cast( ubyte, MV_LOCAL )
            av.ty = cast( ubyte, MT_PTR )
            av.id = qslot
            StoreThrough( c, av, sv )
        elseif c.types->Kind( c.types->Unqualify( pt ) ) = Tko.TK_UDT then
            '' A BYVAL UDT TRAVELS AS ITS OWN ADDRESS, once, after the whole composite
            '' run -- no pointer temporary the way a byref gets one. fbc's hGetExprRef
            '' takes a VARIABLE's address directly and copies anything else into a
            '' temporary of the argument's type first; ByrefTemp_ is that temporary.
            av = LowerAddr( c, ae )
            if av.kind = cast( ubyte, MV_NONE ) then av = ByrefTemp_( c, ae, pt )
            if av.kind = cast( ubyte, MV_NONE ) then return false
        else
            '' A BYVAL SCALAR OVER A VARIABLE PASSES THE VARIABLE'S OWN ADDRESS -- fbc
            '' makes no temporary for one -- and an RVALUE gets a temporary of the
            '' parameter's type.
            dim as MirType pmt = LowerType( pt, *c.types )
            if (pmt = MT_VOID) orelse (pmt = MT_AGG) then return false
            av = LowerAddr( c, ae )
            if av.kind = cast( ubyte, MV_NONE ) then
                dim as MirValue rv = LowerExpr( c, ae )
                if rv.kind = cast( ubyte, MV_NONE ) then return false
                rv = CoerceTy( c, rv, pmt, pt)
                if rv.kind = cast( ubyte, MV_NONE ) then return false
                dim as long vslot = NewTempLocal( c, pmt, TyWidthBytes_( pmt ) )
                if vslot < 0 then return false
                av.kind = cast( ubyte, MV_LOCAL )
                av.ty = cast( ubyte, MT_PTR )
                av.id = vslot
                StoreThrough( c, av, rv )
            end if
        end if
        if av.kind = cast( ubyte, MV_NONE ) then return false

        '' THE DESCRIPTION IS A RUN, not one value: a composite writes its code, its
        '' field count and one description per field before the address arrives.
        if PushThreadDesc_( c, pt, code, args ) = false then return false
        args.Push( cast( ulong, av.kind ) ) : args.Push( cast( ulong, av.id ) )
    next

    outv = EmitRtl( c, RTL_THREAD_CALL, args )
    DeleteStrArgTemps_( c, strTemps, strTempTypes )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function
