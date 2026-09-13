'' lower.bas -- AST to MIR. See lower.bi for what this slice does and does not cover.

#include once "mir/lower.bi"
#include once "mir/lowerctx.bi"

namespace Tko.Mir

declare function LowerCtorReturn_( byref c as Ctx, byval e as Tko.NodeId ) as boolean
declare function LowerTupleReturn_( byref c as Ctx, byval e as Tko.NodeId ) as boolean
declare function DerefCharTy_( byref c as Ctx, byval id as Tko.NodeId ) as MirType
'' CharLvalueTy_ and NumericTerm_ are declared in lowerctx.bi, because lowerwstr.bas
'' is its own compilation unit and needs them too.
declare function StaticMemberSym_ _
    ( byref c as Ctx, byval stmt as Tko.NodeId, byval item as Tko.NodeId ) as Tko.SymbolId
declare function InitArgCount_( byref c as Ctx, byval e as Tko.NodeId ) as long
declare function IsCmpOp_( byval op as MirOp ) as boolean
declare function LowerByrefResult_ _
    ( byref c as Ctx, byval valueE as Tko.NodeId ) as boolean
declare function LowerTypeLitConvert_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
declare function TypeLitCopySource_ _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId ) as Tko.NodeId
declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long

'' Ctx and the shared helpers live in lowerctx.bi: lowering is now two files.


#include once "mir/lowerutil.bas"
#include once "mir/lowerexpr.bas"
'' A CAPTURING LAMBDA'S OBJECT, split out of lowerexpr.bas at the 1500-line cap.
#include once "mir/lowerclosure.bas"
#include once "mir/lowerassign.bas"

#include once "mir/lowerinit.bas"

'' THE SRET TEMPORARY A CALL RESULT WAS MOVED OUT OF, unregistered so nothing
'' destroys it.
''
'' 'dim a as Box = makeBox( )' over a type holding a dynamic array takes the plain
'' store, and that store IS the move: the destination adopts the returned descriptor,
'' buffer and all. The call site had already registered its sret temporary for
'' destruction, so the array was erased out from under the variable that had just
'' adopted it and the variable's own destructor then erased it again -- the probe
'' printed the right element and exited 127.
''
'' fbc does NOT move here: it copy-constructs, and its SYNTHESISED copy constructor
'' deep-copies the array with fb_ArrayRedimTo and an element loop before destroying
'' the temporary. tiko synthesises no such constructor on purpose -- see
'' ByvalUdtCopyArg_, which says why -- so the move is the model it actually has, and
'' a move that destroys its source is not one.
''
'' THE OBSERVABLE DIFFERENCE THAT REMAINS is one destructor call fewer than fbc for
'' this shape. It is recorded rather than hidden; closing it means synthesising the
'' deep copy.
''
'' The FIRST entry added since 'from_' whose type is the destination's is the
'' outermost call's sret slot: LowerCall pushes it before it lowers any argument.
private sub DropMovedTemp_ _
    ( byref c as Ctx, byval from_ as long, byval t as Tko.TypeId )

    if t = Tko.TYPE_NONE then return
    for i as long = from_ to c.udtTemps.Count - 1
        if c.udtTempTypes[i] = cast( ulong, t ) then
            for k as long = i to c.udtTemps.Count - 2
                c.udtTemps[k] = c.udtTemps[k + 1]
                c.udtTempTypes[k] = c.udtTempTypes[k + 1]
            next
            c.udtTemps.Pop( )
            c.udtTempTypes.Pop( )
            return
        end if
    next
end sub

sub LowerStmt( byref c as Ctx, byval id as Tko.NodeId )
    if id = Tko.NODE_NONE then return
    '' A DEAD CURSOR STOPS EVERYTHING EXCEPT A LABEL, and the exception is the point: a
    '' label is precisely what makes the code after it reachable again. 'exit sub' and
    '' 'return' end their block and leave no cursor -- correctly, since nothing FALLS
    '' into what follows -- and every later statement was then dropped in silence,
    '' label included. So
    ''
    ''     sub s( ) : print "one" : exit sub : tail: : print "two" : end sub
    ''
    '' lowered to the first print and a ret. 'tail:' and everything after it produced no
    '' code and no diagnostic, while fbc compiles the same source and lets a GOTO reach
    '' the label. That is not a dead-code curiosity: 'exit sub' before the handler's
    '' label is how an error handler is written, so the whole handler disappeared.
    ''
    '' OPENING A BLOCK AT THE TERMINATOR INSTEAD WOULD BE THE WRONG FIX, and was tried:
    '' lowerinit.bas records that giving every RETURN an "after" block left one
    '' unreachable block, and one unreachable 'ret', per return in the corpus -- 1,488 of
    '' them. Nothing needs a block there unless a label follows, and a label opens its
    '' own.
    if c.curBlock < 0 then
        if c.ast->Kind( id ) <> Tko.N_LABEL then return
    end if
    '' Saved and restored: statements nest, and a decline belongs to the INNERMOST one.
    dim as ushort savedKind = c.curStmtKind
    dim as ulong savedNode = c.curStmtNode
    c.curStmtKind = cast( ushort, c.ast->Kind( id ) )
    c.curStmtNode = cast( ulong, id )

    '' STATEMENT-LIFETIME STRING TEMPORARIES. A string 'iif' builds its result in a
    '' temporary descriptor that must be released once the statement that consumes it
    '' has finished -- measured; fbc emits the fb_StrDelete on the very next line.
    '' That is a shorter life than any scope, so it cannot use the scope cleanup list.
    ''
    '' The mark is saved and restored because statements NEST: an 'if' releases only
    '' the temporaries its own condition made, not the ones its body made, and those
    '' have already been released by the inner LowerStmt.
    dim as long tmpMark = c.strTemps.Count
    dim as long wtmpMark = c.wstrTemps.Count
    dim as long utmpMark = c.udtTemps.Count
    dim as long savedUdtMark = c.stmtUdtMark
    c.stmtUdtMark = utmpMark

    LowerStmtInner( c, id )

    c.stmtUdtMark = savedUdtMark
    ReleaseUdtTemps_( c, utmpMark )

    ReleaseStrTemps_( c, tmpMark )

    ReleaseWstrTemps_( c, wtmpMark )

    c.curStmtKind = savedKind
    c.curStmtNode = savedNode
end sub

private sub LowerStmtInner( byref c as Ctx, byval id as Tko.NodeId )

    select case c.ast->Kind( id )
    case Tko.N_BLOCK
        LowerBlock( c, id )

    case Tko.N_SCOPE
        '' A SCOPE carries its body in 'b'. Sending the SCOPE node itself to
        '' LowerBlock recursed forever: LowerBlock forwards anything that is not an
        '' N_BLOCK to LowerStmt, which forwarded it straight back. A guard that does
        '' not narrow is not a guard.
        '' A SCOPE is a break TARGET too: 'exit scope' leaves it. Its exit block is
        '' opened LAZILY -- the frame is pushed with -1 and LowerExitLike allocates
        '' the block the first time something actually needs it. Allocating it up
        '' front gave every scope in the corpus a dead block and renumbered the rest,
        '' which the goldens caught.
        c.breakTo.Push( -1 )
        c.contTo.Push( -1 )
        c.loopScope.Push( c.scopeMark.Count )
        c.loopKind.Push( cast( long, Tko.KW_SCOPE ) )
        dim as long scAt = c.breakTo.Count - 1
        PushScope( c )
        LowerBlock( c, StmtOf( c, id )->b )
        CloseScope( c )
        dim as long scExit = c.breakTo[scAt]
        c.breakTo.Pop( )
        c.contTo.Pop( )
        c.loopScope.Pop( )
        c.loopKind.Pop( )
        if scExit >= 0 then
            Terminate( c, MTERM_BR, scExit, -1, NoVal( ) )
            c.curBlock = scExit
        end if

    case Tko.N_SPAWN
        '' The parser rewrote 'spawn f( a )' into a SCOPE of ordinary statements --
        '' allocate the frame, copy the arguments in, hand it to fb_Spawn -- so
        '' there is nothing here but to lower them. A spawn whose shape the
        '' rewrite refused has no body and declines, as it always did.
        dim as Tko.NodeId sb = StmtOf( c, id )->b
        if sb = Tko.NODE_NONE then
            SkipHere( c )
        else
            LowerStmt( c, sb )
        end if

    case Tko.N_DEFER
        '' Registered, not run. It fires at the end of the ENCLOSING scope, in
        '' reverse registration order -- which is the FBC-Modern behaviour to
        '' reproduce, not to improve on.
        c.cleanupNode.Push( cast( ulong, StmtOf( c, id )->b ) )
        c.cleanupSlot.Push( -1 )
        c.cleanupType.Push( 0 )

    case Tko.N_VAR
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
        for i as long = 0 to sp->count - 1
            dim as Tko.NodeId item = cast( Tko.NodeId, c.ast->children[sp->first + i] )
            if c.ast->Kind( item ) <> Tko.N_VAR_ITEM then continue for
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
                continue for
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
                    continue for
                end if
                '' A STATIC LOCAL OBJECT is constructed LAZILY, where it is declared:
                '' a guard flag, the constructor and an atexit thunk. Module storage
                '' with no code run on it left a string field's descriptor
                '' uninitialised for the life of the program.
                if IsStaticLocal( c, sid ) then
                    if LowerStaticLocalInit_( c, sid, ip->b ) then continue for
                end if
                InitSharedGlobal( c, sid, ip->b )
                continue for
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
                continue for
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
                    dim as Tko.TypeId ivt = c.info->TypeOf_( ip->b )
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
                        dim as boolean initIsCall = _
                            (c.ast->Kind( ip->b ) = Tko.N_CALL)
                        '' ...and ONLY for a type carrying a dynamic array, which is
                        '' the set this path newly reaches. A type that wanted the
                        '' implicit copy BEFORE -- one holding a var-length string,
                        '' say -- still gets it from a call, because a plain store
                        '' would alias its buffer exactly the way it would here. The
                        '' array case has no such history to preserve: its store was
                        '' the move all along.
                        dim as boolean wantImplCopy = NeedsLetBody_( c, dvt )
                        if initIsCall andalso HasDynArrayMember_( c, dvt ) then
                            wantImplCopy = false
                        end if
                        if (ucp <> Tko.SYMBOL_NONE) orelse wantImplCopy then
                            dim as MirValue dsa
                            dsa.kind = cast( ubyte, MV_LOCAL )
                            dsa.ty = cast( ubyte, MT_PTR )
                            dsa.id = slot
                            '' WHAT THE INITIALISER REGISTERS FOR DESTRUCTION has to
                            '' be known before it is lowered -- see DropMovedTemp_.
                            dim as long cmark = c.udtTemps.Count
                            dim as MirValue ssa = LowerAddr( c, ip->b )
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
                    if TermIsWide_( c, ip->b ) then
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
                if UserConvToScalar_( c, ip->b, dstT, val ) = false then
                    '' 'dim as parent p = c' OVER A DERIVED VALUE COPIES THE BASE
                    '' SUBOBJECT ONLY -- see UpcastAggInit_. LowerExpr hands back the
                    '' whole derived aggregate, and storing sixteen bytes into an
                    '' eight-byte slot is not an instruction clang will take.
                    if UpcastAggInit_( c, ip->b, dstT, val ) = false then
                        val = LowerExpr( c, ip->b )
                    end if
                end if
                '' A MOVE, not a copy -- so the source must not be destroyed.
                dim as boolean movedFrom = (c.ast->Kind( ip->b ) = Tko.N_CALL)
                if movedFrom then movedFrom = (dstT <> Tko.TYPE_NONE)
                if movedFrom then movedFrom = (c.types->Kind( dstT ) = Tko.TK_UDT)
                if movedFrom then movedFrom = HasDynArrayMember_( c, dstT )
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
        next

    case Tko.N_AMBIGUOUS
        dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
        select case c.info->AmbiguousOf( id )
        case Tko.AMB_RESULT
            '' BASIC's result assignment, both spellings: 'function = expr' and
            '' 'f = expr' inside f. It stores and CARRIES ON -- it is not a return, so
            '' no terminator and no cleanups.
            '' A UDT RESULT travelling through the HIDDEN POINTER has no result slot
            '' at all: the pointer IS the result object, so 'function = expr' copies
            '' the value straight through it. Measured -- fbc emits
            '' '__builtin_memcpy( tmp$2$1, &T$1, 4 )', or the type's 'operator let'
            '' where it has one.
            if (c.resultSlot < 0) andalso (c.sretParam >= 0) then
                if LowerSretResult( c, sp->b ) = false then
                    SkipHere( c )
                    c.st->ambResultNoSlot += 1
                end if
            elseif c.resultSlot < 0 then
                '' A result type with no slot: a UDT return that is NOT sret, which is
                '' returned BY VALUE and has no address to write through. Declining is
                '' the honest answer; storing into an invented slot would compile and
                '' be wrong.
                SkipHere( c )
                c.st->ambResultNoSlot += 1
                '' WHICH TYPE, so the next reader has a name rather than a count. The
                '' scalar, string, sret and by-value-UDT cases all have slots; what
                '' reaches here is whatever none of those recognised.
                if c.st->resultNoSlotKinds.Count = 0 then
                    for i as long = 0 to 15
                        c.st->resultNoSlotKinds.Push( 0 )
                    next
                end if
                dim as long rk = cast( long, c.types->Kind( c.resultType ) )
                if (rk >= 0) andalso (rk < 16) then
                    c.st->resultNoSlotKinds[rk] += 1
                end if
            elseif c.byrefResult then
                if LowerByrefResult_( c, sp->b ) = false then SkipHere( c )
            elseif IsStringType( c, c.resultType ) then
                '' A STRING RESULT IS ASSIGNED, NOT STORED. The result slot holds a
                '' DESCRIPTOR, and copying one is not the same as assigning to it:
                '' 'function = s' was emitting a raw 24-byte aggregate copy, so the
                '' result descriptor came out pointing at the ARGUMENT's data. Both
                '' owners then free it. Measured -- fbc emits
                '' 'fb_StrAssign( &fb$result, -1, S, -1, 0 )', and the same call with
                '' a length of 0 for a ZSTRING source and fb_WstrAssignToA for a wide
                '' one. It compiled, verified and counted as lowered the whole time.
                '' A WIDE SOURCE goes through fb_WstrAssignToA, not fb_StrAssign.
                if LowerWideToNarrowSlot( c, c.resultSlot, c.resultType, sp->b ) then
                elseif LowerStringAssignToSlot( c, c.resultSlot, sp->b ) = false then
                    SkipHere( c )
                end if
            elseif ResultFieldListInit_( c, sp->b ) then
                '' 'function = type( 1, 2 )' and 'function = ( 1, 2 )' -- A FIELD LIST
                '' WRITTEN STRAIGHT INTO THE RESULT. Neither spelling names a type: the
                '' RESULT's type is the context, exactly as a declaration's is for
                '' 'dim as P x = ( 1, 2 )'. Lowering it as an expression asked the tuple
                '' for a type it has not got, so both declined.
            else
                dim as MirValue rval = LowerExpr( c, sp->b )
                if rval.kind = cast( ubyte, MV_NONE ) then
                    SkipHere( c )
                else
                    dim as MirValue raddr
                    raddr.kind = cast( ubyte, MV_LOCAL )
                    raddr.ty = cast( ubyte, MT_PTR )
                    raddr.id = c.resultSlot
                    dim as MirInst rs
                    rs.op = cast( ushort, M_STORE )
                    rs.ty = cast( ubyte, MT_VOID )
                    rs.a = raddr
                    '' MIR has no implicit conversions, so the narrowing FreeBASIC
                    '' allows on a result assignment is explicit here, exactly as it
                    '' is for an ordinary assignment.
                    rs.b = CoerceTy( c, rval, cast( MirType, c.resultTy ), c.info->TypeOf_( sp->b ) )
                    Emit( c, rs )
                end if
            end if
        case Tko.AMB_ASSIGN
            '' THE BLOCK AS WELL AS THE COUNT. A compound assignment that is CONTROL
            '' FLOW -- 'i andalso= e' -- ends the current block and continues in the
            '' join, so comparing the join's instruction count against the count taken
            '' in a different block reported a statement that lowered perfectly well as
            '' having emitted nothing.
            dim as long beforeAB = c.curBlock
            dim as long beforeA = c.f->blocks[c.curBlock].insts.Count
            dim as Tko.TokenKind aop = cast( Tko.TokenKind, sp->op )
            '' '&=' WAS TREATED AS PLAIN, so 's &= "b"' lowered to fb_StrAssign -- an
            '' assignment where an append belongs. So is '+=' over a string.
            if aop = Tko.TK_EQ then
                LowerAssign( c, sp->a, sp->b )
            elseif LowerConcatAssignStmt( c, sp->a, sp->b, aop ) then
            elseif LowerCompoundAssign( c, sp->a, sp->b, aop ) = false then
                SkipHere( c )
            end if
            if (c.curBlock = beforeAB) andalso _
               (c.f->blocks[c.curBlock].insts.Count = beforeA) then
                c.st->ambAssign += 1
                '' WHICH KIND OF TARGET, so the next reader has something to go and
                '' implement rather than a number.
                if c.st->ambAssignKinds.Count = 0 then
                    for i as long = 0 to 15
                        c.st->ambAssignKinds.Push( 0 )
                    next
                end if
                dim as Tko.TypeId att = c.info->TypeOf_( sp->a )
                if att = Tko.TYPE_NONE then
                    c.st->ambAssignUntyped += 1
                else
                    dim as long ak = cast( long, c.types->Kind( att ) )
                    if (ak >= 0) andalso (ak < 16) then c.st->ambAssignKinds[ak] += 1
                end if
                if c.st->ambAssignValKinds.Count = 0 then
                    for i as long = 0 to 127
                        c.st->ambAssignValKinds.Push( 0 )
                    next
                end if
                dim as long vk = cast( long, c.ast->Kind( sp->b ) )
                if (vk >= 0) andalso (vk < 128) then c.st->ambAssignValKinds[vk] += 1
            end if
        case Tko.AMB_CALL
            '' A CALL STATEMENT THAT PRODUCES NOTHING IS A DECLINE, and has to be counted
            '' as one. LowerCall returns MV_NONE for an unresolved callee without
            '' recording anything, so when the classification changed from error to call
            '' these statements stopped being counted while still emitting no code --
            '' the count fell by 78,000 and the work was not being done.
            ''
            '' A call whose result is void legitimately yields MV_NONE too, so the test
            '' is whether the statement emitted ANY instruction, not what it returned.
            '' THE BLOCK IS PART OF THE TEST. An argument containing ANDALSO is
            '' control flow, so lowering the call moves c.curBlock -- and comparing
            '' this block's count against a DIFFERENT block's said "emitted nothing"
            '' for a call that had just been emitted elsewhere.
            dim as long beforeB = c.curBlock
            dim as long beforeN = c.f->blocks[c.curBlock].insts.Count
            '' AND WHETHER A CALL GAVE UP, which the instruction count cannot tell:
            '' the ARGUMENTS are lowered before the call can fail, so a statement whose
            '' call was never emitted looked exactly like one that lowered.
            c.lastCallOk = true
            c.lastCallFailLine = 0
            '' 'W( 1, 2 )' is an expression; 'W 1, 2' is this statement's own callee
            '' and children, and looks nothing like a call node.
            if c.ast->Kind( sp->a ) = Tko.N_CALL then
                '' 'base( n )' IS THE BASE-CLASS CONSTRUCTOR, not a call to anything
                '' named 'base' -- tried first, because the ordinary call path has no
                '' callee to bind and would decline it.
                if LowerBaseCtorCall_( c, sp->a ) = false then
                    dim as MirValue dv = LowerExpr( c, sp->a )
                    '' A DISCARDED STRING RESULT IS STILL A CALL, and it is released.
                    '' 'hex( i )' as a statement is, measured:
                    ''
                    ''   FBSTRING* vr = fb_HEX_i( (uint32)I );
                    ''   fb_hStrDelTemp( (FBSTRING*)vr );
                    ''
                    '' -- and the wide twin through fb_WstrHex_i and fb_WstrDelete.
                    '' These callees answer only through the string-DESCRIPTOR path,
                    '' which nothing asked for here, so LowerExpr produced nothing
                    '' and the statement declined -- while 'dim s as string =
                    '' hex( i )' beside it lowered.
                    if dv.kind = cast( ubyte, MV_NONE ) then
                        dim as MirValue sd
                        dim as boolean released = false
                        if TermIsWide_( c, sp->a ) then
                            '' ...UNLESS THE OPERAND REGISTERED ITSELF. The wide
                            '' radix family now parks its result in a statement
                            '' temporary, so the flush at the end of LowerStmt
                            '' already releases it -- and emitting one here as well
                            '' is a DOUBLE FREE. 'whex( i )' as a discarded
                            '' statement is one fb_WstrDelete to fbc and became two.
                            '' The count is what says which: WideOperand_ pushes
                            '' onto wstrTemps exactly when it took ownership.
                            dim as long wtBefore = c.wstrTemps.Count
                            if WideOperand_( c, sp->a, sd ) then
                                if c.wstrTemps.Count > wtBefore then
                                    released = true
                                else
                                    dim as FB.Array( of ulong ) wa
                                    wa.Push( cast( ulong, sd.kind ) )
                                    wa.Push( cast( ulong, sd.id ) )
                                    EmitRtl( c, RTL_WSTR_DELETE, wa )
                                    released = true
                                end if
                            end if
                        elseif StrDescriptorOf_( c, sp->a, sd ) then
                            dim as FB.Array( of ulong ) da
                            da.Push( cast( ulong, sd.kind ) )
                            da.Push( cast( ulong, sd.id ) )
                            EmitRtl( c, RTL_H_STR_DEL_TEMP, da )
                            released = true
                        end if
                        '' The call DID lower after all, so the failure the ordinary
                        '' path recorded on the way past is not one.
                        if released then
                            c.lastCallOk = true
                            c.lastCallFailLine = 0
                        end if
                    else
                        '' ...AND WHEN IT LOWERED FINE. The branch above releases only
                        '' what LowerExpr could not produce, which is the INTRINSIC
                        '' case; a user function returning a string lowers perfectly
                        '' well and its result was then dropped on the floor. Measured,
                        '' for 'F()' as a statement over a 'function F( ) as string':
                        ''
                        ''     FBSTRING* vr$0 = F( );
                        ''     fb_hStrDelTemp( (FBSTRING*)vr$0 );
                        ''
                        '' -- one leak per call, in a statement that lowered and
                        '' verified. 'dim as string s = F()' beside it is NOT this: the
                        '' initialisation CONSUMES the temporary, and fbc emits no
                        '' release for it.
                        dim as Tko.TypeId dvt = c.info->TypeOf_( sp->a )
                        dim as longint dvn = 0
                        if IsStringType( c, dvt ) andalso _
                           (StrSwapKind_( c, dvt, dvn ) = 0) then
                            dim as FB.Array( of ulong ) ra
                            ra.Push( cast( ulong, dv.kind ) )
                            ra.Push( cast( ulong, dv.id ) )
                            EmitRtl( c, iif( IsUStringType( c, dvt ), _
                                             RTL_USTR_DELETE, RTL_H_STR_DEL_TEMP ), ra )
                        end if
                    end if
                end if
            else
                LowerStmtCall( c, id )
            end if

            '' ASSERT AND ASSERTWARN EMIT NOTHING ON PURPOSE. Measured: without -g,
            '' fbc evaluates neither the condition nor anything else, and its C
            '' contains no trace of the statement. Emitting nothing is the WHOLE
            '' lowering, so the emitted-nothing test below has to know that -- and it
            '' is the only construct in the language for which that is true.
            dim as boolean deliberateNoOp = false
            if c.ast->Kind( sp->a ) = Tko.N_CALL then
                dim as Tko.ListPayload ptr np = _
                    @c.ast->lists[cast( long, c.ast->nodes[cast( long, sp->a )].data )]
                if np->target <> Tko.NODE_NONE then
                    if c.ast->Kind( np->target ) = Tko.N_IDENT then
                        dim as Tko.IdentPayload ptr nip = _
                            @c.ast->idents[cast( long, _
                                c.ast->nodes[cast( long, np->target )].data )]
                        select case Tko.Text.LowerAscii( c.names->Spelling( nip->name ) )
                        case "assert", "assertwarn"
                            deliberateNoOp = true
                        end select
                    end if
                end if
            end if

            if deliberateNoOp then
                '' nothing to emit, and nothing to count
            elseif c.lastCallOk = false then
                '' BLAMED ON THE BRANCH THAT ACTUALLY GAVE UP, not on this line.
                '' Every declining call in the corpus aggregated HERE, because this
                '' is where the flag is read -- one site with hundreds of counts and
                '' nothing to say which of the eighteen give-up branches inside
                '' lowercall.bas produced them. CallFailed_ records its caller's
                '' __LINE__ and the histogram gets that instead.
                if c.lastCallFailLine > 0 then
                    SkipAt( c, "lowercall.bas", c.lastCallFailLine )
                else
                    SkipHere( c )
                end if
                CountUnlowredCall( c, sp->a )
            elseif (c.curBlock = beforeB) andalso _
                   (c.f->blocks[c.curBlock].insts.Count = beforeN) then
                SkipHere( c )
                CountUnlowredCall( c, sp->a )
            end if
        case else
            '' No expression to look at: the statement was classified as something other
            '' than a call or an assignment -- a property setter, BASIC's result
            '' assignment, or nothing at all.
            SkipHere( c )
            c.st->ambOther += 1
            dim as long ac = cast( long, c.info->AmbiguousOf( id ) )
            while c.st->ambOtherClass.Count <= ac
                c.st->ambOtherClass.Push( 0 )
            wend
            c.st->ambOtherClass[ac] += 1
        end select

    case Tko.N_IF
        dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
        LowerIf( c, id, sp )

    case Tko.N_WHILE
        dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
        dim as long headB = NewBlock( c, "while.head" )
        dim as long bodyB = NewBlock( c, "while.body" )
        dim as long exitB = NewBlock( c, "while.exit" )
        Terminate( c, MTERM_BR, headB, -1, NoVal( ) )
        c.curBlock = headB
        '' A UDT temporary made by the CONDITION dies here, not at the end of the
        '' loop: the head runs again on every iteration and the slot is the same one.
        dim as long umark = c.udtTemps.Count
        dim as MirValue cond = LowerCondition( c, sp->a )
        ReleaseUdtTemps_( c, umark )
        Terminate( c, MTERM_CONDBR, bodyB, exitB, cond )
        c.curBlock = bodyB
        c.breakTo.Push( exitB )
        c.contTo.Push( headB )
        c.loopScope.Push( c.scopeMark.Count )
        c.loopKind.Push( cast( long, Tko.KW_WHILE ) )
        '' A loop BODY is a scope: its locals and defers run on every iteration
        '' (docs/plan/08 rule 4), which the measurement confirms.
        PushScope( c )
        LowerBlock( c, sp->b )
        CloseScope( c )
        c.loopScope.Pop( )
        c.loopKind.Pop( )
        c.breakTo.Pop( )
        c.contTo.Pop( )
        Terminate( c, MTERM_BR, headB, -1, NoVal( ) )
        c.curBlock = exitB

    case Tko.N_DO
        LowerDo( c, id )

    case Tko.N_FOR
        LowerFor( c, id )

    case Tko.N_INTRINSIC
        '' The intrinsic STATEMENTS -- one keyword each, and a dispatch long enough
        '' to be its own subject. It lives in lowerintr.bas with the rest of them.
        if LowerIntrinsicStmt( c, id ) = false then SkipStmt( c, id )

    case Tko.N_FOREACH
        if LowerForEachArray( c, id ) = false then SkipStmt( c, id )

    case Tko.N_DELETE_STMT
        if LowerDelete( c, id ) = false then SkipStmt( c, id )

    case Tko.N_WITH
        '' 'with expr' declares nothing and emits nothing of its own -- it is a NAMING
        '' construct. Resolve has already pointed every '.field' inside it at the
        '' subject's own node, so the body lowers as ordinary statements and the member
        '' accesses find their base the usual way.
        ''
        '' ...ONCE. The subject's ADDRESS is computed here and pushed, and LowerAddr
        '' hands that same address back for every use of the node inside the body --
        '' so a subject with a side effect runs once, which is what fbc does, and
        '' 'with( status( hFindSlot( @this ) ) )' does not call hFindSlot per field.
        ''
        '' A subject with no address leaves the stack alone and its members decline
        '' inside the body, which is the honest outcome and what happened before.
        dim as Tko.StmtPayload ptr wp = StmtOf( c, id )
        dim as boolean wpushed = false
        if wp->a <> Tko.NODE_NONE then
            dim as MirValue wa = LowerAddr( c, wp->a )
            if wa.kind <> cast( ubyte, MV_NONE ) then
                '' INTO A SLOT, not held as a value. A GOTO may jump INTO the body --
                '' warnings/branch-cross-with is a corpus file that does exactly that,
                '' and fbc warns about it rather than refusing it -- so a use inside is
                '' not dominated by the definition at the top and the verifier is right
                '' to say so. A LOCAL is not in SSA form: stored once here and loaded
                '' at each use, which is the shape fbc emits as well.
                dim as long wslot = NewTempLocal( c, MT_PTR, _
                    c.types->target.pointerBits \ 8 )
                if wslot >= 0 then
                    dim as MirValue wdst
                    wdst.kind = cast( ubyte, MV_LOCAL )
                    wdst.ty = cast( ubyte, MT_PTR )
                    wdst.id = wslot
                    dim as MirInst wst
                    wst.op = cast( ushort, M_STORE )
                    wst.ty = cast( ubyte, MT_VOID )
                    wst.a = wdst
                    wst.b = wa
                    Emit( c, wst )
                    c.withNode.Push( cast( ulong, wp->a ) )
                    c.withKind.Push( cast( ulong, MV_LOCAL ) )
                    c.withId.Push( cast( ulong, wslot ) )
                    wpushed = true
                end if
            end if
        end if
        LowerBlock( c, wp->b )
        if wpushed then
            c.withNode.Pop( )
            c.withKind.Pop( )
            c.withId.Pop( )
        end if

    case Tko.N_END_STMT
        LowerEndStmt( c, id )

    case Tko.N_SELECT
        LowerSelect( c, id )

    case Tko.N_LABEL
        LowerLabel( c, id )

    case Tko.N_GOTO
        LowerGoto( c, id )

    case Tko.N_RETURN
        dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
        '' 'return' with no expression yields the result variable, not nothing --
        '' 'function = 7 : return' is 7. Loaded only in that case: reading the slot
        '' unconditionally emitted a load every explicit 'return expr' then discarded,
        '' which the golden caught as four dead instructions.
        '' A STRING RESULT does not leave as a value: it is BUILT in the result
        '' descriptor and handed to fb_StrAllocTempResult on the way out, which is
        '' what fbc emits. 'return "hi"' is therefore an ASSIGNMENT into the result
        '' slot followed by that call -- returning the literal directly would hand
        '' back a pointer to static text where the caller expects a descriptor.
        if LowerStringReturn( c, sp->a ) then return

        '' A TRIVIAL UDT RESULT is returned BY VALUE out of its result slot. The value
        '' has to be copied into that slot first, exactly as 'function = expr' does --
        '' the ordinary path below would try to Coerce an aggregate to an aggregate,
        '' which is not a conversion MIR has.
        if c.udtResult andalso (c.resultSlot >= 0) then
            if sp->a <> Tko.NODE_NONE then
                '' THE VALUE FIRST, the address only as a fallback. 'return F( )'
                '' and 'return Vec3d_( x, y, z )' have no address to take -- a call
                '' result is a value -- and requiring one declined 10,387 statements,
                '' which is most of what a UDT-returning function actually returns.
                '' A BARE TUPLE LITERAL HAS NO TYPE OF ITS OWN -- 'return (20, 22)'
                '' names no type and UdtLiteralSlot_ wants one written -- so it is
                '' built straight INTO the result slot from the function's own result
                '' type. fbc builds a temporary and copies it in; this is the same
                '' object one copy earlier, and without it every tuple-returning
                '' function declined its return.
                if LowerTupleReturn_( c, sp->a ) then return

                '' 'return T( args )' CONSTRUCTS INTO THE RESULT, and is not a value
                '' to copy: 'D( this.y + n )' is a constructor call spelled as a call
                '' to the type name, so LowerExpr had nothing to hand back and
                '' LowerAddr no address to take. See LowerCtorReturn_.
                if LowerCtorReturn_( c, sp->a ) then return

                '' 'return this' IS THE OBJECT, not the receiver pointer -- see
                '' ThisObjectAddr_. LowerExpr below yields the POINTER and it was
                '' stored straight into the result slot.
                dim as MirValue uval
                dim as Tko.TypeId uthT = Tko.TYPE_NONE
                dim as MirValue uthA
                if ThisObjectAddr_( c, sp->a, uthT, uthA ) then
                    dim as long uthSz = SizeOfType( c, uthT )
                    if uthSz > 0 then uval = LowerExprLoad( c, uthA, MT_AGG, uthSz )
                else
                    uval = LowerExpr( c, sp->a )
                end if
                dim as boolean copied = false
                if uval.kind = cast( ubyte, MV_NONE ) then
                    dim as MirValue usrc = LowerAddr( c, sp->a )
                    if usrc.kind <> cast( ubyte, MV_NONE ) then
                        uval = LowerExprLoad( c, usrc, MT_AGG )
                    end if
                end if
                if uval.kind <> cast( ubyte, MV_NONE ) then
                    if true then
                        dim as MirValue uda
                        uda.kind = cast( ubyte, MV_LOCAL )
                        uda.ty = cast( ubyte, MT_PTR )
                        uda.id = c.resultSlot
                        dim as MirInst us
                        us.op = cast( ushort, M_STORE )
                        us.ty = cast( ubyte, MT_VOID )
                        us.a = uda
                        us.b = uval
                        Emit( c, us )
                        copied = true
                    end if
                end if
                if copied = false then SkipHere( c )
            end if
            '' A RETURN'S OWN TEMPORARIES DIE HERE, not at the end of the statement: the
            '' terminator below ends the block, and ReleaseUdtTemps_ refuses to emit into a
            '' dead cursor -- so everything the return expression built was leaked. Measured:
            '' 'function Value( ) as (Counted, long)' returning '( Counted( this.i ), this.i )'
            '' ran two constructors per call and no destructor at all.
            ''
            '' AFTER the result has been copied out, because the result is often one of them.
            ReleaseUdtTemps_( c, c.stmtUdtMark )
            EmitCleanupsTo( c, 0 )
            dim as MirValue ura2
            ura2.kind = cast( ubyte, MV_LOCAL )
            ura2.ty = cast( ubyte, MT_PTR )
            ura2.id = c.resultSlot
            Terminate( c, MTERM_RET, -1, -1, LowerExprLoad( c, ura2, MT_AGG ) )
            c.curBlock = -1
            return
        end if

        '' A UDT RETURN through the hidden pointer: copy into the caller's storage if
        '' there is a value, then return THAT POINTER -- which is what fbc's own C
        '' does, 'return tmp$2$1'.
        if c.sretParam >= 0 then
            if sp->a <> Tko.NODE_NONE then
                if LowerSretResult( c, sp->a, true ) = false then SkipHere( c )
            end if
            '' A RETURN'S OWN TEMPORARIES DIE HERE, not at the end of the statement: the
            '' terminator below ends the block, and ReleaseUdtTemps_ refuses to emit into a
            '' dead cursor -- so everything the return expression built was leaked. Measured:
            '' 'function Value( ) as (Counted, long)' returning '( Counted( this.i ), this.i )'
            '' ran two constructors per call and no destructor at all.
            ''
            '' AFTER the result has been copied out, because the result is often one of them.
            ReleaseUdtTemps_( c, c.stmtUdtMark )
            EmitCleanupsTo( c, 0 )
            dim as MirValue spa
            spa.kind = cast( ubyte, MV_LOCAL )
            spa.ty = cast( ubyte, MT_PTR )
            spa.id = c.sretParam
            Terminate( c, MTERM_RET, -1, -1, LowerExprLoad( c, spa, MT_PTR ) )
            c.curBlock = -1
            return
        end if

        '' 'return byval p' IN A BYREF-RESULT FUNCTION is the same assignment
        '' 'function = byval p' makes: the pointer's VALUE, stored into the result slot.
        '' LowerExpr produced nothing at all for it.
        ''
        '' ONLY THE 'byval' SPELLING is diverted. An ordinary 'return x' out of a byref
        '' function already lowers, and routing every one of them through the assignment
        '' path changed fourteen goldens -- a blast radius out of all proportion to the
        '' two statements this closes.
        '' EVERY 'return' OUT OF A BYREF FUNCTION GOES THROUGH THE SAME PATH AS
        '' 'function =', and only the 'byval' spelling used to. An ordinary
        '' 'return p' lowered to the pointee's VALUE and returned it where the
        '' declaration promises an ADDRESS -- measured, fbc's C for
        '' 'function pick( ... ) byref as long' is 'int32* PICK( ... )' with
        '' 'fb$result = P$1' and '*vr' at every call site. tiko-lang emitted
        '' 'func ptr PICK' and then 'ret <the loaded long>': a well-typed
        '' function returning the wrong thing, which lowered and verified.
        ''
        '' The note that used to sit here said routing every return through the
        '' assignment path 'changed fourteen goldens -- a blast radius out of all
        '' proportion'. The blast radius was the bug: all fourteen were the same
        '' wrong answer.
        dim as boolean retByval = c.byrefResult andalso (sp->a <> Tko.NODE_NONE)
        if retByval then
            if LowerByrefResult_( c, sp->a ) then
                '' A RETURN'S OWN TEMPORARIES DIE HERE, not at the end of the statement: the
                '' terminator below ends the block, and ReleaseUdtTemps_ refuses to emit into a
                '' dead cursor -- so everything the return expression built was leaked. Measured:
                '' 'function Value( ) as (Counted, long)' returning '( Counted( this.i ), this.i )'
                '' ran two constructors per call and no destructor at all.
                ''
                '' AFTER the result has been copied out, because the result is often one of them.
                ReleaseUdtTemps_( c, c.stmtUdtMark )
                EmitCleanupsTo( c, 0 )
                Terminate( c, MTERM_RET, -1, -1, LoadResult( c ) )
                c.curBlock = -1
                return
            end if
        end if

        dim as MirValue rv
        if sp->a <> Tko.NODE_NONE then
            rv = LowerExpr( c, sp->a )
            '' 'return expr' WHOSE VALUE WOULD NOT LOWER was silent: the terminator
            '' went out with nothing in it and the statement counted as fully lowered,
            '' so a function returned whatever the ABI happened to leave behind. Every
            '' other decline in this file is counted; this one was not.
            if rv.kind = cast( ubyte, MV_NONE ) then SkipHere( c )
            '' TO THE RESULT'S TYPE. 'return expr' coerced nothing at all, so a
            '' narrowing result took whatever width the expression had and the
            '' emitter truncated it: 'function f( i as integer ) as boolean :
            '' return i' answered FALSE for 256, where 'function = i' -- which
            '' does coerce -- answers true. fbc gives true for both.
            if rv.kind <> cast( ubyte, MV_NONE ) then
                dim as MirType rmt = cast( MirType, c.resultTy )
                if (rmt <> MT_VOID) andalso (rmt <> MT_AGG) then
                    rv = CoerceTy( c, rv, rmt, c.info->TypeOf_( sp->a ), c.resultType )
                end if
            end if
        else
            rv = LoadResult( c )
        end if
        '' A RETURN leaves every open scope, so every open scope's actions run,
        '' innermost first, BEFORE the terminator.
        '' A RETURN'S OWN TEMPORARIES DIE HERE, not at the end of the statement: the
        '' terminator below ends the block, and ReleaseUdtTemps_ refuses to emit into a
        '' dead cursor -- so everything the return expression built was leaked. Measured:
        '' 'function Value( ) as (Counted, long)' returning '( Counted( this.i ), this.i )'
        '' ran two constructors per call and no destructor at all.
        ''
        '' AFTER the result has been copied out, because the result is often one of them.
        ReleaseUdtTemps_( c, c.stmtUdtMark )
        EmitCleanupsTo( c, 0 )
        Terminate( c, MTERM_RET, -1, -1, rv )
        '' The cursor goes DEAD rather than opening a block nothing branches to.
        '' Statements after a RETURN are unreachable, and creating a block for them
        '' left the function with an orphan the verifier rightly complained about.
        c.curBlock = -1

    case Tko.N_EXIT
        LowerExitLike( c, id, true )

    case Tko.N_CONTINUE
        LowerExitLike( c, id, false )

    case Tko.N_NAMESPACE, Tko.N_EXTERN_BLOCK
        '' A 'dim shared ... = <init>' INSIDE ONE STILL HAS AN INITIALISER, and
        '' nobody was running it. Both kinds used to sit in the declarations list
        '' below on the grounds that the MODULE WALK handles them -- but WalkTop
        '' lowers N_PROC and nothing else, so a shared variable nested in either got
        '' its storage and NO initialising store at all. Measured:
        ''
        ''     namespace o : dim shared as long a = 7 : end namespace
        ''     print o.a          fbc: 7      tiko: 0
        ''
        '' A WRONG VALUE, silently, in a program that compiles, verifies and links.
        '' The same for 'extern "C"', whose own note in this file claimed it was
        '' handled -- measured, it was not -- and for a NESTED namespace, which is
        '' why this recurses rather than looking one level down.
        ''
        '' ONLY THE DECLARATIONS: neither block may hold anything executable (fbc's
        '' error 96), so every other child is a declaration the module walk owns.
        dim as Tko.StmtPayload ptr nsp = StmtOf( c, id )
        for i as long = 0 to nsp->count - 1
            dim as Tko.NodeId nch = cast( Tko.NodeId, c.ast->children[nsp->first + i] )
            select case c.ast->Kind( nch )
            case Tko.N_VAR, Tko.N_NAMESPACE, Tko.N_EXTERN_BLOCK
                LowerStmt( c, nch )
            end select
        next

    case Tko.N_PROC, Tko.N_TYPE, Tko.N_ENUM, Tko.N_TYPEDEF, _
         Tko.N_CONST, Tko.N_FIELD, Tko.N_PARAM, _
         Tko.N_USING, Tko.N_ASSERT
        '' Declarations: handled by the module walk, not inside a body.
        ''
        '' N_EXTERN_BLOCK belongs here and was declining instead -- 1,238 of them, the
        '' second largest never-started kind. An 'extern "C" ... end extern' can hold
        '' NOTHING EXECUTABLE: measured, both 'print 1' and an assignment inside one are
        '' fbc error 96, "Illegal inside a compound statement or scoped block". What it
        '' may hold is DECLARE, a procedure body, and 'dim shared as T x = 5' -- and a
        '' shared initialiser is part of the global's definition, not a store in main.
        '' So there is nothing for the statement layer to emit, and saying so is not
        '' the same as failing to.

    case Tko.N_ASM
        '' AN EMPTY ASM BLOCK EMITS NOTHING, and that is not a decline. The parser
        '' marks one -- pp/pragma-reserve-7.bas writes a block whose whole body is a
        '' '#if' that yields no tokens -- and a block with real assembly in it has
        '' already been refused there, with a diagnostic.
        if StmtOf( c, id )->extra <> 1 then SkipStmt( c, id )

    case else
        SkipStmt( c, id )
    end select
end sub






end namespace
