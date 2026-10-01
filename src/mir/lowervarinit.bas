'' lowervarinit.bas -- lowering a 'dim' (N_VAR): its items, their storage and their
'' initialisers. MOVED OUT OF lower.bas's LowerStmtAt_ at the 1500-line cap, as one
'' procedure; INCLUDED from the end of lower.bas, so every helper it calls is the one it
'' called before. The only early 'return' (a REDIM) left LowerStmtAt_ from the last arm
'' of its 'select', so returning from here is the same thing. Nothing else changed.

declare sub LowerVarItem_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval item as Tko.NodeId, _
      byval isByrefLocal as boolean )
declare sub LowerCollInit_( byref c as Ctx, byval id as Tko.NodeId, byval item as Tko.NodeId )

sub LowerVarDecl_( byref c as Ctx, byval id as Tko.NodeId )
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    if sp->op = cast( ushort, Tko.KW_REDIM ) then
        if LowerRedim( c, id, sp ) = false then SkipHere( c )
        return
    end if
    '' 'dim BYREF rb as integer = a' ALIASES a, and its slot holds a POINTER --
    '' the same shape a byref PARAMETER has. Resolve types it as a REFERENCE, so
    '' the slot lowers to a pointer and AddrOfVar loads it; every read, every write
    '' and every '@' of the alias then goes through the indirection, because all of
    '' them ask that one function.
    ''
    '' What is left here is the DECLARATION: it stores the referent's ADDRESS, not
    '' its value. fbc writes 'int64* RB$0; RB$0 = &A$0;'.
    ''
    '' This used to decline, and the decline was the right answer at the time:
    '' parsing BYREF had turned a statement that silently vanished into one that
    '' silently ALIASED NOTHING -- 'rb = 5' then 'print a' gives 5 under fbc and
    '' would have given 1 here.
    dim as boolean isByrefLocal = _
        ((c.ast->nodes[cast( long, id )].flags and Tko.NF_BYREF) <> 0)
    '' EACH DECLARATOR IS A STATEMENT OF ITS OWN for its temporaries. Measured, fbc's
    '' 'dim as long x1 = takeR( mkH( 6 ) ), y1 = cnt( )' has destroyed the first
    '' declarator's temporary before the second one's initialiser runs.
    dim as long vmark = c.udtTemps.Count
    for i as long = 0 to sp->count - 1
        ReleaseUdtTemps_( c, vmark )
        dim as Tko.NodeId item = cast( Tko.NodeId, c.ast->children[sp->first + i] )
        LowerVarItem_( c, id, item, isByrefLocal )
        LowerCollInit_( c, id, item )   '' 'dim a as Array( of integer ) = { 1, 2 }'
    next
end sub

'' ONE DECLARATOR, split out of the loop above so that a collection initialiser's calls run
'' after it whichever way it finished: every 'return' here was a 'continue for'.
sub LowerVarItem_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval item as Tko.NodeId, _
      byval isByrefLocal as boolean )
    if c.ast->Kind( item ) <> Tko.N_VAR_ITEM then return
    dim as Tko.StmtPayload ptr ip = StmtOf( c, item )
    '' The VARIABLE, not a type name that happens to share the spelling.
    dim as Tko.SymbolId sid = Tko.SYMBOL_NONE
    if (c.ast->nodes[cast( long, item )].flags and Tko.NF_QUALIFIED) = 0 then
        sid = c.syms->LookupLocalTyped( c.info->ScopeOf( id ), ip->name, false )
    end if
    '' 'dim shared T.x as integer = 2' DEFINES a static member, looked up
    '' through its OWNER. See StaticMemberSym_.
    if (c.ast->nodes[cast( long, item )].flags and Tko.NF_QUALIFIED) <> 0 then
        sid = StaticMemberSym_( c, id, item )
    end if
    if sid = Tko.SYMBOL_NONE then
        SkipHere( c )
        return
    end if
    '' DIM SHARED is STORAGE, not code. fbc emits 'static int32 H$ = 5;' --
    '' the initialiser belongs to the definition and is not a store executed
    '' anywhere -- so the declaration records the initial value and emits
    '' nothing.
    ''
    '' A shared string also gets NO cleanup: fbc emits no fb_StrDelete for one,
    '' anywhere. Registering one here would release module storage at the end of
    '' whichever scope happened to declare it.
    '' A STATIC local takes the same route: module lifetime, a compile-time
    '' initialiser rather than a store on entry, and no cleanup registered.
    dim as boolean inModule = IsSharedVar( c, sid )
    if IsStaticLocal( c, sid ) then inModule = true
    if inModule then
        '' A SHARED OR STATIC ALIAS is module storage holding an address, and
        '' fbc initialises it statically -- 'int64* RG$ = &G$;'. A MIR global
        '' carries an integer, a float or a byte image, none of which is a
        '' RELOCATION, so the address is stored where the declaration is
        '' instead. Same value: the referent is module storage too, so its
        '' address is the same on every pass through this line.
        if isByrefLocal then
            if BindAliasStorage( c, sid, ip->b, true ) = false then
                SkipHere( c )
                c.st->varByref += 1
            end if
            return
        end if
        '' A STATIC LOCAL OBJECT is constructed LAZILY, where it is declared:
        '' a guard flag, the constructor and an atexit thunk. Module storage
        '' with no code run on it left a string field's descriptor
        '' uninitialised for the life of the program.
        if IsStaticLocal( c, sid ) then
            if LowerStaticLocalInit_( c, sid, ip->b ) then return
        end if
        InitSharedGlobal( c, sid, ip->b )
        return
    end if

    dim as long slot = LocalFor( c, sid )

    '' THE ALIAS ITSELF: store the referent's ADDRESS in the slot and stop. No
    '' construction, no cleanup and no initialiser store -- the alias owns
    '' nothing, and the thing it names was declared somewhere else.
    if isByrefLocal then
        if BindAliasStorage( c, sid, ip->b, false ) = false then
            SkipHere( c )
            c.st->varByref += 1
        end if
        return
    end if

    '' A UDT local is CONSTRUCTED where it is declared and DESTROYED at the
    '' end of its scope. The destructor is registered into the same cleanup
    '' list the defers use, so the measured order -- reverse registration,
    '' interleaved with defers, innermost scope first on an early exit --
    '' applies to it without any extra arrangement.
    dim as Tko.Symbol ptr vs = c.syms->SymbolAt( sid )
    dim as boolean constructed = false
    dim as boolean strInited = false

    '' EVERY LOCAL WITH NO INITIALISER IS ZEROED, and none of them were.
    ''
    '' Measured, fbc emits one memset per uninitialised local and NONE for a
    '' local that has an initialiser or is STATIC:
    ''
    ''     int32 A$1;   __builtin_memset( &A$1, 0, 4ll );
    ''     int32 B$1;   B$1 = 5;                    '' no memset
    ''     static int32 S$1;                        '' no memset, .bss
    ''     struct $3POD U$1;  __builtin_memset( &U$1, 0, 8ll );
    ''     int32 ARR$1[4];    __builtin_memset( ARR$1, 0, 16ll );
    ''     FBSTRING S$1;      __builtin_memset( &S$1, 0, 24ll );
    ''
    '' tiko emitted nothing at all, so a local read before assignment saw
    '' whatever the frame held. Measured on a probe that dirties the stack
    '' first: fbc prints 0 and 0 where tiko printed -559038737 and
    '' 16045690984833335023. It is the widest silent-wrongness class the
    '' run-stage scan found -- a null-pointer test on an uninitialised
    '' pointer field is what tests/vendor/fbc-tests/generics/recursive-generic.bas
    '' fails on, and it is not a generics fault at all.
    ''
    '' BEFORE EVERYTHING ELSE, which is where fbc puts it: a constructor, a
    '' descriptor setup or an initialiser store all run over the zeroed
    '' bytes. Zeroing on top of a synthesised constructor that memsets too
    '' is redundant and harmless; zeroing AFTER one would undo it.
    '' ...AND NOT WHERE A CONSTRUCTOR WILL RUN, which is also measured. fbc
    '' emits NO memset for a UDT local whose constructor runs, because the
    '' constructor memsets THIS itself:
    ''
    ''     void _ZN8WITHCTORC1Ev( struct $8WITHCTOR* THIS$1 )
    ''     { __builtin_memset( (int32*)THIS$1, 0, 4ll ); *(int32*)THIS$1 = 3; }
    ''     void P( void ) { struct $8WITHCTOR W$1; _ZN8WITHCTORC1Ev( &W$1 ); }
    ''
    '' A DYNAMIC ARRAY is left alone for the same reason: its slot is a
    '' DESCRIPTOR and InitDynArrayDesc writes every field of it.
    dim as boolean zSkip = false
    if (slot >= 0) andalso (vs <> 0) then
        if c.types->IsDynArray( vs->type_ ) then zSkip = true
        if c.types->Kind( vs->type_ ) = Tko.TK_UDT then
            if TypeNeedsInit_( c, vs->type_ ) then zSkip = true
            if StructorWithArity( c, _
                StructorOf( c, vs->type_, "__ctor" ), 0 ) <> Tko.SYMBOL_NONE then
                zSkip = true
            end if
        end if
    end if
    dim as boolean zWant = (slot >= 0)
    if zWant then zWant = (vs <> 0)
    if zWant then zWant = (ip->b = Tko.NODE_NONE)
    if zWant then zWant = (zSkip = false)
    if zWant then
        dim as long zsz = SizeOfType( c, vs->type_ )
        if zsz > 0 then
            dim as MirValue zva
            zva.kind = cast( ubyte, MV_LOCAL )
            zva.ty = cast( ubyte, MT_PTR )
            zva.id = slot
            dim as FB.Array( of ulong ) zargs
            zargs.Push( cast( ulong, zva.kind ) )
            zargs.Push( cast( ulong, zva.id ) )
            zargs.Push( cast( ulong, MV_CONST_INT ) ) : zargs.Push( 0 )
            zargs.Push( cast( ulong, MV_CONST_INT ) )
            zargs.Push( cast( ulong, zsz ) )
            EmitRtl( c, RTL_MEMSET, zargs )
        end if
    end if

    '' A DYNAMIC array's slot holds a DESCRIPTOR, which has to be filled in
    '' before anything can redim or erase it, and erased on the way out --
    '' fbc erases every local dynamic array at scope exit whatever its element
    '' type. Registered as cleanup node 1, which the cleanup emitter reads as
    '' 'erase this array slot'.
    if (slot >= 0) andalso (vs <> 0) then
        if c.types->IsDynArray( vs->type_ ) then
            dim as MirValue dd
            dd.kind = cast( ubyte, MV_LOCAL )
            dd.ty = cast( ubyte, MT_PTR )
            dd.id = slot
            InitDynArrayDesc( c, dd, vs->type_ )
            c.cleanupNode.Push( CLEANUP_ERASE_ARRAY )
            c.cleanupSlot.Push( slot )
            c.cleanupType.Push( 0 )
            '' ...AND ITS BOUNDS, when it has any. 'dim a( 1 to n )' with a
            '' bound that is not a constant is a DYNAMIC array, and fbc
            '' follows the descriptor setup with an fb_ArrayRedimEx that
            '' allocates it. Only the setup was emitted, so DATA stayed NULL
            '' and the first element store wrote through it -- which is where
            '' fbcunit's check_internal_state faulted, on its own local
            '' 'dim test_suite_index( 1 to fbcu_tests_count )'.
            ''
            '' 'dim a()' and 'dim a( any )' have no bounds to apply and are
            '' declined inside EmitArrayBounds, exactly as the REDIM form is.
            if (ip->c <> Tko.NODE_NONE) andalso _
               (AnyDimCount( c, ip ) = 0) then
                if EmitArrayBounds( c, dd, vs->type_, ip, false ) = false then
                    SkipHere( c )
                end if
            end if
        end if
    end if

    '' A FIXED ARRAY OF VAR-LENGTH STRINGS. Every element is a descriptor the
    '' runtime owns, and neither end of its life was being lowered: the array
    '' was never zeroed, so the first 'a(i) = x' handed fb_StrAssign a garbage
    '' descriptor to RELEASE, and nothing destructed it, so every buffer it did
    '' end up holding leaked. Both halves are measured --
    ''
    ''   __builtin_memset( (FBSTRING*)S$0, 0, 48ll );
    ''   ...
    ''   fb_ArrayDestructStr( (struct $7FBARRAYIvE*)&tmp$2$0 );
    ''
    '' -- and the UTF-16 flavour takes fb_ArrayDestructUStr instead.
    if (slot >= 0) andalso (vs <> 0) then
        if IsFixedStrArray_( c, vs->type_ ) then
            dim as MirValue za
            za.kind = cast( ubyte, MV_LOCAL )
            za.ty = cast( ubyte, MT_PTR )
            za.id = slot
            dim as FB.Array( of ulong ) zma
            zma.Push( cast( ulong, za.kind ) )
            zma.Push( cast( ulong, za.id ) )
            zma.Push( cast( ulong, MV_CONST_INT ) ) : zma.Push( 0 )
            zma.Push( cast( ulong, MV_CONST_INT ) )
            zma.Push( cast( ulong, SizeOfType( c, vs->type_ ) ) )
            EmitRtl( c, RTL_MEMSET, zma )
            c.cleanupNode.Push( CLEANUP_DESTRUCT_STR_ARRAY )
            c.cleanupSlot.Push( slot )
            c.cleanupType.Push( cast( ulong, vs->type_ ) )
        end if
    end if

    if (slot >= 0) andalso (vs <> 0) then
        '' 'dim as T x = T( 5 )' selects a constructor by its arguments; a
        '' bare 'dim as T x' takes the no-argument one.
        '' 'dim as T y = x' OVER THE SAME TYPE IS THE COPY CONSTRUCTOR.
        '' Without it the initialiser was a whole-aggregate load and store, so
        '' a type holding a string ended with two objects owning one buffer --
        '' and both were released at scope exit. fbc emits
        '' '_ZN1TC1ERKS_( &Y, &X )' and nothing else: no default constructor
        '' call and no copy of the bytes.
        '' A TYPE LITERAL IS A CONSTRUCTOR CALL, NOT A COPY SOURCE.
        '' 'dim as T x = type<T>( 123 )' has T's own type, so it reached the
        '' copy path, which took its ADDRESS and passed that as the argument:
        '' '_ZN7CTORUDTC1Ei( @a, @$tmp2 )' where 123 belonged. Its children are
        '' the constructor's arguments and LowerCtorInit below takes them.
        '' A CONSTRUCTOR CALL IS NOT A COPY SOURCE EITHER. 'dim a as T = T( 3 )'
        '' now has the type T on its initialiser -- it did not before -- so it
        '' reached the copy path, which built a TEMPORARY, constructed into
        '' that, and then copy-constructed 'a' from it. fbc constructs 'a'
        '' directly, and LowerCtorInit below does the same.
        dim as boolean initIsLiteral = false
        if ip->b <> Tko.NODE_NONE then
            if c.ast->Kind( ip->b ) = Tko.N_TUPLE then
                initIsLiteral = _
                    ((c.ast->nodes[cast( long, ip->b )].flags and _
                      Tko.NF_TYPE_LITERAL) <> 0)
            elseif c.ast->Kind( ip->b ) = Tko.N_CALL then
                initIsLiteral = _
                    (TypeCtorTypeOf_( c, ip->b ) <> Tko.TYPE_NONE)
            end if
        end if
        if (ip->b <> Tko.NODE_NONE) andalso (initIsLiteral = false) then
            dim as Tko.TypeId ivt = InitSourceType_( c, ip->b )   '' 'this' is its pointee
            '' ...AND A CALL CHECK LEFT UNTYPED is its binding's result:
            '' 'mk( a + " 2027" )' over a DWSTRING. See UntypedCallResult_.
            if ivt = Tko.TYPE_NONE then ivt = UntypedCallResult_( c, ip->b )
            '' ...AND AN UPCAST IS A COPY OF THE BASE SUBOBJECT, which sits at
            '' offset zero -- so the source address needs no adjustment and
            '' every question below is asked of the DESTINATION type. The
            '' exact-equality test sent 'dim d as A = <a B>' past this block
            '' to UpcastAggInit_, which is a BITWISE base-slice copy: over a
            '' base owning a string the two objects were left sharing one
            '' buffer and both destructors freed it -- 0xC0000374 after
            '' printing the right answer. Measured, fbc copy-constructs and
            '' default-constructs nothing: '_ZN1AC1ERKS_( &D6, (A*)vr )'.
            ''
            '' UpcastAggInit_ is not wrong -- it exists for the SIZE problem,
            '' clang refusing a 56-byte store into a 32-byte slot -- it was
            '' simply being reached for types a bitwise copy cannot serve.
            dim as boolean ivtUpcast = false
            if (ivt <> Tko.TYPE_NONE) andalso (vs->type_ <> Tko.TYPE_NONE) then
                ivtUpcast = IsBaseOf_( c, vs->type_, ivt )
            end if
            if (ivt <> Tko.TYPE_NONE) andalso _
               ((ivt = vs->type_) orelse ivtUpcast) andalso _
               (c.types->Kind( ivt ) = Tko.TK_UDT) then
                '' THE DESTINATION'S TYPE, not the source's: an upcast copies
                '' with the BASE's copy constructor.
                dim as Tko.TypeId dvt = vs->type_
                '' AND ITS PARAMETER MUST BE THE TYPE ITSELF. StructorWithArity
                '' answers ANY one-argument constructor, so a type declaring
                '' 'constructor( byval n as long )' and nothing else had that
                '' one picked as its copy constructor -- and was handed an
                '' ADDRESS where a long belonged.
                dim as Tko.SymbolId ucp = CopyCtorOf_( c, dvt )
                '' A FUNCTION RESULT IS ALREADY A TEMPORARY, so it is MOVED
                '' and not copied. fbc hands the callee the destination and
                '' the object is built there once -- 'F( &T$1 )' with no copy
                '' at the call site at all. Routing one through the implicit
                '' copy instead took the returned descriptor into a temporary,
                '' deep-copied THAT into the destination, and never erased the
                '' temporary: a LEAK where the plain store was already right.
                dim as boolean initIsCall = IsCallResult_( c, ip->b )
                '' ...and ONLY for a type carrying a dynamic array, which is
                '' the set this path newly reaches. A type that wanted the
                '' implicit copy BEFORE -- one holding a var-length string,
                '' say -- still gets it from a call, because a plain store
                '' would alias its buffer exactly the way it would here. The
                '' array case has no such history to preserve: its store was
                '' the move all along.
                dim as boolean wantImplCopy = NeedsLetBody_( c, dvt )
                '' ...NOT A BYREF RESULT, which is somebody else's object: 'dim as
                '' TdbDatabase db2 = back.Value( )' aliased it, freed twice.
                if initIsCall andalso HasDynArrayMember_( c, dvt ) andalso (CallReturnsByref_( c, ip->b ) = false) then
                    wantImplCopy = false
                end if
                '' A HIDDEN-POINTER RESULT IS BUILT IN THE VARIABLE: no default
                '' constructor, no temporary, no copy -- see SretInPlaceInit_.
                if (ivt = vs->type_) andalso SretInPlaceInit_( c, slot, dvt, ip->b ) then
                    constructed = true
                elseif (ucp <> Tko.SYMBOL_NONE) orelse wantImplCopy then
                    dim as MirValue dsa
                    dsa.kind = cast( ubyte, MV_LOCAL )
                    dsa.ty = cast( ubyte, MT_PTR )
                    dsa.id = slot
                    '' WHAT THE INITIALISER REGISTERS FOR DESTRUCTION has to
                    '' be known before it is lowered -- see DropMovedTemp_.
                    dim as long cmark = c.udtTemps.Count
                    dim as MirValue ssa = InitSourceAddr_( c, ip->b )
                    '' A CALL'S HIDDEN-POINTER TEMPORARY IS MOVED, NOT
                    '' COPIED. 'dim as C r = f( )' built the result in a
                    '' temporary, COPY-CONSTRUCTED r out of it and destroyed
                    '' the temporary -- one copy and one destructor more
                    '' than fbc, which hands the callee the destination and
                    '' builds the object there once. The temporary is an
                    '' rvalue nobody else can reach, so adopting its bytes
                    '' and unregistering it gives the same counts.
                    ''
                    '' ONLY A TEMPORARY THIS EXPRESSION JUST REGISTERED. A
                    '' BYREF-returning call hands back somebody else's
                    '' object and registers nothing, so it still copies.
                    '' NOT FOR AN UPCAST. Adopting the temporary's bytes is
                    '' only a move when the two are the SAME object; for a
                    '' base slice fbc still copy-constructs and THEN destroys
                    '' the temporary, so it has to stay registered.
                    dim as boolean movedRes = false
                    if (c.ast->Kind( ip->b ) = Tko.N_CALL) andalso _
                       (ivt = vs->type_) andalso _
                       (ssa.kind = cast( ubyte, MV_LOCAL )) then
                        for k as long = cmark to c.udtTemps.Count - 1
                            if cast( long, c.udtTemps[k] ) = ssa.id then
                                movedRes = true
                                exit for
                            end if
                        next
                    end if
                    if movedRes then
                        dim as long msz = SizeOfType( c, dvt )
                        dim as MirValue mv
                        if msz > 0 then mv = LowerExprLoad( c, ssa, MT_AGG, msz )
                        if mv.kind <> cast( ubyte, MV_NONE ) then
                            StoreThrough( c, dsa, mv )
                            ForgetUdtTemp_( c, ssa.id )
                            constructed = true
                        end if
                    end if
                    if (movedRes = false) andalso _
                       (ssa.kind <> cast( ubyte, MV_NONE )) then
                        if ucp <> Tko.SYMBOL_NONE then
                            dim as FB.Array( of ulong ) cargs
                            cargs.Push( cast( ulong, ssa.kind ) )
                            cargs.Push( cast( ulong, ssa.id ) )
                            EmitStructorCall( c, ucp, slot, 0, @cargs )
                        else
                            CallImplicitCopy_( c, dvt, dsa, ssa )
                        end if
                        constructed = true
                    end if
                end if
            end if
        end if
        '' A CLOSURE IS BUILT IN PLACE. Lowered as a value it goes into a
        '' temporary and is copied out bitwise, which leaves the variable's
        '' own default-constructed captures unclaimed: a counted capture
        '' came out three constructed and two destroyed. Building into the
        '' slot is one object, constructed once -- and it is also what
        '' 'constructed' means here, so no default constructor follows.
        if constructed = false then
            if c.ast->Kind( ip->b ) = Tko.N_CLOSURE then
                dim as MirValue clo
                clo.kind = cast( ubyte, MV_LOCAL )
                clo.ty = cast( ubyte, MT_PTR )
                clo.id = slot
                dim as MirValue cout
                if LowerClosureAddr_( c, ip->b, cout, @clo ) then
                    constructed = true
                end if
            end if
        end if
        if constructed = false then
            constructed = LowerCtorInit( c, slot, vs->type_, ip->b )
        end if
        '' ...and 'dim u as U = s', a CONVERTING constructor, which fell
        '' through to the default one and dropped the initialiser entirely.
        if constructed = false then
            constructed = LowerConvCtorInit_( c, slot, vs->type_, ip->b )
        end if
        dim as Tko.SymbolId ctor = Tko.SYMBOL_NONE
        if constructed = false then
            ctor = StructorWithArity( c, _
                StructorOf( c, vs->type_, "__ctor" ), 0 )
        end if
        if ctor <> Tko.SYMBOL_NONE then EmitStructorCall( c, ctor, slot )

        '' THE VPTR, for a type that has a table. fbc stores it inside the
        '' constructor -- implicit or written -- so a type with no constructor
        '' at all still gets one made for it. tiko-lang synthesises no constructors,
        '' so the store is emitted HERE for a variable that runs none, and in
        '' the constructor's own prologue when it does.
        ''
        '' NOT COVERED, and it is the honest limit of this: a UDT FIELD of a
        '' class type, an element of an array of one, and 'new T'. Each of
        '' those is constructed somewhere tiko-lang models no construction at all,
        '' and inventing one here would be inventing implicit structors.
        '' NO WRITTEN CONSTRUCTOR, but the type may still need one: a
        '' string field's descriptor has to be zeroed before anything assigns
        '' through it, a dynamic array's descriptor has to be built, and a
        '' type with a table needs its vptr. fbc synthesises a constructor for
        '' exactly those cases; this calls the one tiko-lang synthesises.
        if (ctor = Tko.SYMBOL_NONE) andalso (constructed = false) then
            dim as MirValue va
            va.kind = cast( ubyte, MV_LOCAL )
            va.ty = cast( ubyte, MT_PTR )
            va.id = slot
            '' A UDT ONLY. A bare 'dim as string s' and a bare dynamic
            '' array have their own initialisation at this site already, and
            '' routing them through here asked for a constructor of a type
            '' called FBSTRING that nothing defines.
            if c.types->Kind( vs->type_ ) = Tko.TK_UDT then
                if TypeNeedsInit_( c, vs->type_ ) then
                    CallImplicitCtor_( c, vs->type_, va )
                end if
            elseif ArrayElemNeedsInit_( c, vs->type_ ) then
                EmitArrayElems_( c, slot, vs->type_, true )
            end if
            '' AN EMPTY 'T( )' IS FINISHED HERE: the synthesised constructor
            '' has run and the call has no value to store. 'type<P>( 5, 6 )'
            '' is a FIELD LIST and the store below writes it, which is why
            '' the count decides.
            if initIsLiteral andalso (InitArgCount_( c, ip->b ) = 0) then
                constructed = true
            end if
        end if
        dim as Tko.SymbolId dtor = StructorWithArity( c, _
            StructorOf( c, vs->type_, "__dtor" ), 0 )
        if dtor <> Tko.SYMBOL_NONE then
            c.cleanupNode.Push( cast( ulong, dtor ) )
            c.cleanupSlot.Push( slot )
            c.cleanupType.Push( 0 )
        elseif ArrayElemNeedsDtor_( c, vs->type_ ) then
            '' AN ARRAY OF T IS N OBJECTS, each destroyed in turn -- in reverse,
            '' which is what 'delete[]' was measured doing.
            c.cleanupNode.Push( CLEANUP_DESTROY_ARRAY )
            c.cleanupSlot.Push( slot )
            c.cleanupType.Push( cast( ulong, vs->type_ ) )
        elseif (c.types->Kind( vs->type_ ) = Tko.TK_UDT) andalso _
               TypeNeedsDtor_( c, vs->type_ ) then
            '' ...and the destructor fbc synthesises, for the same reasons.
            '' Without it a UDT holding a string leaked its buffer at every
            '' scope exit, silently.
            c.cleanupNode.Push( CLEANUP_IMPLICIT_DTOR )
            c.cleanupSlot.Push( slot )
            c.cleanupType.Push( cast( ulong, vs->type_ ) )
        end if
        if IsStringType( c, vs->type_ ) then
            '' Order matters: the descriptor is made valid BEFORE its release
            '' is registered, so no path can reach the fb_StrDelete with a
            '' descriptor that was never written.
            '' The answer is READ: a string initialiser that cannot be built
            '' is a decline, not a variable that silently starts out empty.
            if LowerStringInit( c, slot, item, ip->b ) = false then SkipHere( c )
            strInited = true
            c.cleanupNode.Push( 0 )
            c.cleanupSlot.Push( slot )
            c.cleanupType.Push( 0 )
        end if

        '' A 'string * N' IS PREFILLED WITH SPACES, not zeros, and not
        '' incidentally: it has no terminator, so its N bytes ARE its value and
        '' an unwritten one must read back as N blanks. Measured --
        '' '__builtin_memset( (uint8*)A$1, 32, 32ll )' -- and the one thing here
        '' that a zstring's zero-fill would get wrong rather than merely leave
        '' untidy. Emitted before any initialiser, which then overwrites it.
        dim as longint fsn3
        if StrSwapKind_( c, vs->type_, fsn3 ) = 3 then
            dim as MirValue fsa
            fsa.kind = cast( ubyte, MV_LOCAL )
            fsa.ty = cast( ubyte, MT_PTR )
            fsa.id = slot
            dim as FB.Array( of ulong ) fma
            fma.Push( cast( ulong, fsa.kind ) ) : fma.Push( cast( ulong, fsa.id ) )
            fma.Push( cast( ulong, MV_CONST_INT ) ) : fma.Push( 32 )
            fma.Push( cast( ulong, MV_CONST_INT ) )
            fma.Push( cast( ulong, c.types->ElemCount( vs->type_ ) ) )
            EmitRtl( c, RTL_MEMSET, fma )
        end if
    end if

    '' Hoisted: FreeBASIC warns 38 on a mixed boolean/non-boolean chain, and
    '' the house rule is to name the condition rather than silence it.
    dim as boolean needsStore = (slot >= 0)
    if ip->b = Tko.NODE_NONE then needsStore = false
    '' 'dim d as double = any' INITIALISES NOTHING. It is the explicit request
    '' for an uninitialised variable, and fbc emits the declaration and no
    '' store at all -- measured. Treating 'any' as an ordinary initialiser
    '' expression left it with no value to store, so the declaration DECLINED:
    '' 32 corpus lines, every one of them a statement that is meant to produce
    '' no code. 'any' is a keyword, so nothing else can be spelled that way.
    if IsAnyInit_( c, ip->b ) then needsStore = false
    if constructed then needsStore = false
    '' A string initialiser went through fb_StrInit, which is a call and not a
    '' store; storing over it as well would overwrite the descriptor the
    '' runtime just filled in.
    if strInited then needsStore = false
    '' A BRACE INITIALISER over an array is element stores, not one store of
    '' a value there is no way to name.
    if needsStore andalso (slot >= 0) then
        if LowerArrayInit( c, slot, c.syms->SymbolAt( sid )->type_, ip->b ) then
            needsStore = false
        end if
    end if

    '' A FIXED WSTRING initialiser is a runtime call, not a store: the slot
    '' holds the buffer itself, so 'dim w as wstring * 50 = trim( t )' has to
    '' go through fb_WstrAssign exactly as an assignment does.
    '' A FIXED-LENGTH NARROW string initialiser is a runtime call too, and its
    '' length arguments are its own element count rather than -1.
    if needsStore andalso (slot >= 0) then
        dim as longint zn2
        dim as long zk2 = StrSwapKind_( c, c.syms->SymbolAt( sid )->type_, zn2 )
        if (zk2 = 1) orelse (zk2 = 3) orelse (zk2 = 4) then
            dim as MirValue zdst
            zdst.kind = cast( ubyte, MV_LOCAL )
            zdst.ty = cast( ubyte, MT_PTR )
            zdst.id = slot
            '' A WIDE SOURCE FIRST. 'dim s1 as zstring * 10 = wchr( 65 )' is
            '' 'fb_WstrAssignToA_Init( S1, 10, L"A", 0 )' -- the code folded
            '' to a wide literal -- and the narrow path below has no narrow
            '' source to find, so it declined.
            if TermIsWide_( c, ip->b ) orelse IsWideChain_( c, ip->b ) then   '' 'w & "d"' too
                if LowerWideToNarrowSlot( c, slot, _
                       c.syms->SymbolAt( sid )->type_, ip->b, true ) then
                    needsStore = false
                end if
            end if
            if needsStore then
                if LowerZstrAssignTo( c, zdst, zn2, ip->b, true, (zk2 = 4) ) then _
                    needsStore = false
            end if
        end if
    end if

    if needsStore andalso (slot >= 0) then
        dim as long wn = _
            WideStringElems( c, c.syms->SymbolAt( sid )->type_ )
        if wn > 0 then
            dim as MirValue wdst
            wdst.kind = cast( ubyte, MV_LOCAL )
            wdst.id = slot
            if LowerWideAssignTo( c, wdst, wn, ip->b ) then needsStore = false
        end if
    end if

    '' 'dim as UDT x = ( 1, 2, 3 )' -- a PAREN INITIALISER LIST, which is a
    '' sequence of field stores and not a value to coerce into the slot.
    if needsStore andalso (slot >= 0) then
        if LowerUdtParenInit_( c, slot, c.syms->SymbolAt( sid )->type_, _
                               ip->b ) then needsStore = false
    end if

    if needsStore then
        '' A UDT INITIALISER FOR A SCALAR IS ITS 'operator cast', not its bytes.
        '' See UserConvToScalar_ -- this loaded the aggregate and sign-extended
        '' it, and that lowered and verified.
        dim as MirValue val
        dim as Tko.TypeId dstT = Tko.TYPE_NONE
        dim as Tko.Symbol ptr dsym = c.syms->SymbolAt( sid )
        if dsym <> 0 then dstT = dsym->type_
        '' See DropMovedTemp_: what this expression registers for destruction
        '' has to be known before it is lowered.
        dim as long tmark = c.udtTemps.Count
        '' ...AND A UDT INITIALISER FOR ANOTHER UDT IS ONE TOO -- UdtCastValue_.
        if UserConvToScalar_( c, ip->b, dstT, val ) = false then
         if UdtCastValue_( c, ip->b, dstT, val ) = false then
            '' 'dim as parent p = c' OVER A DERIVED VALUE COPIES THE BASE
            '' SUBOBJECT ONLY -- see UpcastAggInit_. LowerExpr hands back the
            '' whole derived aggregate, and storing sixteen bytes into an
            '' eight-byte slot is not an instruction clang will take.
            if UpcastAggInit_( c, ip->b, dstT, val ) = false then
                val = LowerExpr( c, ip->b )
            end if
         end if
        end if
        '' A MOVE, not a copy -- so the source must not be destroyed.
        dim as boolean movedFrom = (c.ast->Kind( ip->b ) = Tko.N_CALL)
        if movedFrom then movedFrom = (dstT <> Tko.TYPE_NONE)
        if movedFrom then movedFrom = (c.types->Kind( dstT ) = Tko.TK_UDT) orelse c.types->IsDynArray( dstT )
        if movedFrom then movedFrom = HasDynArrayMember_( c, dstT ) orelse c.types->IsDynArray( dstT )
        if movedFrom then DropMovedTemp_( c, tmark, dstT )
        '' AN INITIALISER THAT WOULD NOT LOWER IS A DECLINE, and was silent:
        '' the store was simply skipped, so 'dim as integer r = iif( c, 10,
        '' 20 )' allocated r, stored nothing, and printed whatever the stack
        '' held -- with "0 statements not lowered" beside it. Every other
        '' decline in this file is counted; this one was not.
        if val.kind = cast( ubyte, MV_NONE ) then SkipHere( c )
        if val.kind <> cast( ubyte, MV_NONE ) then
            '' dstT is the DECLARED type, already in hand -- and CoerceTy needs
            '' it: 'dim as boolean b = i' is a comparison and 'dim as byte b = t'
            '' a negate, and both are MT_I8 to the slot.
            val = CoerceTy( c, val, cast( MirType, c.f->locals[slot].ty ), _
                            c.info->TypeOf_( ip->b ), dstT )
            dim as MirValue addr
            addr.kind = cast( ubyte, MV_LOCAL )
            addr.ty = cast( ubyte, MT_PTR )
            addr.id = slot
            dim as MirInst ins
            ins.op = cast( ushort, M_STORE )
            ins.ty = cast( ubyte, MT_VOID )
            ins.a = addr
            ins.b = val
            Emit( c, ins )
        end if
    end if
end sub

'' A COLLECTION INITIALISER (symbols/collinit.bas): the 'x.Push( e )' statements Resolve
'' built for this declarator, run after it was constructed. Not for a STATIC local, whose
'' calls run inside its run-once guard instead -- LowerStaticLocalInit_ -- or every call
'' of the procedure would add the elements again; nor for a SHARED or namespace one, whose
'' calls run in the module initialiser (lowermodinit.bas).
sub LowerCollInit_( byref c as Ctx, byval id as Tko.NodeId, byval item as Tko.NodeId )
    if Tko.CollInitOf( *c.ast, item ) = Tko.NODE_NONE then return
    dim as Tko.SymbolId sid = _
        c.syms->LookupLocalTyped( c.info->ScopeOf( id ), StmtOf( c, item )->name, false )
    if sid <> Tko.SYMBOL_NONE then
        if IsStaticLocal( c, sid ) then return
        if IsSharedVar( c, sid ) then return     '' the module initialiser runs them
    end if
    LowerCollInitCalls_( c, item )
end sub

'' Judged from where the DECLARATION stands, not from the synthesised nodes, which sit at
'' the end of the arena -- see LowerStmt on '#undef'.
sub LowerCollInitCalls_( byref c as Ctx, byval item as Tko.NodeId )
    dim as Tko.NodeId blk = Tko.CollInitOf( *c.ast, item )
    if blk = Tko.NODE_NONE then return
    dim as Tko.ListPayload ptr bl = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, blk )].data )]
    dim as long first_ = bl->first
    dim as long count_ = bl->count
    dim as ulong savedPos = c.syms->usePos
    c.syms->usePos = cast( ulong, item )
    for k as long = 0 to count_ - 1
        LowerStmtAt_( c, cast( Tko.NodeId, c.ast->children[first_ + k] ) )
    next
    c.syms->usePos = savedPos
end sub
