'' lowerassign.bas -- THE ASSIGNMENT STATEMENT, lowered.
''
'' Split out of lower.bas at the 1500-line cap and included from it in the same place.



'' NOT private any more: the expression call chain moved to lowerintr.bas when this
'' file reached its size limit, and it ends here.





'' -------------------------------------------------------------- statements



private sub LowerAssign _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId )

    '' A string assignment is a runtime call, not a store. When it cannot be lowered
    '' -- 'a = b + a' needs a temporary -- it is SKIPPED, never allowed to fall
    '' through: an ordinary store would emit load/add/store over 24-byte descriptors,
    '' which is not a partial answer but a wrong one.
    '' A WIDE STRING is neither a store nor the narrow string runtime: 'wstring * N'
    '' is a bare uint16* with its own family of entry points, and which one depends on
    '' whether the SOURCE is wide or narrow.
    '' 'x = type<T>( y )' OVER THE SAME TYPE IS A COPY OF y, not a field list, and
    '' the field-list path could not take it -- T's first field is a LONG and the
    '' argument is a T -- so the whole assignment declined. Unwrapped and assigned,
    '' so a type with an 'operator let' still gets its call. See TypeLitCopySource_.
    dim as Tko.NodeId tlv = TypeLitCopySource_( c, target, value )
    if tlv <> Tko.NODE_NONE then
        LowerAssign( c, target, tlv )
        return
    end if

    if LowerWideAssign( c, target, value ) then return
    if LowerWideToNarrow( c, target, value ) then return

    if IsStringType( c, c.info->TypeOf_( target ) ) then
        if LowerStringAssign( c, target, value ) = false then c.st->skipped += 1
        return
    end if

    '' A FIXED-LENGTH NARROW DESTINATION -- 'zstring * N' -- is a CHAR ARRAY, not a
    '' descriptor, so IsStringType says no and it fell through to the ordinary store
    '' path. There it emitted NOTHING AT ALL and counted as fully lowered: 'dim as
    '' zstring * 8 fa : fa = c' left fa untouched with "0 statements not lowered"
    '' beside it, which is the worst of the three outcomes -- worse than declining,
    '' because nothing said it had happened.
    ''
    '' The runtime call is the one the DIM INITIALISER already used, and fbc emits the
    '' same thing for both: fb_StrAssign( FA, 8, &C, -1, 0 ).
    dim as longint zdn
    dim as long zdk = StrSwapKind_( c, c.info->TypeOf_( target ), zdn )
    '' Kind 4 is a fixed USTRING, which takes the same shape through the UTF-16
    '' entry points.
    if (zdk = 1) orelse (zdk = 3) orelse (zdk = 4) then
        dim as MirValue zdst = LowerAddr( c, target )
        if zdst.kind <> cast( ubyte, MV_NONE ) then
            if LowerZstrAssignTo( c, zdst, zdn, value, false, (zdk = 4) ) then return
        end if
        SkipHere( c )
        return
    end if

    '' A UDT WITH AN ASSIGNMENT OPERATOR IS A CALL, not a store. 'x = y' over a type
    '' holding a string copied the DESCRIPTOR bitwise and left two objects owning one
    '' buffer -- a double free at scope exit, not a leak. fbc emits
    '' '_ZN1TaSERKS_( &X, &Y )'.
    ''
    '' Both sides must be the SAME type: 'x = someOtherThing' is a conversion, and the
    '' assignment operator takes its own type by reference.
    '' AN ARRAY ASSIGNED TO A UDT IS ITS 'operator let( a( ) as E )'. The two sides
    '' are never the same type, so the equality test below can never reach it, and
    '' the argument is a DESCRIPTOR rather than an address.
    '' structs/udt-array-ops-1.bas writes 'z = a( )' beside the constructor form.
    ''
    '' The SHAPE is tested before anything is emitted -- an empty call over a name
    '' whose type is an ARRAY -- because building the descriptor is code, and code
    '' emitted for an overload that then does not exist is dead.
    dim as Tko.TypeId atl = c.info->TypeOf_( target )
    if (atl <> Tko.TYPE_NONE) andalso (c.ast->Kind( value ) = Tko.N_CALL) then
        if c.types->Kind( atl ) = Tko.TK_UDT then
            dim as Tko.ListPayload ptr vlp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, value )].data )]
            dim as Tko.TypeId vat = Tko.TYPE_NONE
            if (vlp->count = 0) andalso (vlp->target <> Tko.NODE_NONE) then
                vat = c.info->TypeOf_( vlp->target )
            end if
            if vat <> Tko.TYPE_NONE then
                if c.types->Kind( vat ) = Tko.TK_ARRAY then
                    dim as FB.Array( of ulong ) latT
                    latT.Push( cast( ulong, vat ) )
                    dim as Tko.SymbolId alet = _
                        PickCtor( c, StructorOf( c, atl, "let" ), latT )
                    if alet <> Tko.SYMBOL_NONE then
                        dim as MirValue ada = LowerAddr( c, target )
                        dim as MirValue aadv
                        if (ada.kind <> cast( ubyte, MV_NONE )) andalso _
                           ArrayDescArg_( c, value, true, aadv ) then
                            dim as FB.Array( of ulong ) alargs
                            alargs.Push( cast( ulong, aadv.kind ) )
                            alargs.Push( cast( ulong, aadv.id ) )
                            EmitStructorCall( c, alet, -1, @ada, @alargs )
                            return
                        end if
                    end if
                end if
            end if
        end if
    end if

    if (atl <> Tko.TYPE_NONE) andalso (atl = c.info->TypeOf_( value )) then
        if c.types->Kind( atl ) = Tko.TK_UDT then
            dim as boolean handled = false
            dim as Tko.SymbolId ulet = StructorOf( c, atl, "let" )
            if (ulet <> Tko.SYMBOL_NONE) orelse NeedsLetBody_( c, atl ) then
                dim as MirValue da = LowerAddr( c, target )
                dim as MirValue sa = LowerAddr( c, value )
                if (da.kind <> cast( ubyte, MV_NONE )) andalso _
                   (sa.kind <> cast( ubyte, MV_NONE )) then
                    if ulet <> Tko.SYMBOL_NONE then
                        dim as FB.Array( of ulong ) largs
                        largs.Push( cast( ulong, sa.kind ) )
                        largs.Push( cast( ulong, sa.id ) )
                        EmitStructorCall( c, ulet, -1, @da, @largs )
                    else
                        CallImplicitLet_( c, atl, da, sa )
                    end if
                    handled = true
                end if
            end if
            if handled then return
        end if
    end if

    '' Same reason as the read: a full-width store into a bitfield's unit would
    '' overwrite every field packed beside it, so it is a read-modify-write.
    '' 't.V = x' OVER A PROPERTY IS A CALL, not a store. Without this it reached the
    '' ordinary store path, which looked for a FIELD of that name, found a procedure and
    '' declined.
    if LowerPropertySet_( c, target, value ) then return

    if LowerBitfieldStore( c, target, value ) then return

    '' 'let (a, b) = expr' -- N assignments from the elements of ONE evaluation, not an
    '' assignment of one thing to another. An N_TUPLE target is not an lvalue and has no
    '' address, so the whole statement declined.
    if LowerDestructure( c, target, value ) then return

    dim as MirValue addr = LowerAddr( c, target )
    dim as MirValue val = LowerExpr( c, value )
    if (addr.kind = cast( ubyte, MV_NONE )) orelse (val.kind = cast( ubyte, MV_NONE )) then
        SkipHere( c )
        return
    end if
    '' AN UNTYPED TARGET IS A DECLINE, not a store. Every remaining MIR verify failure
    '' in the corpus was this one shape -- 'store: stores <T> into a void slot' --
    '' where the frontend left a variable untyped and lowering stored into it anyway.
    ''
    '' The verifier exists to catch that, and catching it is the right outcome; but
    '' EMITTING the store and then reporting it is worse than not emitting it. A
    '' decline is counted, names the site, and leaves nothing malformed behind.
    if LowerType( c.info->TypeOf_( target ), *c.types ) = MT_VOID then
        SkipHere( c )
        return
    end if

    '' The stored value must match the TARGET's type exactly -- MIR has no implicit
    '' conversions, so the narrowing FreeBASIC allows on assignment is explicit here.
    '' The type comes from the target EXPRESSION, not from the local slot: a member
    '' store's address is a temp from field.addr, and there is no slot to ask.
    val = Coerce( c, val, LowerType( c.info->TypeOf_( target ), *c.types ), _
                  IsUnsignedType( c, c.info->TypeOf_( value ) ) )
    dim as MirInst ins
    ins.op = cast( ushort, M_STORE )
    ins.ty = cast( ubyte, MT_VOID )
    ins.a = addr
    ins.b = val
    Emit( c, ins )
end sub


declare sub LowerStmtInner( byref c as Ctx, byval id as Tko.NodeId )

'' The assignment and declaration helpers, in their own file at the 1500-line cap.
