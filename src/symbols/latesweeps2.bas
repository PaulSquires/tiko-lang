'' latesweeps2.bas -- MORE POST-CHECK SWEEPS, each measured against fbc first.
''
'' Included from visibility.bas after byrefcheck.bas, inside its namespace, so every helper
'' there (StructorOf_, RequiredParams_, DerivesFrom_, IsStringyType_, TupleLike_) is to
'' hand. WalkExtra_ is called once per node from Walk_; RunLateSweeps2_ once from Run.

'' The UDT symbol behind a type, or 0.
private function UdtSymbolOf_ ( byref c as Ctx, byval udt as TypeId ) as Symbol ptr
    if udt = TYPE_NONE then return 0
    if c.types->Kind( udt ) <> TK_UDT then return 0
    dim as InternId tn = c.types->NameOf( udt )
    if tn = 0 then return 0
    dim as ScopeId ds = cast( ScopeId, c.types->DeclScopeOf( udt ) )
    dim as SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    return c.syms->SymbolAt( ts )
end function

'' Does the type, or any base of it, declare a procedure of this name? Its presence may
'' make a conversion legal, so it is a reason to decline, never to report. A GENERIC or a
'' TUPLE is declined outright: neither is measured here.
private function DeclaresAnywhere_ _
    ( byref c as Ctx, byval udt as TypeId, byref nm as string ) as boolean
    dim as TypeId t = udt
    dim as long guard = 0
    while (t <> TYPE_NONE) andalso (guard < 64)
        guard += 1
        if c.types->Kind( t ) <> TK_UDT then return true
        dim as string tn = c.names->Spelling( c.types->NameOf( t ) )
        if (instr( tn, "<" ) > 0) orelse (instr( tn, "(" ) > 0) then return true
        if TupleLike_( c, t ) then return true
        if StructorOf_( c, t, nm ) <> 0 then return true
        t = BaseOf_( c, t )
    wend
    return false
end function

'' WHICH DECLARATION RESCUES WHICH FORM. Measured, each way:
''     b = 1     with 'constructor( byval i as integer )' on AA     error 181  still
''     b = 1     with 'operator let( byval i as integer )' on AA    OK
''     b = d     with 'constructor( byref r as BB )' on AA          error 181  still
''     dim b as AA = 1   with the constructor                       OK
''     dim b as AA = d   with 'operator let( byref r as BB )'       error 24   still
''     i = b / dim i as integer = b   with 'operator cast( ) as integer' on AA   OK
'' So an ASSIGNMENT is rescued by a LET on the destination or a CAST on the source, an
'' INITIALISER by a CONSTRUCTOR on the destination or a CAST on the source.
private function Rescued_ _
    ( byref c as Ctx, byval dst as TypeId, byval src as TypeId, _
      byval byAssign as boolean ) as boolean
    if c.types->Kind( dst ) = TK_UDT then
        if byAssign then
            if DeclaresAnywhere_( c, dst, "let" ) then return true
        else
            if DeclaresAnywhere_( c, dst, "__ctor" ) then return true
        end if
    end if
    if c.types->Kind( src ) = TK_UDT then
        if DeclaresAnywhere_( c, src, "cast" ) then return true
    end if
    return false
end function

'' Strip a reference; a fixed string stays what it is.
private function ValueType_ ( byref c as Ctx, byval t as TypeId ) as TypeId
    if t = TYPE_NONE then return TYPE_NONE
    dim as TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) = TK_REFERENCE then u = c.types->Unqualify( c.types->Inner( u ) )
    return u
end function

'' AN OPERATOR INVOKED IMPLICITLY IS STILL A MEMBER ACCESS -- fbc error 202, "Illegal
'' member access". The name is never written at the use site, so CheckMember_ has nothing
'' to bind and every one of these went through. Measured, private and protected alike,
'' one corpus file per shape:
''
''     x += x        a compound assignment    operator +=
''     @x            the address-of operator  operator @
''     new T         allocation               operator new    (and its constructor, 204)
''     delete p      deallocation             operator delete
''     i = x         a conversion             operator cast   (destination NOT a UDT)
''     for i as T    a UDT counter            operator for, next and step -- all three
''
'' ...and the reverse of each, with the operator PUBLIC, compiles. A UNARY ARITHMETIC
'' operator is not in this set at all: 'declare operator -( ) as T' inside a type is fbc
'' error 153, "Operator cannot be a member function", so only '@' is read from N_ADDROF.
''
'' ANY REACHABLE OVERLOAD IS ENOUGH -- the whole chain is walked, exactly as
'' CheckOneStructor_ walks a constructor's -- and a type declaring no such operator at all
'' is not this question and is left alone.
private sub RequireOperator_ _
    ( byref c as Ctx, byval udt as TypeId, byref nm as string, byval here as TypeId, _
      byval at as NodeId )
    dim as TypeId u = ValueType_( c, udt )
    if u = TYPE_NONE then return
    if c.types->Kind( u ) <> TK_UDT then return
    dim as Symbol ptr st = StructorOf_( c, u, nm )
    if st = 0 then return
    dim as Symbol ptr walk = st
    dim as long guard = 0
    while (walk <> 0) andalso (guard < 1000)
        guard += 1
        if StructorReachable_( c, walk, u, here ) then return
        walk = c.syms->SymbolAt( walk->nextOverload )
    wend
    c.diags->Report( TKO0746, PointRange( c.ast->Loc( at ) ), "operator " & nm, _
                     c.names->Spelling( c.types->NameOf( u ) ) )
end sub

'' A UDT MEETS SOMETHING IT DOES NOT CONVERT TO -- fbc error 181 by assignment and 24 by
'' initialiser. Measured, over types declaring no constructor and no operator:
''
''     d = b        derived  <- base          181      b = d    base <- derived    OK
''     x = y        two unrelated UDTs        181      b = 1    UDT <- integer     181
''     i = b        integer <- UDT            181      s = b    string <- UDT      181
''     p = b        ptr <- UDT                181      b = p    UDT <- any ptr     181
''     dim as AA x = type<BB>( 1, 2, 3 )      24       dim as AA x = 1            24
''     dim as integer i = b                   24       dim d as BB = b (base)     24
''
'' ...and every one of them is accepted again as soon as either type declares a
'' constructor, an 'operator let' or an 'operator cast' -- so any of those declines the
'' whole question. A bare parenthesised aggregate '( 1, 2 )' is an initialiser list, not
'' a value, and is not judged; 'type<B>( ... )' is.
'' 'this' IS NOT A CONVERSION QUESTION. tiko-lang types the receiver as a POINTER --
'' that is what the ABI passes -- so 'dim as S r = this' and 'r = this' inside a method
'' look like a UDT meeting a pointer and were both refused, while fbc compiles them as the
'' ordinary copy of the object they are. Measured: 'dim as S r = this', 'r = this',
'' '@this', 'this.field' and 'g( this )' are ALL accepted by fbc.
''
'' Found by a DIFFERENTIAL scan of two builds over the corpus, not by the id scan that
'' cleared the rule when it landed: that one confirms a suspected false rejection by
'' recompiling with fbc and DID NOT PASS fbc THE INCLUDE PATH, so every file needing
'' fbcunit/inc failed under fbc and was dropped from the report instead of counted.
private function EitherIsThis_ _
    ( byref c as Ctx, byval a as NodeId, byval b as NodeId ) as boolean
    if IsThisBase_( c, a ) then return true
    if IsThisBase_( c, b ) then return true
    return false
end function

private sub JudgeConversion_ _
    ( byref c as Ctx, byval at as NodeId, byval lt as TypeId, byval rt as TypeId, _
      byval byAssign as boolean )
    dim as TypeId lu = ValueType_( c, lt )
    dim as TypeId ru = ValueType_( c, rt )
    if (lu = TYPE_NONE) orelse (ru = TYPE_NONE) then return
    dim as TypeKind lk = c.types->Kind( lu )
    dim as TypeKind rk = c.types->Kind( ru )
    dim as boolean lUdt = (lk = TK_UDT)
    dim as boolean rUdt = (rk = TK_UDT)
    if (lUdt orelse rUdt) = false then return
    if lu = ru then return
    if lUdt andalso rUdt then
        if DerivesFrom_( c, ru, lu ) then return
        if Rescued_( c, lu, ru, byAssign ) then return
        c.diags->Report( TKO0738, PointRange( c.ast->Loc( at ) ) )
        return
    end if
    '' One side a UDT, the other a scalar builtin or a pointer. A fixed string, an
    '' array, an enum and a procedure type are not measured.
    dim as TypeId other = ru
    dim as TypeId udt = lu
    if rUdt then other = lu : udt = ru
    dim as TypeKind ok = c.types->Kind( other )
    if (ok <> TK_BUILTIN) andalso (ok <> TK_POINTER) then return
    if ok = TK_BUILTIN then
        select case c.types->BuiltinOf( other )
        case TY_ANY, TY_FIXSTR, TY_FIXUSTR
            return
        end select
    end if
    if Rescued_( c, lu, ru, byAssign ) then return
    c.diags->Report( TKO0738, PointRange( c.ast->Loc( at ) ) )
end sub

private sub CheckUdtAssign_ ( byref c as Ctx, byval id as NodeId )
    if c.info->AmbiguousOf( id ) <> AMB_ASSIGN then return
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cast( TokenKind, sp->op ) <> TK_EQ then return
    if (sp->a = NODE_NONE) orelse (sp->b = NODE_NONE) then return
    '' A PROPERTY on the left is a call, and its setter's parameter is not measured.
    dim as Symbol ptr ls = c.syms->SymbolAt( c.info->RefOf( sp->a ) )
    if (ls <> 0) andalso (ls->kind = cast( ubyte, SYM_PROC )) then return
    '' ONLY A PLAIN LVALUE ON THE LEFT: 'let( a, b ) = x' unpacks and is its own rule,
    '' and 'this = other' assigns the object, which tiko-lang types as a POINTER.
    select case c.ast->Kind( sp->a )
    case N_IDENT, N_MEMBER, N_INDEX, N_CALL, N_UNARY
    case else
        return
    end select
    if EitherIsThis_( c, sp->a, sp->b ) then return
    '' AN INTRINSIC ON THE RIGHT -- 'iif( cond, base, derived )' -- has a type of its own
    '' making, judged by the iif rule; a call that binds no symbol is not this question.
    if c.ast->Kind( sp->b ) = N_CALL then
        dim as ListPayload ptr rl = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, sp->b )].data )]
        if c.info->RefOf( rl->target ) = SYMBOL_NONE then return
    end if
    JudgeConversion_( c, id, c.info->TypeOf_( sp->a ), c.info->TypeOf_( sp->b ), true )
end sub

private sub CheckUdtInits_ ( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_VARIABLE ) then continue for
        if (s->flags and SYMF_BYREF) <> 0 then continue for
        if s->type_ = TYPE_NONE then continue for
        if s->payload = 0 then continue for
        dim as NodeId item = cast( NodeId, s->payload )
        if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
        dim as StmtPayload ptr ip = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
        if ip->b = NODE_NONE then continue for
        '' A DECLARED TYPE ONLY: 'var x = y' takes y's type and converts nothing.
        if ip->a = NODE_NONE then continue for
        if IsThisBase_( c, ip->b ) then continue for
        select case c.ast->Kind( ip->b )
        case N_TUPLE, N_PAREN
            if (c.ast->nodes[cast( long, ip->b )].flags and NF_TYPE_LITERAL) = 0 then continue for
        case N_INITIALIZER
            continue for
        end select
        JudgeConversion_( c, item, s->type_, c.info->TypeOf_( ip->b ), false )
        dim as TypeId idt = ValueType_( c, s->type_ )
        dim as TypeId ivt = ValueType_( c, c.info->TypeOf_( ip->b ) )
        if (idt <> TYPE_NONE) andalso (ivt <> TYPE_NONE) andalso (idt <> ivt) then
            if c.types->Kind( idt ) <> TK_UDT then
                RequireOperator_( c, ivt, "cast", EnclosingTypeOf_( c, s->parent ), ip->b )
            end if
        end if
    next
    '' ...AND THE QUALIFIED DEFINITION OF A STATIC MEMBER, 'var UDT.x = type<B>( ... )',
    '' whose symbol's own item is the 'static x as A' inside the type -- fbc error 20.
    for n as long = 0 to c.ast->Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        if c.ast->Kind( id ) <> N_VAR_ITEM then continue for
        if (c.ast->nodes[n].flags and NF_QUALIFIED) = 0 then continue for
        dim as StmtPayload ptr ip = _
            @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        if ip->b = NODE_NONE then continue for
        dim as Symbol ptr ms = c.syms->SymbolAt( c.info->RefOf( id ) )
        if ms = 0 then
            '' Nothing bound the item: the member is found through its OWNER, the way
            '' the qualified-init sweeps do -- a single UDT of that name, or nothing.
            dim as ScopeId osc = TypeScopeOf_( c, ip->ownerName )
            if osc = SCOPE_NONE then continue for
            ms = c.syms->SymbolAt( c.syms->LookupLocal( osc, c.names->Fold( ip->name ) ) )
            if ms = 0 then continue for
        end if
        if ms->kind <> cast( ubyte, SYM_VARIABLE ) then continue for
        if ms->type_ = TYPE_NONE then continue for
        select case c.ast->Kind( ip->b )
        case N_TUPLE, N_PAREN
            if (c.ast->nodes[cast( long, ip->b )].flags and NF_TYPE_LITERAL) = 0 then continue for
        case N_INITIALIZER
            continue for
        end select
        JudgeConversion_( c, id, ms->type_, c.info->TypeOf_( ip->b ), false )
    next
end sub

'' A MEMBER THAT DOES NOT EXIST -- fbc error 18, "Element not defined", for 'u.A = 0'
'' over a type that declares no A. Only through an INSTANCE of a plain UDT, only when
'' Check bound nothing, and only after this pass has searched the type and every base
'' itself and found nothing either: a name Check declined to bind for a reason of its own
'' is not evidence.
private sub CheckMemberExists_ ( byref c as Ctx, byval id as NodeId )
    dim as BinaryPayload ptr mp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as TokenKind op = cast( TokenKind, mp->op )
    if (op <> TK_DOT) andalso (op <> TK_ARROW) then return
    if (mp->lhs = NODE_NONE) orelse (mp->rhs = NODE_NONE) then return
    if c.ast->Kind( mp->rhs ) <> N_IDENT then return
    if c.info->RefOf( id ) <> SYMBOL_NONE then return
    if c.info->RefOf( mp->rhs ) <> SYMBOL_NONE then return
    dim as Symbol ptr bs = c.syms->SymbolAt( c.info->RefOf( mp->lhs ) )
    if bs = 0 then return
    select case cast( SymbolKind, bs->kind )
    case SYM_VARIABLE, SYM_PARAMETER, SYM_FIELD
    case else
        return
    end select
    if IsThisBase_( c, mp->lhs ) then return
    dim as TypeId bt = c.info->TypeOf_( mp->lhs )
    if bt = TYPE_NONE then return
    dim as TypeId bu = ValueType_( c, bt )
    if c.types->Kind( bu ) = TK_POINTER then bu = c.types->Unqualify( c.types->Inner( bu ) )
    if c.types->Kind( bu ) <> TK_UDT then return
    dim as string tnm = c.names->Spelling( c.types->NameOf( bu ) )
    if (instr( tnm, "<" ) > 0) orelse (instr( tnm, "(" ) > 0) then return
    if TupleLike_( c, bu ) then return
    dim as InternId want = c.names->Fold( _
        c.ast->idents[cast( long, c.ast->nodes[cast( long, mp->rhs )].data )].name )
    '' 'b.constructor( )' and 'pb->destructor( )' are explicit structor calls, which
    '' CheckExplicitStructor_ judges; neither name is ever a member.
    select case lcase( c.names->Spelling( want ) )
    case "constructor", "destructor"
        return
    end select
    dim as TypeId t = bu
    dim as long guard = 0
    while (t <> TYPE_NONE) andalso (guard < 64)
        guard += 1
        dim as Symbol ptr ts = UdtSymbolOf_( c, t )
        if ts = 0 then return
        if ts->inner = SCOPE_NONE then return
        '' A UNION or an ANONYMOUS aggregate inside the type is not searched here, so
        '' a type holding one is not judged at all.
        if (ts->flags and SYMF_UNION_KIND) <> 0 then return
        for i as long = 0 to c.syms->symbols.Count - 1
            dim as Symbol ptr f = @c.syms->symbols[i]
            if f->parent <> ts->inner then continue for
            if (f->flags and SYMF_UNION) <> 0 then return
            if c.names->Fold( f->name ) = want then return
            if f->kind = cast( ubyte, SYM_FIELD ) then
                '' An anonymous nested TYPE/UNION field opens its members into the
                '' owner: decline over any field whose type is an unnamed UDT.
                if f->type_ <> TYPE_NONE then
                    dim as TypeId fu = c.types->Unqualify( f->type_ )
                    if c.types->Kind( fu ) = TK_UDT then
                        if c.types->NameOf( fu ) = 0 then return
                        if left( c.names->Spelling( c.types->NameOf( fu ) ), 1 ) = "_" then return
                    end if
                end if
            end if
        next
        t = BaseOf_( c, t )
    wend
    c.diags->Report( TKO0739, PointRange( c.ast->Loc( mp->rhs ) ), _
                     tnm, c.names->Spelling( want ) )
end sub

'' 'erase x' OVER AN ARRAY WHOSE TYPE HAS NO DEFAULT CONSTRUCTOR -- fbc error 183: the
'' elements are reconstructed and there is nothing to do it with. Measured over 'dim as T
'' x(0 to 0) = { T( 5 ) }' with only 'constructor( byval as integer )'; one with every
'' parameter defaulted is a default constructor and passes.
private sub CheckEraseDefaultCtor_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cast( TokenKind, sp->op ) <> KW_ERASE then return
    for i as long = 0 to sp->count - 1
        dim as NodeId arg = cast( NodeId, c.ast->children[sp->first + i] )
        if arg = NODE_NONE then continue for
        dim as Symbol ptr av = c.syms->SymbolAt( c.info->RefOf( arg ) )
        if av = 0 then continue for
        if av->type_ = TYPE_NONE then continue for
        dim as TypeId u = c.types->Unqualify( av->type_ )
        if c.types->Kind( u ) <> TK_ARRAY then continue for
        dim as TypeId el = c.types->Unqualify( c.types->Inner( u ) )
        if c.types->Kind( el ) <> TK_UDT then continue for
        dim as Symbol ptr ct = StructorOf_( c, el, "__ctor" )
        if ct = 0 then continue for
        dim as boolean hasDefault = false
        dim as long guard = 0
        while (ct <> 0) andalso (guard < 1000)
            guard += 1
            dim as NodeId cd = cast( NodeId, ct->payload )
            if (cd <> NODE_NONE) andalso (c.ast->Kind( cd ) = N_PROC) then
                if RequiredParams_( c, cd ) = 0 then hasDefault = true
            else
                hasDefault = true
            end if
            ct = c.syms->SymbolAt( ct->nextOverload )
        wend
        if hasDefault then continue for
        c.diags->Report( TKO0737, PointRange( c.ast->Loc( arg ) ) )
    next
end sub

'' THREE THINGS A PROCEDURE DEFINITION CANNOT DO. All measured, one corpus file each:
''
''     function f( ) as any            error 24    'any' is not a value type
''     sub f( ( ) as integer )         error 59    a DEFINITION names every parameter
''                                                 ('declare sub f( ( ) as integer )' is fine)
''     function f( ) as UDT ...        error 184   the result is constructed, and UDT
''                                                 declares constructors but no default one
''         -- a 'byref as UDT' result is not constructed and passes; so does a UDT whose
''            only constructor has every parameter defaulted; so does a declaration.
private sub CheckProcDefinitionShapes_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->b = NODE_NONE then return
    for i as long = 0 to sp->count - 1
        dim as NodeId prm = cast( NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( prm ) <> N_PARAM then continue for
        dim as StmtPayload ptr pp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, prm )].data )]
        if pp->op = cast( ushort, TK_ELLIPSIS ) then continue for
        if pp->name = 0 then
            c.diags->Report( TKO0733, PointRange( c.ast->Loc( prm ) ) )
            exit for
        end if
    next
    if sp->a = NODE_NONE then return
    dim as TypeId rt = c.info->TypeOf_( sp->a )
    if rt = TYPE_NONE then return
    dim as TypeId ru = c.types->Unqualify( rt )
    if c.types->Kind( ru ) = TK_BUILTIN then
        if c.types->BuiltinOf( ru ) = TY_ANY then
            c.diags->Report( TKO0732, PointRange( c.ast->Loc( id ) ), _
                             c.names->Spelling( sp->name ) )
        end if
        return
    end if
    if cast( TokenKind, sp->op ) <> KW_FUNCTION then return
    if (c.ast->nodes[cast( long, id )].flags and NF_BYREF) <> 0 then return
    if c.types->Kind( ru ) <> TK_UDT then return
    '' 'RETURN' CONSTRUCTS THE RESULT IN PLACE and needs no default constructor; only the
    '' implicit result variable that 'function =' assigns into does. Measured, over a type
    '' whose only constructor takes an argument:
    ''
    ''     return Mt( 1 )                  accepted      two RETURNs      accepted
    ''     function = Mt( 1 )              error 184     neither          error 184
    ''     dim as Mt r = ... : return r    accepted      a DECLARE alone  accepted
    ''
    '' Judging the DECLARATION alone refused dim/auto_var3.bas, expressions/mult-assign.bas
    '' and structs/temp-var-dtors.bas, all of which return.
    dim as boolean sawReturn = false
    dim as boolean sawAssign = false
    ScanReturnStyles_( c, sp->b, sawReturn, sawAssign )
    if sawReturn then return
    dim as Symbol ptr ct = StructorOf_( c, ru, "__ctor" )
    if ct = 0 then return
    dim as long guard = 0
    while (ct <> 0) andalso (guard < 1000)
        guard += 1
        dim as NodeId cd = cast( NodeId, ct->payload )
        if (cd = NODE_NONE) orelse (c.ast->Kind( cd ) <> N_PROC) then return
        if RequiredParams_( c, cd ) = 0 then return
        ct = c.syms->SymbolAt( ct->nextOverload )
    wend
    c.diags->Report( TKO0736, PointRange( c.ast->Loc( id ) ), _
                     c.names->Spelling( sp->name ) )
end sub

'' WHAT A BYREF VARIABLE MAY BE BOUND TO, beyond what CheckByrefBinding_ measured:
''
''     var byref x = type<UDT>( 123 )          error 24    a temporary
''     var byref x = UDT( )                    error 24    a temporary
''     dim byref d as double = i (integer)     error 24    not exactly its type
''     dim byref j as long = i (integer)       error 24    the same size, still refused
''     dim byref t as zstring = s (string)     error 24
''     dim byref t as zstring = z (zstring*8)  OK          a fixed string IS a zstring
''     dim byref j as const integer = i        OK          adding const
''     static byref ri as integer = i (local)  error 11    a static reference to a local
''     static byref ri as integer = g (shared) OK
private sub CheckByrefInitShapes_ ( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_VARIABLE ) then continue for
        if (s->flags and SYMF_BYREF) = 0 then continue for
        if s->payload = 0 then continue for
        dim as NodeId item = cast( NodeId, s->payload )
        if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
        dim as StmtPayload ptr ip = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
        if ip->b = NODE_NONE then continue for
        dim as NodeId init = ip->b
        dim as NodeKind ik = c.ast->Kind( init )
        if (ik = N_TUPLE) andalso _
           ((c.ast->nodes[cast( long, init )].flags and NF_TYPE_LITERAL) <> 0) then
            c.diags->Report( TKO0643, PointRange( c.ast->Loc( init ) ), _
                             c.names->Spelling( s->name ) )
            continue for
        end if
        if ik = N_CALL then
            dim as ListPayload ptr lp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, init )].data )]
            dim as Symbol ptr ts = c.syms->SymbolAt( c.info->RefOf( lp->target ) )
            if (ts <> 0) andalso (ts->kind = cast( ubyte, SYM_UDT )) then
                c.diags->Report( TKO0643, PointRange( c.ast->Loc( init ) ), _
                                 c.names->Spelling( s->name ) )
                continue for
            end if
        end if
        '' A STRING LITERAL INTO 'byref as STRING' is error 24 -- while into 'byref as
        '' zstring' (CheckByrefBinding_) and 'var byref' it is accepted. Measured.
        if (ik = N_STRING_LIT) andalso (ip->a <> NODE_NONE) andalso (s->type_ <> TYPE_NONE) then
            dim as TypeId sdt = ValueType_( c, s->type_ )
            if c.types->Kind( sdt ) = TK_BUILTIN then
                if c.types->BuiltinOf( sdt ) = TY_STRING then
                    c.diags->Report( TKO0729, PointRange( c.ast->Loc( init ) ), _
                                     c.names->Spelling( s->name ) )
                end if
            end if
            continue for
        end if
        '' A BITFIELD HAS NO ADDRESS -- fbc error 24 for 'dim byref y as integer = x.n'
        '' over an 'n:1 as integer'. A plain field of the same type binds fine.
        if ik = N_MEMBER then
            dim as Symbol ptr bfs = c.syms->SymbolAt( c.info->RefOf( init ) )
            if bfs <> 0 then
                if (bfs->flags and SYMF_BITFIELD) <> 0 then
                    c.diags->Report( TKO0753, PointRange( c.ast->Loc( init ) ), _
                                     c.names->Spelling( bfs->name ) )
                    continue for
                end if
            end if
        end if
        if (ik <> N_IDENT) andalso (ik <> N_MEMBER) then continue for
        '' The static-reference rule.
        if ((s->flags and SYMF_STATIC) <> 0) andalso (ik = N_IDENT) then
            dim as Symbol ptr vs = c.syms->SymbolAt( c.info->RefOf( init ) )
            if (vs <> 0) andalso (vs->kind = cast( ubyte, SYM_VARIABLE )) then
                if (vs->flags and (SYMF_SHARED or SYMF_STATIC or SYMF_EXTERN or _
                                   SYMF_COMMON)) = 0 then
                    c.diags->Report( TKO0730, PointRange( c.ast->Loc( init ) ), _
                                     c.names->Spelling( s->name ) )
                    continue for
                end if
            end if
        end if
        '' The exact-type rule, over a DECLARED type and a builtin on both sides.
        if ip->a = NODE_NONE then continue for
        if s->type_ = TYPE_NONE then continue for
        dim as TypeId dt = ValueType_( c, s->type_ )
        dim as TypeId vt = ValueType_( c, c.info->TypeOf_( init ) )
        if (dt = TYPE_NONE) orelse (vt = TYPE_NONE) then continue for
        if c.types->Kind( vt ) = TK_ARRAY then
            dim as TypeId ve = c.types->Unqualify( c.types->Inner( vt ) )
            if c.types->Kind( ve ) = TK_BUILTIN then
                select case c.types->BuiltinOf( ve )
                case TY_ZSTRING, TY_WSTRING, TY_USTRING
                    vt = ve
                end select
            end if
        end if
        if (c.types->Kind( dt ) <> TK_BUILTIN) orelse (c.types->Kind( vt ) <> TK_BUILTIN) then
            continue for
        end if
        if c.types->BuiltinOf( dt ) = TY_ANY then continue for
        if dt = vt then continue for
        c.diags->Report( TKO0729, PointRange( c.ast->Loc( init ) ), _
                         c.names->Spelling( s->name ) )
    next
end sub

'' One folded array bound, or 'known = false'.
private function FoldBound_ _
    ( byref c as Ctx, byval n as NodeId, byref known as boolean ) as longint
    known = false
    if n = NODE_NONE then return 0
    select case c.ast->Kind( n )
    case N_INT_LIT
        known = true
        return cast( longint, c.ast->literals[cast( long, c.ast->nodes[cast( long, n )].data )].intValue )
    case N_UNARY
        dim as UnaryPayload ptr up = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, n )].data )]
        if cast( TokenKind, up->op ) <> TK_MINUS then return 0
        dim as longint v = FoldBound_( c, up->operand, known )
        return -v
    end select
    return 0
end function

'' The written bounds of a declaration item: lo/hi pairs into 'lo'/'hi', the rank as the
'' result, -1 when any bound does not fold. '...' takes its size from the initializer.
private function WrittenBounds_ _
    ( byref c as Ctx, byval item as NodeId, lo() as longint, hi() as longint ) as long
    dim as StmtPayload ptr ip = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
    if ip->c = NODE_NONE then return 0
    if c.ast->Kind( ip->c ) <> N_BLOCK then return 0
    dim as ListPayload ptr bl = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, ip->c )].data )]
    if bl->count <= 0 then return 0
    if bl->count > 8 then return -1
    for d as long = 0 to bl->count - 1
        dim as NodeId r = cast( NodeId, c.ast->children[bl->first + d] )
        if r = NODE_NONE then return -1
        if c.ast->Kind( r ) <> N_CASE_RANGE then return -1
        dim as StmtPayload ptr rp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, r )].data )]
        if (rp->a = NODE_NONE) orelse (rp->b = NODE_NONE) then return -1
        dim as boolean k1, k2
        lo(d) = FoldBound_( c, rp->a, k1 )
        if k1 = false then return -1
        if c.ast->Kind( rp->b ) = N_ELLIPSIS then
            if (bl->count <> 1) orelse (ip->b = NODE_NONE) then return -1
            if c.ast->Kind( ip->b ) <> N_INITIALIZER then return -1
            dim as ListPayload ptr il = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, ip->b )].data )]
            hi(d) = lo(d) + il->count - 1
        else
            hi(d) = FoldBound_( c, rp->b, k2 )
            if k2 = false then return -1
        end if
    next
    return bl->count
end function

'' A DEFINITION AGREES WITH ITS EXTERN. Measured, over 'extern array(0 to 1) as integer':
''
''     dim array(0 to 0) as integer            error 37   the bounds differ
''     dim array(1 to 2) as integer            error 37
''     dim array(-1 to ...) = { 1, 2 }         error 37   -1 to 0 is not 0 to 1
''     dim array(0 to ...) = { 1, 2 }          OK         0 to 1 is
''     dim array(0 to 1) as integer            OK
''     extern a(0 to 1, 0 to 1) / dim a(0 to 1)   error 36   the rank differs
''     redim array(0 to 1) as integer          error 54   the extern is a FIXED array
''
'' ...and 'extern s as string' then 'dim s as string = "foo"' or 'var s = "foo"' is
'' error 87, the static-storage string rule, which CheckStaticStringInits cannot see
'' because the merged symbol no longer says EXTERN.
''
'' Both statements sit in ONE BLOCK -- the module's, or a namespace's -- so the pairing
'' is by name within a block, which is what keeps a same-named local in some procedure
'' out of it.
private sub CheckExternRange_ ( byref c as Ctx, byval first as long, byval count as long )
    for i as long = 0 to count - 1
        dim as NodeId st = cast( NodeId, c.ast->children[first + i] )
        if st = NODE_NONE then continue for
        if c.ast->Kind( st ) = N_NAMESPACE then
            dim as StmtPayload ptr np = _
                @c.ast->stmts[cast( long, c.ast->nodes[cast( long, st )].data )]
            CheckExternRange_( c, np->first, np->count )
            continue for
        end if
        if c.ast->Kind( st ) <> N_VAR then continue for
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, st )].data )]
        if sp->op <> cast( ushort, KW_EXTERN ) then continue for
        for j as long = 0 to sp->count - 1
            dim as NodeId ex = cast( NodeId, c.ast->children[sp->first + j] )
            if c.ast->Kind( ex ) <> N_VAR_ITEM then continue for
            dim as StmtPayload ptr ep = _
                @c.ast->stmts[cast( long, c.ast->nodes[cast( long, ex )].data )]
            if ep->name = 0 then continue for
            dim as InternId want = c.names->Fold( ep->name )
            dim as longint elo(0 to 7), ehi(0 to 7)
            dim as long erank = WrittenBounds_( c, ex, elo(), ehi() )
            dim as TypeId et = TYPE_NONE
            if ep->a <> NODE_NONE then et = c.types->Unqualify( c.info->TypeOf_( ep->a ) )
            dim as boolean isString = false
            if (et <> TYPE_NONE) andalso (c.types->Kind( et ) = TK_BUILTIN) then
                isString = (c.types->BuiltinOf( et ) = TY_STRING)
            end if
            '' Every later declaration of the name in this block.
            for k as long = i + 1 to count - 1
                dim as NodeId st2 = cast( NodeId, c.ast->children[first + k] )
                if st2 = NODE_NONE then continue for
                if c.ast->Kind( st2 ) <> N_VAR then continue for
                dim as StmtPayload ptr sp2 = _
                    @c.ast->stmts[cast( long, c.ast->nodes[cast( long, st2 )].data )]
                if sp2->op = cast( ushort, KW_EXTERN ) then continue for
                for m as long = 0 to sp2->count - 1
                    dim as NodeId df = cast( NodeId, c.ast->children[sp2->first + m] )
                    if c.ast->Kind( df ) <> N_VAR_ITEM then continue for
                    dim as StmtPayload ptr dp = _
                        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, df )].data )]
                    if dp->name = 0 then continue for
                    if c.names->Fold( dp->name ) <> want then continue for
                    if (c.ast->nodes[cast( long, df )].flags and NF_QUALIFIED) <> 0 then continue for
                    if sp2->op = cast( ushort, KW_REDIM ) then
                        if (dp->a <> NODE_NONE) andalso (erank > 0) then
                            c.diags->Report( TKO0723, PointRange( c.ast->Loc( df ) ) )
                        end if
                        continue for
                    end if
                    if isString andalso (dp->b <> NODE_NONE) then
                        c.diags->Report( TKO0628, PointRange( c.ast->Loc( df ) ), _
                                         c.names->Spelling( dp->name ) )
                        continue for
                    end if
                    if erank <= 0 then continue for
                    dim as longint dlo(0 to 7), dhi(0 to 7)
                    dim as long drank = WrittenBounds_( c, df, dlo(), dhi() )
                    if drank <= 0 then continue for
                    if drank <> erank then
                        c.diags->Report( TKO0728, PointRange( c.ast->Loc( df ) ), _
                                         c.names->Spelling( dp->name ) )
                        continue for
                    end if
                    for d as long = 0 to erank - 1
                        if (dlo(d) <> elo(d)) orelse (dhi(d) <> ehi(d)) then
                            c.diags->Report( TKO0727, PointRange( c.ast->Loc( df ) ), _
                                             c.names->Spelling( dp->name ) )
                            exit for
                        end if
                    next
                next
            next
        next
    next
end sub

private sub CheckExternBlock_ ( byref c as Ctx, byval blk as NodeId )
    if blk = NODE_NONE then return
    dim as NodeKind bk = c.ast->Kind( blk )
    if (bk <> N_BLOCK) andalso (bk <> N_MODULE) then return
    dim as ListPayload ptr bl = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, blk )].data )]
    CheckExternRange_( c, bl->first, bl->count )
end sub

'' 'on s goto ...' OVER A STRING -- fbc error 20, "Type mismatch, before 'goto'": the
'' selector is a number. Measured: a string variable and a literal are refused, a double
'' is accepted. The parser records 2 for GOTO and 3 for GOSUB in 'extra'; ON ERROR is 1.
private sub CheckOnGotoSelector_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cast( TokenKind, sp->op ) <> KW_ON then return
    if (sp->extra <> 2) andalso (sp->extra <> 3) then return
    if sp->a = NODE_NONE then return
    dim as TypeId t = ValueType_( c, c.info->TypeOf_( sp->a ) )
    if t = TYPE_NONE then return
    if c.types->Kind( t ) = TK_ARRAY then t = c.types->Unqualify( c.types->Inner( t ) )
    if c.types->Kind( t ) <> TK_BUILTIN then return
    if IsStringyType_( c, t ) = false then return
    c.diags->Report( TKO0742, PointRange( c.ast->Loc( sp->a ) ) )
end sub

'' WITHDRAWN: 'sizeof( undeclaredid )' as fbc's error 42. A TYPE NAME reaches this pass as
'' a plain N_IDENT too -- 'sizeof( IMAGE_SYMBOL_EX )' in winnt.bi and 'sizeof( T )' over a
'' generic parameter in fb/comptr.bi -- so an unbound name is not an undeclared one. The
'' corpus scan refused eight COM files fbc accepts before the rule was an hour old.

'' 'ns.a' WHERE THE NAMESPACE HAS NO 'a' -- fbc error 8, "Undefined symbol". Only when
'' the left side binds a NAMESPACE symbol and this pass's own search of it, 'using'
'' included, finds nothing.
private sub CheckNamespaceMember_ ( byref c as Ctx, byval id as NodeId )
    dim as BinaryPayload ptr mp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cast( TokenKind, mp->op ) <> TK_DOT then return
    if (mp->lhs = NODE_NONE) orelse (mp->rhs = NODE_NONE) then return
    if c.ast->Kind( mp->rhs ) <> N_IDENT then return
    if c.info->RefOf( id ) <> SYMBOL_NONE then return
    if c.info->RefOf( mp->rhs ) <> SYMBOL_NONE then return
    dim as Symbol ptr bs = c.syms->SymbolAt( c.info->RefOf( mp->lhs ) )
    if bs = 0 then return
    if bs->kind <> cast( ubyte, SYM_NAMESPACE ) then return
    if bs->inner = SCOPE_NONE then return
    dim as InternId want = c.names->Fold( _
        c.ast->idents[cast( long, c.ast->nodes[cast( long, mp->rhs )].data )].name )
    if c.syms->LookupInNamespace( bs->inner, want ) <> SYMBOL_NONE then return
    c.diags->Report( TKO0745, PointRange( c.ast->Loc( mp->rhs ) ), _
                     c.names->Spelling( bs->name ), c.names->Spelling( want ) )
end sub

'' 'dim array(0 to ...) as integer = { ubound( array ) }' -- fbc error 58: the size comes
'' from the initializer, so the initializer cannot ask for it. Measured: 'ubound' in any
'' element position is refused; 'lbound' is accepted (it is the written lower bound).
private function MentionsUbound_ _
    ( byref c as Ctx, byval n as NodeId, byval sym as SymbolId, byval depth as long ) as boolean
    if (n = NODE_NONE) orelse (depth > 8) then return false
    select case c.ast->Kind( n )
    case N_CALL
        dim as ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
        if (lp->target <> NODE_NONE) andalso (c.ast->Kind( lp->target ) = N_IDENT) then
            dim as string tn = lcase( c.names->Spelling( _
                c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )].name ) )
            if (tn = "ubound") andalso (lp->count >= 1) then
                dim as NodeId a0 = cast( NodeId, c.ast->children[lp->first] )
                if c.info->RefOf( a0 ) = sym then return true
            end if
        end if
        for i as long = 0 to lp->count - 1
            if MentionsUbound_( c, cast( NodeId, c.ast->children[lp->first + i] ), sym, depth + 1 ) then return true
        next
    case N_INITIALIZER, N_TUPLE, N_PAREN
        dim as ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
        for i as long = 0 to lp->count - 1
            if MentionsUbound_( c, cast( NodeId, c.ast->children[lp->first + i] ), sym, depth + 1 ) then return true
        next
    case N_BINARY
        dim as BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, n )].data )]
        if MentionsUbound_( c, bp->lhs, sym, depth + 1 ) then return true
        if MentionsUbound_( c, bp->rhs, sym, depth + 1 ) then return true
    end select
    return false
end function

'' Is there an 'extern <name>( lo to hi )' anywhere in this module? Collect MERGES the
'' extern and its definition into one symbol and clears SYMF_EXTERN when the definition
'' arrives, so the flag alone cannot answer it and the AST is searched instead.
private function ExternDeclaredElsewhere_ _
    ( byref c as Ctx, byval nm as InternId ) as boolean
    dim as InternId want = c.names->Fold( nm )
    for n as long = 0 to c.ast->Count( ) - 1
        if c.ast->Kind( cast( NodeId, n ) ) <> N_VAR then continue for
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        if sp->op <> cast( ushort, KW_EXTERN ) then continue for
        for i as long = 0 to sp->count - 1
            dim as NodeId item = cast( NodeId, c.ast->children[sp->first + i] )
            if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
            dim as StmtPayload ptr ip = _
                @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
            if ip->name = 0 then continue for
            if c.names->Fold( ip->name ) = want then return true
        next
    next
    return false
end function

private sub CheckEllipsisUbound_ ( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_VARIABLE ) then continue for
        if s->payload = 0 then continue for
        dim as NodeId item = cast( NodeId, s->payload )
        if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
        dim as StmtPayload ptr ip = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
        if (ip->b = NODE_NONE) orelse (ip->c = NODE_NONE) then continue for
        if c.ast->Kind( ip->c ) <> N_BLOCK then continue for
        dim as ListPayload ptr bl = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, ip->c )].data )]
        dim as boolean sawEllipsis = false
        for d as long = 0 to bl->count - 1
            dim as NodeId r = cast( NodeId, c.ast->children[bl->first + d] )
            if (r = NODE_NONE) orelse (c.ast->Kind( r ) <> N_CASE_RANGE) then continue for
            dim as StmtPayload ptr rp = _
                @c.ast->stmts[cast( long, c.ast->nodes[cast( long, r )].data )]
            if (rp->b <> NODE_NONE) andalso (c.ast->Kind( rp->b ) = N_ELLIPSIS) then sawEllipsis = true
            if (rp->a <> NODE_NONE) andalso (c.ast->Kind( rp->a ) = N_ELLIPSIS) then sawEllipsis = true
        next
        if sawEllipsis = false then continue for
        '' AN EXTERN AHEAD OF IT ALREADY FIXED THE BOUNDS, so 'ubound' folds at compile
        '' time and fbc accepts the line -- quirk/lubound.bas says so in a comment and
        '' then writes it. Only an array whose size comes SOLELY from the initializer is
        '' the error.
        if (s->flags and (SYMF_EXTERN or SYMF_COMMON)) <> 0 then continue for
        if ExternDeclaredElsewhere_( c, s->name ) then continue for
        if MentionsUbound_( c, ip->b, cast( SymbolId, i ), 0 ) = false then continue for
        c.diags->Report( TKO0744, PointRange( c.ast->Loc( ip->b ) ), _
                         c.names->Spelling( s->name ) )
    next
end sub

'' The constructor arguments of an N_NEW, as a (first, count) range into the child list.
'' The node's children are not all arguments: PLACEMENT NEW puts its buffer in child 0 and
'' the ARRAY form its element count there, and fbc allows no constructor arguments
'' alongside either. So 'new( buf ) T' and 'new T[ 5 ]' both call the DEFAULT constructor.
private sub NewCtorArgs_ _
    ( byref c as Ctx, byval id as NodeId, byref first as long, byref count as long )
    dim as ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    first = lp->first
    count = lp->count
    dim as ushort fl = c.ast->nodes[cast( long, id )].flags
    if (fl and NF_PLACEMENT) <> 0 then
        first += 1
        count -= 1
    end if
    if (fl and NF_ARRAY) <> 0 then
        first += 1
        count -= 1
    end if
    if count < 0 then count = 0
end sub

private sub CheckOperatorVisibility_ _
    ( byref c as Ctx, byval id as NodeId, byval k as NodeKind, byval here as TypeId )
    select case k
    case N_AMBIGUOUS
        if c.info->AmbiguousOf( id ) <> AMB_ASSIGN then return
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
        if (sp->a = NODE_NONE) orelse (sp->b = NODE_NONE) then return
        dim as TokenKind op = cast( TokenKind, sp->op )
        if op = TK_EQ then
            '' A PLAIN '=' INVOKES THE SOURCE'S 'cast' ONLY WHEN THE DESTINATION IS NOT A
            '' UDT: between two UDTs it is a 'let' or a copy, and 'y = x' over one type
            '' converts nothing at all. Measured both ways -- 'y = x' with a private cast
            '' on T is accepted, 'i = x' is error 202.
            dim as TypeId dt = ValueType_( c, c.info->TypeOf_( sp->a ) )
            dim as TypeId vt = ValueType_( c, c.info->TypeOf_( sp->b ) )
            if (dt = TYPE_NONE) orelse (vt = TYPE_NONE) then return
            if dt = vt then return
            if c.types->Kind( dt ) = TK_UDT then return
            RequireOperator_( c, vt, "cast", here, id )
            return
        end if
        '' A COMPOUND ASSIGNMENT IS A MEMBER OPERATOR ON THE DESTINATION.
        RequireOperator_( c, c.info->TypeOf_( sp->a ), _
                          Text.LowerAscii( TokenKindText( op ) ), here, id )

    case N_ADDROF
        dim as UnaryPayload ptr up = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        if up->operand = NODE_NONE then return
        '' 'varptr', 'strptr' and 'procptr' share this node; only '@' is an operator.
        if cast( TokenKind, up->op ) <> TK_AT then return
        RequireOperator_( c, c.info->TypeOf_( up->operand ), "@", here, id )

    case N_NEW
        dim as ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if lp->target = NODE_NONE then return
        dim as TypeId nt = c.types->Unqualify( c.info->TypeOf_( lp->target ) )
        if nt = TYPE_NONE then return
        if c.types->Kind( nt ) <> TK_UDT then return
        RequireOperator_( c, nt, "new", here, id )
        '' ...AND THE CONSTRUCTOR IT CALLS -- fbc's 204 for the default one and 205 for
        '' the copy, both the same refusal. 'new T[ 5 ]' default-constructs every element.
        dim as long cfirst, ccount
        NewCtorArgs_( c, id, cfirst, ccount )
        if ccount = 0 then
            CheckOneStructor_( c, nt, "__ctor", here, c.ast->Loc( id ), 0 )
        elseif ccount = 1 then
            dim as NodeId a0 = cast( NodeId, c.ast->children[cfirst] )
            if ValueType_( c, c.info->TypeOf_( a0 ) ) = nt then
                CheckCopyStructor_( c, nt, here, c.ast->Loc( id ), 0 )
            end if
        end if

    case N_DELETE_STMT
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
        if sp->a = NODE_NONE then return
        dim as TypeId pt = ValueType_( c, c.info->TypeOf_( sp->a ) )
        if pt = TYPE_NONE then return
        if c.types->Kind( pt ) <> TK_POINTER then return
        RequireOperator_( c, c.types->Inner( pt ), "delete", here, id )

    case N_FOR
        '' A UDT COUNTER DRIVES THE LOOP THROUGH ALL THREE OF ITS OPERATORS.
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
        if sp->a = NODE_NONE then return
        dim as TypeId ct = c.info->TypeOf_( sp->a )
        RequireOperator_( c, ct, "for", here, id )
        RequireOperator_( c, ct, "next", here, id )
        RequireOperator_( c, ct, "step", here, id )
    end select
end sub

'' A PRIVATE OR PROTECTED FIELD CANNOT BE FILLED FROM OUTSIDE -- fbc error 202 for
'' 'dim as T x = ( 3 )' and 'dim as T x = type<T>( 3 )' over a type whose fields are
'' protected, and for 'let( n ) = x' unpacking a private one. Both forms name no member,
'' so CheckMember_ never sees them. Measured: the same declaration inside a DERIVED type's
'' method is accepted for a protected field, and a plain copy 'dim as T y = x' is not this
'' rule at all.
private function HiddenFieldOf_ _
    ( byref c as Ctx, byval udt as TypeId, byval here as TypeId ) as Symbol ptr
    dim as TypeId u = ValueType_( c, udt )
    if u = TYPE_NONE then return 0
    if c.types->Kind( u ) <> TK_UDT then return 0
    dim as Symbol ptr ts = UdtSymbolOf_( c, u )
    if ts = 0 then return 0
    if ts->inner = SCOPE_NONE then return 0
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr f = @c.syms->symbols[i]
        if f->parent <> ts->inner then continue for
        if f->kind <> cast( ubyte, SYM_FIELD ) then continue for
        if (f->flags and (SYMF_MEMB_PRIVATE or SYMF_MEMB_PROTECTED)) = 0 then continue for
        if StructorReachable_( c, f, u, here ) then continue for
        return f
    next
    return 0
end function

private sub ReportHiddenField_ _
    ( byref c as Ctx, byval f as Symbol ptr, byval udt as TypeId, byval at as NodeId )
    c.diags->Report( TKO0746, PointRange( c.ast->Loc( at ) ), _
                     "field " & c.names->Spelling( f->name ), _
                     c.names->Spelling( c.types->NameOf( ValueType_( c, udt ) ) ) )
end sub

private sub CheckAggregateInitVisibility_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_VARIABLE ) then continue for
        if s->type_ = TYPE_NONE then continue for
        if s->payload = 0 then continue for
        dim as NodeId item = cast( NodeId, s->payload )
        if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
        dim as StmtPayload ptr ip = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
        if ip->b = NODE_NONE then continue for
        '' BOTH SPELLINGS: the bare '( 3 )' and the 'type<T>( 3 )' literal are refused
        '' alike, which was measured -- so NF_TYPE_LITERAL is not consulted here.
        select case c.ast->Kind( ip->b )
        case N_TUPLE, N_PAREN
        case else
            continue for
        end select
        '' ...BUT ONLY WHEN THE TYPE DECLARES NO CONSTRUCTOR. With one, the parentheses
        '' are a CONSTRUCTOR CALL and not an aggregate at all, and the fields are never
        '' touched by the caller. Measured, over a type with a protected field:
        ''
        ''     no constructor                     dim as Hid v = ( 3 )     error 202
        ''     constructor( byval n as integer )  dim as Hid v = ( 3 )     accepted
        ''     constructor( byref b as Bee )      dim as Hid v = ( bb )    accepted
        ''     a constructor that does NOT match  dim as Hid v = ( 3 )     error 24, not 202
        ''
        '' Counting the call form refused functions/udt_result_access4.bas and -5.bas,
        '' which write 'dim as tfoo f2 = ( f1.bar( ) )' over a type whose constructor takes
        '' exactly that -- and the scan that cleared this rule could not see them.
        if DeclaresAnywhere_( c, ValueType_( c, s->type_ ), "__ctor" ) then continue for
        dim as Symbol ptr f = HiddenFieldOf_( c, s->type_, EnclosingTypeOf_( c, s->parent ) )
        if f = 0 then continue for
        ReportHiddenField_( c, f, s->type_, ip->b )
    next
end sub

private sub CheckLetUnpackVisibility_ _
    ( byref c as Ctx, byval id as NodeId, byval here as TypeId )
    if c.info->AmbiguousOf( id ) <> AMB_ASSIGN then return
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if (sp->a = NODE_NONE) orelse (sp->b = NODE_NONE) then return
    if cast( TokenKind, sp->op ) <> TK_EQ then return
    select case c.ast->Kind( sp->a )
    case N_TUPLE, N_PAREN
    case else
        return
    end select
    dim as TypeId st = c.info->TypeOf_( sp->b )
    dim as Symbol ptr f = HiddenFieldOf_( c, st, here )
    if f = 0 then return
    ReportHiddenField_( c, f, st, id )
end sub

'' The name an expression carries, for the diagnostic's '%0'.
private function SpellOf_ ( byref c as Ctx, byval n as NodeId ) as string
    if n = NODE_NONE then return ""
    if c.ast->Kind( n ) <> N_IDENT then return ""
    return c.names->Spelling( _
        c.ast->idents[cast( long, c.ast->nodes[cast( long, n )].data )].name )
end function

'' NOTHING CONST MAY BE WRITTEN -- fbc error 119, "Cannot modify a constant". The simple
'' case, an assignment straight to a const VARIABLE, is CheckAssignTarget_'s; these are the
'' spellings that reach const storage through an expression, and every one was measured:
''
''     *p = 1          p as const integer ptr          error 119
''     *p = 1          p as integer const ptr          ACCEPTED -- the POINTEE is writable
''     cast( const integer, i ) = 1                    error 24
''     *cptr( const integer ptr, pci ) = 123           error 119
''     swap a, b       either one const                error 119
''     let( i ) = x    i a const                       error 119
''     *p = 0          p from 'var p = @( x.n )', n a const FIELD    error 119
''     (*strptr( s ))[0] = c    s a const string       error 119
''
'' ALL OF THEM ASK ONE QUESTION -- is the type this expression designates CONST -- so the
'' target's own type answers it, and a const POINTER answers 'no' because its POINTEE is
'' what a dereference designates. That is the distinction the const-pointer parser fix
'' made expressible; before it every one of these was a coin toss.
private function ConstDesignated_ ( byref c as Ctx, byval n as NodeId ) as boolean
    if n = NODE_NONE then return false
    dim as TypeId t = c.info->TypeOf_( n )
    if t = TYPE_NONE then return false
    if c.types->Kind( t ) = TK_REFERENCE then t = c.types->Inner( t )
    return c.types->IsConst( t )
end function

'' The assignment targets CheckAssignTarget_ does not reach: a DEREFERENCE and a CAST.
'' A plain N_IDENT is left to it so nothing is reported twice.
private sub CheckConstWriteTarget_ ( byref c as Ctx, byval id as NodeId )
    if c.info->AmbiguousOf( id ) <> AMB_ASSIGN then return
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->a = NODE_NONE then return
    dim as NodeKind k = c.ast->Kind( sp->a )
    dim as boolean judged = (k = N_DEREF) orelse (k = N_INDEX)
    if k = N_CALL then
        '' 'cast( const T, x ) = ...' -- a CAST is not a call, and its result type is
        '' what is being written. A real call on the left is a property or an array
        '' subscript and is somebody else's question.
        dim as ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, sp->a )].data )]
        if lp->target <> NODE_NONE then
            if c.ast->Kind( lp->target ) = N_IDENT then
                if c.info->RefOf( lp->target ) = SYMBOL_NONE then
                    dim as string cn = lcase( c.names->Spelling( _
                        c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )].name ) )
                    judged = (cn = "cast") orelse (cn = "cptr")
                    '' 'mid( s, i, n ) = v' WRITES INTO s, so a const string there is
                    '' fbc's 119 -- while a const INDEX argument is fine. The call's own
                    '' type is the string it returns, so argument 0 is what is judged.
                    if cn = "mid" then
                        if lp->count >= 1 then
                            dim as NodeId m0 = cast( NodeId, c.ast->children[lp->first] )
                            if ConstDesignated_( c, m0 ) then
                                c.diags->Report( TKO0617, _
                                    PointRange( c.ast->Loc( m0 ) ), SpellOf_( c, m0 ) )
                            end if
                        end if
                        return
                    end if
                end if
            end if
        end if
    end if
    if judged = false then return
    if ConstDesignated_( c, sp->a ) = false then return
    c.diags->Report( TKO0617, PointRange( c.ast->Loc( sp->a ) ), "" )
end sub

'' SWAP WRITES BOTH OPERANDS, so a const on either side is fbc's 119. Measured both ways.
private sub CheckSwapConst_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cast( TokenKind, sp->op ) <> KW_SWAP then return
    for pass_ as long = 0 to 1
        dim as NodeId v = sp->a
        if pass_ = 1 then v = sp->b
        if v = NODE_NONE then continue for
        '' A LITERAL and a NAMED CONSTANT are TKO0642's, not this rule's -- reporting them
        '' here too put two diagnostics on one 'swap K, b'. What TKO0642 does not see is a
        '' variable whose TYPE is const, which is what rtl-swap.bas writes.
        dim as boolean bad = ConstDesignated_( c, v )
        if bad then
            c.diags->Report( TKO0617, PointRange( c.ast->Loc( v ) ), _
                             SpellOf_( c, v ) )
            return
        end if
    next
end sub

'' A CONSTANT'S TYPE MUST BE ONE A VALUE CAN BE FOLDED INTO -- fbc error 24. Measured
'' across the whole set, and the accepted side is wide:
''
''     integer  double  single  longint  ubyte  boolean       accepted
''     string (plain)   any pointer      an enum              accepted
''     any              string * 20      zstring * 20         error 24
''     wstring * 20     a UDT            a UDT with no '='    error 24
''
'' A FIXED STRING IS AN ARRAY of a character builtin in this type model, which is what the
'' TK_ARRAY test below is reading; a const ARRAY is not a thing FreeBASIC has.
private sub CheckConstDeclTypes2_( byref c as Ctx )
    for n as long = 0 to c.ast->Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        if c.ast->Kind( id ) <> N_CONST then continue for
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        for i as long = 0 to sp->count - 1
            dim as NodeId item = cast( NodeId, c.ast->children[sp->first + i] )
            if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
            dim as StmtPayload ptr ip = _
                @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
            '' WITHOUT AN EXPLICIT TYPE there is nothing to judge: 'const k = 1' infers.
            if ip->a = NODE_NONE then continue for
            dim as TypeId t = c.types->Unqualify( c.info->TypeOf_( ip->a ) )
            if t = TYPE_NONE then continue for
            dim as boolean bad = false
            select case c.types->Kind( t )
            case TK_UDT, TK_ARRAY
                bad = true
            case TK_BUILTIN
                bad = (c.types->BuiltinOf( t ) = TY_ANY)
            end select
            if bad = false then continue for
            c.diags->Report( TKO0748, PointRange( c.ast->Loc( item ) ), _
                             c.names->Spelling( ip->name ) )
        next
    next
end sub

'' WHAT 'threadcall' CAN RUN. Two fbc errors, both measured over the whole threads/
'' family, and the accepted side of each measured beside it:
''
''     threadcall goodSub( )                 accepted
''     threadcall someFunction( )            error 289 -- a FUNCTION is not a sub
''     threadcall bc.BadMember( )            error 289 -- and neither is a qualified call
''     threadcall pascalSub( )               error 288 -- the calling convention
''     threadcall cdeclSub( ) / stdcallSub( )  accepted
''     threadcall f( u )  u a BYVAL UDT holding an ARRAY, STRING or BITFIELD   error 288
''     threadcall f( u )  u a byval UNION, or a UDT with an anonymous one   error 288
''     threadcall f( u )  u a byval UDT holding a BITFIELD        error 288
''     threadcall f( u )  u a byval PLAIN UDT                     accepted
''
'' The 288 cases are all the same shape: the thread trampoline copies each byval argument,
'' and fbc will not copy an aggregate whose layout it cannot pass through one pointer.
private function ThreadUnsupportedUdt_ _
    ( byref c as Ctx, byval t as TypeId, byref why as string, byval depth as long ) as boolean

    if depth > 8 then return false
    dim as TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) <> TK_UDT then return false
    dim as Symbol ptr ts = UdtSymbolOf_( c, u )
    if ts = 0 then return false
    if (ts->flags and SYMF_UNION_KIND) <> 0 then
        why = "a union cannot be passed to a thread"
        return true
    end if
    if ts->inner = SCOPE_NONE then return false
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr f = @c.syms->symbols[i]
        if f->parent <> ts->inner then continue for
        if f->kind <> cast( ubyte, SYM_FIELD ) then continue for
        if (f->flags and SYMF_UNION) <> 0 then
            why = "a union field cannot be passed to a thread"
            return true
        end if
        if (f->flags and SYMF_BITFIELD) <> 0 then
            why = "a bitfield cannot be passed to a thread"
            return true
        end if
        if f->type_ = TYPE_NONE then continue for
        dim as TypeId ft = c.types->Unqualify( f->type_ )
        if c.types->Kind( ft ) = TK_BUILTIN then
            if c.types->BuiltinOf( ft ) = TY_STRING then
                why = "a string field cannot be passed byval to a thread"
                return true
            end if
        end if
        if c.types->Kind( ft ) = TK_ARRAY then
            '' A FIXED STRING is an array of a character builtin and is not this.
            dim as TypeId el = c.types->Unqualify( c.types->Inner( ft ) )
            dim as boolean fixstr = false
            if c.types->Kind( el ) = TK_BUILTIN then
                select case c.types->BuiltinOf( el )
                case TY_ZSTRING, TY_WSTRING, TY_USTRING, TY_FIXSTR, TY_FIXUSTR
                    fixstr = true
                end select
            end if
            if fixstr = false then
                why = "an array field cannot be passed to a thread"
                return true
            end if
        end if
        if c.types->Kind( ft ) = TK_UDT then
            if ThreadUnsupportedUdt_( c, ft, why, depth + 1 ) then return true
        end if
    next
    return false
end function

private sub CheckThreadCall_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cast( TokenKind, sp->op ) <> KW_THREADCALL then return
    '' THE CALL IS THE ONE CHILD, not 'a': the parser pushes it into the child list.
    if sp->count < 1 then return
    dim as NodeId tcall = cast( NodeId, c.ast->children[sp->first] )
    if tcall = NODE_NONE then return
    if c.ast->Kind( tcall ) <> N_CALL then return
    dim as ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, tcall )].data )]
    if lp->target = NODE_NONE then return

    '' A QUALIFIED CALL is not a plain sub either -- 'bc.BadMember( )' is fbc's 289.
    if c.ast->Kind( lp->target ) = N_MEMBER then
        c.diags->Report( TKO0749, PointRange( c.ast->Loc( tcall ) ), "this member call" )
        return
    end if
    dim as Symbol ptr callee = c.syms->SymbolAt( c.info->RefOf( tcall ) )
    if callee = 0 then callee = c.syms->SymbolAt( c.info->RefOf( lp->target ) )
    if callee = 0 then return
    if callee->kind <> cast( ubyte, SYM_PROC ) then return
    dim as NodeId decl = cast( NodeId, callee->payload )
    if decl = NODE_NONE then return
    if c.ast->Kind( decl ) <> N_PROC then return
    dim as StmtPayload ptr pp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, decl )].data )]

    '' A FUNCTION IS NOT A SUB. The result type is what says so: a SUB has none.
    if cast( TokenKind, pp->op ) = KW_FUNCTION then
        c.diags->Report( TKO0749, PointRange( c.ast->Loc( tcall ) ), _
                         c.names->Spelling( pp->name ) )
        return
    end if
    if (pp->extra and PF_PASCAL) <> 0 then
        c.diags->Report( TKO0750, PointRange( c.ast->Loc( tcall ) ), _
                         c.names->Spelling( pp->name ), _
                         "the PASCAL calling convention is not supported" )
        return
    end if
    for i as long = 0 to pp->count - 1
        dim as NodeId prm = cast( NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) <> N_PARAM then continue for
        '' BYVAL ONLY. The byval side is consistent and was measured whole: a UDT holding
        '' an ARRAY, a STRING or a BITFIELD, and a UNION, are each fbc's 288, while a plain
        '' UDT, an integer and a string PARAMETER are all accepted.
        ''
        '' THE BYREF SIDE IS NOT MODELLED, because it does not reduce to "contains X" and
        '' guessing it refused threads/threadcall.bas, which fbc compiles:
        ''
        ''     byref, UDT holding an array only          error 288
        ''     byref, that UDT plus a STRING field       ACCEPTED
        ''     byref, that UDT plus a BITFIELD           ACCEPTED
        ''     byref, a UNION                            error 288
        ''
        '' Whatever decides that, it is not the field list alone, so the whole byref half
        '' is declined rather than half-modelled.
        if (c.ast->nodes[cast( long, prm )].flags and NF_BYREF) <> 0 then continue for
        if (c.ast->nodes[cast( long, prm )].flags and NF_ARRAY) <> 0 then continue for
        dim as StmtPayload ptr prp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, prm )].data )]
        if prp->a = NODE_NONE then continue for
        dim as string why = ""
        if ThreadUnsupportedUdt_( c, c.info->TypeOf_( prp->a ), why, 0 ) then
            c.diags->Report( TKO0750, PointRange( c.ast->Loc( tcall ) ), _
                             c.names->Spelling( pp->name ), why )
            return
        end if
    next
end sub

'' TWO THINGS EVERY REDIM MUST HAVE. Measured, with the accepted line beside each:
''
''     redim array( 1 to 2 )                     error 147 -- it DECLARES, with no type
''     redim shared a( 0 to 1 )                  error 147
''     redim a$( 0 to 1 )                        error 147 -- a suffix is not a type
''     extern a( ) as integer : redim a( )       error 147 -- still declares nothing typed
''     redim array( 1 to 2 ) as integer          accepted
''     dim a( ) as integer : redim a( 0 to 2 )   accepted -- the DIM gave it a type
''     redim a( 0 to 2 ) as integer : redim a( 0 to 3 )    accepted -- so did the first
''     sub s( a( ) as integer ) : redim a( 0 to 2 )        accepted -- so did the parameter
''
''     redim array as integer                    error 63 -- no bounds at all
''     redim a$                                  error 63
''     dim a( ) as integer : redim a as integer  error 63
''
'' The first rule is about a redim that DECLARES: the ordinary re-dimensioning of an array
'' something else already declared needs no type, which is the commonest spelling there is.
'' The symbol's own declaration item is what says which this is -- when the redim item IS
'' the declaration, nothing else typed the array.
private sub CheckRedimDeclShape_( byref c as Ctx )
    for n as long = 0 to c.ast->Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        if c.ast->Kind( id ) <> N_VAR then continue for
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        if sp->op <> cast( ushort, KW_REDIM ) then continue for
        for i as long = 0 to sp->count - 1
            dim as NodeId item = cast( NodeId, c.ast->children[sp->first + i] )
            if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
            dim as StmtPayload ptr ip = _
                @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]

            '' BOUNDS FIRST: without them there is no array to re-dimension at all, and
            '' that is the error whether or not a type was written.
            '' NO PARENTHESES AT ALL is the 63: there is no array here to re-dimension.
            '' EMPTY parens 'a( )' are a different thing and are read below.
            dim as boolean hasParens = false
            dim as long bounds = 0
            if ip->c <> NODE_NONE then
                if c.ast->Kind( ip->c ) = N_BLOCK then
                    hasParens = true
                    bounds = c.ast->lists[cast( long, _
                        c.ast->nodes[cast( long, ip->c )].data )].count
                end if
            end if
            if hasParens = false then
                '' ...UNLESS THE TARGET IS NOT AN ARRAY AT ALL, which is TKO0695's. 'redim
                '' scalar' over an 'extern scalar as integer' is one fbc error, and putting
                '' both on it made two -- caught by this suite's outside-namespace-2 test.
                dim as Symbol ptr ns = c.syms->SymbolAt( c.info->RefOf( item ) )
                if ns <> 0 then
                    if ns->type_ <> TYPE_NONE then
                        if c.types->Kind( c.types->Unqualify( ns->type_ ) ) <> TK_ARRAY then
                            continue for
                        end if
                    end if
                end if
                c.diags->Report( TKO0752, PointRange( c.ast->Loc( item ) ), _
                                 c.names->Spelling( ip->name ) )
                continue for
            end if

            if ip->a <> NODE_NONE then continue for
            '' A QUALIFIED or object-target redim names something declared elsewhere.
            if (c.ast->nodes[cast( long, item )].flags and NF_QUALIFIED) <> 0 then continue for
            if (ip->b <> NODE_NONE) andalso (ip->extra = cast( ushort, KW_REDIM )) then continue for
            '' WITHOUT A TYPE the redim must be RE-dimensioning something already declared,
            '' and it must actually write bounds. Measured, and both halves are needed:
            ''
            ''     dim a( ) as integer : redim a( 0 to 2 )   accepted
            ''     dim a( ) as integer : redim a( )          error 147 -- empty parens
            ''     redim array( 1 to 2 )                     error 147 -- nothing declared it
            ''     redim a( ) as integer                     accepted
            dim as boolean declaredElsewhere = _
                (c.info->RefOf( item ) <> SYMBOL_NONE)
            if declaredElsewhere andalso (bounds > 0) then continue for
            c.diags->Report( TKO0751, PointRange( c.ast->Loc( item ) ), _
                             c.names->Spelling( ip->name ) )
        next
    next
end sub

private sub WalkExtra_ _
    ( byref c as Ctx, byval id as NodeId, byval k as NodeKind, byval byrefResult as boolean, _
      byval here as TypeId )
    CheckOperatorVisibility_( c, id, k, here )
    if k = N_AMBIGUOUS then CheckLetUnpackVisibility_( c, id, here )
    if k = N_AMBIGUOUS then CheckUdtAssign_( c, id )
    if k = N_MEMBER then CheckMemberExists_( c, id )
    if k = N_INTRINSIC then CheckEraseDefaultCtor_( c, id )
    if k = N_PROC then CheckProcDefinitionShapes_( c, id )
    if k = N_INTRINSIC then CheckOnGotoSelector_( c, id )
    if k = N_MEMBER then CheckNamespaceMember_( c, id )
    if k = N_AMBIGUOUS then CheckConstWriteTarget_( c, id )
    if k = N_INTRINSIC then CheckSwapConst_( c, id )
    if k = N_INTRINSIC then CheckThreadCall_( c, id )
end sub

private sub RunLateSweeps2_ ( byref c as Ctx )
    CheckUdtInits_( c )
    CheckByrefInitShapes_( c )
    CheckExternBlock_( c, c.root )
    CheckEllipsisUbound_( c )
    CheckAggregateInitVisibility_( c )
    CheckConstDeclTypes2_( c )
    CheckRedimDeclShape_( c )
end sub
