'' lowerconcat.bas -- concatenation assignment, and the small string helpers beside it.
''
'' Split out of lowerstr.bas at the 1500-line cap and included from it in the same place.



'' THE WIDE HALF OF 's &= v' OVER A NARROW VAR-LENGTH STRING -- see the call site in
'' LowerConcatAssignStmt. The value is built FIRST, as fbc builds it, so
'' 'k &= mid( k, 2 ) & wz' reads k before the append changes it. Measured:
''
''     vr  = fb_WstrConcatAW( (void*)"a", 2ll, WZ )      '' the value, when a chain
''     vr2 = fb_WstrConcatAW( (void*)&B, -1ll, vr )
''     fb_WstrAssignToA( (void*)&B, -1ll, vr2, 0 )
private function NarrowAppendWide_ _
    ( byref c as Ctx, byref dst as MirValue, byval value as Tko.NodeId ) as boolean

    dim as MirValue src
    if ConcatHasWideTerm_( c, value ) then
        if WideConcatToTemp_( c, value, src ) = false then return false
    elseif (WideOperand_( c, value, src ) = false) orelse (src.kind = cast( ubyte, MV_NONE )) then
        if UserCastToWide_( c, value, src ) = false then return false
    end if
    if src.kind = cast( ubyte, MV_NONE ) then return false
    dim as FB.Array( of ulong ) args
    PushStrArg( args, dst )
    args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
    dim as MirValue joined
    if WideConcatStep_( c, args, RTL_WSTR_CONCAT_AW, joined ) = false then return false
    dim as FB.Array( of ulong ) aargs
    aargs.Push( cast( ulong, dst.kind ) ) : aargs.Push( cast( ulong, dst.id ) )
    PushStrLen_( c, aargs, -1 )
    aargs.Push( cast( ulong, joined.kind ) ) : aargs.Push( cast( ulong, joined.id ) )
    aargs.Push( cast( ulong, MV_CONST_INT ) ) : aargs.Push( 0 )
    EmitRtl( c, RTL_WSTR_ASSIGN_TOA, aargs )
    return true
end function

'' 'a &= b' AND 'a += b' OVER A STRING, which is the same statement: measured, fbc
'' emits 'fb_StrConcatAssign( &S, -1ll, src, len, 0 )' for both spellings.
''
'' The operator was recorded on the statement and then thrown away for '&=': the
'' dispatch treated it as PLAIN, so 's &= "b"' lowered to fb_StrAssign -- an
'' assignment, not an append. It verified, it emitted code, it counted as fully
'' lowered, and it was wrong every time. '+=' declined instead, because the compound
'' path works in the target's MIR type and a string is an aggregate.
''
'' Only the shapes fbc reaches with ONE call are lowered. A fixed 'zstring * N' or
'' 'string * N' destination builds a temporary first -- 'fb_StrConcat( &TMP, Z, 10,
'' "f", 2 )' then 'fb_StrAssign( Z, 10, vr, -1, 0 )' -- and a narrow source appended
'' to a WIDE destination needs a temporary's lifetime as well. Those decline, which
'' is the honest answer where half of the model would be a wrong one.
function LowerConcatAssignStmt _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId, _
      byval op as Tko.TokenKind ) as boolean

    if (op <> Tko.TK_AMPEQ) andalso (op <> Tko.TK_PLUSEQ) then return false
    dim as Tko.TypeId tt = c.info->TypeOf_( target )
    if tt = Tko.TYPE_NONE then return false

    if IsStringType( c, tt ) then
        dim as MirValue dst = LowerAddr( c, target )
        if dst.kind = cast( ubyte, MV_NONE ) then return false
        dim as boolean isU = IsUStringType( c, tt )
        '' A CHAIN APPENDED TO A USTRING IS FOLDED, like the three-term self chain it is.
        '' Measured (every ustring row a fold and one assign):
        ''
        ''     t &= " (" & n & ")"   fb_UStrConcat, fb_UStrConcatUA, fb_UStrConcat, fb_UStrAssign
        ''     t &= u2 & "x"         fb_UStrConcat, fb_UStrConcat, fb_UStrAssign
        ''     t &= "a" & s2         fb_UStrConcat, fb_UStrConcatUA, fb_UStrAssign
        ''
        '' while a NARROW destination appends each term in place ('nar &= "a" & s2' is two
        '' fb_StrConcatAssign), which the path below already does. Asking StrTermFlavour_
        '' of the WHOLE chain gave NEUTRAL for 'u2 & "x"', and one fb_UStrConcatAssign of a
        '' narrow build followed: 'Tu', NUL -- fbsqlite's DbError.ToString lost everything
        '' after its first line ('text &= " [" & m_operation & "]"').
        if isU then
            dim as FB.Array( of ulong ) vterms
            FlattenConcat( c, value, vterms )
            if vterms.Count >= 2 then
                dim as FB.Array( of ulong ) chain
                chain.Push( cast( ulong, target ) )
                for i as long = 0 to vterms.Count - 1
                    chain.Push( vterms[i] )
                next
                return LowerUStrChain( c, dst, true, chain, false )
            end if
        end if
        '' 'u &= q' over a narrow source is fb_UStrConcatUA into a TEMPORARY and then an
        '' assign, not one concat-assign -- measured. Appending the narrow bytes through
        '' the UTF-16 entry point is what this used to do.
        '' 'u &= q' over a narrow source is fb_UStrConcatUA into a TEMPORARY and then
        '' an assign, not one concat-assign -- measured. It is the two-term chain
        '' 'u = u + q', so it goes through the same fold.
        dim as long vf = StrTermFlavour_( c, value )

        '' A WIDE SOURCE APPENDED TO A USTRING IS A CONVERSION, not a concat: a
        '' wstring is a bare uint16* and a ustring a DESCRIPTOR, and no entry point
        '' takes one and appends to the other. See WideAppendToU_.
        if isU andalso (vf = STF_WIDE) then
            if WideAppendToU_( c, dst, value ) then return true
        end if

        '' A WIDE VALUE APPENDED TO A NARROW STRING -- a wstring, a 'wstr( )', a UDT
        '' casting to a wstring (AfxNova's DWSTRING) -- has no narrow form, so EmitStrTerm
        '' declined it and the whole statement was DROPPED: tracks' 's &= "host=" &
        '' this.Host & "|"' appended nothing. Measured, fbc builds the value wide, then
        '' 'fb_WstrConcatAW( &S, -1ll, vr )' and 'fb_WstrAssignToA( &S, -1ll, vr2, 0 )'.
        '' A USTRING in the same chain was worse: it lowered narrow over UTF-16 units and
        '' 'h &= u & wz' held "nU w i". It takes the fold 'h = h & u & wz' already takes.
        '' A UDT that ALSO casts to a narrow string stays narrow -- fbc picks that cast.
        if (isU = false) andalso (vf = STF_WIDE) then
            dim as FB.Array( of ulong ) wterms
            FlattenConcat( c, value, wterms )
            dim as boolean touchesU = false
            dim as boolean wideOnly = false
            dim as boolean hasDual = false
            for i as long = 0 to wterms.Count - 1
                dim as Tko.NodeId wt = cast( Tko.NodeId, wterms[i] )
                if IsUStringType( c, c.info->TypeOf_( wt ) ) then touchesU = true
                if TermIsWide_( c, wt ) then
                    dim as Tko.TypeId wtt = c.info->TypeOf_( Unparen_( c, wt ) )
                    if NarrowCastOverload_( c, wtt ) = Tko.SYMBOL_NONE then
                        wideOnly = true
                    else
                        hasDual = true
                    end if
                end if
            next
            if touchesU then
                dim as FB.Array( of ulong ) uchain
                uchain.Push( cast( ulong, target ) )
                for i as long = 0 to wterms.Count - 1
                    uchain.Push( wterms[i] )
                next
                return LowerUStrChain( c, dst, false, uchain, false )
            end if
            '' ...AND NOT BESIDE ONE: fbc takes the narrow cast inside a wide chain as well --
            '' 'b &= du & wz' is "nnarrowwide" -- where WideConcatToTemp_ would take the wide
            '' one. That mix declines rather than guess.
            if wideOnly andalso hasDual then return false
            if wideOnly then return NarrowAppendWide_( c, dst, value )
        end if

        dim as boolean mism = false
        if vf <> STF_NEUTRAL then
            if isU then
                mism = (vf <> STF_UTF16)
            else
                mism = (vf = STF_UTF16)
            end if
        end if
        if mism then
            dim as FB.Array( of ulong ) two
            two.Push( cast( ulong, target ) )
            two.Push( cast( ulong, value ) )
            if LowerUStrChain( c, dst, isU, two, false ) then return true
            if isU then return LowerNarrowChainToU_( c, dst, two, false )
            return false
        end if
        dim as FB.Array( of ulong ) args
        PushStrArg( args, dst )
        if EmitStrTerm( c, args, value, isU ) = false then return false
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( 0 )
        EmitRtl( c, iif( isU, RTL_USTR_CONCAT_ASSIGN, RTL_STR_CONCAT_ASSIGN ), args )
        return true
    end if

    '' A FIXED WIDE STRING with a wide source: 'fb_WstrConcatAssign( W, 50ll, W2 )'.
    if IsWideString_( c, tt ) then
        return LowerWideConcatAssign( c, target, WideStringElems( c, tt ), value )
    end if
    return false
end function

'' Flatten a left-leaning '+' chain into its terms, in source order.
sub FlattenConcat _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outp as FB.Array( of ulong ) )

    if id = Tko.NODE_NONE then return
    if c.ast->Kind( id ) = Tko.N_BINARY then
        dim as Tko.BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        '' '&' AND '+' ARE THE SAME OPERATION on strings -- measured: fbc emits
        '' fb_StrAssign followed by fb_StrConcatAssign for both, instruction for
        '' instruction. Only '+' was flattened, so 'b = a & p' declined outright while
        '' 'b = a + p' beside it lowered. ('and' is FreeBASIC's bitwise operator, so
        '' '&' is never ambiguous here.)
        dim as Tko.TokenKind bop = cast( Tko.TokenKind, bp->op )
        if (bop = Tko.TK_PLUS) orelse (bop = Tko.TK_AMP) then
            FlattenConcat( c, bp->lhs, outp )
            FlattenConcat( c, bp->rhs, outp )
            return
        end if
    end if
    outp.Push( cast( ulong, id ) )
end sub

'' Whether two expressions name the same storage. Only the simple cases are needed:
'' anything else falls back to the general path rather than guessing.
function SameLValue _
    ( byref c as Ctx, byval a as Tko.NodeId, byval b as Tko.NodeId ) as boolean
    if (a = Tko.NODE_NONE) orelse (b = Tko.NODE_NONE) then return false
    if c.ast->Kind( a ) <> c.ast->Kind( b ) then return false
    if c.ast->Kind( a ) <> Tko.N_IDENT then return false
    return c.info->RefOf( a ) = c.info->RefOf( b )
end function

'' DOES THIS TERM READ THE TARGET ANYWHERE, not only as itself. 's = w & mid( s, 5 )' built
'' in place assigned w into s and then took mid( s, 5 ) of the RESULT, so ApexWealth's token
'' redaction kept its first '[redacted]' and lost the rest. Measured, fbc takes the
'' substring first and concatenates into a temporary. The target is recognised as
'' SameLValue recognises it, and a node kind not walked here is not searched.
function TermReadsLValue_ _
    ( byref c as Ctx, byval target as Tko.NodeId, byval e as Tko.NodeId ) as boolean

    if (target = Tko.NODE_NONE) orelse (e = Tko.NODE_NONE) then return false
    dim as ulong d = c.ast->nodes[cast( long, e )].data
    select case c.ast->Kind( e )
    case Tko.N_IDENT
        return SameLValue( c, target, e )
    case Tko.N_UNARY, Tko.N_ADDROF, Tko.N_DEREF
        return TermReadsLValue_( c, target, c.ast->unaries[cast( long, d )].operand )
    case Tko.N_BINARY, Tko.N_MEMBER
        if TermReadsLValue_( c, target, c.ast->binaries[cast( long, d )].lhs ) then return true
        return TermReadsLValue_( c, target, c.ast->binaries[cast( long, d )].rhs )
    case Tko.N_CALL, Tko.N_INDEX, Tko.N_PAREN, Tko.N_TUPLE
        dim as Tko.ListPayload ptr lp = @c.ast->lists[cast( long, d )]
        if TermReadsLValue_( c, target, lp->target ) then return true
        for i as long = 0 to lp->count - 1
            if TermReadsLValue_( c, target, cast( Tko.NodeId, c.ast->children[lp->first + i] ) ) then return true
        next
    end select
    return false
end function

'' THE WIDE HALF, into a fixed wstring: 'x = ww & mid( x, 5 )'. Measured, fbc takes
'' fb_WstrMid, concatenates into a temporary with fb_WstrConcat and fb_WstrAssigns that;
'' built in place, ww went into x first and mid( x, 5 ) read the result. False, emitting
'' nothing, when no term after the first reads the target.
function WideAssignViaTemp_ _
    ( byref c as Ctx, byref dst as MirValue, byval n as long, _
      byval target as Tko.NodeId, byval value as Tko.NodeId ) as boolean

    dim as FB.Array( of ulong ) terms
    FlattenConcat( c, value, terms )
    dim as boolean reads = false
    for i as long = 1 to terms.Count - 1
        if TermReadsLValue_( c, target, cast( Tko.NodeId, terms[i] ) ) then reads = true
    next
    if reads = false then return false
    dim as MirValue src
    if WideConcatToTemp_( c, value, src ) = false then return false
    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, dst.kind ) ) : args.Push( cast( ulong, dst.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, n ) )
    args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
    EmitRtl( c, RTL_WSTR_ASSIGN, args )
    return true
end function

'' 'offsetof( T, field )' -- A COMPILE-TIME INTEGER, folded from the measured layout.
''
'' Measured: over a type whose first two fields are INTEGERs, 'offsetof( E, i )' is 16
'' and 'typeof' of it is INTEGER. It takes a TYPE and a FIELD NAME rather than two
'' expressions -- neither argument has a type of its own, and the field name never
'' resolves to anything, which is why nothing else here recognises the shape.
''
'' It was not implemented at all, so every use declined. structs/padding.bas is written
'' almost entirely in terms of it.
function LowerOffsetOf _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count <> 2 then return false
    if lp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( lp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
    if Tko.Text.LowerAscii( c.names->Spelling( ip->name ) ) <> "offsetof" then return false

    '' THE TYPE. Written as a bare name, so Resolve bound it to the UDT's own symbol
    '' rather than typing the node.
    dim as Tko.NodeId tn = cast( Tko.NodeId, c.ast->children[lp->first] )
    dim as Tko.TypeId ut = c.info->TypeOf_( tn )
    if ut = Tko.TYPE_NONE then
        dim as Tko.SymbolId ts = c.info->RefOf( tn )
        dim as Tko.Symbol ptr tsy = c.syms->SymbolAt( ts )
        if tsy = 0 then return false
        ut = tsy->type_
    end if
    if ut = Tko.TYPE_NONE then return false
    ut = c.types->Unqualify( ut )
    if c.types->Kind( ut ) <> Tko.TK_UDT then return false

    '' THE FIELD, by name. It is not an expression and resolves to nothing, so the
    '' spelling is all there is to go on -- which is what the layout store keys on too.
    ''
    '' ...AND A DOTTED PATH IS A WALK. 'offsetof( T, a.b )' parses as an N_MEMBER over
    '' N_IDENTs, so the N_IDENT test below saw a node kind it did not know and DECLINED
    '' SILENTLY -- a compile-time constant that lowered to no value at all, with the
    '' statement around it dropped and no diagnostic. tiko-editor's theme key table is
    '' built entirely out of 'offsetof( THEMEROOT_TYPE, editor.selection.forecolor )':
    '' all 71 rows took the -1 their macro had just defaulted them to, so every colour
    '' in the file reached nothing and the editor painted its built-in defaults.
    ''
    '' The spine is left-nested -- N_MEMBER( N_MEMBER( a, b ), c ) -- so it is walked
    '' from the outside in and the names come out reversed, then applied in order,
    '' each one's offset added and its TYPE becoming the next one's container.
    dim as Tko.NodeId fn = cast( Tko.NodeId, c.ast->children[lp->first + 1] )
    dim as FB.Array( of ulong ) path
    while c.ast->Kind( fn ) = Tko.N_MEMBER
        dim as Tko.BinaryPayload ptr mbp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, fn )].data )]
        if c.ast->Kind( mbp->rhs ) <> Tko.N_IDENT then return false
        path.Push( cast( ulong, mbp->rhs ) )
        fn = mbp->lhs
    wend
    if c.ast->Kind( fn ) <> Tko.N_IDENT then return false
    path.Push( cast( ulong, fn ) )

    dim as long off = 0
    dim as Tko.TypeId cur = ut
    for i as long = path.Count - 1 to 0 step -1
        '' A STEP THAT IS NOT A UDT HAS NO FIELDS, so a path that keeps going past one
        '' names nothing -- declined rather than answered with the offset so far.
        if cur = Tko.TYPE_NONE then return false
        cur = c.types->Unqualify( cur )
        if c.types->Kind( cur ) <> Tko.TK_UDT then return false
        dim as Tko.IdentPayload ptr fip = _
            @c.ast->idents[cast( long, c.ast->nodes[cast( long, path[i] )].data )]
        dim as boolean found = false
        dim as Tko.TypeId ft = Tko.TYPE_NONE
        off += c.udts->FieldOffsetType( cur, fip->name, found, ft )
        if found = false then return false
        cur = ft
    next
    outv = ConstInt( c, off, MT_I64 )
    return true
end function

'' A USTRING DESTINATION BUILT IN PLACE WHOSE CHAIN RENDERS A NUMBER. Measured, 'v = w & n &
'' "z"' with w not v: fb_UStrAssign( v, w ), fb_StrToUStr( n ), fb_UStrConcatAssign, then
'' ConcatAssign "z"; 'v = n & w': fb_UStrAssignFromA( v, n ), ConcatAssign w. The narrow
'' digits concat-assigned unconverted read as UTF-16 -- '25' came out as U+3532.
function LowerUStrInPlaceWithNumbers_ _
    ( byref c as Ctx, byref dst as MirValue, byref terms as FB.Array( of ulong ) ) as boolean

    for i as long = 0 to terms.Count - 1
        dim as Tko.NodeId term = cast( Tko.NodeId, terms[i] )
        dim as FB.Array( of ulong ) args
        PushStrArg( args, dst )
        if IsRenderedNumberTerm_( c, term ) then
            dim as MirValue nv
            if NumberToStrDesc_( c, term, nv ) = false then return false
            if i = 0 then
                PushStrArg( args, nv )
                args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
                args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
                EmitRtl( c, RTL_USTR_FROM_A, args )
                continue for
            end if
            dim as FB.Array( of ulong ) cv
            PushStrArg( cv, nv )
            dim as MirValue uv = EmitRtl( c, RTL_STR_TO_USTR, cv )
            if uv.kind = cast( ubyte, MV_NONE ) then return false
            PushStrArg( args, uv )
        elseif WideCastOverload_( c, c.info->TypeOf_( Unparen_( c, term ) ) ) <> Tko.SYMBOL_NONE then
            '' A UDT THAT CASTS TO A WSTRING (AfxNova's DWSTRING) is converted first, as
            '' PushChainTerm_ does for the fold: EmitStrTerm has no UTF-16 form for it, so
            '' 't = u & n & dws' declined here with 't = u' already emitted.
            dim as MirValue wu
            if WideTermAsUStr_( c, term, wu ) = false then return false
            PushStrArg( args, wu )
        else
            if EmitStrTerm( c, args, term, true ) = false then return false
        end if
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
        EmitRtl( c, iif( i = 0, RTL_USTR_ASSIGN, RTL_USTR_CONCAT_ASSIGN ), args )
    next
    return true
end function

end namespace
