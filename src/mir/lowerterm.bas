'' lowerterm.bas -- ONE TERM of a string operation, as the (pointer, length) pair the
'' runtime takes.
''
'' Every string entry point has the same argument shape and this is what fills it: a
'' literal, a constant, an iif, a concatenation with no address, a fixed 'zstring * N',
'' a descriptor. The 'isU' flag is which FLAVOUR the destination is, because a UTF-16
'' operation needs a UTF-16 literal and a tagged length where the narrow one needs
'' neither.
''
'' Split out of lowerstr.bas at the 1500-line cap. Nothing moved with it changed.

#include once "lowerctx.bi"

namespace Tko.Mir

using Tko

'' Defined at the foot of this file, and used above it.
declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long


'' The (pointer, length) pair for one term of a concatenation.
function EmitStrTerm _
    ( byref c as Ctx, byref args as FB.Array( of ulong ), _
      byval term as Tko.NodeId, byval isU as boolean = false ) as boolean

    term = Unparen_( c, term )

    '' A STRING CONSTANT IS ITS TEXT, and it has to be recognised BEFORE the type test
    '' below claims it and asks for an address a constant has not got.
    '' '__FUNCTION__' IS A STRING LITERAL, folded to the enclosing procedure's name --
    '' measured, fbc folds a concatenation containing one to a single literal. It is
    '' recognised here for the same reason a string CONSTANT is: the type test below
    '' would claim it and then ask a predeclared name for an address it has not got.
    if c.ast->Kind( term ) = Tko.N_IDENT then
        dim as Tko.Symbol ptr fns = c.syms->SymbolAt( c.info->RefOf( term ) )
        if fns <> 0 then
            if (fns->flags and Tko.SYMF_FUNCNAME) <> 0 then
                dim as string fnText = Tko.Mangle.ProcNameOrMain( _
                    *c.syms, c.curProcSym, *c.names )
                if isU then
                    PushUStrLiteralArg( c, args, _
                        c.m->AddWideStringLiteral( fnText, *c.names ), len( fnText ) )
                else
                    PushStrLiteralArg( args, _
                        c.m->AddStringLiteral( fnText, *c.names ), len( fnText ) )
                end if
                return true
            end if
        end if
    end if

    if c.ast->Kind( term ) = Tko.N_IDENT then
        dim as string ct
        if ConstStringTextOf_( c, term, ct ) then
            if isU then
                PushUStrLiteralArg( c, args, _
                    c.m->AddWideStringLiteral( ct, *c.names ), len( ct ) )
            else
                PushStrLiteralArg( args, c.m->AddStringLiteral( ct, *c.names ), len( ct ) )
            end if
            return true
        end if
    end if

    '' ADJACENT LITERALS ARE ONE STRING. '"a" "b"' is N_STRCAT, and the corpus writes
    '' it as '(#op " ")' -- a STRINGIZE followed by a literal -- which is how
    '' structs/ops.bas declares all 36 of its operators. Nothing here looked at one, so
    '' every 'return (#op " ") & a.value' declined.
    dim as string catText
    if StrCatText_( c, term, catText ) then
        if isU then
            PushUStrLiteralArg( c, args, _
                c.m->AddWideStringLiteral( catText, *c.names ), len( catText ) )
        else
            PushStrLiteralArg( args, c.m->AddStringLiteral( catText, *c.names ), _
                               len( catText ) )
        end if
        return true
    end if

    if c.ast->Kind( term ) = Tko.N_STRING_LIT then
        '' Named litText, not text: 'Text' is a namespace and FreeBASIC is
        '' case-insensitive, so a local called text shadows it.
        dim as string litText = StringLitText_( c, term )
        '' A USTRING LITERAL IS UTF-16 AND ITS LENGTH IS TAGGED. Emitting the narrow
        '' global here is what put narrow bytes in a UTF-16 descriptor.
        if isU then
            PushUStrLiteralArg( c, args, _
                c.m->AddWideStringLiteral( litText, *c.names ), len( litText ) )
        else
            PushStrLiteralArg( args, c.m->AddStringLiteral( litText, *c.names ), _
                               len( litText ) )
        end if
        return true
    end if
    '' A STRING 'iif' produces a temporary DESCRIPTOR, whose address is exactly what
    '' this needs. Tried before the type test because Check computes no type for an
    '' iif call, so a type-first test would never reach it.
    '' THE DESTINATION IS ALREADY KNOWN TO BE A STRING, so an iif here is a string
    '' iif whatever its arms look like. Asking IsStringIif_ instead meant every
    '' 'iif( c, hex( 1 ), hex( 2 ) )' declined: Check computes no type for an
    '' intrinsic call, so neither arm looked like a string and the whole statement
    '' produced nothing.
    dim as Tko.NodeId iC, iT, iE
    if IsIifCall_( c, term, iC, iT, iE ) then
        dim as MirValue iv
        if LowerStringIif_( c, iC, iT, iE, iv ) = false then return false
        if iv.kind = cast( ubyte, MV_NONE ) then return false
        PushStrArg( args, iv )
        return true
    end if

    '' A NUMBER IN A CONCATENATION IS RENDERED, not refused: 'x & ", "' over a byte is
    '' 'fb_IntToStr( (int32)X )' and then an ordinary narrow concat of the result. The
    '' renderer already existed for STR( ) and only STR( ) could reach it, so every
    '' 'number & string' in the corpus declined -- which is what the wstring PRINT
    '' files are made of.
    ''
    '' Tried before the string tests below rather than after: a number is not
    '' string-typed, so nothing else here would look at it.
    dim as Tko.TypeId termT = c.info->TypeOf_( term )
    if termT <> Tko.TYPE_NONE then
        if IsStringType( c, termT ) = false then
            dim as longint tsk
            if StrSwapKind_( c, termT, tsk ) = -1 then
                dim as MirValue nv
                if NumberToStrDesc_( c, term, nv ) then
                    PushStrArg( args, nv )
                    return true
                end if
            end if
        end if
    end if

    '' 'dir( ... )' -- an INTRINSIC that hands back a descriptor pointer, tried before
    '' the ordinary call path below: Check now types it STRING, so that path would
    '' claim it and then look for a callee symbol it has not got.
    dim as MirValue drv
    if LowerDir( c, term, drv ) then
        PushStrArg( args, drv )
        return true
    end if

    '' A CALL TO A STRING-RETURNING FUNCTION, before the type test below claims it.
    ''
    '' 's = f( 1 )' and 'print f( 2 )' both produced NOTHING -- the term is string-typed,
    '' so the type test asked for its address, an N_CALL has none, and the whole
    '' statement declined. One of the commonest shapes there is.
    ''
    '' A string-returning function RETURNS THE DESCRIPTOR POINTER, which is what fbc's
    '' own C says: 'FBSTRING* vr$1 = F( 1 ); fb_StrAssign( &S, -1, vr$1, -1, 0 )'. The
    '' intrinsic family above reaches the same place by its own route because Check
    '' computes no type for those calls.
    if c.ast->Kind( term ) = Tko.N_CALL then
        if IsStringType( c, c.info->TypeOf_( term ) ) then
            '' TYPED MT_PTR, not left to the expression's own type. A string is an
            '' AGGREGATE to LowerType, so LowerExpr would type the call 'agg' and the
            '' descriptor pointer would come back sign-extended and bitcast. The
            '' FUNCTION returns a pointer -- that is what its own declaration says.
            dim as Tko.ListPayload ptr scp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, term )].data )]
            dim as Tko.SymbolId scallee = c.info->RefOf( term )
            if scallee = Tko.SYMBOL_NONE then scallee = c.info->RefOf( scp->target )
            dim as MirValue scv = LowerCallParts( c, scp->target, scallee, _
                                                  scp->first, scp->count, MT_PTR )
            if scv.kind <> cast( ubyte, MV_NONE ) then
                PushStrArg( args, scv )
                return true
            end if
        end if
    end if

    '' A BARE STRING-RETURNING FUNCTION NAME, before the type test below claims it.
    '' 's = curdir' names a function whose TYPE is string, so the type test takes its
    '' ADDRESS -- and a function's address is a well-typed pointer, so fb_CurDir's entry
    '' point was handed to fb_StrAssign as a descriptor and the whole thing verified.
    dim as MirValue bpv
    if LowerBareProcCall_( c, term, MT_PTR, bpv ) then
        PushStrArg( args, bpv )
        return true
    end if

    '' 'trim( s )', 'left( s, n )' and the rest hand back a descriptor pointer, which
    '' is exactly what a term is. Tried before the type test: Check computes no type
    '' for these calls either.
    dim as MirValue rvv
    if LowerStrRvalue( c, term, rvv ) then
        PushStrArg( args, rvv )
        return true
    end if

    '' A USER OPERATOR THAT RETURNS A STRING is a call and hands back a descriptor
    '' pointer, exactly as a string-returning function does -- and it is spelled '-a'
    '' or 'a + b', so it arrives as a UNARY or a BINARY and none of the tests above
    '' looks at one.
    dim as MirValue uopv
    if LowerStrOperandOp_( c, term, uopv ) then
        PushStrArg( args, uopv )
        return true
    end if

    '' A FIXED-LENGTH STRING IS A CHAR ARRAY WITH NO DESCRIPTOR, so it passes its
    '' ADDRESS and its DECLARED LENGTH where a var-length string passes -1 and lets the
    '' descriptor say. Measured -- 'dim as string c : dim as zstring * 8 fa : c = fa':
    ''
    ''     fb_StrAssign( (void*)&C$1, -1ll, (void*)FA$1, 8ll, 0 );
    ''
    '' PushStrArg's -1 would have made the runtime read a length out of the first bytes
    '' of the text. The reverse direction -- a fixed destination -- was already handled;
    '' this is the same fact on the other side, and it declined outright: 'c = fa' is
    '' one of the commonest shapes in the corpus and produced nothing at all.
    '' A CONCATENATION, before the type test below claims it. Reached from the string
    '' COMPARISON path -- 'if a + b = c' -- where the operands are not flattened; the
    '' assignment path flattens first, so a term is never a concat there.
    dim as MirValue tcc
    if ConcatToTemp_( c, term, tcc ) then
        args.Push( cast( ulong, tcc.kind ) ) : args.Push( cast( ulong, tcc.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, cast( ulongint, -1 ) ) )
        return true
    end if

    '' A UDT CONVERTED BY 'operator cast'. A bare char* passes LENGTH 0 here, not -1
    '' and not a declared count: measured, 'r = u' is
    '' 'fb_StrAssign( &R, -1ll, vr, 0ll, 0 )'. 0 means NUL-terminated, work it out.
    dim as boolean tRaw = false
    dim as MirValue tuc
    if UserCastToStr_( c, term, tuc, tRaw ) then
        args.Push( cast( ulong, tuc.kind ) ) : args.Push( cast( ulong, tuc.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, iif( tRaw, 0, cast( longint, -1 ) ) ) )
        return true
    end if

    '' A FIXED-LENGTH STRING passes its address and its ENCODED length -- kind 3 comes
    '' back with the sign-tagged constant already in 'zn', so this is the same push as
    '' the zstring case and the two share a branch.
    '' KIND 4 IS 'ustring * N', and it belongs here for the same reason as the other
    '' two: it is a char array with no descriptor and its tagged length is already in
    '' 'zn'. It is taken ONLY when the destination is UTF-16, because its bytes are --
    '' handing them to a narrow entry point would be the wrong encoding, not a shorter
    '' string. Without it 'dim as ustring u = uf' had no term at all and the whole
    '' initialiser was dropped.
    dim as longint zn
    dim as long zk = StrSwapKind_( c, c.info->TypeOf_( term ), zn )
    if (zk = 4) andalso (isU = false) then return false
    if (zk = 1) orelse (zk = 3) orelse (zk = 4) then
        dim as MirValue za = LowerAddr( c, term )
        if za.kind <> cast( ubyte, MV_NONE ) then
            args.Push( cast( ulong, za.kind ) )
            args.Push( cast( ulong, za.id ) )
            PushStrLen_( c, args, zn )
            return true
        end if
    end if

    if IsStringType( c, c.info->TypeOf_( term ) ) = false then return false
    dim as MirValue src = LowerAddr( c, term )
    if src.kind = cast( ubyte, MV_NONE ) then return false
    PushStrArg( args, src )
    return true
end function

'' ------------------------------------------------------- ustring CONVERSION
''
'' A USTRING NEVER CONVERTS BY COPYING. It transcodes, and which entry point does it
'' depends on the flavours of BOTH sides -- which is exactly what was missing: the
'' flavour came from the DESTINATION alone and every term was pushed as if it shared
'' it, so 'u = q' over a narrow string called fb_UStrAssign and put UTF-8 bytes in a
'' UTF-16 descriptor. It lowered, it verified, and it was wrong every time.
''
'' Measured from what fbc emits, one statement at a time:
''
''     u = q            fb_UStrAssignFromA( u, -1, q, -1, 0, 0 )
''     dim u = q        fb_UStrAssignFromA( u, -1, q, -1, 0, -1 )
''     u = p            fb_WstrToUStr( p ) then the ordinary fb_UStrAssign
''     s = u            fb_UStrAssignToA( s, -1, u, -1, 0, 0 )
''     dim s = u        fb_UStrAssignToA( s, -1, u, -1, 0, -1 )
''
'' so the trailing int32 is -1 at a DECLARATION and 0 at a later store, the same
'' distinction fb_StrInit and fb_StrAssign make by being separate functions.

'' Which FLAVOUR one term of a chain is, which is not the same question as what the
'' destination is.
''
'' NEUTRAL is the interesting one: a literal, a string CONSTANT and a rendered NUMBER
'' all follow the destination -- measured, 'u = u & "lit"' emits the UTF-16 literal
'' straight into fb_UStrConcatAssign and 'u = u & n' renders the number narrow and
'' hands THAT to the same entry point. An untyped term is neutral too, because Check
'' computes no type for an intrinsic call and following the destination is what the
'' code did before any of this.
function StrTermFlavour_( byref c as Ctx, byval term as Tko.NodeId ) as long

    dim as Tko.NodeId t2 = Unparen_( c, term )
    if c.ast->Kind( t2 ) = Tko.N_STRING_LIT then return STF_NEUTRAL
    if c.ast->Kind( t2 ) = Tko.N_IDENT then
        dim as string ct
        if ConstStringTextOf_( c, t2, ct ) then return STF_NEUTRAL
    end if

    dim as Tko.TypeId tt = c.info->TypeOf_( t2 )
    if tt = Tko.TYPE_NONE then return STF_NEUTRAL
    if IsUStringType( c, tt ) then return STF_UTF16
    if WideStringElems( c, tt ) > 0 then return STF_WIDE
    if c.types->Kind( tt ) = Tko.TK_BUILTIN then
        if c.types->BuiltinOf( tt ) = Tko.TY_WSTRING then return STF_WIDE
    end if
    if IsStringType( c, tt ) then return STF_NARROW
    dim as longint sn
    if StrSwapKind_( c, tt, sn ) >= 0 then return STF_NARROW
    return STF_NEUTRAL
end function

'' A WIDE term as a USTRING DESCRIPTOR -- fb_WstrToUStr, which takes the bare uint16*
'' and hands back a descriptor the ordinary ustring entry points accept.
function WideTermAsUStr_ _
    ( byref c as Ctx, byval term as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as MirValue wp
    if WideOperand_( c, term, wp ) = false then return false
    if wp.kind = cast( ubyte, MV_NONE ) then return false
    dim as FB.Array( of ulong ) wargs
    wargs.Push( cast( ulong, wp.kind ) ) : wargs.Push( cast( ulong, wp.id ) )
    outv = EmitRtl( c, RTL_WSTR_TO_USTR, wargs )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' ONE term into a destination of a DIFFERENT flavour. False when the two agree, which
'' leaves the caller's existing path to handle it, and false again for a mismatch this
'' does not model -- a chain, or a WIDE destination -- because emitting the same-flavour
'' call anyway is what produced the wrong bytes in the first place.
function LowerStrConvertTerm _
    ( byref c as Ctx, byref dst as MirValue, byval dstIsU as boolean, _
      byval term as Tko.NodeId, byval isInit as boolean ) as boolean

    dim as long tf = StrTermFlavour_( c, term )
    dim as longint flag = 0
    if isInit then flag = -1

    if dstIsU then
        if tf = STF_NARROW then
            dim as FB.Array( of ulong ) args
            PushStrArg( args, dst )
            if EmitStrTerm( c, args, term, false ) = false then return false
            args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
            args.Push( cast( ulong, MV_CONST_INT ) )
            args.Push( cast( ulong, cast( ulongint, flag ) ) )
            return (EmitRtl( c, RTL_USTR_FROM_A, args ).kind <> cast( ubyte, MV_NONE ))
        end if
        if tf = STF_WIDE then
            dim as MirValue uv
            if WideTermAsUStr_( c, term, uv ) = false then return false
            dim as FB.Array( of ulong ) args
            PushStrArg( args, dst )
            PushStrArg( args, uv )
            args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
            dim as long which = RTL_USTR_ASSIGN
            if isInit then which = RTL_USTR_INIT
            return (EmitRtl( c, which, args ).kind <> cast( ubyte, MV_NONE ))
        end if
        return false
    end if

    '' A NARROW destination with a UTF-16 source is the same fact the other way round.
    if tf = STF_UTF16 then
        dim as FB.Array( of ulong ) args
        PushStrArg( args, dst )
        if EmitStrTerm( c, args, term, true ) = false then return false
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, cast( ulongint, flag ) ) )
        return (EmitRtl( c, RTL_USTR_TO_A, args ).kind <> cast( ubyte, MV_NONE ))
    end if
    return false
end function

'' True when a chain cannot be built with ONE flavour's entry points -- any term of a
'' flavour the destination is not. The caller declines rather than emitting the
'' same-flavour call over a source that is not that flavour.
function StrChainNeedsConvert _
    ( byref c as Ctx, byval dstIsU as boolean, _
      byref terms as FB.Array( of ulong ) ) as boolean

    for i as long = 0 to terms.Count - 1
        dim as long tf = StrTermFlavour_( c, cast( Tko.NodeId, terms[i] ) )
        if tf = STF_NEUTRAL then continue for
        if dstIsU then
            if tf <> STF_UTF16 then return true
        else
            if tf = STF_UTF16 then return true
        end if
    next
    return false
end function

'' The destination's flavour when there is no NODE to ask -- a string-returning
'' function's result descriptor, or a declaration's slot. The SLOT carries the frontend
'' type, which is the only thing that knows a ustring from a string here.
function IsUStringDest_( byref c as Ctx, byref dst as MirValue ) as boolean
    if dst.kind <> cast( ubyte, MV_LOCAL ) then return false
    if dst.id < 0 then return false
    if dst.id >= c.f->locals.Count then return false
    return IsUStringType( c, c.f->locals[dst.id].frontendType )
end function

'' One term of a mixed chain pushed as the (pointer, length) pair the chosen entry point
'' wants. 'wantU' is the flavour that SIDE of the call takes, which is not always the
'' term's own: a WIDE term becomes a ustring descriptor through fb_WstrToUStr, and a
'' neutral one follows whatever it was asked for.
private function PushChainTerm_ _
    ( byref c as Ctx, byref args as FB.Array( of ulong ), _
      byval term as Tko.NodeId, byval wantU as boolean ) as boolean

    if wantU then
        if StrTermFlavour_( c, term ) = STF_WIDE then
            dim as MirValue uv
            if WideTermAsUStr_( c, term, uv ) = false then return false
            PushStrArg( args, uv )
            return true
        end if
    end if
    return EmitStrTerm( c, args, term, wantU )
end function

'' A MIXED-FLAVOUR CHAIN, folded LEFT TO RIGHT with a fresh temporary per step. Every
'' shape below was read out of what fbc emits:
''
''     v = q + u + r     UStrConcatAU( t1, q, u )   UStrConcatUA( t2, t1, r )
''     v = q + r + u     StrConcat   ( t1, q, r )   UStrConcatAU( t2, t1, u )
''     v = u + q + r     UStrConcatUA( t1, u, q )   UStrConcatUA( t2, t1, r )
''     s = q + u + r     the same fold, then UStrAssignToA
''     v = "lit" + q + u StrConcat   ( t1, lit, q ) UStrConcatAU( t2, t1, u )
''     v = p + u         WstrToUStr( p ) then UStrConcat
''
'' so the ACCUMULATOR has a flavour of its own and the entry point names which side is
'' the ustring: UA when the accumulator is, AU when the term is, plain UStrConcat when
'' both are and fb_StrConcat when neither is. A NEUTRAL term -- a literal, a constant, a
'' rendered number -- takes the accumulator's flavour, which is what makes '"lit" + q'
'' fold narrow before the ustring arrives.
''
'' ONE MEASURED SHAPE IS REFUSED rather than approximated: a chain with a NARROW term, a
'' WIDE one and a ustring folds the narrow prefix into a WIDE temporary first --
'' 'fb_WstrConcatAW' then 'fb_WstrToUStr' -- which is the wide path's business and not
'' this fold's. It declines.
function LowerUStrChain _
    ( byref c as Ctx, byref dst as MirValue, byval dstIsU as boolean, _
      byref terms as FB.Array( of ulong ), byval isInit as boolean ) as boolean

    if terms.Count < 2 then return false

    dim as boolean hasN = false, hasW = false, hasU = false
    for i as long = 0 to terms.Count - 1
        select case StrTermFlavour_( c, cast( Tko.NodeId, terms[i] ) )
        case STF_NARROW : hasN = true
        case STF_WIDE   : hasW = true
        case STF_UTF16  : hasU = true
        end select
    next
    if hasU = false then return false
    if hasW andalso hasN then return false

    '' The accumulator starts as the FIRST NON-NEUTRAL term's flavour, and a wide one
    '' becomes UTF-16 as soon as it meets a ustring -- which is every chain here.
    dim as boolean accU = dstIsU
    for i as long = 0 to terms.Count - 1
        dim as long f0 = StrTermFlavour_( c, cast( Tko.NodeId, terms[i] ) )
        if f0 = STF_NEUTRAL then continue for
        accU = (f0 <> STF_NARROW)
        exit for
    next

    dim as MirValue acc
    dim as boolean haveAcc = false

    for i as long = 1 to terms.Count - 1
        dim as Tko.NodeId tn = cast( Tko.NodeId, terms[i] )
        dim as long tf = StrTermFlavour_( c, tn )
        dim as boolean termU = (tf = STF_UTF16) orelse (tf = STF_WIDE)
        if tf = STF_NEUTRAL then termU = accU

        dim as long slot = NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
        dim as MirValue tmp
        tmp.kind = cast( ubyte, MV_LOCAL )
        tmp.ty = cast( ubyte, MT_PTR )
        tmp.id = slot

        dim as FB.Array( of ulong ) args
        args.Push( cast( ulong, tmp.kind ) ) : args.Push( cast( ulong, tmp.id ) )

        '' The LEFT operand: the previous step's result, or the first term.
        if haveAcc then
            PushStrArg( args, acc )
        else
            if PushChainTerm_( c, args, cast( Tko.NodeId, terms[0] ), accU ) = false then
                return false
            end if
        end if
        if PushChainTerm_( c, args, tn, termU ) = false then return false

        dim as long which = RTL_STR_CONCAT
        if accU andalso termU then
            which = RTL_USTR_CONCAT
        elseif accU then
            which = RTL_USTR_CONCAT_UA
        elseif termU then
            which = RTL_USTR_CONCAT_AU
        end if
        acc = EmitRtl( c, which, args )
        if acc.kind = cast( ubyte, MV_NONE ) then return false
        haveAcc = true
        accU = accU orelse termU
    next

    '' ...and the accumulator into the destination, which is the same four-way choice
    '' one more time.
    dim as longint flag = 0
    if isInit then flag = -1
    dim as FB.Array( of ulong ) fin
    PushStrArg( fin, dst )
    PushStrArg( fin, acc )
    fin.Push( cast( ulong, MV_CONST_INT ) ) : fin.Push( 0 )
    if accU andalso dstIsU then
        dim as long w2 = RTL_USTR_ASSIGN
        if isInit then w2 = RTL_USTR_INIT
        return (EmitRtl( c, w2, fin ).kind <> cast( ubyte, MV_NONE ))
    end if
    fin.Push( cast( ulong, MV_CONST_INT ) )
    fin.Push( cast( ulong, cast( ulongint, flag ) ) )
    if accU then
        return (EmitRtl( c, RTL_USTR_TO_A, fin ).kind <> cast( ubyte, MV_NONE ))
    end if
    if dstIsU then
        return (EmitRtl( c, RTL_USTR_FROM_A, fin ).kind <> cast( ubyte, MV_NONE ))
    end if
    return false
end function

'' AN ALL-NARROW CHAIN INTO A USTRING DESTINATION. Measured: fbc folds the narrow part
'' with fb_StrConcat into a temporary and transcodes ONCE at the end --
''
''     u = q + q     fb_StrConcat( &TMP, q, -1, q, -1 )
''                   fb_UStrAssignFromA( &U, -1, vr, -1, 0, 0 )
''
'' rather than transcoding each term. The trailing flag is -1 at a declaration.
function LowerNarrowChainToU_ _
    ( byref c as Ctx, byref dst as MirValue, _
      byref terms as FB.Array( of ulong ), byval isInit as boolean ) as boolean

    if terms.Count < 2 then return false
    dim as long slot = NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
    dim as MirValue tmp
    tmp.kind = cast( ubyte, MV_LOCAL )
    tmp.ty = cast( ubyte, MT_PTR )
    tmp.id = slot

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, tmp.kind ) ) : args.Push( cast( ulong, tmp.id ) )
    if EmitStrTerm( c, args, cast( Tko.NodeId, terms[0] ), false ) = false then return false
    if EmitStrTerm( c, args, cast( Tko.NodeId, terms[1] ), false ) = false then return false
    dim as MirValue acc = EmitRtl( c, RTL_STR_CONCAT, args )
    if acc.kind = cast( ubyte, MV_NONE ) then return false

    for i as long = 2 to terms.Count - 1
        dim as FB.Array( of ulong ) more
        PushStrArg( more, tmp )
        if EmitStrTerm( c, more, cast( Tko.NodeId, terms[i] ), false ) = false then return false
        more.Push( cast( ulong, MV_CONST_INT ) ) : more.Push( 0 )
        EmitRtl( c, RTL_STR_CONCAT_ASSIGN, more )
    next

    dim as longint flag = 0
    if isInit then flag = -1
    dim as FB.Array( of ulong ) fin
    PushStrArg( fin, dst )
    PushStrArg( fin, acc )
    fin.Push( cast( ulong, MV_CONST_INT ) ) : fin.Push( 0 )
    fin.Push( cast( ulong, MV_CONST_INT ) )
    fin.Push( cast( ulong, cast( ulongint, flag ) ) )
    return (EmitRtl( c, RTL_USTR_FROM_A, fin ).kind <> cast( ubyte, MV_NONE ))
end function

'' ONE OPERAND OF A USTRING COMPARISON. A ustring and a literal push as they are; a real
'' NARROW string becomes a ustring through fb_StrToUStr first and a WIDE one through
'' fb_WstrToUStr, which is what fbc emits and what makes the comparison compare the same
'' encoding on both sides.
function UStrCmpOperand_ _
    ( byref c as Ctx, byref args as FB.Array( of ulong ), _
      byval term as Tko.NodeId ) as boolean

    select case StrTermFlavour_( c, term )
    case STF_NARROW
        dim as FB.Array( of ulong ) sub_
        if EmitStrTerm( c, sub_, term, false ) = false then return false
        dim as MirValue uv = EmitRtl( c, RTL_STR_TO_USTR, sub_ )
        if uv.kind = cast( ubyte, MV_NONE ) then return false
        PushStrArg( args, uv )
        return true
    case STF_WIDE
        dim as MirValue wv
        if WideTermAsUStr_( c, term, wv ) = false then return false
        PushStrArg( args, wv )
        return true
    end select
    return EmitStrTerm( c, args, term, true )
end function

'' Moved here from lowerstr.bas at the 1500-line cap. Nothing about it changed.
'' A byref ZSTRING parameter takes the DATA POINTER, not a descriptor and not the
'' address of one. Measured, all three spellings:
''
''     P2( (char*)"lit" )     a literal: the bytes themselves
''     P2( (char*)ZS )        a 'zstring * N': its own address
''     P2( *(char**)&S )      a STRING: the pointer LOADED out of the descriptor
''
'' The wide half of this is WideOperand_, which already existed for the same reason.
function ZstrDataOf_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    if id = Tko.NODE_NONE then return false
    if c.ast->Kind( id ) = Tko.N_STRING_LIT then
        outv.kind = cast( ubyte, MV_GLOBAL )
        outv.ty = cast( ubyte, MT_PTR )
        outv.id = c.m->AddStringLiteral( StringLitText_( c, id ), *c.names )
        return true
    end if

    dim as longint n
    dim as long k = StrSwapKind_( c, c.info->TypeOf_( id ), n )
    if k = 1 then
        outv = LowerAddr( c, id )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if
    if k = 0 then
        '' StrDescriptorOf_ RATHER THAN LowerAddr, so an rvalue works too: 'str( t )'
        '' has no address, and fbc copies it into a temporary descriptor before taking
        '' the pointer. Everything with an address comes back as its own address here,
        '' so the variable case is unchanged.
        dim as MirValue da
        if StrDescriptorOf_( c, id, da ) = false then da = LowerAddr( c, id )
        if da.kind = cast( ubyte, MV_NONE ) then return false
        '' The data pointer is the descriptor's FIRST field, which is why this is a
        '' plain load and not a field address.
        outv = LowerExprLoad( c, da, MT_PTR )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if
    return false
end function

'' Moved here from lowerstr.bas at the 1500-line cap. Nothing about it changed.
'' SWAP a, b -- measured from fbc, and it is TWO different lowerings.
''
'' A STRING pair goes through the runtime, six arguments rather than four: each side is
'' (pointer, length, flag) with the flag 0.
''
''     fb_StrSwap( &S$1, -1ll, 0, &T$1, -1ll, 0 )
''
'' Anything else is a TEMPORARY OF THE OPERAND'S OWN TYPE and three assignments:
''
''     { double TMP;  TMP = D$1;  D$1 = E$1;  E$1 = TMP; }
''
'' Note the temporary is typed to the operand, not to a fixed width: swapping two
'' doubles through an integer slot would round-trip the bits through the wrong register
'' class, and swapping two aggregates would not fit at all.
'' What kind of string a type is, for the SWAP runtime's argument shape. Returns
''   0 = var-length STRING, and 'n' is set to -1
''   1 = ZSTRING * N,       and 'n' is N
''   2 = WSTRING * N,       and 'n' is N
''  -1 = not a string
''
'' A fixed-length string is modelled as an ARRAY of the element builtin, which is what
'' it is, so the count comes off the array rather than out of a byte size.
function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref nOut as longint ) as long

    if t = Tko.TYPE_NONE then return -1
    '' CONST IS NOT A DIFFERENT STRING. 'dim cz as const zstring * 10' is the same char
    '' array as a mutable one and every runtime call takes it the same way, but the
    '' QUALIFIED type is a distinct entry whose kind test fell through to "not a string
    '' at all" -- so every term spelled with one had no (pointer, length) pair and the
    '' whole statement produced nothing. string/concat.bas is half const by design.
    t = c.types->Unqualify( t )
    if IsStringType( c, t ) then
        nOut = -1
        return 0
    end if
    '' AN UNSIZED ZSTRING -- what a 'zstring ptr' points at, and what '*pz' is. It has
    '' no declared count, and fbc passes LENGTH 0 for one: 'fb_StrAssign( PC, 0ll, PA,
    '' 0ll, 0 )', 0 meaning "NUL-terminated, work it out". It matched neither the array
    '' test below nor IsStringType above, so every operation through a zstring pointer
    '' declined -- and 'hStringChecks( *pa, *pb, *pc )' is how the corpus exercises the
    '' whole string surface a second time.
    if c.types->Kind( t ) = Tko.TK_BUILTIN then
        if c.types->BuiltinOf( t ) = Tko.TY_ZSTRING then
            nOut = 0
            return 1
        end if
        '' AND THE WIDE HALF OF THE SAME THING -- what a 'wstring ptr' points at, and
        '' what '*pw' is. Its absence made 'line input #1, *pw, 10' answer "not a
        '' string at all" and decline, while the zstring line beside it lowered.
        if c.types->BuiltinOf( t ) = Tko.TY_WSTRING then
            nOut = 0
            return 2
        end if
    end if

    if c.types->Kind( t ) <> Tko.TK_ARRAY then return -1
    dim as Tko.TypeId el = c.types->Inner( t )
    if el = Tko.TYPE_NONE then return -1
    if c.types->Kind( el ) <> Tko.TK_BUILTIN then return -1
    nOut = c.types->ElemCount( t )
    if nOut <= 0 then return -1
    select case c.types->BuiltinOf( el )
    case Tko.TY_ZSTRING : return 1
    case Tko.TY_WSTRING : return 2
    case Tko.TY_FIXUSTR
        '' 'ustring * N' -- the FIXED-LENGTH UTF-16 flavour, and its tag is N MINUS
        '' ONE where 'string * N' uses N. Measured, both on win64:
        ''
        ''     dim as string  * 8 s   ->  fb_StrInit ( S, &h8000000000000008, ... )
        ''     dim as ustring * 8 u   ->  fb_UStrInit( U, &h8000000000000007, ... )
        ''
        '' so its capacity is N-1 usable characters, exactly as 'zstring * N' is, and
        '' the fixed narrow string is the odd one out. Nothing about the two spellings
        '' says which, and getting it wrong writes one character past the end.
        nOut = FixedStrLenArg_( c, nOut - 1 )
        return 4
    case Tko.TY_FIXSTR
        '' 'string * N' -- the FIXED-LENGTH, space-padded flavour. 'n' comes back
        '' ENCODED, because that is the only form any runtime call wants it in, and
        '' encoding it here means every '(pointer, length)' push site emits fbc's
        '' constant without knowing this type exists.
        nOut = FixedStrLenArg_( c, nOut )
        return 3
    end select
    return -1
end function

'' A USER OPERATOR WHOSE RESULT IS A STRING, as the descriptor pointer every string
'' reader wants. '-a' and 'a + b' over a UDT are calls like any other, but they are
'' spelled as a UNARY and a BINARY, so nothing that looks for a string CALL finds them.
function LowerStrOperandOp_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    if id = Tko.NODE_NONE then return false
    dim as Tko.SymbolId opsym = c.info->RefOf( id )
    if opsym = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr opsy = c.syms->SymbolAt( opsym )
    if opsy = 0 then return false
    if opsy->kind <> cast( ubyte, Tko.SYM_PROC ) then return false
    if IsStringType( c, opsy->type_ ) = false then return false

    if c.ast->Kind( id ) = Tko.N_UNARY then
        dim as Tko.UnaryPayload ptr uop = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        return LowerUserUnaryOp_( c, id, uop, MT_PTR, outv )
    end if
    if c.ast->Kind( id ) = Tko.N_BINARY then
        dim as Tko.BinaryPayload ptr bop = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        return LowerUserBinaryOp_( c, id, bop, MT_PTR, outv )
    end if
    return false
end function

'' THE TEXT OF A RUN OF ADJACENT STRING LITERALS, or false when the node is not one.
'' The lexer keeps '"a" "b"' as an N_STRCAT of its parts rather than folding it, so the
'' whole run has to be joined before it can be emitted as one literal.
function StrCatText_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as string ) as boolean

    if id = Tko.NODE_NONE then return false
    if c.ast->Kind( id ) <> Tko.N_STRCAT then return false
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count <= 0 then return false
    outv = ""
    for i as long = 0 to lp->count - 1
        dim as Tko.NodeId e = cast( Tko.NodeId, c.ast->children[lp->first + i] )
        if c.ast->Kind( e ) = Tko.N_STRING_LIT then
            outv &= StringLitText_( c, e )
        else
            dim as string inner
            if StrCatText_( c, e, inner ) = false then return false
            outv &= inner
        end if
    next
    return true
end function


'' 'u &= <wide>' -- A WIDE VALUE APPENDED TO A USTRING, which is a CONVERSION and not
'' a concatenation. Measured:
''
''     vr$2 = fb_WstrChr( 1, QUOTE );
''     vr$3 = fb_WstrToUStr( vr$2 );
''     fb_UStrConcatAssign( &CUR$0, -1, vr$3, -1, 0 );
''
'' -- which is how fb/string.bi appends 'wchr( QUOTE )' to the ustring it is building,
'' on the line its own comment insists must be WCHR and never CHR.
function WideAppendToU_ _
    ( byref c as Ctx, byref dst as MirValue, byval value as Tko.NodeId ) as boolean

    dim as MirValue uv
    if WideTermAsUStr_( c, value, uv ) = false then return false
    if uv.kind = cast( ubyte, MV_NONE ) then return false
    dim as FB.Array( of ulong ) aargs
    PushStrArg( aargs, dst )
    PushStrArg( aargs, uv )
    aargs.Push( cast( ulong, MV_CONST_INT ) )
    aargs.Push( 0 )
    EmitRtl( c, RTL_USTR_CONCAT_ASSIGN, aargs )
    return true
end function

end namespace
