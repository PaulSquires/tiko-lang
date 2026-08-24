'' overload.bas -- CHOOSING BETWEEN CANDIDATES.
''
'' Split out of check.bas when that file passed the 1500-line lint cap. The subject is
'' one question asked several ways: which procedure a call means, which operator an
'' expression means, and whether an argument is viable for a parameter at all.
''
'' #included from check.bas rather than compiled separately: it reads that file's Ctx
'' and calls TypeOf_, so it has to sit after both.

'' Could this expression have an ADDRESS? Asked by the byref-exactness rule, because
'' that rule exists only where there IS a variable to write back through: fbc converts
'' a constant into a temporary and takes any type at all. Answered from the SHAPE,
'' since Check has no source manager to fold constants with.
private function IsLvalueShape_ _
    ( byref c as Ctx, byval e as Tko.NodeId ) as boolean

    if e = Tko.NODE_NONE then return false
    select case c.ast->Kind( e )
    case Tko.N_IDENT, Tko.N_MEMBER, Tko.N_INDEX, Tko.N_DEREF
        return true
    end select
    return false
end function

'' A builtin NUMERIC type -- the family the byref-exactness rule applies to. A string,
'' a pointer, a UDT and ANY are all excluded: each has its own conversion rules, and fbc
'' does convert some of them at a byref parameter.
private function IsNumericBuiltin_ _
    ( byref c as Ctx, byval t as Tko.TypeId ) as boolean

    if t = Tko.TYPE_NONE then return false
    dim as Tko.TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) <> Tko.TK_BUILTIN then return false
    select case c.types->BuiltinOf( u )
    case Tko.TY_BYTE, Tko.TY_UBYTE, Tko.TY_SHORT, Tko.TY_USHORT, _
         Tko.TY_LONG, Tko.TY_ULONG, Tko.TY_INTEGER, Tko.TY_UINTEGER, _
         Tko.TY_LONGINT, Tko.TY_ULONGINT, Tko.TY_SINGLE, Tko.TY_DOUBLE, _
         Tko.TY_BOOLEAN
        return true
    end select
    return false
end function

'' A UDT's operator by its SPELLING -- '[]', '+', 'cast'. Operators are declared under
'' the punctuation itself, folded, which is what makes this a plain member lookup.
private function UdtOperatorNamed_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref nm as string ) as Tko.SymbolId

    if t = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
    dim as Tko.TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) <> Tko.TK_UDT then return Tko.SYMBOL_NONE
    dim as Tko.InternId tn = c.types->NameOf( u )
    if tn = 0 then return Tko.SYMBOL_NONE
    dim as Tko.ScopeId ds = cast( Tko.ScopeId, c.types->DeclScopeOf( u ) )
    dim as Tko.SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = Tko.SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    dim as Tko.Symbol ptr sy = c.syms->SymbolAt( ts )
    if sy = 0 then return Tko.SYMBOL_NONE
    if sy->inner = Tko.SCOPE_NONE then return Tko.SYMBOL_NONE
    return c.syms->LookupLocal( sy->inner, c.names->Fold( c.names->GetString( nm ) ) )
end function

private function IsUdtOperand_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    if t = Tko.TYPE_NONE then return false
    return (c.types->Kind( c.types->Unqualify( t ) ) = Tko.TK_UDT)
end function

'' THE USER-DEFINED BINARY OPERATOR for 'lt op rt', or nothing.
''
'' Operators are declared under their PUNCTUATION, folded, so finding one is an
'' ordinary lookup of that spelling -- in the UDT's own scope for a member operator,
'' and by scope chain for a global one, which is how fbc's own headers write every
'' arithmetic operator on a value type.
''
'' Both operands are costed, so an overload set over several right-hand types picks
'' the same way a call does; a tie yields nothing rather than a silent choice.
private function UserBinaryOp_ _
    ( byref c as Ctx, byval op as Tko.TokenKind, byval lt as Tko.TypeId, _
      byval rt as Tko.TypeId ) as Tko.SymbolId

    dim as string nm = Tko.TokenKindText( op )
    if len( nm ) = 0 then return Tko.SYMBOL_NONE
    dim as Tko.InternId fold = c.names->Fold( c.names->GetString( nm ) )

    '' The candidates: the left operand's members, the right operand's, then the scope
    '' the expression is written in.
    dim as FB.Array( of ulong ) heads
    dim as Tko.SymbolId h1 = UdtOperatorNamed_( c, lt, nm )
    if h1 <> Tko.SYMBOL_NONE then heads.Push( cast( ulong, h1 ) )
    dim as Tko.SymbolId h2 = UdtOperatorNamed_( c, rt, nm )
    if (h2 <> Tko.SYMBOL_NONE) andalso (h2 <> h1) then heads.Push( cast( ulong, h2 ) )
    '' FROM THE OPERAND TYPE'S OWN SCOPE, not from the expression's: Check has no
    '' current scope, and SCOPE_GLOBAL holds only the builtins -- the trap this
    '' codebase has now hit three times. A type and the operators over it are declared
    '' together, which is what makes the declaring scope the right place to look, and
    '' Lookup walks outward from there.
    for si as long = 0 to 1
        dim as Tko.TypeId ot = iif( si = 0, lt, rt )
        if ot = Tko.TYPE_NONE then continue for
        dim as Tko.ScopeId sc = cast( Tko.ScopeId, c.types->DeclScopeOf( c.types->Unqualify( ot ) ) )
        if sc = Tko.SCOPE_NONE then continue for
        dim as Tko.SymbolId h3 = c.syms->Lookup( sc, fold )
        if h3 = Tko.SYMBOL_NONE then continue for
        dim as boolean dup = false
        for k as long = 0 to heads.Count - 1
            if cast( Tko.SymbolId, heads[k] ) = h3 then dup = true
        next
        if dup = false then heads.Push( cast( ulong, h3 ) )
    next
    if heads.Count = 0 then return Tko.SYMBOL_NONE

    dim as Tko.SymbolId best = Tko.SYMBOL_NONE
    dim as long bestCost = CONV_NONE
    dim as long ties = 0
    for hi as long = 0 to heads.Count - 1
        dim as Tko.SymbolId cur = cast( Tko.SymbolId, heads[hi] )
        while cur <> Tko.SYMBOL_NONE
            dim as Tko.Symbol ptr s = c.syms->SymbolAt( cur )
            if s = 0 then exit while
            if s->kind <> cast( ubyte, Tko.SYM_PROC ) then exit while
            dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
            if (pn <> Tko.NODE_NONE) andalso (c.ast->Kind( pn ) = Tko.N_PROC) then
                dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
                if pp->op = cast( ushort, Tko.KW_OPERATOR ) then
                    '' A MEMBER operator takes ONE parameter and the receiver; a
                    '' global one takes two.
                    dim as long np = 0
                    dim as Tko.TypeId p0 = Tko.TYPE_NONE
                    dim as Tko.TypeId p1 = Tko.TYPE_NONE
                    for i as long = 0 to pp->count - 1
                        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
                        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
                        if np = 0 then
                            p0 = c.info->TypeOf_( StmtOf( c, prm )->a )
                        elseif np = 1 then
                            p1 = c.info->TypeOf_( StmtOf( c, prm )->a )
                        end if
                        np += 1
                    next
                    dim as long total = CONV_NONE
                    if np = 2 then
                        dim as long c0 = ConversionCost( lt, p0, *c.types )
                        dim as long c1 = ConversionCost( rt, p1, *c.types )
                        if (c0 < CONV_NONE) andalso (c1 < CONV_NONE) then total = c0 + c1
                    elseif np = 1 then
                        '' ONE PARAMETER MEANS TWO DIFFERENT THINGS. Inside a TYPE it
                        '' is a binary operator whose left operand is the receiver;
                        '' outside one it is a UNARY operator and is not a candidate
                        '' here at all. Costing it either way let 'operator -( byref a
                        '' as D )' win the binary '-' and be called with one operand.
                        dim as Tko.SymScope ptr osc = c.syms->ScopeAt( s->parent )
                        if osc <> 0 then
                            if osc->kind = cast( ubyte, Tko.SCOPEK_TYPE ) then
                                '' The receiver is the LEFT operand and is not costed:
                                '' fbc only considers a member operator for its own type.
                                dim as long c1 = ConversionCost( rt, p0, *c.types )
                                if c1 < CONV_NONE then total = c1
                            end if
                        end if
                    end if
                    if total < CONV_NONE then
                        if total < bestCost then
                            bestCost = total
                            best = cur
                            ties = 0
                        elseif total = bestCost then
                            ties += 1
                        end if
                    end if
                end if
            end if
            cur = s->nextOverload
        wend
    next
    if ties > 0 then return Tko.SYMBOL_NONE
    return best
end function

'' THE USER-DEFINED UNARY OPERATOR for 'op x', or nothing. The same lookup as the
'' binary one, with the arity the other way round: a GLOBAL unary operator takes ONE
'' parameter and a member takes NONE, so the two are told apart by the scope they are
'' declared in rather than by counting.
function UserUnaryOp_ _
    ( byref c as Ctx, byval op as Tko.TokenKind, byval ot as Tko.TypeId ) as Tko.SymbolId

    if IsUdtOperand_( c, ot ) = false then return Tko.SYMBOL_NONE
    dim as string nm = Tko.TokenKindText( op )
    if len( nm ) = 0 then return Tko.SYMBOL_NONE
    dim as Tko.InternId fold = c.names->Fold( c.names->GetString( nm ) )

    dim as FB.Array( of ulong ) heads
    dim as Tko.SymbolId h1 = UdtOperatorNamed_( c, ot, nm )
    if h1 <> Tko.SYMBOL_NONE then heads.Push( cast( ulong, h1 ) )
    dim as Tko.ScopeId sc = cast( Tko.ScopeId, c.types->DeclScopeOf( c.types->Unqualify( ot ) ) )
    if sc <> Tko.SCOPE_NONE then
        dim as Tko.SymbolId h2 = c.syms->Lookup( sc, fold )
        if (h2 <> Tko.SYMBOL_NONE) andalso (h2 <> h1) then heads.Push( cast( ulong, h2 ) )
    end if
    if heads.Count = 0 then return Tko.SYMBOL_NONE

    dim as Tko.SymbolId best = Tko.SYMBOL_NONE
    dim as long bestCost = CONV_NONE
    dim as long ties = 0
    for hi as long = 0 to heads.Count - 1
        dim as Tko.SymbolId cur = cast( Tko.SymbolId, heads[hi] )
        while cur <> Tko.SYMBOL_NONE
            dim as Tko.Symbol ptr s = c.syms->SymbolAt( cur )
            if s = 0 then exit while
            if s->kind <> cast( ubyte, Tko.SYM_PROC ) then exit while
            dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
            if (pn <> Tko.NODE_NONE) andalso (c.ast->Kind( pn ) = Tko.N_PROC) then
                dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
                if pp->op = cast( ushort, Tko.KW_OPERATOR ) then
                    dim as long np = 0
                    dim as Tko.TypeId p0 = Tko.TYPE_NONE
                    for i as long = 0 to pp->count - 1
                        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
                        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
                        if np = 0 then p0 = c.info->TypeOf_( StmtOf( c, prm )->a )
                        np += 1
                    next
                    dim as long total = CONV_NONE
                    dim as Tko.SymScope ptr osc = c.syms->ScopeAt( s->parent )
                    dim as boolean member_ = false
                    if osc <> 0 then
                        member_ = (osc->kind = cast( ubyte, Tko.SCOPEK_TYPE ))
                    end if
                    if (np = 1) andalso (member_ = false) then
                        total = ConversionCost( ot, p0, *c.types )
                    elseif (np = 0) andalso member_ then
                        total = CONV_EXACT
                    end if
                    if total < CONV_NONE then
                        if total < bestCost then
                            bestCost = total
                            best = cur
                            ties = 0
                        elseif total = bestCost then
                            ties += 1
                        end if
                    end if
                end if
            end if
            cur = s->nextOverload
        wend
    next
    if ties > 0 then return Tko.SYMBOL_NONE
    return best
end function


'' Are these two symbols the SAME PROCEDURE -- a declaration and its definition that
'' Collect could not pair up? Compared by MANGLED NAME, which is exactly the question:
'' two symbols that mangle alike are one linker symbol.
private function SameProc_ _
    ( byref c as Ctx, byval a as Tko.SymbolId, byval b as Tko.SymbolId ) as boolean

    if (a = Tko.SYMBOL_NONE) orelse (b = Tko.SYMBOL_NONE) then return false
    if a = b then return true
    dim as Tko.Symbol ptr sa = c.syms->SymbolAt( a )
    dim as Tko.Symbol ptr sb = c.syms->SymbolAt( b )
    if (sa = 0) orelse (sb = 0) then return false
    dim as Tko.NodeId na = cast( Tko.NodeId, sa->payload )
    dim as Tko.NodeId nb = cast( Tko.NodeId, sb->payload )
    if (na = Tko.NODE_NONE) orelse (nb = Tko.NODE_NONE) then return false
    if c.ast->Kind( na ) <> Tko.N_PROC then return false
    if c.ast->Kind( nb ) <> Tko.N_PROC then return false
    return (Tko.Mangle.ProcName( *c.ast, na, *c.syms, *c.names, *c.types, *c.info ) = _
            Tko.Mangle.ProcName( *c.ast, nb, *c.syms, *c.names, *c.types, *c.info ))
end function

'' Does this symbol's procedure node carry a BODY, or is it a bare declaration?
private function ProcHasBody_ _
    ( byref c as Ctx, byval sid as Tko.SymbolId ) as boolean

    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return false
    dim as Tko.NodeId n = cast( Tko.NodeId, s->payload )
    if n = Tko.NODE_NONE then return false
    if c.ast->Kind( n ) <> Tko.N_PROC then return false
    return (StmtOf( c, n )->b <> Tko.NODE_NONE)
end function

'' Pick the overload for one call. Returns the chosen procedure's RETURN type, or
'' TYPE_NONE when nothing is viable or two candidates tie.
private function ResolveCall_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval callee as Tko.SymbolId, _
      byval argFirst as long, byval argCount as long ) as Tko.TypeId

    '' Argument types first; an untyped argument makes the whole call undecidable
    '' rather than wrong.
    dim as FB.Array( of ulong ) argT
    for i as long = 0 to argCount - 1
        dim as Tko.NodeId a = cast( Tko.NodeId, c.ast->children[argFirst + i] )
        '' AN ELIDED ARGUMENT -- 'locate , 10' -- has no type and needs none: it takes
        '' the parameter's default, so it is recorded as TYPE_NONE and costed as a
        '' parameter that was not written at all. Treating it as an untyped argument
        '' made every call with a hole in it undecidable.
        if c.ast->Kind( a ) = Tko.N_ELIDED then
            argT.Push( cast( ulong, Tko.TYPE_NONE ) )
            continue for
        end if
        dim as Tko.TypeId at = TypeOf_( c, a )
        if at = Tko.TYPE_NONE then
            dim as Tko.NodeId leaf = UntypedLeaf_( c, a )
            NoteUntypedName_( c, leaf )
            dim as long ak = cast( long, c.ast->Kind( leaf ) )
            while c.st->argUntypedKind.Count <= ak
                c.st->argUntypedKind.Push( 0 )
            wend
            c.st->argUntypedKind[ak] += 1
            return Tko.TYPE_NONE
        end if
        argT.Push( cast( ulong, at ) )
    next

    dim as Tko.SymbolId best = Tko.SYMBOL_NONE
    dim as long bestCost = CONV_NONE
    dim as long ties = 0

    '' How many candidates there are CHANGES WHAT IS VIABLE, so it has to be known
    '' before any of them is costed. fbc accepts a warning-3 pointer conversion for a
    '' procedure called on its own and refuses the identical conversion the moment a
    '' second overload exists, however unviable that second one is.
    dim as long ncand = 0
    dim as Tko.SymbolId walk = callee
    while walk <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr ws = c.syms->SymbolAt( walk )
        if ws = 0 then exit while
        if ws->kind <> cast( ubyte, Tko.SYM_PROC ) then exit while
        ncand += 1
        walk = ws->nextOverload
    wend
    dim as boolean overloaded = (ncand > 1)

    dim as Tko.SymbolId cur = callee

    while cur <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr s = c.syms->SymbolAt( cur )
        if s = 0 then exit while
        if s->kind <> cast( ubyte, Tko.SYM_PROC ) then exit while
        dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
        if (pn <> Tko.NODE_NONE) andalso (c.ast->Kind( pn ) = Tko.N_PROC) then
            dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
            '' A CANDIDATE IS VIABLE ON FEWER ARGUMENTS THAN PARAMETERS when every
            '' parameter past the last written one has a DEFAULT. This read 'np =
            '' argT.Count' and nothing else, so a procedure with an optional parameter
            '' was viable only when every one of them was written -- and the effect was
            '' not a diagnostic but a SILENTLY UNTYPED CALL: 'r = screenres( 320, 200 )'
            '' bound to nothing, so the assignment had no value and declined, while the
            '' same call as a STATEMENT lowered fine because nothing asked its type.
            ''
            '' fbc's rule was measured, not assumed: with 'F( a )' and 'F( a, b = 0 )'
            '' both declared, 'F 1' is its error 98, AMBIGUOUS -- so a defaulted
            '' candidate really is viable and ties with the exact-arity one rather than
            '' losing to it. Ties already return TYPE_NONE here.
            dim as long np = 0
            dim as boolean variadic = false
            for i as long = 0 to pp->count - 1
                dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
                if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
                if StmtOf( c, prm )->op = cast( ushort, Tko.TK_ELLIPSIS ) then
                    variadic = true
                else
                    np += 1
                end if
            next
            dim as boolean arityOk = (np = argT.Count)
            if variadic then
                if argT.Count >= np then arityOk = true
            elseif argT.Count < np then
                '' Every parameter the call did not reach must have a default.
                arityOk = true
                dim as long seen = 0
                for i as long = 0 to pp->count - 1
                    dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
                    if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
                    if seen >= argT.Count then
                        if StmtOf( c, prm )->b = Tko.NODE_NONE then
                            arityOk = false
                            exit for
                        end if
                    end if
                    seen += 1
                next
            end if
            if arityOk then
                dim as long total = 0
                dim as long ai = 0
                dim as boolean viable = true
                for i as long = 0 to pp->count - 1
                    dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
                    if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
                    dim as Tko.StmtPayload ptr sp2 = StmtOf( c, prm )
                    if sp2->op = cast( ushort, Tko.TK_ELLIPSIS ) then continue for
                    '' Past the written arguments, or an elided one: the default
                    '' stands and there is nothing to convert. An elided argument
                    '' whose parameter has NO default is not viable -- 'locate , 10'
                    '' against a parameter that must be written.
                    if ai >= argT.Count then exit for
                    dim as Tko.TypeId at2 = cast( Tko.TypeId, argT[ai] )
                    if at2 = Tko.TYPE_NONE then
                        if sp2->b = Tko.NODE_NONE then
                            viable = false
                            exit for
                        end if
                        ai += 1
                        continue for
                    end if
                    dim as Tko.TypeId pt = c.info->TypeOf_( sp2->a )

                    '' A BYREF NUMERIC PARAMETER TAKES ITS OWN TYPE AND NOTHING ELSE.
                    '' Measured: 'declare sub F( byref x as long )' called with a SHORT
                    '' or an INTEGER is fbc's error 58, not a conversion -- there is
                    '' nowhere for a converted value to live that the callee could
                    '' write back through. A CONSTANT is exempt, because it has no
                    '' address either way and fbc materialises a temporary for it.
                    ''
                    '' This is not pedantry about a diagnostic tiko-lang does not emit: it
                    '' decides an OVERLOAD. 'screeninfo w, h' over INTEGERs is
                    '' fb_GfxScreenInfo64 and over LONGs is fb_GfxScreenInfo32, and
                    '' costing the two as convertible picked the 32-bit one for both --
                    '' an int64* passed where an int32* belongs.
                    if (prm <> Tko.NODE_NONE) andalso (pt <> Tko.TYPE_NONE) then
                        if (c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) <> 0 then
                            if IsNumericBuiltin_( c, pt ) andalso IsNumericBuiltin_( c, at2 ) then
                                if c.types->Unqualify( at2 ) <> c.types->Unqualify( pt ) then
                                    dim as Tko.NodeId an2 = Tko.NODE_NONE
                                    if ai < argCount then
                                        an2 = cast( Tko.NodeId, c.ast->children[argFirst + ai] )
                                    end if
                                    if IsLvalueShape_( c, an2 ) then
                                        viable = false
                                        exit for
                                    end if
                                end if
                            end if
                        end if
                    end if

                    '' 'a( ) as ANY' TAKES AN ARRAY OF ANY ELEMENT TYPE. That is what
                    '' the spelling is for -- fbc's own fbc-int header declares
                    '' 'ArrayDescriptorPtr( a( ) as any )' and passes arrays of every
                    '' type to it -- and the argument of an array parameter arrives
                    '' here as its ELEMENT type, so costing 'integer' against 'any'
                    '' said not viable and the call came out UNTYPED. Not a diagnostic:
                    '' the initialiser it fed simply had no value and declined.
                    dim as boolean anyArrayParam = false
                    if (prm <> Tko.NODE_NONE) andalso (pt <> Tko.TYPE_NONE) then
                        if (c.ast->nodes[cast( long, prm )].flags and Tko.NF_ARRAY) <> 0 then
                            if c.types->Kind( pt ) = Tko.TK_BUILTIN then
                                anyArrayParam = _
                                    (c.types->BuiltinOf( pt ) = Tko.TY_ANY)
                            end if
                        end if
                    end if
                    if anyArrayParam then
                        ai += 1
                        continue for
                    end if

                    dim as long cost = ConversionCost( at2, pt, *c.types, overloaded )
                    ai += 1
                    if cost >= CONV_NONE then
                        viable = false
                        exit for
                    end if
                    total += cost
                next
                if viable then
                    if total < bestCost then
                        bestCost = total
                        best = cur
                        ties = 0
                    elseif total = bestCost then
                        '' TWO HALVES OF ONE PROCEDURE ARE NOT TWO CANDIDATES.
                        ''
                        '' Collect attaches a definition to its declaration by ARITY,
                        '' because it runs before any type is resolved -- so when two
                        '' overloads take the same NUMBER of parameters it cannot tell
                        '' which one a definition belongs to, and the definition
                        '' declares a symbol of its own. The set then holds the same
                        '' procedure twice, the two cost identically, and the call
                        '' resolved to NOTHING: not a diagnostic, an untyped call whose
                        '' consumer then declined.
                        ''
                        '' That is every header with a same-arity overload set and a
                        '' body somewhere -- fb/fspath.bi's seven decomposition
                        '' functions each have three, and its own test lost 80
                        '' statements to it.
                        ''
                        '' Here the types ARE resolved, so the two can be compared the
                        '' way a linker would: by mangled name. The one with a BODY
                        '' wins, so the call reaches the definition.
                        if SameProc_( c, best, cur ) then
                            if ProcHasBody_( c, cur ) then best = cur
                        else
                            ties += 1
                        end if
                    end if
                end if
            end if
        end if
        cur = s->nextOverload
    wend

    if best = Tko.SYMBOL_NONE then return Tko.TYPE_NONE
    if ties > 0 then
        c.st->callsAmbiguous += 1
        return Tko.TYPE_NONE
    end if
    c.st->callsResolved += 1
    c.info->SetRef( id, best )
    dim as Tko.Symbol ptr bs = c.syms->SymbolAt( best )
    if bs = 0 then return Tko.TYPE_NONE
    return bs->type_
end function

'' The statement payload from an ARENA rather than a context -- the two arrow helpers
'' below take the tables, so they cannot use Check's own StmtOf.
private function StmtAt_ _
    ( byref ast as Tko.AstArena, byval id as Tko.NodeId ) as Tko.StmtPayload ptr
    return @ast.stmts[cast( long, ast.nodes[cast( long, id )].data )]
end function

'' THE GLOBAL 'operator ->' FOR A UDT, or nothing.
''
'' 'p->v' over a UDT is a CALL to that operator followed by an ordinary field access on
'' what it returns, which is byref and so a pointer at the ABI. fb/sharedptr.bi and
'' fb/comptr.bi both declare one, and without this every '->' on a smart pointer was an
'' untyped member access: 63 declines in generics/container-sharedptr.bas and the whole
'' com/comptr family behind it.
''
'' Free-standing, with the tables passed in rather than a Ctx, because CHECK needs it to
'' TYPE the access and LOWERING needs the same operator to CALL -- and the two layers
'' have different context types.
function ArrowOperatorFor _
    ( byref types as Tko.TypeContext, byref syms as Tko.SymbolTable, _
      byref names as Tko.Interner, byref ast as Tko.AstArena, _
      byref info as Tko.SemanticInfo, byval bt as Tko.TypeId ) as Tko.SymbolId

    if bt = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
    dim as Tko.TypeId ut = types.Unqualify( bt )
    if types.Kind( ut ) <> Tko.TK_UDT then return Tko.SYMBOL_NONE

    dim as Tko.InternId fold = names.Fold( names.GetString( "->" ) )
    dim as Tko.ScopeId sc = cast( Tko.ScopeId, types.DeclScopeOf( ut ) )
    if sc = Tko.SCOPE_NONE then return Tko.SYMBOL_NONE
    dim as Tko.SymbolId cur = syms.Lookup( sc, fold )

    '' ONE PARAMETER, and it must be this UDT. An overload set over several handle
    '' types is ordinary here -- comptr declares one per interface shape -- so the
    '' parameter is compared rather than assumed.
    while cur <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr s = syms.SymbolAt( cur )
        if s = 0 then exit while
        if s->kind = cast( ubyte, Tko.SYM_PROC ) then
            dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
            if (pn <> Tko.NODE_NONE) andalso (ast.Kind( pn ) = Tko.N_PROC) then
                dim as Tko.StmtPayload ptr pp = StmtAt_( ast, pn )
                if pp->op = cast( ushort, Tko.KW_OPERATOR ) then
                    dim as long np = 0
                    dim as Tko.TypeId p0 = Tko.TYPE_NONE
                    for i as long = 0 to pp->count - 1
                        dim as Tko.NodeId prm = cast( Tko.NodeId, ast.children[pp->first + i] )
                        if ast.Kind( prm ) <> Tko.N_PARAM then continue for
                        if np = 0 then p0 = info.TypeOf_( StmtAt_( ast, prm )->a )
                        np += 1
                    next
                    if np = 1 then
                        if types.Unqualify( p0 ) = ut then return cur
                    end if
                end if
            end if
        end if
        cur = s->nextOverload
    wend
    return Tko.SYMBOL_NONE
end function

'' What 'operator ->' hands back, with the BYREF stripped: the UDT whose fields the
'' access then names.
function ArrowResultType _
    ( byref types as Tko.TypeContext, byref syms as Tko.SymbolTable, _
      byval op as Tko.SymbolId ) as Tko.TypeId

    if op = Tko.SYMBOL_NONE then return Tko.TYPE_NONE
    dim as Tko.Symbol ptr s = syms.SymbolAt( op )
    if s = 0 then return Tko.TYPE_NONE
    dim as Tko.TypeId rt = s->type_
    if rt = Tko.TYPE_NONE then return Tko.TYPE_NONE
    rt = types.Unqualify( rt )
    if types.Kind( rt ) = Tko.TK_REFERENCE then rt = types.Unqualify( types.Inner( rt ) )
    if types.Kind( rt ) = Tko.TK_POINTER then rt = types.Unqualify( types.Inner( rt ) )
    return rt
end function
