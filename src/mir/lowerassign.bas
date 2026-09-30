'' lowerassign.bas -- THE ASSIGNMENT STATEMENT, lowered.
''
'' Split out of lower.bas at the 1500-line cap and included from it in the same place.



'' NOT private any more: the expression call chain moved to lowerintr.bas when this
'' file reached its size limit, and it ends here.





'' -------------------------------------------------------------- statements



'' 'u = ( a, b )' -- A BARE TUPLE LIST ASSIGNED TO A TUPLE VARIABLE.
''
'' THE DESTINATION DECIDES THE TYPE, and the literal's own inferred type is not just
'' unhelpful, it is WRONG: '( Counted( 3 ), 4 )' types its second element INTEGER, so
'' the literal is a 16-byte tuple where '(Counted, long)' is 8. Lowered as itself and
'' stored, that is a 16-byte load into an 8-byte slot -- clang refused the module.
''
'' Measured, fbc builds the temporary AS THE TARGET'S TYPE and assigns it:
''
''     _ZN8FBTUPLE2I7COUNTEDiEC1Ev( &U )
''     _ZN7COUNTEDC1Ei( &TMP2, 3 )
''     memcpy( &TMP3, &TMP2, 4 )                       field 0
''     *(int32*)((uint8*)&TMP3 + 4) = 4                field 1
''     _ZN8FBTUPLE2I7COUNTEDiEaSERKS1_( &U, &TMP3 )    operator let, not a store
''
'' -- note 'i' in the mangled name: the TARGET's LONG, not the literal's INTEGER.
''
'' NOT THE DECLARATION FORM, which has the type written one line up and already
'' worked, and not 'x = type( )', which LowerBareTypeLiteralAssign_ below owns.
private function LowerTupleListAssign_ _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId ) as boolean

    if value = Tko.NODE_NONE then return false
    if c.ast->Kind( value ) <> Tko.N_TUPLE then return false
    if (c.ast->nodes[cast( long, value )].flags and Tko.NF_TYPE_LITERAL) <> 0 then
        return false
    end if
    '' A TUPLE TARGET is destructuring -- 'let (a, b) = e' -- and is handled ahead
    '' of here.
    if c.ast->Kind( target ) = Tko.N_TUPLE then return false

    dim as Tko.TypeId dt = c.types->Unqualify( c.info->TypeOf_( target ) )
    if dt = Tko.TYPE_NONE then return false
    if c.types->Kind( dt ) <> Tko.TK_UDT then return false
    if IsTupleType_( c, dt ) = false then return false
    dim as long sz = SizeOfType( c, dt )
    if sz <= 0 then return false

    dim as MirValue daddr = LowerAddr( c, target )
    if daddr.kind = cast( ubyte, MV_NONE ) then return false

    dim as long tslot = NewTempLocal( c, MT_AGG, sz )
    if tslot < 0 then return false
    dim as MirValue tv
    tv.kind = cast( ubyte, MV_LOCAL )
    tv.ty = cast( ubyte, MT_PTR )
    tv.id = tslot
    if TypeNeedsInit_( c, dt ) then CallImplicitCtor_( c, dt, tv )
    if LowerUdtParenInit_( c, tslot, dt, value ) = false then return false
    if TypeNeedsDtor_( c, dt ) then
        c.udtTemps.Push( cast( ulong, tslot ) )
        c.udtTempTypes.Push( cast( ulong, dt ) )
    end if

    '' ASSIGNED, not stored: a tuple whose half owns something has an 'operator let'
    '' and a raw copy would skip it. The same-type one -- the temp is a dt.
    dim as FB.Array( of ulong ) tletT
    tletT.Push( cast( ulong, dt ) )
    dim as Tko.SymbolId lt = PickCtor( c, StructorOf( c, dt, "let" ), tletT )
    if lt <> Tko.SYMBOL_NONE then
        dim as FB.Array( of ulong ) largs
        largs.Push( cast( ulong, tv.kind ) ) : largs.Push( cast( ulong, tv.id ) )
        EmitStructorCall( c, lt, -1, @daddr, @largs )
        return true
    end if
    if NeedsLetBody_( c, dt ) then
        CallImplicitLet_( c, dt, daddr, tv )
        return true
    end if
    dim as MirValue whole = LowerExprLoad( c, tv, MT_AGG, sz )
    if whole.kind = cast( ubyte, MV_NONE ) then return false
    StoreThrough( c, daddr, whole )
    return true
end function

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

'' A SPAWN FRAME'S ARGUMENT IS PASSED, NOT ASSIGNED. The parser desugars 'spawn f( a )'
'' into '(*frame).__ARG_0 = a', and the field has the PARAMETER's type -- so an argument
'' of another type needs the conversion ARGUMENT PASSING makes, which an assignment does
'' not: fbc refuses 'sc = ch' outright (error 181) and builds a parameter through its
'' converting constructor.
''
'' Measured: 'spawn P( ch )' over 'sub P( byval c as SendChan( of long ) )', with 'ch' a
'' 'Channel( of long )', reached the ordinary store below -- the Channel's bytes copied
'' into the SendChan with no reference taken -- and the frame's 'delete' then released a
'' reference nobody held, freeing the channel under the caller. The next Receive read
'' freed memory: exit 139, where fbc prints 'done'. A direct 'P( ch )' was always right,
'' because a call argument converts. fbc's frame keeps the ARGUMENT's type and its invoke
'' constructs the parameter from it ('U::ctor( &TMP, &THIS->A0 )'); constructing at the
'' spawn instead takes the same references, earlier.
''
'' So a UDT field meeting a value of another type is built as a temporary through the
'' converting constructor -- LowerConvCtorInit_, the 'dim u as U = s' path -- then
'' ASSIGNED as its own type, and the temporary dies with the statement, as in
'' LowerTupleListAssign_ above. ONLY A SPAWN FRAME'S FIELDS: the same assignment written
'' in source is fbc's error 181, not a conversion to make. The frame is recognised by the
'' name the parser gives it, '__tko_spawnframe_<tag>', which no source type can spell.
private function IsSpawnFrameField_ ( byref c as Ctx, byval target as Tko.NodeId ) as boolean
    if c.ast->Kind( target ) <> Tko.N_MEMBER then return false
    dim as Tko.BinaryPayload ptr bp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, target )].data )]
    dim as Tko.TypeId ft = c.info->TypeOf_( bp->lhs )
    if ft = Tko.TYPE_NONE then return false
    ft = c.types->Unqualify( ft )
    if c.types->Kind( ft ) <> Tko.TK_UDT then return false
    dim as string nm = Tko.Text.LowerAscii( c.names->Spelling( c.types->NameOf( ft ) ) )
    return (left( nm, 17 ) = "__tko_spawnframe_")
end function

private function LowerSpawnArgAssign_ _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId ) as boolean

    if value = Tko.NODE_NONE then return false
    if IsSpawnFrameField_( c, target ) = false then return false
    dim as Tko.TypeId dt = c.types->Unqualify( c.info->TypeOf_( target ) )
    if dt = Tko.TYPE_NONE then return false
    if c.types->Kind( dt ) <> Tko.TK_UDT then return false
    dim as Tko.TypeId vt = c.info->TypeOf_( value )
    if vt = Tko.TYPE_NONE then return false
    vt = c.types->Unqualify( vt )
    if c.types->Kind( vt ) = Tko.TK_REFERENCE then vt = c.types->Unqualify( c.types->Inner( vt ) )
    '' The same type is a COPY, and a derived object is the base subobject: both are the
    '' ordinary path's.
    if vt = dt then return false
    '' SETTLED BEFORE ANYTHING IS EMITTED -- a decline that has already made a temporary
    '' does not look like one.
    if c.types->Kind( vt ) = Tko.TK_UDT then
        if c.types->BaseDistance( vt, dt ) >= 0 then return false
        if HasUdtConvCtor_( c, dt, vt ) = false then return false
    else
        dim as FB.Array( of ulong ) argT
        argT.Push( cast( ulong, vt ) )
        if PickCtor( c, StructorOf( c, dt, "__ctor" ), argT ) = Tko.SYMBOL_NONE then return false
    end if
    dim as long sz = SizeOfType( c, dt )
    if sz <= 0 then return false

    dim as MirValue daddr = LowerAddr( c, target )
    if daddr.kind = cast( ubyte, MV_NONE ) then return false
    dim as long tslot = NewTempLocal( c, MT_AGG, sz )
    if tslot < 0 then return false
    if LowerConvCtorInit_( c, tslot, dt, value, 0 ) = false then return false
    if TypeNeedsDtor_( c, dt ) then
        c.udtTemps.Push( cast( ulong, tslot ) )
        c.udtTempTypes.Push( cast( ulong, dt ) )
    end if
    dim as MirValue tv
    tv.kind = cast( ubyte, MV_LOCAL )
    tv.ty = cast( ubyte, MT_PTR )
    tv.id = tslot

    '' ASSIGNED AS ITS OWN TYPE, as LowerTupleListAssign_ does it.
    dim as FB.Array( of ulong ) letT
    letT.Push( cast( ulong, dt ) )
    dim as Tko.SymbolId lt = PickCtor( c, StructorOf( c, dt, "let" ), letT )
    if lt <> Tko.SYMBOL_NONE then
        dim as FB.Array( of ulong ) largs
        largs.Push( cast( ulong, tv.kind ) ) : largs.Push( cast( ulong, tv.id ) )
        EmitStructorCall( c, lt, -1, @daddr, @largs )
        return true
    end if
    if NeedsLetBody_( c, dt ) then
        CallImplicitLet_( c, dt, daddr, tv )
        return true
    end if
    dim as MirValue whole = LowerExprLoad( c, tv, MT_AGG, sz )
    if whole.kind = cast( ubyte, MV_NONE ) then return false
    StoreThrough( c, daddr, whole )
    return true
end function

private sub LowerAssign _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId )

    if AssignArrayResult_( c, target, value ) then return   '' lowerarrret.bas
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
    '' A FRAME VARIABLE BY SLOT; ANY OTHER TARGET BY ADDRESS -- a shared or static
    '' variable, a parameter, a FIELD and an ELEMENT alike. The field and element forms
    '' did not decline, as this once said: they fell to the plain store, which stored
    '' the literal's own INTEGER bits into single fields -- 'arr( 1 ) = type( 5, 6, 7 )'
    '' read back 7.0e-45 where fbc prints 5, and so did 'ns.v = type( ... )'.
    dim as Tko.NodeKind tlk = c.ast->Kind( target )
    dim as boolean tlTarget = (tlk = Tko.N_IDENT) orelse (tlk = Tko.N_MEMBER)
    if tlTarget = false then tlTarget = IsArrayIndex( c, target )
    if tlTarget then
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
                '' ONLY A FRAME VARIABLE HAS A SLOT. LocalFor MAKES one for any symbol it
                '' is handed, so a SHARED 'eyepoint = type( 512, 384, 800 )' filled a
                '' fresh local nobody reads and left the global zero -- starshine.bas's
                '' planet collapsed to the origin -- and over a BYREF parameter the
                '' fields were written across the reference itself: a segfault. Those,
                '' statics and every parameter are addressed instead; fbc writes the
                '' fields through the address the same way, '*(float*)&SH$ = ...'.
                dim as Tko.SymbolId tlsid = c.info->RefOf( target )
                dim as Tko.Symbol ptr tls = c.syms->SymbolAt( tlsid )
                dim as boolean frameVar = (tls <> 0) andalso (tlk = Tko.N_IDENT)
                if frameVar then frameVar = (tls->kind = cast( ubyte, Tko.SYM_VARIABLE ))
                if frameVar then frameVar = (IsSharedVar( c, tlsid ) = false)
                if frameVar then frameVar = (IsStaticLocal( c, tlsid ) = false)
                if frameVar then
                    dim as long tlslot = LocalFor( c, tlsid )
                    if tlslot >= 0 then
                        if LowerUdtParenInit_( c, tlslot, tlt, value ) then return
                    end if
                else
                    dim as MirValue tlda = LowerAddr( c, target )
                    if tlda.kind <> cast( ubyte, MV_NONE ) then
                        if LowerUdtParenInit_( c, -1, tlt, value, @tlda ) then return
                    end if
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
    '' 'this = o' IS AN ASSIGNMENT TO THE OBJECT, and 'this' is a POINTER: its
    '' symbol's type is Pointer_( owner ), so the same-type test below compared a
    '' pointer against a UDT, never matched, and the statement fell to the generic
    '' store -- where CoerceTy answers nothing for an aggregate and Emit dropped it.
    '' 'constructor P( byref o as P ) : this = o : end constructor' copied NOTHING,
    '' silently: one statement not lowered and a zeroed object.
    dim as MirValue thisDst
    if c.ast->Kind( target ) = Tko.N_IDENT then
        if c.types->Kind( c.types->Unqualify( atl ) ) = Tko.TK_POINTER then
            dim as Tko.IdentPayload ptr tip = _
                @c.ast->idents[cast( long, c.ast->nodes[cast( long, target )].data )]
            if tip->name = c.names->Fold( c.names->GetString( "this" ) ) then
                dim as Tko.TypeId pin2 = c.types->Inner( c.types->Unqualify( atl ) )
                if pin2 <> Tko.TYPE_NONE then
                    if c.types->Kind( c.types->Unqualify( pin2 ) ) = Tko.TK_UDT then
                        '' THIS HOLDS A POINTER, so the destination is its VALUE.
                        dim as Tko.TypeId ot = c.types->Unqualify( pin2 )
                        if ot = c.types->Unqualify( c.info->TypeOf_( value ) ) then
                            dim as MirValue tsa = LowerAddr( c, target )
                            dim as MirValue ssa = LowerAddr( c, value )
                            if (tsa.kind <> cast( ubyte, MV_NONE )) andalso _
                               (ssa.kind <> cast( ubyte, MV_NONE )) then
                                thisDst = LowerExprLoad( c, tsa, MT_PTR )
                                if thisDst.kind <> cast( ubyte, MV_NONE ) then
                                    dim as FB.Array( of ulong ) tlT
                                    tlT.Push( cast( ulong, ot ) )
                                    dim as Tko.SymbolId tlet = _
                                        PickCtor( c, StructorOf( c, ot, "let" ), tlT )
                                    if tlet <> Tko.SYMBOL_NONE then
                                        dim as FB.Array( of ulong ) tla
                                        tla.Push( cast( ulong, ssa.kind ) )
                                        tla.Push( cast( ulong, ssa.id ) )
                                        EmitStructorCall( c, tlet, -1, @thisDst, @tla )
                                    elseif NeedsLetBody_( c, ot ) then
                                        CallImplicitLet_( c, ot, thisDst, ssa )
                                    else
                                        '' fbc's answer for a type with no
                                        '' assignment operator is the bitwise copy.
                                        dim as MirValue sv2 = _
                                            LowerExprLoad( c, ssa, MT_AGG, SizeOfType( c, ot ) )
                                        if sv2.kind = cast( ubyte, MV_NONE ) then
                                            SkipHere( c )
                                            return
                                        end if
                                        StoreThrough( c, thisDst, sv2 )
                                    end if
                                    return
                                end if
                            end if
                        else
                            '' ...AND A VALUE OF ANOTHER TYPE IS A CONVERTING 'operator let' on
                            '' the object -- 'this = dtSrc' over 'let( byval as DATE_ )' (fbx's
                            '' COleDateTime). The object is where the slot of 'this' points,
                            '' which is how LowerUserLetConv_ reads a result slot. Never the
                            '' plain store below, which wrote the value over the pointer.
                            dim as MirValue tsl = LowerAddr( c, target )
                            if tsl.kind = cast( ubyte, MV_LOCAL ) then
                                if LowerUserLetConv_( c, target, ot, value, tsl.id, false ) then return
                            end if
                            SkipHere( c )
                            return
                        end if
                    end if
                end if
            end if
        end if
    end if
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

    '' ...AND AN UPCAST IS THIS TOO. 'd = v' where v's type DERIVES from d's is a
    '' copy of the base subobject, and the base subobject is at offset zero -- so
    '' every question below is asked of the DESTINATION type and the source address
    '' needs no adjustment. The exact-equality test sent it past this block to the
    '' ordinary aggregate store, which is a BITWISE copy: over a base owning a
    '' string, the two objects were left sharing one buffer and both destructors
    '' freed it -- 0xC0000374 after printing the right answer.
    ''
    '' fbc emits '_ZN1AC1Ev( &D8 ); _ZN1AaSERKS_( &D8, (A*)&V )' for exactly this,
    '' which is the default constructor and then the implicit LET below.
    ''
    '' ...AND A CALL CHECK LEFT UNTYPED is its binding's result. 'c = mk( a +
    '' " 2028" )' over a DWSTRING had no type on the right, so it missed this block and
    '' reached the aggregate store: the result's bytes over c and that temporary destroyed
    '' -- c's own buffer leaked, the new one freed twice, 0xC0000374. fbc calls the
    '' operator, 'vr$10 = MK( &TMP$9541$1, TMP$9543$1 ); _ZN7AFXNOVA8DWSTRINGaSERS0_( &C$1,
    '' vr$10 )', and destroys the temporary after. See UntypedCallResult_.
    '' A UDT-TYPED PROPERTY IS A CALL TOO, and the same-type LET below would claim it:
    '' 'pRegExp.Pattern = dwsMatch' over a getter 'as DWSTRING' took the target's address
    '' -- the GETTER'S CODE -- and ran DWSTRING's 'operator let' over it. AfxNova's
    '' DWStrRemove died there, in every tracks date function.
    if (atl <> Tko.TYPE_NONE) andalso (c.ast->Kind( target ) = Tko.N_MEMBER) then
        if c.types->Kind( atl ) = Tko.TK_UDT then
            if LowerPropertySet_( c, target, value ) then return
        end if
    end if
    dim as Tko.TypeId avt = c.info->TypeOf_( value )
    if avt = Tko.TYPE_NONE then avt = UntypedCallResult_( c, value )
    dim as boolean atlUpcast = false
    if atl <> Tko.TYPE_NONE then
        atlUpcast = IsBaseOf_( c, atl, avt )
    end if
    if (atl <> Tko.TYPE_NONE) andalso _
       ((atl = avt) orelse atlUpcast) then
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
                '' A PAREN-LESS FUNCTION ON THE RIGHT IS A CALL, not an address.
                '' 'wst = pStream.ReadLine' over 'function ReadLine( ) as DWSTRING'
                '' asked LowerAddr for the value's address, and a node that names a
                '' PROCEDURE has one -- the procedure's:
                ''
                ''     %8 = func.addr ptr _ZN1S8READLINEEv
                ''     call void _ZN7AFXNOVA8DWSTRINGaSERS0_(@wst, %8)
                ''
                '' -- so 'operator let' was handed the function's MACHINE CODE as its
                '' source DWSTRING. It verified, and tiko-editor died at the next
                '' allocation. fbc calls it: 'vr$5 = READLINE( &TMP, &STRM );
                '' _ZN..aSERS0_( &WST, vr$5 )'.
                ''
                '' ONLY THIS SPELLING WAS WRONG, which is what says where the fix
                '' goes: 'dim as DWSTRING w = strm.ReadLine' already worked, and so
                '' did both forms written with '( )'. LowerBareProcCall_ is what the
                '' initialiser path uses and it declines anything that is not a
                '' FUNCTION with every parameter defaulted, so a procedure-pointer
                '' assignment still reaches LowerAddr below.
                dim as MirValue sa
                if LowerBareProcCall_( c, value, MT_PTR, sa ) = false then
                    sa = LowerAddr( c, value )
                end if
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
    if LowerSpawnArgAssign_( c, target, value ) then return
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
    '' A BARE TUPLE LIST TAKES THE DESTINATION'S TYPE -- see LowerTupleListAssign_.
    if LowerTupleListAssign_( c, target, value ) then return

    if LowerBareTypeLiteralAssign_( c, target, value ) then return

    if LowerBitfieldStore( c, target, value ) then return

    dim as MirValue addr = LowerAddr( c, target )
    '' A UDT VALUE ASSIGNED TO A SCALAR IS ITS 'operator cast', not its bytes. See
    '' UserConvToScalar_.
    dim as MirValue val
    '' ...AND A UDT VALUE ASSIGNED TO ANOTHER UDT IS ONE TOO -- see UdtCastValue_.
    if UserConvToScalar_( c, value, c.info->TypeOf_( target ), val ) = false then
        if UdtCastValue_( c, value, c.info->TypeOf_( target ), val ) = false then
            val = LowerExpr( c, value )
        end if
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
    '' ...AND THROUGH A CONVERSION-FREE CAST, TO THE OPERAND'S. 'cast( LPARAM, pItem ) = lPrm'
    '' stores into pItem itself -- measured, 'PITEM = (HWND*)LPRM' -- so the integer the cast's
    '' type made is bitcast once more to the pointer slot it lands in.
    dim as Tko.NodeId ncop = NoConvOperand_( c, target )
    if ncop <> Tko.NODE_NONE then
        dim as Tko.TypeId nct = c.types->Unqualify( c.info->TypeOf_( ncop ) )
        if c.types->Kind( nct ) = Tko.TK_REFERENCE then nct = c.types->Inner( nct )
        val = CoerceTy( c, val, LowerType( nct, *c.types ), c.info->TypeOf_( target ), nct )
    end if
    dim as MirInst ins
    ins.op = cast( ushort, M_STORE )
    ins.ty = cast( ubyte, MT_VOID )
    ins.a = addr
    ins.b = val
    Emit( c, ins )
end sub


declare sub LowerStmtInner( byref c as Ctx, byval id as Tko.NodeId )

'' The assignment and declaration helpers, in their own file at the 1500-line cap.
