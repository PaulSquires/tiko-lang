'' latechecks.bas -- THE SYMBOL-TABLE SWEEPS OF THE POST-CHECK PASS.
''
'' Split out of visibility.bas at the 1500-line lint cap and included from it, inside its
'' own namespace. Nothing in it changed in the move.
''
'' What lives here asks a question of a SYMBOL rather than of a node: does this type's
'' base have a default constructor, is this parameter a fixed-length string, does this
'' shared initialiser name something with a frame. The AST walk stays next door.


'' A FIXED-LENGTH STRING HAS NO PARAMETER FORM AT ALL -- fbc's error 324, "Fixed-length
'' string combined with BYREF (not supported)", and error 59 for the byval spelling.
'' Measured, and the surprise is the third row: writing NEITHER modifier is refused too,
'' so this is not a rule about byref.
''
''     sub f( z as zstring * 10 )          error 324
''     sub f( byref z as zstring * 10 )    error 324
''     sub f( byval z as zstring * 10 )    error 59
''     sub f( byref z as string * 10 )     error 324
''     sub f( byref z as zstring )         OK      -- no length, so not one
'' A STATIC MEMBER VARIABLE IS ONLY ALLOWED IN A TOP-LEVEL UDT -- fbc error 264, "Static
'' member variable in nested UDT". Measured, and "nested" means INSIDE A PROCEDURE and
'' nothing else: a type declared inside another TYPE takes one, and so does a top-level
'' type.
private sub CheckNestedStatics_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        '' A STATIC MEMBER IS AN N_VAR, not an N_FIELD -- it has storage of its own and
        '' no place in the layout -- so its symbol is a VARIABLE living in the TYPE's
        '' scope. Testing SYM_FIELD alone found none of them.
        dim as SymbolKind mk = cast( SymbolKind, s->kind )
        if (mk <> SYM_FIELD) andalso (mk <> SYM_VARIABLE) then continue for
        if (s->flags and (SYMF_STATIC or SYMF_SHARED)) = 0 then continue for
        dim as SymScope ptr sc = c.syms->ScopeAt( s->parent )
        if sc = 0 then continue for
        if sc->kind <> cast( ubyte, SCOPEK_TYPE ) then continue for
        '' The type's OWN declaring scope is what decides, not the field's.
        dim as Symbol ptr owner = c.syms->SymbolAt( sc->owner )
        if owner = 0 then continue for
        dim as boolean inProc = false
        dim as ScopeId cur = owner->parent
        dim as long guard = 0
        while (cur <> SCOPE_NONE) andalso (guard < 1000)
            guard += 1
            dim as SymScope ptr ps = c.syms->ScopeAt( cur )
            if ps = 0 then exit while
            if ps->kind = cast( ubyte, SCOPEK_PROC ) then
                inProc = true
                exit while
            end if
            cur = ps->parent
        wend
        if inProc = false then continue for
        c.diags->Report( TKO0638, PointRange( s->loc ), c.names->Spelling( s->name ) )
    next
end sub

private sub CheckFixLenParams_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        dim as SymbolKind sk = cast( SymbolKind, s->kind )
        '' A PARAMETER, a BYREF VARIABLE and a RESULT TYPE are the same refusal: none of
        '' the three has storage of its own for a fixed-length string to live in.
        '' Measured -- 'dim byref z as zstring * 10 = "hi"' and
        '' 'function f( ) as zstring * 10' are both refused, byref result or not.
        dim as boolean interesting = (sk = SYM_PARAMETER) orelse (sk = SYM_PROC)
        if (interesting = false) andalso (sk = SYM_VARIABLE) then
            interesting = ((s->flags and SYMF_BYREF) <> 0)
        end if
        if interesting = false then continue for
        if s->type_ = TYPE_NONE then continue for
        dim as TypeId u = c.types->Unqualify( s->type_ )
        '' A REFERENCE parameter carries the reference; the fixed string is inside it.
        if c.types->Kind( u ) = TK_REFERENCE then
            u = c.types->Unqualify( c.types->Inner( u ) )
        end if
        '' A FIXED-LENGTH string is an ARRAY of a character builtin -- that is what
        '' distinguishes it from the plain 'zstring' a byref parameter may take.
        if c.types->Kind( u ) <> TK_ARRAY then continue for
        dim as TypeId el = c.types->Unqualify( c.types->Inner( u ) )
        if el = TYPE_NONE then continue for
        if c.types->Kind( el ) <> TK_BUILTIN then continue for
        '' TY_STRING IS EXCLUDED, and that is the whole difference between a
        '' fixed-length string and an ARRAY OF STRINGS. 'string * N' is an array of
        '' TY_FIXSTR and 'zstring * N' one of TY_ZSTRING, while 'buf( ) as T' with T
        '' instantiated as a string is an array of TY_STRING -- fb/sort.bi's
        '' SortMergeBy writes one, and refusing it turned generics/container-sort.bas,
        '' which fbc accepts, into an error.
        select case c.types->BuiltinOf( el )
        case TY_ZSTRING, TY_WSTRING, TY_USTRING, TY_FIXSTR, TY_FIXUSTR
        case else
            continue for
        end select
        c.diags->Report( TKO0636, PointRange( s->loc ), c.names->Spelling( s->name ) )
    next
end sub

'' A SHARED VARIABLE'S INITIALISER RUNS BEFORE ANY FRAME EXISTS, so it may not name one
'' that is not shared -- fbc error 272, "Local symbols can't be referenced". Measured:
''
''     static as integer i
''     dim shared as integer ptr pi = @i     error 272
''
'' 'static' STORAGE IS NOT ENOUGH: that variable outlives the frame, and fbc still calls
'' it local. What the initialiser may name is a SHARED one, so the test is on SYMF_SHARED
'' of what is referenced and not on "does it have automatic storage".
private sub CheckSharedRef_ ( byref c as Ctx, byval id as NodeId, byval vnm as InternId )
    if id = NODE_NONE then return
    dim as NodeKind k = c.ast->Kind( id )
    if k = N_IDENT then
        dim as Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( id ) )
        if s = 0 then return
        if s->kind <> cast( ubyte, SYM_VARIABLE ) then return
        if (s->flags and (SYMF_SHARED or SYMF_EXTERN or SYMF_COMMON)) <> 0 then return
        c.diags->Report( TKO0640, PointRange( c.ast->Loc( id ) ), _
                         c.names->Spelling( s->name ) )
        return
    end if
    '' The same narrow set of shapes CheckAutoRef_ walks, for the same reason.
    select case k
    case N_BINARY
        dim as BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        CheckSharedRef_( c, bp->lhs, vnm )
        CheckSharedRef_( c, bp->rhs, vnm )
    case N_UNARY, N_ADDROF, N_DEREF
        dim as UnaryPayload ptr up = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        CheckSharedRef_( c, up->operand, vnm )
    case N_PAREN, N_TUPLE, N_INITIALIZER
        dim as ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        for i as long = 0 to lp->count - 1
            CheckSharedRef_( c, cast( NodeId, c.ast->children[lp->first + i] ), vnm )
        next
    end select
end sub

'' A BYREF BINDING NEEDS SOMETHING WITH AN ADDRESS, and it needs one at all. Measured:
''
''     dim byref i as integer = 1          error 24     a literal has no address
''     var byref i = f( )                  error 24     nor does a call's RESULT
''     dim byref i as integer = g + 1      error 3      nor an arithmetic expression
''     dim byref i as integer              error 320    and it may not be left unbound
''     dim byref i as integer = g          OK
''     dim byref i as integer = g( 0 )     OK           an element has one
''
'' ONLY THE SHAPES THAT CERTAINLY HAVE NO ADDRESS are reported -- a literal and a call to
'' a PROCEDURE. An indexing expression looks exactly like a call and is an lvalue, which
'' is what the target's symbol kind tells apart.
'' AN ARRAY NAME WITHOUT A SUBSCRIPT IS NOT A VALUE -- fbc error 73, "Array access, index
'' expected". Measured:
''
''     print a            error 73        a( 0 to 3 )
''     draw a             error 73
''     dim n as integer = a               error 73
''     print a( 0 )       OK
''
'' CHECKED AT THE SITES THAT CERTAINLY NEED A VALUE, and nowhere else. 'erase a',
'' 'redim a( ... )', 'lbound( a )' and a BYDESC argument all take the bare name and are
'' the ordinary way to write one -- a blanket rule over every N_IDENT would refuse them
'' all. So: a binary operand, a declaration's initialiser, and the two intrinsics the
'' corpus asserts.
private function IsBareArray_ ( byref c as Ctx, byval n as NodeId ) as boolean
    if n = NODE_NONE then return false
    if c.ast->Kind( n ) <> N_IDENT then return false
    dim as Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( n ) )
    if s = 0 then return false
    if s->kind <> cast( ubyte, SYM_VARIABLE ) then return false
    if s->type_ = TYPE_NONE then return false
    dim as TypeId u = c.types->Unqualify( s->type_ )
    if c.types->Kind( u ) <> TK_ARRAY then return false
    '' A FIXED-LENGTH STRING IS NOT AN ARRAY HERE, though it is one in the type table:
    '' 'zstring * N' and 'wstring * N' are arrays of a character builtin, and comparing
    '' two of them is ordinary. Counting them refused six files fbc accepts --
    '' functions/argv.bas and the five wstring/utf*.bas.
    dim as TypeId el = c.types->Unqualify( c.types->Inner( u ) )
    if el <> TYPE_NONE then
        if c.types->Kind( el ) = TK_BUILTIN then
            select case c.types->BuiltinOf( el )
            case TY_STRING, TY_ZSTRING, TY_WSTRING, TY_USTRING, TY_FIXSTR, TY_FIXUSTR
                return false
            end select
        end if
    end if
    return true
end function

private sub CheckBareArrayOperands_ ( byref c as Ctx, byval id as NodeId )
    dim as BinaryPayload ptr bp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
    if IsBareArray_( c, bp->lhs ) then
        c.diags->Report( TKO0649, PointRange( c.ast->Loc( bp->lhs ) ) )
        return
    end if
    if IsBareArray_( c, bp->rhs ) then
        c.diags->Report( TKO0649, PointRange( c.ast->Loc( bp->rhs ) ) )
    end if
end sub

private sub CheckBareArrayPrint_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as TokenKind k = cast( TokenKind, sp->op )
    if (k <> KW_PRINT) andalso (k <> KW_DRAW) then return
    for i as long = 0 to sp->count - 1
        dim as NodeId a2 = cast( NodeId, c.ast->children[sp->first + i] )
        if IsBareArray_( c, a2 ) = false then continue for
        c.diags->Report( TKO0649, PointRange( c.ast->Loc( a2 ) ) )
        return
    next
end sub

'' AN ABSTRACT METHOD HAS NO BODY -- fbc error 224, "Implemented body for an ABSTRACT
'' method". The declaration says there is nothing to call.
''
'' OVER THE AST, not the symbol table: the DEFINITION joins its DECLARE, and the symbol's
'' payload stays the DECLARATION node -- which has no body, so the symbol sweep saw none.
private sub CheckAbstractBody_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if (sp->extra and PF_ABSTRACT) = 0 then return
    if sp->b = NODE_NONE then return
    c.diags->Report( TKO0646, PointRange( c.ast->Loc( id ) ), _
                     c.names->Spelling( sp->name ) )
end sub

'' 'virtual' NEEDS A VTABLE, and only a type that extends OBJECT has one -- fbc error
'' 221, "Method declared VIRTUAL, but UDT does not extend OBJECT". 'abstract' implies
'' virtual and is the same refusal.
''
'' AND AN ABSTRACT METHOD HAS NO BODY -- fbc error 224, "Implemented body for an ABSTRACT
'' method". The declaration says there is nothing to call.
private function ExtendsObject_ ( byref c as Ctx, byval t as TypeId ) as boolean
    dim as InternId objNm = c.names->Fold( c.names->GetString( "object" ) )
    dim as TypeId cur = t
    dim as long guard = 0
    while (cur <> TYPE_NONE) andalso (guard < 64)
        guard += 1
        if c.names->Fold( c.types->NameOf( cur ) ) = objNm then return true
        cur = BaseOf_( c, cur )
    wend
    return false
end function

private sub CheckVirtualNeedsObject_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_PROC ) then continue for
        dim as NodeId decl = cast( NodeId, s->payload )
        if decl = NODE_NONE then continue for
        if c.ast->Kind( decl ) <> N_PROC then continue for
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, decl )].data )]
        dim as boolean isAbstract = ((sp->extra and PF_ABSTRACT) <> 0)
        dim as boolean isVirtual = ((sp->extra and PF_VIRTUAL) <> 0) orelse isAbstract
        if isVirtual = false then continue for
        '' 'operator new' AND ITS THREE SIBLINGS ARE IMPLICITLY STATIC, so neither
        '' modifier may be written on them -- fbc error 233, "This operator is implicitly
        '' STATIC and cannot be VIRTUAL or ABSTRACT". They allocate the object; there is
        '' no receiver yet to dispatch through.
        dim as string opnm = Text.LowerAscii( c.names->Spelling( s->name ) )
        dim as boolean allocOp = (opnm = "new") orelse (opnm = "delete") orelse _
                                 (opnm = "new[]") orelse (opnm = "delete[]")
        if allocOp then
            c.diags->Report( TKO0647, PointRange( c.ast->Loc( decl ) ) )
            continue for
        end if
        dim as SymScope ptr sc = c.syms->ScopeAt( s->parent )
        if sc = 0 then continue for
        if sc->kind <> cast( ubyte, SCOPEK_TYPE ) then continue for
        dim as Symbol ptr owner = c.syms->SymbolAt( sc->owner )
        if owner = 0 then continue for
        if owner->type_ = TYPE_NONE then continue for
        if ExtendsObject_( c, owner->type_ ) then continue for
        c.diags->Report( TKO0645, PointRange( c.ast->Loc( decl ) ), _
                         c.names->Spelling( s->name ) )
    next
end sub

'' A 'const' DECLARATION MAY NOT CROSS THE STRING/NUMBER DIVIDE -- fbc error 20 one way
'' and 24 the other. Measured:
''
''     const s as string = 1       error 20
''     const s as integer = "x"    error 24
''     const s as string = "x"     OK
''     const s as double = 1       OK        widening within the numbers is fine
''
'' NARROWED TO THAT ONE DIVIDE deliberately: everything numeric converts to everything
'' numeric in a constant, and answering which narrowings fbc also refuses is a separate
'' measurement.
private function IsStringyType_ ( byref c as Ctx, byval t as TypeId ) as boolean
    if t = TYPE_NONE then return false
    dim as TypeId u = c.types->Unqualify( t )
    '' A FIXED-LENGTH string is an ARRAY of a character builtin, and counts.
    dim as long guard = 0
    while (c.types->Kind( u ) = TK_ARRAY) andalso (guard < 16)
        guard += 1
        u = c.types->Unqualify( c.types->Inner( u ) )
    wend
    if c.types->Kind( u ) <> TK_BUILTIN then return false
    select case c.types->BuiltinOf( u )
    case TY_STRING, TY_ZSTRING, TY_WSTRING, TY_USTRING, TY_FIXSTR, TY_FIXUSTR
        return true
    end select
    return false
end function

'' A BASE WITH NO DEFAULT CONSTRUCTOR CANNOT BE INITIALISED FOR YOU -- fbc errors 186 and
'' 188, "base UDT without default constructor requires manual initialization". Measured:
''
''     base declares constructor( byval as integer ) only,
''       derived declares a constructor                    error 188
''       derived declares none                             error 186
''     base declares constructor( ) as well                OK
''     base declares NO constructor at all                 OK -- the implicit one
''
'' What makes it an error is the base HAVING constructors and none of them being callable
'' with no argument: there is then nothing the derived type's own construction can call.
'' AN 'extern' OR 'common' VARIABLE CANNOT BE INITIALISED -- fbc error 135. Both are
'' declarations of storage that belongs to another module, so there is nothing here to
'' write into. Measured: 'extern a as integer = 1' and 'common shared a as integer = 1'
'' are refused, and the same declarations without an initialiser are fine.
''
'' AND A UDT WHOSE CONSTRUCTORS INCLUDE NO DEFAULT ONE cannot be declared without an
'' initialiser -- fbc error 183, "TYPE or CLASS has no default constructor". The same
'' rule as a base's, one level down: 'dim as T x' has nothing to call, while
'' 'dim as T x = T( 1 )' names what to call.
private sub CheckExternInitAndDefaultCtor_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_VARIABLE ) then continue for
        if s->payload = 0 then continue for
        dim as NodeId item = cast( NodeId, s->payload )
        if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
        dim as StmtPayload ptr ip = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]

        if ip->b <> NODE_NONE then
            '' A STATIC MEMBER IS REALLY AN EXTERN -- its storage lives outside the type
            '' and is defined elsewhere -- so 'static i as integer = 1' inside a TYPE is
            '' fbc error 135 just as a plain extern is. dim/member-var-bad-1.bas says so
            '' in its own comment.
            dim as boolean staticMember = false
            if (s->flags and SYMF_STATIC) <> 0 then
                dim as SymScope ptr ms = c.syms->ScopeAt( s->parent )
                if ms <> 0 then
                    staticMember = (ms->kind = cast( ubyte, SCOPEK_TYPE ))
                end if
            end if
            if ((s->flags and (SYMF_EXTERN or SYMF_COMMON)) <> 0) orelse staticMember then
                c.diags->Report( TKO0656, PointRange( c.ast->Loc( item ) ), _
                                 c.names->Spelling( s->name ) )
            end if
            '' An INITIALISED declaration names what to construct, so the default
            '' constructor is not what it calls.
            continue for
        end if

        if s->type_ = TYPE_NONE then continue for
        dim as TypeId u = c.types->Unqualify( s->type_ )
        dim as long guard = 0
        while (c.types->Kind( u ) = TK_ARRAY) andalso (guard < 16)
            guard += 1
            u = c.types->Unqualify( c.types->Inner( u ) )
        wend
        if c.types->Kind( u ) <> TK_UDT then continue for
        dim as Symbol ptr ct = StructorOf_( c, u, "__ctor" )
        '' NO CONSTRUCTOR AT ALL is fine: the implicit default one is always callable.
        if ct = 0 then continue for
        dim as boolean sawDefault = false
        dim as Symbol ptr walk = ct
        dim as long g2 = 0
        while (walk <> 0) andalso (g2 < 1000)
            g2 += 1
            dim as long req = RequiredParams_( c, cast( NodeId, walk->payload ) )
            if (req = 0) orelse (req = -1) then
                sawDefault = true
                exit while
            end if
            walk = c.syms->SymbolAt( walk->nextOverload )
        wend
        if sawDefault then continue for
        c.diags->Report( TKO0657, PointRange( c.ast->Loc( item ) ), _
                         c.names->Spelling( s->name ) )
    next
end sub

'' A DYNAMIC ARRAY CANNOT BE A MEMBER OF A UNION -- fbc error 162, "Dynamic arrays cannot
'' be part of UNION's or nested TYPE's". A dynamic array is a DESCRIPTOR that has to be
'' constructed and destroyed, and a union's members overlap: there is no way to say which
'' of them owns the storage.
private sub CheckDynArrayInUnion_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_FIELD ) then continue for
        if s->type_ = TYPE_NONE then continue for
        dim as TypeId u = c.types->Unqualify( s->type_ )
        if c.types->Kind( u ) <> TK_ARRAY then continue for
        '' A DYNAMIC array records a NEGATIVE rank, and its magnitude is rank + 1: -1 is
        '' 'dim a( )', -2 is 'a( any )', -3 is 'a( any, any )'. Testing for -1 alone found
        '' only the unspecified form and missed every one the corpus writes.
        if c.types->types[cast( long, u )].dims >= 0 then continue for

        '' Either the field's immediate enclosing aggregate is a UNION -- which is what
        '' SYMF_UNION records for an anonymous one -- or the named type it sits in is.
        dim as boolean inUnion = ((s->flags and SYMF_UNION) <> 0)
        if inUnion = false then
            dim as SymScope ptr sc = c.syms->ScopeAt( s->parent )
            if sc = 0 then continue for
            if sc->kind <> cast( ubyte, SCOPEK_TYPE ) then continue for
            dim as Symbol ptr owner = c.syms->SymbolAt( sc->owner )
            if owner = 0 then continue for
            inUnion = ((owner->flags and SYMF_UNION_KIND) <> 0)
        end if
        if inUnion = false then continue for
        c.diags->Report( TKO0659, PointRange( s->loc ), c.names->Spelling( s->name ) )
    next
end sub

private sub CheckBaseHasDefaultCtor_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_UDT ) then continue for
        if s->type_ = TYPE_NONE then continue for
        dim as TypeId base_ = BaseOf_( c, s->type_ )
        if base_ = TYPE_NONE then continue for
        dim as Symbol ptr bc = StructorOf_( c, base_, "__ctor" )
        '' NO CONSTRUCTOR AT ALL is fine: the implicit default one is always callable.
        if bc = 0 then continue for
        dim as boolean sawDefault = false
        dim as Symbol ptr walk = bc
        dim as long guard = 0
        while (walk <> 0) andalso (guard < 1000)
            guard += 1
            dim as long req = RequiredParams_( c, cast( NodeId, walk->payload ) )
            '' A declaration that cannot be read is counted as a default rather than
            '' against one: not knowing is not grounds for refusing.
            if (req = 0) orelse (req = -1) then
                sawDefault = true
                exit while
            end if
            walk = c.syms->SymbolAt( walk->nextOverload )
        wend
        if sawDefault then continue for
        c.diags->Report( TKO0654, PointRange( s->loc ), c.names->Spelling( s->name ) )
    next
end sub

private sub CheckConstDeclTypes_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        '' A VARIABLE IS THE SAME QUESTION: 'dim s as string = 1' and
        '' 'dim n as integer = "x"' are both fbc error 24.
        dim as SymbolKind ck = cast( SymbolKind, s->kind )
        if (ck <> SYM_CONSTANT) andalso (ck <> SYM_VARIABLE) then continue for
        if (s->flags and SYMF_BUILTIN) <> 0 then continue for
        if s->payload = 0 then continue for
        dim as NodeId item = cast( NodeId, s->payload )
        if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
        dim as StmtPayload ptr ip = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
        '' A DECLARED TYPE is what makes the question askable: 'const K = 1' takes its
        '' type from the value and can never disagree with it.
        if ip->a = NODE_NONE then continue for
        if ip->b = NODE_NONE then continue for
        dim as TypeId dt = c.info->TypeOf_( ip->a )
        dim as TypeId vt = c.info->TypeOf_( ip->b )
        if (dt = TYPE_NONE) orelse (vt = TYPE_NONE) then continue for
        '' A UDT ON EITHER SIDE IS NOT THIS QUESTION. 'dim x as U = "abc"' over a type
        '' with a constructor taking a string, or an 'operator let' from one, is an
        '' ordinary conversion -- and counting it broke four of this suite's own MIR
        '' tests, which exist to check exactly that construction.
        if c.types->Kind( c.types->Unqualify( dt ) ) = TK_UDT then continue for
        if c.types->Kind( c.types->Unqualify( vt ) ) = TK_UDT then continue for
        if IsStringyType_( c, dt ) = IsStringyType_( c, vt ) then continue for
        c.diags->Report( TKO0653, PointRange( c.ast->Loc( item ) ), _
                         c.names->Spelling( s->name ) )
    next
end sub

private sub CheckByrefBinding_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_VARIABLE ) then continue for
        if (s->flags and SYMF_BYREF) = 0 then continue for
        if s->payload = 0 then continue for
        dim as NodeId item = cast( NodeId, s->payload )
        if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
        dim as StmtPayload ptr ip = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
        if ip->b = NODE_NONE then
            c.diags->Report( TKO0644, PointRange( s->loc ), c.names->Spelling( s->name ) )
            continue for
        end if
        dim as NodeId init = ip->b
        dim as boolean noAddress = false
        select case c.ast->Kind( init )
        '' A STRING LITERAL IS NOT IN THIS SET. It lives in the data segment and has an
        '' address of its own -- 'var byref i = "abc"' and 'dim byref rz as zstring =
        '' "foo"' are both accepted, and counting them refused two files fbc takes.
        case N_INT_LIT, N_FLOAT_LIT
            noAddress = true
        case N_CALL
            dim as ListPayload ptr lp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, init )].data )]
            dim as Symbol ptr ts = c.syms->SymbolAt( c.info->RefOf( lp->target ) )
            if ts <> 0 then
                noAddress = (ts->kind = cast( ubyte, SYM_PROC ))
                '' ...UNLESS IT RETURNS BYREF. That result IS a reference, and binding
                '' one to it is the whole point -- 'dim byref as long r = o.Value( )' in
                '' generics/container-optional.bas is exactly that.
                if noAddress then
                    dim as NodeId cd = cast( NodeId, ts->payload )
                    if (cd <> NODE_NONE) andalso (c.ast->Kind( cd ) = N_PROC) then
                        if (c.ast->nodes[cast( long, cd )].flags and NF_BYREF) <> 0 then
                            noAddress = false
                        end if
                    end if
                end if
            end if
        end select
        if noAddress = false then continue for
        c.diags->Report( TKO0643, PointRange( c.ast->Loc( init ) ), _
                         c.names->Spelling( s->name ) )
    next
end sub

private sub CheckSharedInits_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_VARIABLE ) then continue for
        if (s->flags and SYMF_SHARED) = 0 then continue for
        if s->payload = 0 then continue for
        dim as NodeId item = cast( NodeId, s->payload )
        if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
        dim as StmtPayload ptr ip = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
        if ip->b = NODE_NONE then continue for
        CheckSharedRef_( c, ip->b, s->name )
    next
end sub

'' THE COPY CONSTRUCTOR -- the '__ctor' overload whose one required parameter is a
'' reference to the type itself. A private one is what stops a type being copied, which is
'' the point of declaring one.
private sub CheckCopyStructor_ _
    ( byref c as Ctx, byval udt as TypeId, byval here as TypeId, _
      byval at as SourceLoc, byval vnm as InternId )

    dim as Symbol ptr st = StructorOf_( c, udt, "__ctor" )
    if st = 0 then return
    dim as boolean sawCopy = false
    dim as Symbol ptr walk = st
    dim as long guard = 0
    while (walk <> 0) andalso (guard < 1000)
        guard += 1
        dim as NodeId decl = cast( NodeId, walk->payload )
        if (decl <> NODE_NONE) andalso (c.ast->Kind( decl ) = N_PROC) then
            if RequiredParams_( c, decl ) = 1 then
                dim as StmtPayload ptr sp = _
                    @c.ast->stmts[cast( long, c.ast->nodes[cast( long, decl )].data )]
                for i as long = 0 to sp->count - 1
                    dim as NodeId prm = cast( NodeId, c.ast->children[sp->first + i] )
                    if c.ast->Kind( prm ) <> N_PARAM then continue for
                    dim as StmtPayload ptr psp = _
                        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, prm )].data )]
                    dim as TypeId pt = c.types->Unqualify( c.info->TypeOf_( psp->a ) )
                    if pt = TYPE_NONE then exit for
                    if c.types->Kind( pt ) = TK_REFERENCE then
                        pt = c.types->Unqualify( c.types->Inner( pt ) )
                    end if
                    if pt <> udt then exit for
                    sawCopy = true
                    if StructorReachable_( c, walk, udt, here ) then return
                    exit for
                next
            end if
        end if
        walk = c.syms->SymbolAt( walk->nextOverload )
    wend
    if sawCopy = false then return
    c.diags->Report( TKO0633, PointRange( at ), c.names->Spelling( vnm ) )
end sub

private sub CheckImplicitStructors_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        dim as SymbolKind k = cast( SymbolKind, s->kind )
        if (k <> SYM_VARIABLE) andalso (k <> SYM_FIELD) then continue for
        if s->type_ = TYPE_NONE then continue for
        '' An ARRAY of them constructs every element; a POINTER constructs nothing.
        dim as TypeId u = c.types->Unqualify( s->type_ )
        dim as long guard = 0
        while (c.types->Kind( u ) = TK_ARRAY) andalso (guard < 16)
            guard += 1
            u = c.types->Unqualify( c.types->Inner( u ) )
        wend
        if c.types->Kind( u ) <> TK_UDT then continue for
        '' THE BASE FIELD IS THE 'extends', not a declaration of one: a derived type
        '' constructs its base whatever the base's constructor says.
        if (k = SYM_FIELD) andalso (s->name = c.baseName) then continue for
        dim as TypeId here = EnclosingTypeOf_( c, s->parent )
        '' 'dim x2 as UDT = x1' CALLS THE COPY CONSTRUCTOR, not the default one, and a
        '' private copy constructor is what stops a type being copied at all -- which is
        '' the point of declaring one. So which structor to look at depends on whether
        '' the declaration was INITIALISED FROM ANOTHER OF ITS OWN TYPE.
        dim as boolean copies = false
        if s->payload <> 0 then
            dim as NodeId it2 = cast( NodeId, s->payload )
            if c.ast->Kind( it2 ) = N_VAR_ITEM then
                dim as StmtPayload ptr ip2 = _
                    @c.ast->stmts[cast( long, c.ast->nodes[cast( long, it2 )].data )]
                '' A COPY IS FROM A NAME, not from a CONSTRUCTION. 'dim as ComInit
                '' wrong = ComInit( COINIT_MULTITHREADED )' builds the object directly
                '' and calls no copy constructor -- fbc accepts it, and treating it as
                '' a copy refused com/comptr-companions.bas.
                dim as boolean fromName = false
                if ip2->b <> NODE_NONE then
                    select case c.ast->Kind( ip2->b )
                    case N_IDENT, N_MEMBER, N_DEREF
                        fromName = true
                    end select
                end if
                if fromName then
                    dim as TypeId it = c.info->TypeOf_( ip2->b )
                    if it <> TYPE_NONE then
                        copies = (c.types->Unqualify( it ) = u)
                    end if
                end if
            end if
        end if
        if copies then
            CheckCopyStructor_( c, u, here, s->loc, s->name )
        else
            CheckOneStructor_( c, u, "__ctor", here, s->loc, s->name )
        end if
        CheckOneStructor_( c, u, "__dtor", here, s->loc, s->name )
    next
end sub
