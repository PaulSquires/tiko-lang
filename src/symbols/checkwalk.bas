'' checkwalk.bas -- the linear pass that types every expression node.
''
'' Split out of check.bas at the 1500-line lint cap and INCLUDED into it, inside the
'' same namespace, exactly as checkinfer.bas and checkeach.bas are. Nothing moved
'' changed in the move.

private sub WalkAll( byref c as Ctx )
    '' Every expression node in the arena, in id order. Expressions are created
    '' bottom-up by the parser, so a child always has a LOWER id than its parent and
    '' one linear pass types the whole tree without recursion into statements.
    for i as long = 1 to c.ast->Count( )
        dim as Tko.NodeId n = cast( Tko.NodeId, i )
        select case c.ast->Kind( n )
        case Tko.N_INT_LIT, Tko.N_FLOAT_LIT, Tko.N_STRING_LIT, Tko.N_STRCAT, _
             Tko.N_IDENT, Tko.N_PAREN, Tko.N_UNARY, Tko.N_BINARY, _
             Tko.N_DEREF, Tko.N_ADDROF, Tko.N_CALL, Tko.N_MEMBER, _
             Tko.N_INDEX, Tko.N_NEW, Tko.N_TUPLE
            '' N_INDEX was missing from this list, so 'p[i]' was never typed however
            '' well the case for it was written -- the cache is what lowering reads,
            '' and nothing ever filled it. A missing case here is invisible: the type
            '' function has the answer and no one asks it.
            ''
            TypeOf_( c, n )

        case Tko.N_INTRINSIC
            '' AN INTRINSIC THAT CAN BE AN EXPRESSION, and only those. The case in
            '' TypeOf_ has had an answer for 'input( n )' since it was written, and
            '' nothing ever asked: 'dim as string s = input( 3 )' is typed by its
            '' DESTINATION and lowered, while 'print input( 3 )' declined, because
            '' PRINT classifies an item by its type and the cache was empty. Every
            '' intrinsic in expression position was in that state.
            ''
            '' NAMED RATHER THAN ASKING ABOUT EVERY N_INTRINSIC, because most of them
            '' are STATEMENTS: PRINT has no type and never will, and asking would
            '' count eighteen of them as 'untyped' in a file that has none.
            dim as Tko.StmtPayload ptr wsp = _
                @c.ast->stmts[cast( long, c.ast->nodes[cast( long, n )].data )]
            select case cast( Tko.TokenKind, wsp->op )
            case Tko.KW_CLOSE, Tko.KW_OPEN, Tko.KW_GET, Tko.KW_PUT, _
                 Tko.KW_INPUT, Tko.KW_WINPUT, Tko.KW_THREADCALL
                TypeOf_( c, n )
            end select

        case Tko.N_AMBIGUOUS
            '' A CALL WRITTEN AS A STATEMENT IS NOT AN N_CALL NODE. 'W 1, 2' is this
            '' statement's own callee and children, so nothing here ever costed its
            '' arguments -- and lowering then used whatever Resolve had bound, which is
            '' the HEAD of the overload chain. Every overloaded statement call went to
            '' the first candidate: 'screeninfo w, h' over INTEGERs called the 32-bit
            '' entry point with int64 pointers.
            ''
            '' The chosen symbol is recorded on the CALLEE IDENT, which is where
            '' LowerStmtCall reads it from.
            if c.info->AmbiguousOf( n ) = Tko.AMB_CALL then
                dim as Tko.StmtPayload ptr asp = _
                    @c.ast->stmts[cast( long, c.ast->nodes[cast( long, n )].data )]
                '' AN N_MEMBER CALLEE IS THE SAME STATEMENT. 'f.bar 1' over an
                '' overloaded member costed nothing either, and its binding lives on the
                '' MEMBER node -- which is where LowerStmtCall reads it from, so
                '' re-costing it through the same node is all this needs. Without it
                ''
                ''     declare sub bar
                ''     declare function bar( byval i as integer ) as integer
                ''
                '' sent 'f.bar 1' to the SUB, so the call passed a receiver and an
                '' argument to something declaring only a receiver: the verifier's
                '' 'calls FOO.BAR with 2 arguments, which declares 1'.
                dim as boolean calleeIsName = false
                if asp->a <> Tko.NODE_NONE then
                    select case c.ast->Kind( asp->a )
                    case Tko.N_IDENT, Tko.N_MEMBER
                        calleeIsName = true
                    end select
                end if
                if asp->a <> Tko.NODE_NONE then
                    if calleeIsName then
                        dim as Tko.SymbolId ac = c.info->RefOf( asp->a )
                        dim as Tko.Symbol ptr acs = c.syms->SymbolAt( ac )
                        if acs <> 0 then
                            '' Only when there is a choice to make: a single candidate
                            '' is already bound, and re-costing it could only take a
                            '' binding away.
                            if (acs->kind = cast( ubyte, Tko.SYM_PROC )) andalso _
                               (acs->nextOverload <> Tko.SYMBOL_NONE) then
                                ResolveCall_( c, asp->a, ac, asp->first, asp->count )
                            end if
                        end if
                    end if
                end if
            end if
        end select
    next
end sub
