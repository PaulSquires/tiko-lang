'' lowerassign.bas -- THE ASSIGNMENT STATEMENT, lowered.
''
'' Split out of lower.bas at the 1500-line cap and included from it in the same place.



'' NOT private any more: the expression call chain moved to lowerintr.bas when this
'' file reached its size limit, and it ends here.





'' -------------------------------------------------------------- statements



'' 'x = type( )' -- a BARE type literal assigned to an existing variable.
''
'' Recognised by SHAPE: an empty N_TUPLE marked as a type literal, with no type name of
'' its own. The type comes from the DESTINATION, which is the only place it can come
'' from, so this cannot be done in Check -- nothing types bottom-up here.
private function LowerBareTypeLiteralAssign_ _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId ) as boolean

    if value = Tko.NODE_NONE then return false
    if c.ast->Kind( value ) <> Tko.N_TUPLE then return false
    if (c.ast->nodes[cast( long, value )].flags and Tko.NF_TYPE_LITERAL) = 0 then
        return false
    end if
    '' A TYPE LITERAL THAT DID GET A TYPE is still one, as long as the type is the
    '' DESTINATION'S. 'x = type<const UDT>( )' is typed -- the CONST qualifier gives
    '' Check something to record -- so the untyped test threw it out and the assignment
    '' declined, while 'x = type<UDT>( )' and 'dim y as UDT = type<const UDT>( )' both
    '' lowered. fbc builds the same temporary for all three:
    '' '_ZN3UDTC1Ev( &TMP$2$0 ); __builtin_memcpy( &X$0, &TMP$2$0, 8 );'.
    dim as Tko.TypeId lvt = c.info->TypeOf_( value )
    if lvt <> Tko.TYPE_NONE then
        dim as Tko.TypeId ldt0 = c.info->TypeOf_( target )
        if ldt0 = Tko.TYPE_NONE then return false
        if c.types->Unqualify( lvt ) <> c.types->Unqualify( ldt0 ) then return false
    end if

    dim as Tko.TypeId dt = c.types->Unqualify( c.info->TypeOf_( target ) )
    if c.types->Kind( dt ) <> Tko.TK_UDT then return false
    dim as long sz = SizeOfType( c, dt )
    if sz <= 0 then return false

    dim as MirValue daddr = LowerAddr( c, target )
    if daddr.kind = cast( ubyte, MV_NONE ) then return false

    dim as long tslot = NewTempLocal( c, MT_AGG, sz )
    if tslot < 0 then return false
    if LowerCtorInit( c, tslot, dt, value ) = false then
        '' A TYPE WITH NO CONSTRUCTOR still has a default value -- fbc emits the
        '' memset its implicit constructor would -- but nothing here has been emitted
        '' yet, so declining leaves the statement clean.
        return false
    end if
    '' DESTROYED AT THE END OF THE STATEMENT, which is the life fbc gives it.
    if TypeNeedsDtor_( c, dt ) then
        c.udtTemps.Push( cast( ulong, tslot ) )
        c.udtTempTypes.Push( cast( ulong, dt ) )
    end if

    dim as MirValue taddr
    taddr.kind = cast( ubyte, MV_LOCAL )
    taddr.ty = cast( ubyte, MT_PTR )
    taddr.id = tslot
    dim as MirValue tv = LowerExprLoad( c, taddr, MT_AGG )
    if tv.kind = cast( ubyte, MV_NONE ) then return false
    StoreThrough( c, daddr, tv )
    return true
end function

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

    '' 'a = type( 1, 2, 3 )' IS A SEQUENCE OF FIELD STORES, the same ones the DIM
    '' initialiser makes. Measured, for 'dim as FVec3 a3 : a3 = type( 1.5f, 0.75f,
    '' 2.25f )':
    ''
    ''   *(float*)&A3$0 = 0x1.8p+0f;
    ''   *(float*)((uint8*)&A3$0 + 4ll) = 0x1.8p-1f;
    ''   *(float*)((uint8*)&A3$0 + 8ll) = 0x1.2p+1f;
    ''
    '' -- no temporary and no copy. Only the DIM position read the form, so every
    '' later assignment of one declined: optimizations/vector.bas writes 24 of them
    '' and math/vector.bas more.
    ''
    '' ...AND ONLY OVER A TYPE WITH NO CONSTRUCTOR. Measured, the two are different:
    '' 'x = type<C>( )' over a type that HAS one builds a temporary and memcpys it --
    '' '_ZN1CC1Ev( &TMP$2$0 ); __builtin_memcpy( &X$0, &TMP$2$0, 8 )' -- while
    '' 'y = type<D>( 1, 2 )' over one that does not writes the fields straight into Y.
    '' And a type whose fields need construction, a string member say, REJECTS the
    '' form outright: error 99, "No matching overloaded function, E.constructor()".
    ''
    '' A PLAIN LOCAL ONLY, because the field-list walk addresses its destination by
    '' SLOT. A field or an element target still declines, which is honest rather than
    '' half-done.
    if c.ast->Kind( target ) = Tko.N_IDENT then
        dim as Tko.TypeId tlt = c.types->Unqualify( c.info->TypeOf_( target ) )
        dim as boolean tlPlain = (c.types->Kind( tlt ) = Tko.TK_UDT)
        if tlPlain then
            tlPlain = (StructorOf( c, tlt, "__ctor" ) = Tko.SYMBOL_NONE)
            tlPlain = tlPlain andalso (TypeNeedsInit_( c, tlt ) = false)
        end if
        if tlPlain then
            dim as boolean isList = (c.ast->Kind( value ) = Tko.N_TUPLE)
            isList = isList orelse (c.ast->Kind( value ) = Tko.N_PAREN)
            if isList then
                dim as long tlslot = LocalFor( c, c.info->RefOf( target ) )
                if tlslot >= 0 then
                    if LowerUdtParenInit_( c, tlslot, tlt, value ) then return
                end if
            end if
        end if
    end if

    '' 'mid( s, n [, l ] ) = v' -- MID AS A TARGET is a runtime call over the
    '' destination's descriptor, not a store: an N_CALL is not an lvalue and has no
    '' address, so the whole statement produced nothing and the string was untouched.
    ''
    '' BEFORE THE FLAVOUR TESTS BELOW, not after. 'mid( s, 1 )' is STRING-TYPED, so
    '' the narrow-assignment path claimed it and then asked an N_CALL for an address --
    '' which is why the WIDE spellings lowered while every narrow one declined.
    if LowerMidAssign( c, target, value ) then return

    if LowerWideAssign( c, target, value ) then return
    if LowerWideToNarrow( c, target, value ) then return

    '' A STRING-VALUED PROPERTY IS A CALL, and the string branch below would claim it.
    ''
    '' 'a.first = \"zero\"' over 'property first( byval x as string )' is string-typed,
    '' so LowerStringAssign took it and asked its target for an ADDRESS -- and the
    '' target names a PROCEDURE:
    ''
    ''     %5 = func.addr ptr _ZN4ARR312FIRST__get__Ev
    ''     %6 = call.rtl ptr fb_StrAssign(%5, -1, @@$str0, 5, 0)
    ''
    '' -- a descriptor written OVER THE GETTER'S MACHINE CODE, and 0xC0000374. The
    '' setter was emitted correctly and never called. A property of any OTHER type was
    '' right all along, because only the string branch runs this early -- which is why
    '' the test goes HERE and not at the top: moving the general property call ahead of
    '' every flavour test made it claim 's.fn = @Less' over a GENERIC procedure-pointer
    '' FIELD, and generic-procptr-typearg.bas went from passing to failing.
    if IsStringType( c, c.info->TypeOf_( target ) ) then
        if LowerPropertySet_( c, target, value ) then return
    end if

    if IsStringType( c, c.info->TypeOf_( target ) ) then
        '' SkipHere, NOT a bare counter bump. This site incremented 'skipped'
        '' directly, so its declines had NO trace line, NO skip-site and NO source
        '' line: 14 corpus statements were counted and could not be located at all,
        '' and TKO_TRACE_SKIP printed nothing for the files that carried them.
        if LowerStringAssign( c, target, value ) = false then SkipHere( c )
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
    '' A NUMBER ASSIGNED THROUGH A ZSTRING OR WSTRING POINTER IS A ONE-CHARACTER
    '' STORE, not a string assignment. Measured:
    ''
    ''   *pz = i    *PZ$0 = (uint8)I$0
    ''   *pw = i    *PW$0 = (uint16)I$0
    ''   *pz = d    *PZ$0 = (uint8)fb_D2I( D$0 )
    ''
    '' -- the ordinary float-to-integer conversion and then a truncation to the
    '' ELEMENT width. Every one of them declined: the string path claimed the
    '' statement because the destination is a string type, and then had no string to
    '' assign. quirk/zwstr-deref.bas writes the six shapes twice over.
    ''
    '' THROUGH A POINTER ONLY. fbc REJECTS the same assignment to a fixed-length
    '' destination -- 'z0 = i' over a 'zstring * 8' is error 181 -- which is what the
    '' zero length distinguishes: an unsized zstring is what a deref yields.
    dim as boolean derefStr = false
    dim as boolean derefWide = false
    '' 'pz[1] = i' IS THE SAME RULE INDEXED. The subscript form and the deref form are
    '' one thing in FreeBASIC -- 'pz[1]' is '*(pz + 1)' -- and both name a single
    '' character of the pointee.
    dim as boolean derefShape = (c.ast->Kind( target ) = Tko.N_DEREF)
    derefShape = derefShape orelse (c.ast->Kind( target ) = Tko.N_INDEX)
    if derefShape then
        dim as Tko.TypeId dtt = c.types->Unqualify( c.info->TypeOf_( target ) )
        if c.types->Kind( dtt ) = Tko.TK_BUILTIN then
            select case c.types->BuiltinOf( dtt )
            case Tko.TY_ZSTRING : derefStr = true
            case Tko.TY_WSTRING : derefStr = true : derefWide = true
            end select
        end if
    end if
    if derefStr then
        dim as Tko.TypeId nvt = c.info->TypeOf_( value )
        dim as boolean nvIsNum = false
        if nvt <> Tko.TYPE_NONE then
            dim as Tko.TypeId nvb = c.types->Unqualify( nvt )
            if c.types->Kind( nvb ) = Tko.TK_BUILTIN then
                select case c.types->BuiltinOf( nvb )
                case Tko.TY_STRING, Tko.TY_ZSTRING, Tko.TY_WSTRING, Tko.TY_USTRING
                case Tko.TY_VOID
                case else
                    nvIsNum = true
                end select
            end if
            if c.types->Kind( nvb ) = Tko.TK_ENUM then nvIsNum = true
        end if
        if nvIsNum then
            dim as MirValue nda = LowerAddr( c, target )
            dim as MirValue nv = LowerExpr( c, value )
            if (nda.kind = cast( ubyte, MV_NONE )) orelse _
               (nv.kind = cast( ubyte, MV_NONE )) then
                SkipHere( c )
                return
            end if
            dim as MirType elemTy = iif( derefWide, MT_I16, MT_I8 )
            '' A FLOAT GOES THROUGH THE 32-BIT CONVERSION FIRST. fbc writes
            '' '(uint8)fb_D2I( D$0 )' and fb_D2I is '(int32)nearbyint( v )', so an
            '' out-of-range double lands on the x86 indefinite value at 32 bits and
            '' is truncated from there. Converting straight to one byte would not.
            if IsFloatTy( cast( MirType, nv.ty ) ) then
                nv = Coerce( c, nv, MT_I32, false )
                if nv.kind = cast( ubyte, MV_NONE ) then
                    SkipHere( c )
                    return
                end if
            end if
            nv = CoerceTy( c, nv, elemTy, nvt)
            if nv.kind = cast( ubyte, MV_NONE ) then
                SkipHere( c )
                return
            end if
            StoreThrough( c, nda, nv )
            return
        end if
    end if

    if (zdk = 1) orelse (zdk = 3) orelse (zdk = 4) then
        dim as MirValue zdst = LowerAddr( c, target )
        if zdst.kind <> cast( ubyte, MV_NONE ) then
            if LowerZstrAssignTo( c, zdst, zdn, value, false, (zdk = 4) ) then return
        end if
        SkipHere( c )
        return
    end if

    '' 'let (a, b) = expr' -- N assignments from the elements of ONE evaluation, not an
    '' assignment of one thing to another. An N_TUPLE target is not an lvalue and has no
    '' address, so the whole statement declined.
    ''
    '' AHEAD OF THE UDT COPY-ASSIGN PATH BELOW, not after it. Check types an N_TUPLE
    '' target as the TUPLE TYPE, so for '(x, y) = p' over an addressable 'p' the
    '' equality test below held, and LowerAddr on an N_TUPLE does not answer MV_NONE --
    '' it MATERIALISES A TEMPORARY out of the targets' current values. The copy-assign
    '' then ran the statement BACKWARDS, assigning p into that temporary:
    ''
    ''     %19 = alloca ptr $tmp4
    ''     %20 = load @x
    ''     %21 = field.addr @$tmp4, 0
    ''     store %21, %20
    ''     %22 = field.addr @$tmp4, 8
    ''     %23 = call.rtl ptr fb_StrAssign(%22, -1, @y, -1, 0)
    ''     call void _ZN9$TUP:6:15aSERKS_(@$tmp4, @p)
    ''
    '' Measured, 'dim p as (long, string)' filled with 1/"one" then '(x, y) = p':
    '' fbc-modern prints 'x= 1 y=one', tiko printed 'x=-99 y=unset' -- the names were
    '' never written and nothing declined to say so. With TWO STRING elements it was
    '' worse than a no-op: $tmp4 gets no constructor call either, so fb_StrAssign into
    '' its uninitialised descriptor is an access violation -- '(u, v) = s' over
    '' 'dim s as (string, string)' exited 127 with no output.
    ''
    '' BOTH conditions had to hold, which is why '(x,y) = (7,"seven")' (right side not
    '' addressable) and '(x,y) = p' over '(long, long)' (nothing needing a let body)
    '' were correct all along and hid this.
    if LowerDestructure( c, target, value ) then return
    '' AND AN N_TUPLE TARGET IS NEVER ANYTHING ELSE. Falling through to the value
    '' path below built a temporary out of the NAMES' CURRENT VALUES and stored the
    '' right side into that -- assigning nothing to any of them, with no decline to
    '' say so. A destructuring this cannot lower is a decline.
    if c.ast->Kind( target ) = Tko.N_TUPLE then
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
            '' THE OVERLOAD THAT TAKES THIS TYPE, not the first one declared. The
            '' chain head is whichever 'operator let' was written first, and a type
            '' may declare only CONVERTING ones -- 'operator let( byval d as double )'
            '' and nothing else. Taking the head unconditionally then called that
            '' operator for 'y = x' and passed the SOURCE OBJECT'S ADDRESS where a
            '' double belonged: 'call void _ZN1VaSEd(@y, @x)'. It lowered, it verified,
            '' and the operator read a pointer as a number.
            ''
            '' fbc does the bitwise copy for that -- '__builtin_memcpy( &Y$0, &X$0, 8 )'
            '' -- so finding no same-type overload here is not a decline: it falls
            '' through to the ordinary aggregate copy below, which is what a UDT with
            '' no assignment operator at all already gets.
            dim as FB.Array( of ulong ) sletT
            sletT.Push( cast( ulong, atl ) )
            dim as Tko.SymbolId ulet = _
                PickCtor( c, StructorOf( c, atl, "let" ), sletT )
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

    '' ...AND A CONVERTING 'operator let' -- 'x = 5' over a type declaring
    '' 'operator let( byval i as integer )'. The two sides are never the same type, so
    '' the equality test above can never reach it and the statement fell through to the
    '' store below, which coerced the scalar to the UDT's OWN type: '%t6 = trunc i64 5
    '' to [0 x i8]'. Verified here, rejected by clang. See LowerUserLetConv_.
    if LowerUserLetConv_( c, target, atl, value ) then return

    '' Same reason as the read: a full-width store into a bitfield's unit would
    '' overwrite every field packed beside it, so it is a read-modify-write.
    '' 't.V = x' OVER A PROPERTY IS A CALL, not a store. Without this it reached the
    '' ordinary store path, which looked for a FIELD of that name, found a procedure and
    '' declined.
    if LowerPropertySet_( c, target, value ) then return

    '' 'x = type( )' -- A BARE TYPE LITERAL, which names no type of its own: it means a
    '' default-constructed temporary of whatever the DESTINATION is. The declaration
    '' form 'dim as T y = type( )' already worked, because there the type is written
    '' one line up; the ASSIGNMENT had nothing to construct and produced nothing.
    ''
    '' Measured, and the temporary is not an implementation detail -- it is observable
    '' through the destructor:
    ''
    ''   _ZN1TC1Ev( &TMP$2$0 );
    ''   __builtin_memcpy( &X$0, &TMP$2$0, 4 );
    ''   _ZN1TD1Ev( &TMP$2$0 );
    ''
    '' -- construct a temporary, copy it in, destroy it. Constructing straight into the
    '' destination would skip that destructor, which structs/temp-var-dtors.bas exists
    '' to count.
    if LowerBareTypeLiteralAssign_( c, target, value ) then return

    if LowerBitfieldStore( c, target, value ) then return

    dim as MirValue addr = LowerAddr( c, target )
    '' A UDT VALUE ASSIGNED TO A SCALAR IS ITS 'operator cast', not its bytes. See
    '' UserConvToScalar_.
    dim as MirValue val
    if UserConvToScalar_( c, value, c.info->TypeOf_( target ), val ) = false then
        val = LowerExpr( c, value )
    end if
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
    '' THE DESTINATION TYPE IS PASSED, not just its MirType. A boolean and a byte are
    '' both MT_I8, and 'x = v' means a COMPARISON when x is a boolean and a truncation
    '' when it is a byte -- CoerceTy cannot tell them apart without this.
    val = CoerceTy( c, val, LowerType( c.info->TypeOf_( target ), *c.types ), _
                    c.info->TypeOf_( value ), c.info->TypeOf_( target ) )
    dim as MirInst ins
    ins.op = cast( ushort, M_STORE )
    ins.ty = cast( ubyte, MT_VOID )
    ins.a = addr
    ins.b = val
    Emit( c, ins )
end sub


declare sub LowerStmtInner( byref c as Ctx, byval id as Tko.NodeId )

'' The assignment and declaration helpers, in their own file at the 1500-line cap.
