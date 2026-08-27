'' lambda.bas -- an ANONYMOUS procedure used as a VALUE.
''
'' Split out of decl.bas at the 1500-line cap and INCLUDED from it in the same place, so
'' the compile order is unchanged. Nothing about the code moved here changed in the move;
'' the CAPTURE LIST below is new.

'' An ANONYMOUS procedure used as a VALUE -- a lambda.
''
''   dim as function( byref as T, byref as T ) as boolean less = _
''       function( byref x as T, byref y as T ) as boolean
''           return x < y
''       end function
''
'' fb/sort.bi writes exactly that, so this was not an exotic corner: four corpus
'' files failed inside a RUNTIME HEADER, at a construct none of them wrote.
''
'' Deliberately NOT ParseProc. That routine reads a name, a qualifier and a run of
'' trailing modifiers terminated by end of line, and a lambda has none of the first
'' two and cannot afford the third -- 'g( function( ) as long ... end function )'
'' has a ')' after the header's own line in some spellings, and the modifier loop
'' would swallow whatever followed. This reads exactly the header a lambda has.
''
'' The body is parsed and kept but NOT collected: an N_PROC reached through an
'' expression payload is never visited by the statement walker, so nothing declares
'' it and lowering declines the value. That is the honest position -- the file
'' parses, and nothing pretends the lambda was compiled.
'' 'sub( )' is not always a lambda. In 'procptr( T.constructor, sub( ) )' and in
'' 'type<sub( )>( 0 )' the very same tokens are a SIGNATURE -- an argument that names
'' a procedure's shape -- and both are accepted by fbc. Taking them as lambdas cost
'' 81 and 12 instructions in two corpus files that had been quietly correct.
''
'' fbc's own disambiguator is the BODY, and it says so: 'function( ) as long return 1
'' end function' on one line is error 351, "Unterminated lambda body, expected END SUB
'' or END FUNCTION". So a lambda's header is followed by end of line (a ':' counts --
'' it lexes as TK_EOL) and a signature's is followed by ')' or ',' or '>'.
''
'' That cannot be decided by lookahead: the header contains a parameter list and an
'' arbitrary type reference. So the header is parsed SPECULATIVELY and the cursor put
'' back if the answer is no. Diagnostics are suppressed across the attempt and the
'' error count restored with the position, or a signature would leave the count raised
'' for a parse that never happened. Nodes built during the attempt are abandoned in
'' the arena -- the arena is bump-allocated and never freed, so that is a few bytes,
'' not a leak.
declare function LambdaExpr( byref p as Tko.ParserState ) as Tko.NodeId

function TryLambdaExpr( byref p as Tko.ParserState ) as Tko.NodeId
    dim as long savedPos = p.pos
    dim as long savedErrors = p.errors
    dim as boolean savedSilent = p.silent
    p.silent = true

    dim as Tko.StmtPayload probe
    dim as Tko.TokenKind kw = Peek( p )
    Advance( p )
    select case Peek( p )
    case Tko.KW_CDECL, Tko.KW_STDCALL, Tko.KW_PASCAL
        Advance( p )
    end select
    '' A CAPTURE LIST IS PROOF ON ITS OWN. A SIGNATURE never has one -- 'sub[ ... ]'
    '' cannot be an argument naming a procedure's shape -- so no speculation is needed
    '' and, more to the point, the '[' must not be left for the expression parser: it
    '' read it as a SUBSCRIPT and reported 'expected )', which took the whole rest of
    '' the file with it. Twenty-nine sites in six corpus files.
    dim as boolean isLambda = false
    if Peek( p ) = Tko.TK_LBRACKET then
        p.pos = savedPos
        p.errors = savedErrors
        p.silent = savedSilent
        return LambdaExpr( p )
    end if
    if Peek( p ) = Tko.TK_LPAREN then
        ParseParamList( p, probe )
        '' A BYREF RESULT IS PART OF THE SIGNATURE. 'function( byref a as long, byref
        '' b as long ) byref as long' is how generics/lambda.bas writes its picker,
        '' and stopping at the 'byref' made the probe say "not a lambda" -- so the
        '' body was parsed as statements where an expression belonged.
        ByrefResult_( p )
        if Accept( p, Tko.KW_AS ) then probe.a = TypeRef( p )
        '' ...AND THE ONE-LINE FORM ends in a COLON, not an EOL: 'dim shared g as Fn =
        '' function( byval x as long ) as long : return x + 100 : end function'.
        isLambda = (Peek( p ) = Tko.TK_EOL) orelse (Peek( p ) = Tko.TK_COLON)
    end if

    p.pos = savedPos
    p.errors = savedErrors
    p.silent = savedSilent
    if isLambda = false then return Tko.NODE_NONE
    return LambdaExpr( p )
end function

private function LambdaExpr( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    dim as Tko.StmtPayload sp
    dim as Tko.TokenKind kw = Peek( p )
    sp.op = cast( ushort, kw )
    Advance( p )

    '' A calling convention may sit between the keyword and the '(' -- measured:
    '' cdecl, stdcall and pascal are accepted there, EXPORT is not, and there are no
    '' trailing modifiers at all ('function( ) as long static' is error 3).
    select case Peek( p )
    case Tko.KW_CDECL, Tko.KW_STDCALL, Tko.KW_PASCAL
        Advance( p )
    end select

    '' THE CAPTURE LIST: 'sub[ byref total, byval bias ]( ... )'.
    ''
    '' EVERY CAPTURE NEEDS AN EXPLICIT BYVAL OR BYREF -- fbc's own error 353, and it is
    '' not a default anybody should be inventing: byref stores an ADDRESS taken at
    '' creation and byval a DEEP COPY made there, and the two differ in what the lambda
    '' sees afterwards.
    dim as long capCount = 0
    dim as boolean sawCaptures = false
    if Peek( p ) = Tko.TK_LBRACKET then
        sawCaptures = true
        Advance( p )
        if Peek( p ) <> Tko.TK_RBRACKET then
            do
                dim as boolean capByref = false
                if Accept( p, Tko.KW_BYREF ) then
                    capByref = true
                elseif Accept( p, Tko.KW_BYVAL ) = false then
                    return ErrorNode( p, Tko.TKO0413 )
                end if
                if Peek( p ) <> Tko.TK_IDENT then return ErrorNode( p, Tko.TKO0406 )
                Advance( p )
                capCount += 1
                if Accept( p, Tko.TK_COMMA ) = false then exit do
            loop
        end if
        Expect( p, Tko.TK_RBRACKET, "]" )
        '' An EMPTY list captures nothing and is the ordinary lambda.
        if capCount = 0 then sawCaptures = false
    end if

    ParseParamList( p, sp )
    dim as boolean byrefRet = ByrefResult_( p )
    if Accept( p, Tko.KW_AS ) then sp.a = TypeRef( p )

    sp.b = Block( p )
    ExpectEnd( p, kw )

    '' A CAPTURING LAMBDA IS A CLOSURE OBJECT, and tiko-lang does not build one yet.
    ''
    '' Measured: fbc-modern synthesises a UDT with one '__CAP_<NAME>' field per capture --
    '' a POINTER for byref, the value INLINE for byval -- plus a static '__FBINVOKE'
    '' member taking the object as its receiver, and the call site is a direct member
    '' call. Each capturing lambda has its OWN type; two with the same signature will not
    '' assign to one another, and none of them converts to a procedure pointer.
    ''
    '' The BODY IS STILL PARSED, above, so the rest of the file is unaffected -- that is
    '' the whole gain here. Hoisting it as an ordinary procedure would be worse than
    '' declining: at module level the captured names either resolve to nothing or, worse,
    '' to a same-named module-level variable, and the second one reads the wrong storage
    '' with nothing to say so.
    if sawCaptures then
        return ErrorNode( p, Tko.TKO0992, "a capturing lambda" )
    end if

    '' A LAMBDA IS AN ORDINARY PROCEDURE WITH A GENERATED NAME, and the expression is
    '' its ADDRESS. Measured: fbc emits a function called L2B9C516C192D043_LT_0003 and
    '' writes 'LESS$1 = (tmp$2)&L2B9C516C192D043_LT_0003'. Nothing outside the module
    '' can name it, so the spelling is ours to choose -- but it must not COLLIDE
    '' across translation units, which is what the file's content hash is for: the
    '' same thing fbc's own hex prefix does.
    ''
    '' HOISTED to module level rather than lowered in place, because a procedure is
    '' not an expression: Collect declares it, Resolve binds its body, and the site
    '' that wrote it gets '@name' -- which is what fbc emits and what every later pass
    '' already understands. FreeBASIC lambdas CAPTURE NOTHING (the body may name an
    '' enclosing local's TYPE but not its value), so there is no closure to build.
    dim as ulong lhash = 0
    dim as Tko.DecodedLoc ld = p.src->Decode( t.loc )
    dim as Tko.SourceFile ptr lf = p.src->FileAt( ld.file )
    if lf <> 0 then lhash = lf->contentHash
    sp.name = p.names->GetString( "__tko_lambda_" & hex( lhash ) & "_" & _
                                  trim( str( p.lambdaSeq ) ) )
    p.lambdaSeq += 1

    '' A LAMBDA INSIDE A GENERIC BODY IS A TEMPLATE TOO. Hoisted at module level its
    '' body names type parameters that stand for nothing there, so it lowered to
    '' nothing and counted as a decline in every file that included fb/sort.bi. Marked
    '' the way the enclosing body is marked, lowering skips it and each instantiation
    '' hoists a copy of its own -- see InstantiatePendingProcs_.
    if p.genericDepth > 0 then sp.extra or= Tko.PF_GENERIC_PROC
    dim as Tko.NodeId ln = MakeStmt( p, Tko.N_PROC, t.loc, sp )
    if byrefRet then p.ast->nodes[cast( long, ln )].flags or= Tko.NF_BYREF
    p.lambdas.Push( cast( ulong, ln ) )

    return MakeAddrOfName( p, sp.name, t.loc, ld.offset, cast( long, t.length ) )
end function
