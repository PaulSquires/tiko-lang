'' lowerprocret.bas -- the string RETURN, and the small per-procedure queries the
'' rest of lowering asks: STATIC, the calling convention, and the sret copy.
''
'' Split out of lowerproc.bas at the 1500-line cap and INCLUDED from it, inside the
'' same namespace. Nothing moved here changed in the move.


'' 'return expr' out of a STRING-RETURNING function. Returns false when this is not
'' one, so the ordinary RETURN carries on.
''
'' The value does not leave as a value: it is BUILT in the result descriptor and handed
'' to fb_StrAllocTempResult on the way out, which is what fbc emits. Returning the
'' expression directly would hand back a pointer to static text where the caller expects
'' a descriptor.
function LowerStringReturn( byref c as Ctx, byval valueE as Tko.NodeId ) as boolean
    if c.resultSlot < 0 then return false
    if c.resultTy <> cast( ubyte, MT_AGG ) then return false
    '' AND THE RESULT MUST ACTUALLY BE A STRING. MT_AGG alone stopped being enough the
    '' moment a by-value UDT result got an aggregate slot too: every 'return <udt>'
    '' came through here, tried a string assignment into it, and then emitted
    '' fb_StrAllocTempResult ON A UDT. Not a decline -- a string runtime call on an
    '' object, which lowers cleanly and verifies.
    if IsStringType( c, c.resultType ) = false then return false

    if valueE <> Tko.NODE_NONE then
        '' A WIDE VALUE IS A CONVERSION, as 'function = w' already has it -- in the DECLARATION
        '' form, because a RETURN initialises the result. Measured, 'return *p' out of a string
        '' function is 'fb_WstrAssignToA_Init( &fb$result, -1ll, P, 0ll )'. DWSTRING's own OEM
        '' property returns '*m_pBuffer' that way, and the statement was dropped.
        if LowerWideToNarrowSlot( c, c.resultSlot, c.resultType, valueE, true ) = false then
            if LowerStringAssignToSlot( c, c.resultSlot, valueE ) = false then SkipHere( c )
        end if
    end if
    '' A RETURN leaves every open scope, so their actions run before the terminator.
    '' THE STATEMENT'S TEMPORARIES GO BEFORE THE RETURN, the result now copied out of them --
    '' fbc's 'fb_WstrDelete( TMP )' right after the assign (audit F-58).
    ReleaseUdtTemps_( c, c.stmtUdtMark ) : ReleaseStrTemps_( c, c.stmtStrMark ) : ReleaseWstrTemps_( c, c.stmtWstrMark )
    EmitCleanupsTo( c, 0 )

    dim as MirValue rsa
    rsa.kind = cast( ubyte, MV_LOCAL )
    rsa.ty = cast( ubyte, MT_PTR )
    rsa.id = c.resultSlot
    dim as FB.Array( of ulong ) rr
    rr.Push( cast( ulong, rsa.kind ) ) : rr.Push( cast( ulong, rsa.id ) )
    Terminate( c, MTERM_RET, -1, -1, EmitRtl( c, ResultTempRtl_( c ), rr ) )
    c.curBlock = -1
    return true
end function


'' The copy-construction half of a UDT result. False when the type has no copy
'' constructor at all, written or synthesised, which is the trivial structure fbc
'' stores whole.

'' Whether a procedure is a STATIC member, which is the question "does it have a
'' receiver" asked the other way round. PF_STATIC may sit on EITHER node: on the
'' definition when the definition repeats the word, and on the DECLARE when -- as is
'' usual and as fbc requires for the allocation operators -- it does not.
function ProcIsStatic_ _
    ( byref c as Ctx, byval defn as Tko.NodeId, byval sid as Tko.SymbolId ) as boolean

    if defn <> Tko.NODE_NONE then
        dim as Tko.StmtPayload ptr dp = StmtOf( c, defn )
        if dp <> 0 then
            if (dp->extra and Tko.PF_STATIC) <> 0 then return true
        end if
    end if
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
    if pn = Tko.NODE_NONE then return false
    if c.ast->Kind( pn ) <> Tko.N_PROC then return false
    dim as Tko.StmtPayload ptr psp = StmtOf( c, pn )
    if psp = 0 then return false
    return ((psp->extra and Tko.PF_STATIC) <> 0)
end function

'' cdecl / stdcall / pascal, off the proc's own flags. All three are one convention on
'' x86-64 and the emitted IR is identical; it is carried because it is part of the
'' signature, because win32 is a stated target, and because it is unrecoverable later.
function ProcCallConv_ _
    ( byref c as Ctx, byval pn as Tko.NodeId ) as ubyte

    if pn = Tko.NODE_NONE then return TKO_CC_CDECL
    dim as Tko.StmtPayload ptr sp = StmtOf( c, pn )
    if sp = 0 then return TKO_CC_CDECL
    if (sp->extra and Tko.PF_STDCALL) <> 0 then return TKO_CC_STDCALL
    if (sp->extra and Tko.PF_PASCAL) <> 0 then return TKO_CC_PASCAL
    return TKO_CC_CDECL
end function

'' THROUGH A POINTER the procedure TYPE says so (TF_PASCAL); a named call asks the
'' procedure's own node. LowerCallParts evaluates a pascal call's arguments left to right.
function CallIsPascal_ _
    ( byref c as Ctx, byval callee as Tko.SymbolId, byval viaPointer as boolean, _
      byval sigT as Tko.TypeId ) as boolean

    if viaPointer then return c.types->IsPascal( sigT )
    dim as Tko.Symbol ptr cs = c.syms->SymbolAt( callee )
    if cs = 0 then return false
    if cs->kind <> cast( ubyte, Tko.SYM_PROC ) then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
    if pn = Tko.NODE_NONE then return false
    if c.ast->Kind( pn ) <> Tko.N_PROC then return false
    return (ProcCallConv_( c, pn ) = TKO_CC_PASCAL)
end function


private function SretCopyResult_ _
    ( byref c as Ctx, byval valueE as Tko.NodeId, byval rt as Tko.TypeId ) as boolean

    if c.types->Kind( rt ) <> Tko.TK_UDT then return false
    '' ANOTHER TYPE IS CONSTRUCTED INTO THE RESULT through its converting constructor, and
    '' needs no copy constructor at all. 'return "Janvier"' out of a function returning a
    '' type with 'constructor( byref z as const zstring )' is, measured, three constructors
    '' and no lets over three calls -- fbc builds the caller's storage from the literal.
    '' It fell through to the plain store, which wrote the LITERAL'S ADDRESS over the
    '' object: AfxNova's DWSTRING came back holding a pointer to static text as its buffer,
    '' its destructor freed that, and PsCalendar died in CAL_MonthName. The overload is
    '' settled before the hidden pointer is loaded, so a type with none emits nothing.
    scope
        dim as Tko.TypeId xvt = Tko.TYPE_NONE
        dim as MirValue xsrc
        if ThisObjectAddr_( c, valueE, xvt, xsrc, true ) = false then
            xvt = c.types->Unqualify( c.info->TypeOf_( valueE ) )
            '' ...and an UNTYPED WIDE value -- 'return dws + s' -- is a wstring for choosing it.
            if xvt = Tko.TYPE_NONE then
                if TermIsWide_( c, valueE ) orelse ConcatHasWideTerm_( c, valueE ) then xvt = c.types->Builtin( Tko.TY_WSTRING )
            end if
            if (xvt <> Tko.TYPE_NONE) andalso (xvt <> c.types->Unqualify( rt )) then
                dim as FB.Array( of ulong ) xT
                xT.Push( cast( ulong, xvt ) )
                dim as Tko.TypeId urt = c.types->Unqualify( rt )
                '' ANOTHER UDT WITH NO CONSTRUCTOR TO TAKE IT is the DEFAULT constructor and then the
                '' assignment ladder 'u = v' walks. Measured, 'return v' over TU with lets only:
                '' 'ctor()', then 'let( byref as TV )' -- or the TV cast and 'let( byref as TU )'
                '' (structs/udt-init-ops-1.bas ns54, ns53a, ns54a). A cast to a TU that copies is
                '' ByrefCastInit_'s, inside LowerConvCtorInit_ (ns53).
                dim as boolean noCtor = (PickCtor( c, StructorOf( c, urt, "__ctor" ), xT ) = Tko.SYMBOL_NONE)
                dim as boolean xRef
                if (c.types->Kind( xvt ) = Tko.TK_UDT) andalso (UdtPtrCast_( c, xvt, urt, xRef ) <> Tko.SYMBOL_NONE) then
                    dim as MirValue bsa
                    bsa.kind = cast( ubyte, MV_LOCAL ) : bsa.ty = cast( ubyte, MT_PTR ) : bsa.id = c.sretParam
                    dim as MirValue bdst = LowerExprLoad( c, bsa, MT_PTR )
                    if bdst.kind <> cast( ubyte, MV_NONE ) then
                        if ByrefCastInit_( c, -1, urt, valueE, @bdst ) then return true
                    end if
                end if
                if noCtor andalso (c.types->Kind( xvt ) = Tko.TK_UDT) andalso (StructorOf( c, urt, "let" ) <> Tko.SYMBOL_NONE) then
                    dim as Tko.SymbolId zct = StructorWithArity( c, StructorOf( c, urt, "__ctor" ), 0 )
                    dim as MirValue ysa
                    ysa.kind = cast( ubyte, MV_LOCAL ) : ysa.ty = cast( ubyte, MT_PTR ) : ysa.id = c.sretParam
                    dim as MirValue ydst = LowerExprLoad( c, ysa, MT_PTR )
                    if (zct <> Tko.SYMBOL_NONE) andalso (ydst.kind <> cast( ubyte, MV_NONE )) then
                        EmitStructorCall( c, zct, -1, @ydst )
                        if LetViaCast_( c, Tko.NODE_NONE, valueE, urt, xvt, @ydst ) then return true
                        if LowerUserLetConv_( c, Tko.NODE_NONE, rt, valueE, c.sretParam ) then return true
                        return false
                    end if
                end if
                if noCtor = false then
                    dim as MirValue xsa
                    xsa.kind = cast( ubyte, MV_LOCAL )
                    xsa.ty = cast( ubyte, MT_PTR )
                    xsa.id = c.sretParam
                    dim as MirValue xdst = LowerExprLoad( c, xsa, MT_PTR )
                    if xdst.kind <> cast( ubyte, MV_NONE ) then
                        if LowerConvCtorInit_( c, -1, c.types->Unqualify( rt ), valueE, @xdst ) then return true
                    end if
                end if
            end if
        end if
    end scope
    '' The whole overload chain -- see CopyCtorOf_.
    dim as Tko.SymbolId cc = CopyCtorOf_( c, rt )
    dim as boolean written = (cc <> Tko.SYMBOL_NONE)
    if (written = false) andalso (NeedsLetBody_( c, rt ) = false) then return false

    '' 'return T( args )' CONSTRUCTS STRAIGHT INTO THE HIDDEN POINTER. Measured, fbc's C for
    '' 'return CC( n )', 'return type<CC>( n )' and 'return CC( o )' is one call each --
    ''
    ''     _ZN2CCC1Ei( tmp$2$1, N$1 );
    ''     _ZN2CCC1ERS_( tmp$6$1, O$1 );
    ''
    '' -- and taking the ADDRESS of the call below built a temporary, copy-constructed the
    '' result from it and destroyed it: one copy and one destructor per return that fbc
    '' does not run. A type with no copy constructor never got here, which is why only
    '' this shape showed it. THE OVERLOAD IS PICKED FIRST, off the arguments' types as
    '' LowerCtorInit picks it, because that lowers the arguments before choosing and a
    '' decline after it would evaluate them a second time on the path below.
    scope
        dim as Tko.TypeId irt = c.types->Unqualify( rt )
        dim as boolean inPlace = (TypeCtorTypeOf_( c, valueE ) = irt)
        if (inPlace = false) andalso (c.ast->Kind( valueE ) = Tko.N_TUPLE) then
            if (c.ast->nodes[cast( long, valueE )].flags and Tko.NF_TYPE_LITERAL) <> 0 then
                inPlace = (c.types->Unqualify( c.info->TypeOf_( valueE ) ) = irt)
            end if
        end if
        if inPlace then
            dim as Tko.ListPayload ptr icp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, valueE )].data )]
            dim as FB.Array( of ulong ) iT
            for i as long = 0 to icp->count - 1
                iT.Push( cast( ulong, c.info->TypeOf_( cast( Tko.NodeId, c.ast->children[icp->first + i] ) ) ) )
            next
            if PickCtor( c, StructorOf( c, irt, "__ctor" ), iT ) <> Tko.SYMBOL_NONE then
                dim as MirValue isa
                isa.kind = cast( ubyte, MV_LOCAL )
                isa.ty = cast( ubyte, MT_PTR )
                isa.id = c.sretParam
                dim as MirValue idst = LowerExprLoad( c, isa, MT_PTR )
                if idst.kind <> cast( ubyte, MV_NONE ) then
                    if LowerCtorInit( c, -1, irt, valueE, @idst ) then return true
                end if
            end if
        end if
    end scope

    '' AND THE SOURCE MUST BE ONE OF THESE. 'return T( 1 )' constructs a temporary
    '' somewhere this cannot see, and 'return' with no value has nothing to copy.
    '' 'this' IS THE OBJECT AND ITS ADDRESS IS THE POINTER'S VALUE -- see
    '' ThisObjectAddr_. Its TypeOf_ is a POINTER, so the test below refused it and
    '' the generic path stored the address as the result.
    '' THE TYPE FIRST AND THE ADDRESS AFTER, because this can still decline: asking
    '' for the address first built a tuple temporary in front of a 'return false'.
    dim as Tko.TypeId vt = Tko.TYPE_NONE
    dim as MirValue src
    dim as boolean isThis = ThisObjectAddr_( c, valueE, vt, src, true )
    if isThis = false then vt = c.types->Unqualify( c.info->TypeOf_( valueE ) )
    if vt <> c.types->Unqualify( rt ) then return false
    if isThis then
        if ThisObjectAddr_( c, valueE, vt, src ) = false then return false
    else
        src = LowerAddr( c, valueE )
    end if
    if src.kind = cast( ubyte, MV_NONE ) then return false

    dim as MirValue sa
    sa.kind = cast( ubyte, MV_LOCAL )
    sa.ty = cast( ubyte, MT_PTR )
    sa.id = c.sretParam
    dim as MirValue dst = LowerExprLoad( c, sa, MT_PTR )
    if dst.kind = cast( ubyte, MV_NONE ) then return false

    if written then
        dim as FB.Array( of ulong ) cargs
        cargs.Push( cast( ulong, src.kind ) )
        cargs.Push( cast( ulong, src.id ) )
        EmitStructorCall( c, cc, -1, @dst, @cargs )
    else
        CallImplicitCopy_( c, rt, dst, src )
    end if
    return true
end function

'' ANOTHER TYPE INTO A UDT RESULT HELD IN ITS OWN SLOT -- a type small enough to come back
'' by value -- goes through the type's own conversion, as SretCopyResult_ does through the
'' hidden pointer. 'a + s' through a 'cast( ) byref as const wstring' has no Check type and
'' no value for LowerExpr; 'wstr( "lit" )' has a POINTER, which the plain store wrote over
'' the object. Measured, fbc's 'function =' default-constructs at entry and calls the
'' matching 'let'; 'return' runs the converting constructor on the raw result.
function UdtConvResult_ _
    ( byref c as Ctx, byval valueE as Tko.NodeId, byval isReturn as boolean ) as boolean

    if (c.udtResult = false) orelse (c.resultSlot < 0) then return false
    if valueE = Tko.NODE_NONE then return false
    if IsThisPointerIdent_( c, valueE ) then return false
    dim as Tko.TypeId rt = c.types->Unqualify( c.resultType )
    if c.types->Kind( rt ) <> Tko.TK_UDT then return false
    dim as Tko.TypeId vt = c.info->TypeOf_( valueE )
    if vt = Tko.TYPE_NONE then
        if (TermIsWide_( c, valueE ) orelse ConcatHasWideTerm_( c, valueE )) = false then return false
    else
        '' A TYPED value only when the type has an overload that takes it; anything else
        '' stays with the ordinary copy.
        if c.types->Unqualify( vt ) = rt then return false
        dim as FB.Array( of ulong ) argT
        argT.Push( cast( ulong, vt ) )
        dim as Tko.SymbolId over = Tko.SYMBOL_NONE
        if isReturn then
            over = PickCtor( c, StructorOf( c, rt, "__ctor" ), argT )
            '' ...AND NO CONSTRUCTOR TAKES ANOTHER UDT: the default one, then the assignment
            '' ladder -- SretCopyResult_ says why (structs/udt-init-ops-1.bas ns53a, ns54a).
            dim as Tko.TypeId uvt = c.types->Unqualify( vt )
            if (over = Tko.SYMBOL_NONE) andalso (c.types->Kind( uvt ) = Tko.TK_UDT) andalso (StructorOf( c, rt, "let" ) <> Tko.SYMBOL_NONE) then
                dim as Tko.SymbolId zct = StructorWithArity( c, StructorOf( c, rt, "__ctor" ), 0 )
                if zct = Tko.SYMBOL_NONE then return false
                EmitStructorCall( c, zct, c.resultSlot )
                dim as MirValue rsa
                rsa.kind = cast( ubyte, MV_LOCAL ) : rsa.ty = cast( ubyte, MT_PTR ) : rsa.id = c.resultSlot
                if LetViaCast_( c, Tko.NODE_NONE, valueE, rt, uvt, @rsa ) then return true
                return LowerUserLetConv_( c, Tko.NODE_NONE, rt, valueE, c.resultSlot, true )
            end if
        else
            over = PickCtor( c, StructorOf( c, rt, "let" ), argT )
        end if
        if over = Tko.SYMBOL_NONE then return false
    end if
    if isReturn then return LowerConvCtorInit_( c, c.resultSlot, rt, valueE, 0 )
    return LowerUserLetConv_( c, Tko.NODE_NONE, rt, valueE, c.resultSlot, true )
end function

'' 'function = expr' IS AN ASSIGNMENT INTO THE RESULT, not a construction of it.
'' fbc's C for a type with no assignment operator is '__builtin_memcpy( tmp, &t, 4 )'
'' after the result has been default-constructed at entry; a type that declares
'' 'operator let' gets that call instead. Same ladder an ordinary assignment walks.
function SretAssignResult_ _
    ( byref c as Ctx, byval valueE as Tko.NodeId, byval rt as Tko.TypeId ) as boolean

    if c.sretParam < 0 then return false
    if c.types->Kind( rt ) <> Tko.TK_UDT then return false
    '' 'this' IS THE OBJECT AND ITS ADDRESS IS THE POINTER'S VALUE -- see
    '' ThisObjectAddr_. Its TypeOf_ is a POINTER, so the test below refused it and
    '' the generic path stored the address as the result.
    '' THE TYPE FIRST AND THE ADDRESS AFTER, because this can still decline: asking
    '' for the address first built a tuple temporary in front of a 'return false'.
    dim as Tko.TypeId vt = Tko.TYPE_NONE
    dim as MirValue src
    dim as boolean isThis = ThisObjectAddr_( c, valueE, vt, src, true )
    if isThis = false then vt = c.types->Unqualify( c.info->TypeOf_( valueE ) )
    '' ANOTHER TYPE GOES THROUGH A CONVERTING 'operator let', as 'x = <other type>'
    '' does. Its bytes are not the object's: a 'wstring * 16' was copied over a STRING
    '' descriptor and the program died with 0xC0000374 -- and AfxNova's
    '' AfxPathRemoveBackslashEx copied a 65536-byte one, which crashed clang outright.
    if (isThis = false) andalso (vt <> c.types->Unqualify( rt )) then
        '' ...OR THROUGH THE SOURCE'S CAST, or a temporary built from it, as 'u = v' is: the
        '' same ladder -- LetViaCast_ (structs/udt-init-ops-1.bas ns42-44).
        if (vt <> Tko.TYPE_NONE) andalso (c.types->Kind( vt ) = Tko.TK_UDT) then
            dim as MirValue lsa
            lsa.kind = cast( ubyte, MV_LOCAL ) : lsa.ty = cast( ubyte, MT_PTR ) : lsa.id = c.sretParam
            dim as MirValue ldst = LowerExprLoad( c, lsa, MT_PTR )
            if (ldst.kind <> cast( ubyte, MV_NONE )) andalso LetViaCast_( c, Tko.NODE_NONE, valueE, c.types->Unqualify( rt ), vt, @ldst ) then return true
        end if
        return LowerUserLetConv_( c, Tko.NODE_NONE, rt, valueE, c.sretParam )
    end if
    if vt <> c.types->Unqualify( rt ) then return false
    if isThis then
        if ThisObjectAddr_( c, valueE, vt, src ) = false then return false
    else
        src = LowerAddr( c, valueE )
    end if
    if src.kind = cast( ubyte, MV_NONE ) then return false

    dim as MirValue sa
    sa.kind = cast( ubyte, MV_LOCAL )
    sa.ty = cast( ubyte, MT_PTR )
    sa.id = c.sretParam
    dim as MirValue dst = LowerExprLoad( c, sa, MT_PTR )
    if dst.kind = cast( ubyte, MV_NONE ) then return false

    dim as FB.Array( of ulong ) letT
    letT.Push( cast( ulong, rt ) )
    dim as Tko.SymbolId ulet = PickCtor( c, StructorOf( c, rt, "let" ), letT )
    if ulet <> Tko.SYMBOL_NONE then
        dim as FB.Array( of ulong ) largs
        largs.Push( cast( ulong, src.kind ) )
        largs.Push( cast( ulong, src.id ) )
        EmitStructorCall( c, ulet, -1, @dst, @largs )
        return true
    end if
    if NeedsLetBody_( c, rt ) then
        CallImplicitLet_( c, rt, dst, src )
        return true
    end if
    '' THE BITWISE COPY NEEDS ITS SIZE: M_LOAD of an MT_AGG carries the byte count
    '' in its immediate, and the destination here is a raw pointer with no slot for
    '' the emitter to read one off.
    dim as long rsz = SizeOfType( c, rt )
    if rsz <= 0 then return false
    dim as MirValue whole = LowerExprLoad( c, src, MT_AGG, rsz )
    if whole.kind = cast( ubyte, MV_NONE ) then return false
    StoreThrough( c, dst, whole )
    return true
end function

'' Does this body write its result with 'function = expr' rather than 'return expr'?
''
'' THE TWO ARE NOT THE SAME STATEMENT, and fbc's own C says so. For a type with a
'' constructor, a copy constructor and a destructor:
''
''     function = t            _ZN1CC1Ev( tmp );          <- the result is
''                             ... t built ...               DEFAULT-CONSTRUCTED
''                             memcpy( tmp, &t, 4 );        at entry and then
''                             _ZN1CD1Ev( &t );             ASSIGNED to
''
''     return t                ... t built ...             <- COPY-CONSTRUCTED,
''                             _ZN1CC1ERS_( tmp, &t );        with no default
''                             _ZN1CD1Ev( &t );               construction at all
''
'' -- two constructors and no copy for the first, one constructor and one copy for
'' the second. tiko copy-constructed for BOTH, so every 'function =' over a type
'' with a destructor ran one constructor too few and one copy too many. It is the
'' single largest cluster in structs/temp-var-dtors.bas.
''
'' 'exit function' COUNTS AS AN ASSIGNMENT for this purpose: it leaves through the
'' result variable, which must therefore exist. The same pair of questions is asked
'' in Check -- see ScanReturnStyles_ in latesweeps.bas -- and this is the lowering
'' half of it.
function BodyAssignsResult_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval depth as long = 0 ) as boolean

    if id = Tko.NODE_NONE then return false
    if depth > 256 then return false
    dim as Tko.NodeKind k = c.ast->Kind( id )
    '' A nested procedure is its own result, and FreeBASIC has none inside a body.
    if k = Tko.N_PROC then return false
    if k = Tko.N_AMBIGUOUS then
        if c.info->AmbiguousOf( id ) = Tko.AMB_RESULT then return true
    end if
    if k = Tko.N_EXIT then
        dim as Tko.StmtPayload ptr xp = StmtOf( c, id )
        select case cast( Tko.TokenKind, xp->op )
        case Tko.KW_FUNCTION, Tko.KW_OPERATOR, Tko.KW_PROPERTY
            return true
        end select
    end if
    if Tko.NodeKindCategory( k ) = Tko.NCAT_EXPR then return false
    if Tko.NodeKindCategory( k ) = Tko.NCAT_TYPE then return false
    if (k = Tko.N_MODULE) orelse (k = Tko.N_BLOCK) then
        dim as Tko.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        for i as long = 0 to lp->count - 1
            if BodyAssignsResult_( c, cast( Tko.NodeId, c.ast->children[lp->first + i] ), _
                                   depth + 1 ) then return true
        next
        return false
    end if
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    if sp = 0 then return false
    if BodyAssignsResult_( c, sp->b, depth + 1 ) then return true
    if BodyAssignsResult_( c, sp->c, depth + 1 ) then return true
    for i as long = 0 to sp->count - 1
        if BodyAssignsResult_( c, cast( Tko.NodeId, c.ast->children[sp->first + i] ), _
                               depth + 1 ) then return true
    next
    return false
end function

'' DOES THE BODY LEAVE THROUGH 'return expr' ANYWHERE? Nested blocks count: 'scope :
'' return t : end scope' under an IF is measured to suppress the entry construction as
'' surely as a top-level one does.
function BodyReturnsValue_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval depth as long = 0 ) as boolean

    if id = Tko.NODE_NONE then return false
    if depth > 256 then return false
    dim as Tko.NodeKind k = c.ast->Kind( id )
    if k = Tko.N_PROC then return false
    if k = Tko.N_RETURN then return true
    if Tko.NodeKindCategory( k ) = Tko.NCAT_EXPR then return false
    if Tko.NodeKindCategory( k ) = Tko.NCAT_TYPE then return false
    if (k = Tko.N_MODULE) orelse (k = Tko.N_BLOCK) then
        dim as Tko.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        for i as long = 0 to lp->count - 1
            if BodyReturnsValue_( c, cast( Tko.NodeId, c.ast->children[lp->first + i] ), _
                                  depth + 1 ) then return true
        next
        return false
    end if
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    if sp = 0 then return false
    if BodyReturnsValue_( c, sp->b, depth + 1 ) then return true
    if BodyReturnsValue_( c, sp->c, depth + 1 ) then return true
    for i as long = 0 to sp->count - 1
        if BodyReturnsValue_( c, cast( Tko.NodeId, c.ast->children[sp->first + i] ), _
                              depth + 1 ) then return true
    next
    return false
end function

'' THE RESULT AT ENTRY, measured over both return paths (fbc's C, first statements):
''
''     by value, no constructor         memset( &fb$result, 0, size )   ALWAYS, even when
''                                                                       the body only
''                                                                       RETURNs
''     a constructor, or field          C1Ev( &fb$result ) / C1Ev( tmp ) -- for
''     initialisers (an implicit one)   'function =', 'exit function', a name assignment
''                                      and a body that sets nothing at all
''     ...and 'return x' anywhere       NOTHING: the return copies into the result
''     hidden pointer, no constructor   nothing (a destructor-only type)
''
'' fbc refuses 'function =' mixed with 'return' for a type with a constructor (error
'' 179), so "no RETURN anywhere" is the whole test. functions/return_notreg is the second
'' row: 'if 0 = 1 then function = type()' must still return the constructed object, and
'' the slot was left holding whatever the stack held.
sub InitResultAtEntry_ _
    ( byref c as Ctx, byval rt as Tko.TypeId, byref dst as MirValue, _
      byval body as Tko.NodeId, byval zeroTrivial as boolean )

    '' AN ARRAY RESULT STARTS EMPTY, whatever the body does -- a valid descriptor is what an early
    '' 'exit function' must hand back, and 'return' then erases and fills it. See lowerarrret.bas.
    if c.types->IsDynArray( rt ) then
        InitDynArrayDesc( c, dst, rt )
        exit sub
    end if
    if c.types->Kind( rt ) = Tko.TK_UDT then
        dim as Tko.SymbolId rct = StructorWithArity( c, StructorOf( c, rt, "__ctor" ), 0 )
        dim as boolean needsCtor = (rct <> Tko.SYMBOL_NONE) orelse TypeNeedsInit_( c, rt )
        if needsCtor then
            if BodyReturnsValue_( c, body ) then exit sub
            if rct <> Tko.SYMBOL_NONE then
                dim as FB.Array( of ulong ) rnone
                EmitStructorCall( c, rct, -1, @dst, @rnone )
            else
                CallImplicitCtor_( c, rt, dst )
            end if
            exit sub
        end if
    end if
    if zeroTrivial = false then exit sub
    dim as long sz = SizeOfType( c, rt )
    if sz <= 0 then exit sub
    dim as FB.Array( of ulong ) bz
    bz.Push( cast( ulong, dst.kind ) ) : bz.Push( cast( ulong, dst.id ) )
    bz.Push( cast( ulong, MV_CONST_INT ) ) : bz.Push( 0 )
    bz.Push( cast( ulong, MV_CONST_INT ) ) : bz.Push( cast( ulong, sz ) )
    EmitRtl( c, RTL_MEMSET, bz )
end sub

'' 'return a + b' COPIES THE OPERATOR'S RESULT; it does not move it. LowerSretResult stores
'' the temporary's bytes through the hidden pointer, and forgetting the temporary there meant
'' it was never destroyed. Measured, over a type with no copy constructor fbc destroys it on
'' the way out --
''
''     _ZplR1HS0_( &TMP$15$1, A$1, B$1 );
''     __builtin_memcpy( tmp$14$1, &TMP$15$1, 8 );
''     _ZN1HD1Ev( &TMP$15$1 );
''
'' -- and '-a' the same: exactly what 'return f( )' gets, whose value arrives loaded and
'' whose temporary nothing forgot. A type WITH a copy constructor, written or implicit, is
'' SretCopyResult_'s and never reaches the store.
private function RetFromUserOp_( byref c as Ctx, byval valueE as Tko.NodeId ) as boolean
    dim as Tko.NodeId rop = Unparen_( c, valueE )
    if (c.ast->Kind( rop ) <> Tko.N_BINARY) andalso (c.ast->Kind( rop ) <> Tko.N_UNARY) then return false
    return (c.info->RefOf( rop ) <> Tko.SYMBOL_NONE)
end function

end namespace
