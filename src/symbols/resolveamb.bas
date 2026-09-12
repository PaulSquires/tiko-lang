'' resolveamb.bas -- an N_AMBIGUOUS statement, resolved into a call or an assignment.
''
'' Split out of resolve.bas at the 1500-line cap and included from it in the same place.


'' The parser's three-way ambiguity, decided now that the target's symbol is known
'' (docs/plan/07 section 8). The payoff is the diagnostic: where fbc reports a syntax
'' error, tiko-lang can say what the name actually is.

'' An array type from a declaration's bounds, or the base type unchanged when there are
'' none.
''
'' THE PARSER SPELLS BOUNDS TWO DIFFERENT WAYS, which is why this takes node lists
'' rather than a payload:
''
''   N_FIELD      flat (lo, hi) children          as long f(0 to 3)
''   N_VAR_ITEM   an N_BLOCK of N_CASE_RANGE      dim as long a(0 to 9)
''
'' Both are collected into (lo, hi) pairs here so the arithmetic exists once. Assuming
'' the field shape for both is what left every LOCAL array typed as its element -- four
'' bytes where forty were needed -- and that went unnoticed only because indexing was
'' not lowered either.
''
'' A missing low bound means 0: 'a(9)' is 'a(0 to 9)'. BOUNDS ARE RETAINED, not just
'' their product, because indexing needs each dimension's stride and its lbound bias.
'' Nothing is folded when any bound is non-constant.

'' '<call>( args ) = value' RE-READ AS '<call>( args = value )'.
''
'' True when it applies, and the statement has been REWRITTEN by then: the call's
'' LAST argument becomes an '=' over itself and the assigned value, which is what
'' fbc parses. False leaves everything untouched.
''
'' Refused for anything but a CALL whose callee is a procedure -- an array
'' subscript is spelled the same way and IS an assignment -- and refused when any
'' candidate of matching arity returns BYREF, because that one is a real
'' assignment through the returned reference.
private function ReadCallAssignAsCall_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval sp as Tko.StmtPayload ptr, _
      byval sid as Tko.SymbolId ) as boolean

    if sp->a = Tko.NODE_NONE then return false
    if sp->b = Tko.NODE_NONE then return false
    if c.ast->Kind( sp->a ) <> Tko.N_CALL then return false
    '' Only a plain '=': '+=' and its family are never a comparison.
    if cast( Tko.TokenKind, sp->op ) <> Tko.TK_EQ then return false
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    '' A MEMBER CALL HAS NOT BOUND YET. Resolve runs before Check, so
    '' 'a.At( 2 ) = 88' has no RefOf on its member node and 'sid' falls back to the
    '' BASE -- the variable 'a' -- which is not a procedure, and the whole rule
    '' declined. The comment below has always said this case folds; it did not.
    ''
    '' It was invisible while a byref member result was double-loaded: the store
    '' went through the loaded VALUE and landed somewhere harmless, so the program
    '' printed the 0 fbc prints, for the wrong reason. Fixing the lvalue path made
    '' it print 88 and exposed this.
    ''
    '' The member is therefore looked up BY NAME in the base's own type scope --
    '' what matters is only whether the name is a PROCEDURE, not which overload.
    if s <> 0 then
        if s->kind <> cast( ubyte, Tko.SYM_PROC ) then
            dim as Tko.NodeId cal2 = ListOf( c, sp->a )->target
            if c.ast->Kind( cal2 ) = Tko.N_MEMBER then
                dim as Tko.BinaryPayload ptr mb2 = _
                    @c.ast->binaries[cast( long, c.ast->nodes[cast( long, cal2 )].data )]
                '' THE BASE VARIABLE'S DECLARED TYPE, not the expression's. Resolve
                '' runs before Check, so TypeOf_ on the base is TYPE_NONE here --
                '' measured -- while the symbol the base bound to already carries it.
                dim as Tko.TypeId bt2 = c.types->Unqualify( s->type_ )
                if c.types->Kind( bt2 ) = Tko.TK_UDT then
                    dim as Tko.InternId tn2 = c.types->NameOf( bt2 )
                    if tn2 <> 0 then
                        dim as Tko.ScopeId ds2 = _
                            cast( Tko.ScopeId, c.types->DeclScopeOf( bt2 ) )
                        dim as Tko.SymbolId ts2 = _
                            c.syms->LookupLocalTyped( ds2, tn2, true )
                        if ts2 = Tko.SYMBOL_NONE then _
                            ts2 = c.syms->LookupTyped( ds2, tn2, true )
                        dim as Tko.Symbol ptr tsy2 = c.syms->SymbolAt( ts2 )
                        if tsy2 <> 0 then
                            if tsy2->inner <> Tko.SCOPE_NONE then
                                dim as Tko.SymbolId mm2 = c.syms->LookupLocal( _
                                    tsy2->inner, IdentNameOf( c, mb2->rhs ) )
                                dim as Tko.Symbol ptr msy2 = c.syms->SymbolAt( mm2 )
                                if msy2 <> 0 then
                                    if msy2->kind = cast( ubyte, Tko.SYM_PROC ) then
                                        '' A PROPERTY IS NOT FOLDED. 'p.Item( 2 ) = 7'
                                        '' is a SETTER CALL, which is the one member
                                        '' shape where the '=' really is the value --
                                        '' measured, fbc prints 7 for it where it
                                        '' prints 0 for the ordinary byref member.
                                        dim as Tko.NodeId mpn2 = _
                                            cast( Tko.NodeId, msy2->payload )
                                        dim as boolean isProp2 = false
                                        if mpn2 <> Tko.NODE_NONE then
                                            if c.ast->Kind( mpn2 ) = Tko.N_PROC then
                                                isProp2 = (StmtOf( c, mpn2 )->op = _
                                                    cast( ushort, Tko.KW_PROPERTY ))
                                            end if
                                        end if
                                        if isProp2 = false then s = msy2
                                    end if
                                end if
                            end if
                        end if
                    end if
                end if
            end if
        end if
    end if
    if s = 0 then return false
    if s->kind <> cast( ubyte, Tko.SYM_PROC ) then return false

    dim as Tko.ListPayload ptr lp = ListOf( c, sp->a )
    if lp->count < 1 then return false

    '' ONE OR MORE WRITTEN ARGUMENTS. With NONE there is nothing to fold the '='
    '' into, and fbc keeps the assignment: measured, 'br0( ) = 456' is
    '' 'vr = BR0( ); *vr = 456' and the program prints 456, while 'br( 1 ) = 456'
    '' over the same shape with an argument prints 0.
    if lp->count < 1 then return false

    '' THE REWRITE. The arena is plain data, so the node is appended the way the
    '' parser appends one; nothing else here builds nodes, which is why this is
    '' spelled out rather than borrowed.
    dim as long lastIx = lp->first + lp->count - 1
    dim as Tko.BinaryPayload bp
    bp.op = cast( ushort, Tko.TK_EQ )
    bp.lhs = cast( Tko.NodeId, c.ast->children[lastIx] )
    bp.rhs = sp->b
    c.ast->binaries.Push( bp )
    dim as Tko.AstNode bn
    bn.kind = cast( ushort, Tko.N_BINARY )
    bn.flags = 0
    bn.loc = c.ast->Loc( id )
    bn.data = cast( ulong, c.ast->binaries.Count - 1 )
    c.ast->nodes.Push( bn )
    c.ast->children[lastIx] = cast( ulong, c.ast->nodes.Count - 1 )

    '' The statement is now a CALL and nothing else: its assigned value has moved
    '' inside the argument, and leaving 'b' set would lower it twice.
    sp->b = Tko.NODE_NONE
    sp->op = 0
    return true
end function

private sub ResolveAmbiguous _
    ( byref c as Ctx, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId )

    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    WalkExpr( c, sp->a, scope_ )
    WalkExpr( c, sp->b, scope_ )
    for i as long = 0 to sp->count - 1
        WalkExpr( c, cast( Tko.NodeId, c.ast->children[sp->first + i] ), scope_ )
    next

    dim as boolean isAssign = (sp->op <> 0)

    '' 'function = expr' names no symbol, so it cannot reach the lookup below -- but it
    '' is the SAME statement as 'f = expr' inside f, and both belong in one bucket. The
    '' keyword form used to decline at a different line from the name form, which is
    '' the shape that made 'amb other' mislead for four commits.
    if c.ast->Kind( sp->a ) = Tko.N_FUNCRESULT then
        c.info->SetAmbiguous( id, Tko.AMB_RESULT )
        c.st->assigns += 1
        return
    end if

    '' The target's head symbol: for a.b.c the head is a.
    dim as Tko.NodeId head = sp->a
    dim as long guard = 0
    while guard < 64
        guard += 1
        dim as Tko.NodeKind hk = c.ast->Kind( head )
        if hk = Tko.N_MEMBER then
            head = c.ast->binaries[cast( long, c.ast->nodes[cast( long, head )].data )].lhs
        elseif (hk = Tko.N_CALL) orelse (hk = Tko.N_INDEX) then
            head = ListOf( c, head )->target
        else
            exit while
        end if
    wend

    '' A QUALIFIED name binds on the MEMBER node itself, so prefer that over the head:
    '' for 'ns.Greet( 1 )' the head is the namespace and tells us nothing useful, while
    '' the member resolved to the procedure.
    dim as Tko.SymbolId sid = c.info->RefOf( head )
    if c.ast->Kind( sp->a ) = Tko.N_MEMBER then
        dim as Tko.SymbolId qsid = c.info->RefOf( sp->a )
        if qsid <> Tko.SYMBOL_NONE then sid = qsid
    elseif c.ast->Kind( sp->a ) = Tko.N_CALL then
        dim as Tko.NodeId callee = ListOf( c, sp->a )->target
        if c.ast->Kind( callee ) = Tko.N_MEMBER then
            dim as Tko.SymbolId qsid = c.info->RefOf( callee )
            if qsid <> Tko.SYMBOL_NONE then sid = qsid
        end if
    end if
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )

    '' 'f( 123 ) = 123' WHERE f RETURNS BYVAL IS NOT AN ASSIGNMENT AT ALL.
    ''
    '' fbc warns and RE-READS the statement as the call 'f( 123 = 123 )' --
    '' warning 34, "'=' parsed as equality operator in function argument, not
    '' assignment to BYREF function result" -- and emits
    '' '_Z2F1u7INTEGER( -1ll )', the comparison's value passed as the argument.
    '' Only a BYREF result makes the assignment form legal, because only that
    '' has an address to store through.
    ''
    '' AND IT DOES NOT DEPEND ON THE RESULT BEING BYVAL, which the warning's own
    '' wording suggests and measurement refutes: 'br( 1 ) = 456' over a BYREF
    '' result warns and prints 0 too, and so does 'a.At( 2 ) = 88' over a byref
    '' MEMBER. What decides is that ARGUMENTS WERE WRITTEN -- 'br0( ) = 456' with
    '' none is the assignment, and prints 456.
    ''
    '' The BRACKET spelling is untouched: 'a[ 1 ] = 99' over an 'operator []' is
    '' 'vr = _ZN1TixEi( &A, 1 ); *vr = 99' -- measured -- and its callee is a
    '' VARIABLE rather than a procedure, which is what the test below asks.
    if isAssign then
        if ReadCallAssignAsCall_( c, id, sp, sid ) then
            c.info->SetAmbiguous( id, Tko.AMB_CALL )
            c.st->calls += 1
            return
        end if
    end if

    if isAssign then
        '' fbc error 119, "Cannot modify a constant" -- for the SYMBOLIC form
        '' ('const i = 0' then 'i = 0') and for the QUALIFIER ('dim as const integer
        '' i' then 'i = 1') alike, and for a compound assignment the same way.
        ''
        '' ONLY WHEN THE TARGET IS THE BARE NAME. 'p = ...' over a 'const integer ptr'
        '' is LEGAL -- the const is on the POINTEE, and the pointer itself is writable
        '' -- so the test is on the symbol's own type, never on what it points at,
        '' and a member or an index is left alone until there is a measurement for it.
        dim as boolean bareName = (c.ast->Kind( sp->a ) = Tko.N_IDENT)
        if bareName andalso (s <> 0) then
            dim as boolean symConst = ((s->flags and Tko.SYMF_CONST) <> 0) orelse _
                                      (cast( Tko.SymbolKind, s->kind ) = Tko.SYM_CONSTANT)
            dim as boolean typeConst = c.types->IsConst( s->type_ )
            if symConst orelse typeConst then
                c.diags->Report( Tko.TKO0617, Tko.PointRange( c.ast->Loc( sp->a ) ), _
                                 c.names->Spelling( s->name ) )
                c.info->SetAmbiguous( id, Tko.AMB_ERROR )
                return
            end if
        end if

        '' Assigning to the enclosing function name is BASIC's result assignment.
        dim as boolean isResult = (c.currentProc <> Tko.SYMBOL_NONE) andalso _
                                  (sid = c.currentProc)
        if isResult then
            c.info->SetAmbiguous( id, Tko.AMB_RESULT )
        else
            c.info->SetAmbiguous( id, Tko.AMB_ASSIGN )
        end if
        c.st->assigns += 1
        return
    end if

    if s = 0 then
        c.info->SetAmbiguous( id, Tko.AMB_CALL )
        c.st->calls += 1
        return
    end if

    select case cast( Tko.SymbolKind, s->kind )
    case Tko.SYM_PROC
        c.info->SetAmbiguous( id, Tko.AMB_CALL )
        c.st->calls += 1
    case Tko.SYM_UDT, Tko.SYM_ENUM, Tko.SYM_TYPEDEF, Tko.SYM_NAMESPACE
        '' ...UNLESS THE TYPE NAME IS ONLY THE BASE. 'UDT( ).copyToGlobal( )'
        '' constructs an ANONYMOUS TEMPORARY and calls a member on it -- the statement
        '' is a CALL, and the type name is the receiver's constructor, not the callee.
        '' The member does not bind (its base is a temporary), so the head's symbol --
        '' the TYPE -- was what reached here and the diagnostic fired on a legal
        '' statement. fbc emits '_ZN3UDTC1Ev( &TMP$2$0 ); _ZN3UDT12COPYTOGLOBALEv(
        '' &TMP$2$0 );' and prints 123.
        if c.ast->Kind( sp->a ) = Tko.N_CALL then
            dim as Tko.NodeId uc = ListOf( c, sp->a )->target
            if c.ast->Kind( uc ) = Tko.N_MEMBER then
                c.info->SetAmbiguous( id, Tko.AMB_CALL )
                c.st->calls += 1
                return
            end if
        end if
        '' This is the diagnostic the ambiguous node exists to make possible.
        dim as Tko.SourceRange r = Tko.PointRange( c.ast->Loc( id ) )
        c.diags->Report( Tko.TKO0602, r, c.names->Spelling( s->name ), _
                         Tko.SymbolKindName( cast( Tko.SymbolKind, s->kind ) ) )
        c.info->SetAmbiguous( id, Tko.AMB_ERROR )
    case else
        c.info->SetAmbiguous( id, Tko.AMB_CALL )
        c.st->calls += 1
    end select
end sub

'' A TYPE BUILT OVER SOMETHING NOT RESOLVED YET.
''
'' 'type t as u const ptr' written before 'type u as integer' resolves to a POINTER
'' TO NOTHING -- non-NONE, so 'dim as t p' looked resolved and never landed on the
'' pending list. BackpatchTypedefs then fixed the TYPEDEF and never came back to the
'' variable, whose slot stayed void: '*p = 0' had an untyped target and declined.
''
'' Refusing to BUILD the pointer was tried and is far too blunt -- 'any ptr' has no
'' element type either, and an unresolved 'typeof' none yet -- so it left those
'' declarations untyped instead and cost 540 corpus statements. The type is built as
'' before; this only says the declaration is worth revisiting.
private function TypeIsIncomplete_ _
    ( byref c as Ctx, byval t as Tko.TypeId ) as boolean

    dim as Tko.TypeId u = t
    for depth as long = 0 to 15
        if u = Tko.TYPE_NONE then return false
        u = c.types->Unqualify( u )
        select case c.types->Kind( u )
        case Tko.TK_POINTER, Tko.TK_REFERENCE, Tko.TK_ARRAY
            dim as Tko.TypeId inner = c.types->Inner( u )
            '' THE POINTEE IS MISSING -- which is what an unresolved element leaves.
            '' 'any ptr' is NOT this: its element is the ANY builtin, a real type.
            if inner = Tko.TYPE_NONE then return true
            u = inner
        case Tko.TK_TYPEDEF
            '' The placeholder Collect gives every typedef, still unfilled.
            return true
        case else
            return false
        end select
    next
    return false
end function
