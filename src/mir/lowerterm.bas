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

'' Defined in lowerstr.bas, which is compiled after this one.
declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long

'' The (pointer, length) pair for one term of a concatenation.
function EmitStrTerm _
    ( byref c as Ctx, byref args as FB.Array( of ulong ), _
      byval term as Tko.NodeId, byval isU as boolean = false ) as boolean

    term = Unparen_( c, term )

    '' A STRING CONSTANT IS ITS TEXT, and it has to be recognised BEFORE the type test
    '' below claims it and asks for an address a constant has not got.
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
    dim as longint zn
    dim as long zk = StrSwapKind_( c, c.info->TypeOf_( term ), zn )
    if (zk = 1) orelse (zk = 3) then
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

end namespace
