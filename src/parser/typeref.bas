'' typeref.bas -- PARSING A TYPE REFERENCE.
''
'' Split out of parser.bas at the 1500-line cap and included from it in the same
'' place, so nothing about the compile order changes. Nothing in it changed in the
'' move.

'' '...' IS ONLY FOR A CDECL PROCEDURE -- fbc's error 312, "vararg parameters are only
'' allowed in CDECL procedures". A variadic stdcall cannot exist: the callee pops its own
'' arguments and cannot know how many there were. Asked where fbc asks it, as the list is
'' read, of every list that can hold '...': a procedure's, a procedure TYPE's and a
'' lambda's. Here because this file is included first, and all three reach it.
''
'' The convention is the one THIS HEADER ends up with, not its DECLARE's: measured, a
'' 'cdecl' declaration whose definition writes none is refused at the definition. With
'' none written:
''
''     a constructor or a destructor              cdecl, fbc's default for them
''     inside extern "C" or "C++"                 cdecl
''     inside extern "Windows" or "Windows-MS"    stdcall
''     anywhere else, extern "rtlib" too          the TARGET's -- stdcall on Windows,
''                                                cdecl on Linux
''
'' Measured 2026-09-19, 72 shapes on fbc-modern 1.20 and fbc 1.10.1 for win64 and on
'' fbc-modern's Linux build. fbc then reports nothing more for the statement, so the
'' '...' is marked for Collect -- see PARAM_VARARG_REFUSED.
''
'' AND IT MAY NOT COME FIRST -- fbc's error 313, asked before 312, so 'declare sub f( ... )'
'' is 313 alone. "First" counts the hidden THIS: a constructor, a destructor and a
'' non-static member DECLARED IN ITS TYPE ('inTypeDecl') already have a parameter, so
'' 'declare sub m cdecl( ... )' there is accepted and a constructor's '( ... )' is left
'' to the overload rule (fbc's 143). A member DEFINITION, 'sub T.m cdecl( ... )', is 313
'' all the same -- fbc reads its parameters before it knows it is a method. Measured:
'' declarations, definitions, statics, global operators, namespaces, 'extern "C"',
'' fields, procedure types and lambdas.
''
'' WHILE SILENT -- inside a speculative parse -- the report is queued instead, because the
'' speculation that is KEPT owes it: see FlushVarargPending_.
private sub CheckVarargConv_ _
    ( byref p as Tko.ParserState, byref sp as Tko.StmtPayload, _
      byval written as Tko.CallConv, byval structor as boolean, _
      byval inTypeDecl as boolean = false )

    if p.fbcallConv = Tko.CC_NONE then exit sub
    dim as long before = 0
    for i as long = 0 to sp.count - 1
        dim as Tko.NodeId pn = cast( Tko.NodeId, p.ast->children[sp.first + i] )
        if p.ast->Kind( pn ) <> Tko.N_PARAM then continue for
        dim as Tko.StmtPayload ptr pp = _
            @p.ast->stmts[cast( long, p.ast->nodes[cast( long, pn )].data )]
        if pp->op <> cast( ushort, Tko.TK_ELLIPSIS ) then
            before += 1
            continue for
        end if
        dim as boolean hasThis = structor
        if inTypeDecl andalso ((sp.extra and Tko.PF_STATIC) = 0) then hasThis = true
        dim as Tko.DiagId d = Tko.TKO0782
        dim as Tko.CallConv cc = written
        if (before > 0) orelse hasThis then
            d = Tko.TKO0781
            if (cc = Tko.CC_NONE) andalso structor then cc = Tko.CC_CDECL
            if cc = Tko.CC_NONE then cc = cast( Tko.CallConv, p.externConv )
            if cc = Tko.CC_NONE then cc = cast( Tko.CallConv, p.fbcallConv )
            if cc = Tko.CC_CDECL then exit sub
        end if
        pp->extra = Tko.PARAM_VARARG_REFUSED
        if p.silent then
            p.varargPending.Push( cast( ulong, pn ) )
            p.varargPending.Push( cast( ulong, d ) )
            p.varargPending.Push( cast( ulong, cc ) )
        else
            p.diags->Report( d, Tko.PointRange( p.ast->Loc( pn ) ), Tko.CallConvName( cc ) )
        end if
        exit sub
    next
end sub

'' THE REPORTS A KEPT SPECULATION OWES, from 'mark' on -- or none, when the parse it sits
'' in is silent too. Either way they are dropped: a speculation that is thrown away
'' leaves orphan nodes, and nothing reads theirs.
private sub FlushVarargPending_( byref p as Tko.ParserState, byval mark as long )
    if p.silent = false then
        for i as long = mark to p.varargPending.Count - 3 step 3
            dim as Tko.NodeId pn = cast( Tko.NodeId, p.varargPending[i] )
            p.diags->Report( cast( Tko.DiagId, p.varargPending[i + 1] ), _
                Tko.PointRange( p.ast->Loc( pn ) ), _
                Tko.CallConvName( cast( Tko.CallConv, p.varargPending[i + 2] ) ) )
        next
    end if
    while p.varargPending.Count > mark
        p.varargPending.Pop( )
    wend
end sub

'' A TUPLE ELEMENT THAT CANNOT BE STORED -- fbc's 369: a bare 'any', or a fixed-length
'' 'string * N', 'zstring * N' or 'wstring * N' (measured). A pointer to either is fine.
private function TupleElemBad_( byref p as Tko.ParserState, byval n as Tko.NodeId ) as boolean
    if n = Tko.NODE_NONE then return false
    if p.ast->Kind( n ) <> Tko.N_TYPEREF then return false
    if (p.ast->nodes[cast( long, n )].flags and Tko.NF_PTR) <> 0 then return false
    dim as Tko.StmtPayload ptr tp = @p.ast->stmts[cast( long, p.ast->nodes[cast( long, n )].data )]
    select case cast( Tko.TokenKind, tp->op )
    case Tko.KW_ANY
        return true
    case Tko.KW_STRING, Tko.KW_ZSTRING, Tko.KW_WSTRING
        return (tp->c <> Tko.NODE_NONE)
    end select
    return false
end function

function TypeRef( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    dim as Tko.StmtPayload sp
    dim as ushort flags = 0

    '' A LEADING '..' -- 'dim as ..a.b.T x' and 'type<..a.b.T>( n )'. It names the GLOBAL
    '' scope, exactly as it does in an expression, and it is consumed here so the
    '' qualified-name loop further down sees the ordinary shape.
    dim as boolean globalPrefix = false
    if Peek( p ) = Tko.TK_DOT then
        if HasTok( p, p.pos + 1 ) then
            dim as Tko.TokenKind gk = cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind )
            if gk = Tko.TK_DOT then
                Advance( p )
                Advance( p )
                globalPrefix = true
            elseif (gk = Tko.TK_IDENT) orelse Tko.IsKeywordKind( gk ) then
                '' ...AND ONE DOT, which a TYPE position reads the same way: AfxNova writes
                '' 'BYVAL hWin AS .HWND' and 'DIM hDC AS .HDC' inside its namespace to reach
                '' the global Win32 names past its own. fbc accepts both; this said
                '' 'expected an identifier' at the dot.
                Advance( p )
                globalPrefix = true
            end if
        end if
    end if

    '' 'const T' and 'T const' are both written; the qualifier is a flag, not a level.
    while Peek( p ) = Tko.KW_CONST
        Advance( p )
        flags or= Tko.NF_CONST
    wend

    '' ...AND THE QUALIFIER MAY COME FIRST: 'byref r as const ..RECT' is how AfxDWrite.bi
    '' reaches the global RECT past AfxNova's own names, and the prefix was looked for only
    '' BEFORE 'const'. Measured on fbc-modern, 'sub T( byref r as const ..R2 )' compiles and
    '' runs; tiko said 'expected an identifier' at the dots, and that ONE header line failed
    '' 74 of the AfxNova examples measured for phase 12.
    if globalPrefix = false then
        if Peek( p ) = Tko.TK_DOT then
            if HasTok( p, p.pos + 1 ) then
                dim as Tko.TokenKind ck = cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind )
                if ck = Tko.TK_DOT then
                    Advance( p )
                    Advance( p )
                    globalPrefix = true
                elseif (ck = Tko.TK_IDENT) orelse Tko.IsKeywordKind( ck ) then
                    Advance( p )
                    globalPrefix = true
                end if
            end if
        end if
    end if

    '' A procedure type: 'sub|function [cdecl|stdcall|pascal] ( params ) [as T]'.
    '' This is what 'as function cdecl ( ) as long = NULL' needs, and it appears
    '' throughout real headers as a callback parameter.
    dim as Tko.TokenKind pk = Peek( p )
    if (pk = Tko.KW_SUB) orelse (pk = Tko.KW_FUNCTION) then
        Advance( p )
        sp.op = cast( ushort, pk )
        dim as Tko.CallConv ptConv = Tko.CC_NONE
        while Tko.IsCallConvKind( Peek( p ) )
            select case Peek( p )
            case Tko.KW_CDECL   : ptConv = Tko.CC_CDECL
            case Tko.KW_STDCALL : ptConv = Tko.CC_STDCALL
            case Tko.KW_PASCAL  : ptConv = Tko.CC_PASCAL
            end select
            Advance( p )
        wend
        ParseParamList( p, sp )
        CheckVarargConv_( p, sp, ptConv, false )
        '' 'function( ) BYREF as zstring' -- a byref-returning procedure TYPE. The
        '' modifier sits before the AS, so 'Accept( KW_AS )' failed and the return type
        '' was left for the caller to trip over: 'expected )'. The same shape as the
        '' byref-returning procedure DECLARATION, which cost a run of its own.
        dim as boolean byrefRet = Accept( p, Tko.KW_BYREF )
        '' ...AND IT NEEDS A RESULT TO BE A REFERENCE TO. 'sub( ) byref' is fbc's error
        '' 17 and 'function( ) byref' with no 'as' is 68, "Expected explicit result
        '' type". Both measured; one file each in the corpus.
        if byrefRet then
            if (pk = Tko.KW_SUB) orelse (Peek( p ) <> Tko.KW_AS) then
                p.diags->Report( Tko.TKO0731, Tko.PointRange( t.loc ) )
            end if
        end if
        if Accept( p, Tko.KW_AS ) then sp.a = TypeRef( p )
        if byrefRet then sp.extra or= Tko.PF_BYREF_RESULT
        dim as Tko.NodeId pn = MakeStmt( p, Tko.N_TYPEREF, t.loc, sp )
        p.ast->nodes[cast( long, pn )].flags or= flags or Tko.NF_PROC_TYPE
        while (Peek( p ) = Tko.KW_PTR) orelse (Peek( p ) = Tko.KW_POINTER)
            Advance( p )
            dim as Tko.StmtPayload up
            up.a = pn
            pn = MakeStmt( p, Tko.N_TYPEREF, t.loc, up )
            p.ast->nodes[cast( long, pn )].flags or= Tko.NF_PTR
        wend
        return pn
    end if

    dim as Tko.TokenKind k = Peek( p )

    '' A TUPLE type: 'as (long, string)'. Measured against fbc -- it is accepted in
    '' every type position, its fields are '_1'.._N, and its layout is EXACTLY the
    '' equivalent hand-written TYPE. Element names are DOCUMENTATION:
    '' '(count as long, name as string)' still has fields _1 and _2.
    ''
    '' The elements are the typeref's children; the type itself is built in Resolve,
    '' where two identical tuples can be unified.
    '' ...AND ITS DECLARATION IS CHECKED HERE, as fbc does. Measured on fbc-modern 1.20,
    '' 2026-09-25 (its errors/tuple-errors.bas): '(long)' is 367, "a tuple needs at least
    '' two elements"; '(x as long, x as long)' is 368, names compared case-insensitively;
    '' an element 'any' or 'string * 4' (zstring, wstring) is 369 -- 'any ptr' and
    '' 'zstring ptr' are fine. Left to right, and only the FIRST problem is reported:
    '' '(any, x as long, x as long)' is 369 alone. tiko accepted all of them.
    if k = Tko.TK_LPAREN then
        Advance( p )
        dim as Tko.NodeIdVec elems
        dim as Tko.NodeIdVec enames
        dim as boolean tupBad = false
        if Peek( p ) <> Tko.TK_RPAREN then
            do
                '' 'name as T' -- the name is read and discarded, which is what makes
                '' it documentation rather than a field name.
                '' A KEYWORD is a legal element name too -- '(count as long, name as
                '' string)' is in the corpus, and NAME is the NAME statement. The
                '' following AS is what tells a name from a type: an element that IS a
                '' type is followed by ',' or ')'.
                dim as Tko.TokenKind ek = Peek( p )
                dim as Tko.InternId enm = 0
                dim as Tko.SourceLoc eloc = Cur( p ).loc
                if (ek = Tko.TK_IDENT) orelse Tko.IsKeywordKind( ek ) then
                    if HasTok( p, p.pos + 1 ) then
                        if cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind ) = Tko.KW_AS then
                            if ek = Tko.TK_IDENT then
                                enm = p.names->Fold( cast( Tko.InternId, Cur( p ).literal ) )
                            else
                                enm = p.names->GetString( Tko.Text.LowerAscii( Tko.TokenKindText( ek ) ) )
                            end if
                            Advance( p )
                            Advance( p )
                        end if
                    end if
                end if
                dim as long before = p.pos
                dim as Tko.NodeId etr = TypeRef( p )
                elems.Push( cast( ulong, etr ) )
                if p.pos = before then exit do
                if (tupBad = false) andalso (p.silent = false) then
                    if TupleElemBad_( p, etr ) then
                        p.diags->Report( Tko.TKO0823, Tko.PointRange( eloc ) )
                        tupBad = true
                    elseif enm <> 0 then
                        for q as long = 0 to enames.Count - 1
                            if cast( Tko.InternId, enames[q] ) = enm then
                                p.diags->Report( Tko.TKO0822, Tko.PointRange( eloc ), p.names->Spelling( enm ) )
                                tupBad = true
                                exit for
                            end if
                        next
                        enames.Push( cast( ulong, enm ) )
                    end if
                end if
                if Accept( p, Tko.TK_COMMA ) = false then exit do
            loop
        end if
        Expect( p, Tko.TK_RPAREN, ")" )
        if (tupBad = false) andalso (p.silent = false) andalso (elems.Count < 2) then
            p.diags->Report( Tko.TKO0821, Tko.PointRange( t.loc ) )
        end if
        '' Marked by 'op', not by a node flag and not by a different payload kind. The
        '' ushort NF_ set is fully allocated, and giving one N_TYPEREF a LIST payload
        '' where every other has a STMT payload is the pool mistake this codebase has
        '' made six times. No builtin type is spelled '(' , so the op is free.
        dim as Tko.StmtPayload tp
        tp.op = cast( ushort, Tko.TK_LPAREN )
        tp.first = p.ast->children.Count
        tp.count = elems.Count
        for i as long = 0 to elems.Count - 1
            p.ast->children.Push( elems[i] )
        next
        return MakeStmt( p, Tko.N_TYPEREF, t.loc, tp )
    end if

    dim as boolean named = (k = Tko.TK_IDENT) orelse Tko.IsKeywordKind( k )
    if named = false then return ErrorNode( p, Tko.TKO0406 )

    if k = Tko.TK_IDENT then
        sp.name = cast( Tko.InternId, Cur( p ).literal )
    else
        sp.name = p.names->GetString( Tko.Text.LowerAscii( Tko.TokenKindText( k ) ) )
    end if
    sp.op = cast( ushort, k )
    Advance( p )

    '' 'typeof( X )' as a TYPE. Without this it was read as a NAMED TYPE called
    '' 'typeof' and the parenthesised group left behind -- silent in a DIM, where
    '' nothing follows, and a broken parameter list in
    ''
    ''     declare sub f( byval c as typeof( sub( ) ) ptr, byval d as long )
    ''
    '' which is how it surfaced: 20 corpus files, all of them including rpcndr.bi.
    ''
    '' The group is CONSUMED AND DISCARDED, so the type is left unresolved rather than
    '' wrong -- the inner may be a type OR an expression, and telling which needs
    '' Check. That is no worse than the named type it used to produce, which resolved
    '' to nothing either, and it stops the leftover tokens breaking what follows.
    if (k = Tko.KW_TYPEOF) andalso (Peek( p ) = Tko.TK_LPAREN) then
        '' THE OPERAND IS KEPT when it is a bare NAME, which is what the corpus almost
        '' always writes -- 'typeof( s )', 'typeof( a )', 'typeof( T )'. Resolve takes
        '' the type of whatever that name turns out to be, a variable's or a type's.
        '' Discarding it left the declaration untyped and its slot 'void': 63 verifier
        '' failures, most of them one file's 'dim aa as typeof( a ) = a'.
        ''
        '' Anything more than a name -- 'typeof( sub( ) )', 'typeof( 1 + 1 )' -- is
        '' still consumed and DISCARDED. Telling a type from an expression there needs
        '' Check, and an unresolved type is no worse than the named type this used to
        '' produce, while leftover tokens break the parameter list that follows.
        dim as long save2 = p.pos
        dim as boolean tookName = false
        if HasTok( p, p.pos + 1 ) andalso HasTok( p, p.pos + 2 ) then
            dim as Tko.Token inner = p.toks->At( p.pos + 1 )
            dim as Tko.TokenKind after = cast( Tko.TokenKind, p.toks->At( p.pos + 2 ).kind )
            if (cast( Tko.TokenKind, inner.kind ) = Tko.TK_IDENT) andalso _
               (after = Tko.TK_RPAREN) then
                '' 'rawName' is an InternId and unused on a TYPEREF; 'b' is a NodeId
                '' and putting a name in it would be a pun on the wrong pool.
                sp.rawName = cast( Tko.InternId, inner.literal )
                tookName = true
            end if
        end if
        p.pos = save2

        '' AN EXPRESSION OPERAND -- 'typeof( cuint( 1 ) )', 'typeof( a + b )'. Parsed
        '' SPECULATIVELY, because the operand may equally be a TYPE ('typeof( sub( ) )',
        '' 'typeof( integer ptr )') which no expression parser can read. It counts only
        '' when the parse lands exactly on the closing ')'; otherwise the cursor goes
        '' back and the group is consumed and discarded as before.
        ''
        '' Kept for CHECK rather than Resolve: the type of an expression is Check's to
        '' say, and it says it lazily -- the same arrangement 'var' uses.
        '' A TYPE OPERAND SPELLED AS A KEYWORD -- 'typeof( integer )', 'typeof( long
        '' ptr )'. The bare-name test above fires only on an IDENT and no expression
        '' parser reads a builtin type name, so these were discarded and the
        '' declaration came out untyped. Speculative like the expression attempt
        '' below: it counts only when the parse lands exactly on the ')'.
        if tookName = false then
            dim as long saveT = p.pos
            dim as boolean savedSilentT = p.silent
            dim as long savedErrorsT = p.errors
            dim as long pendMark = p.varargPending.Count
            p.silent = true
            Advance( p )                       '' past '('
            dim as Tko.NodeId inner = TypeRef( p )
            dim as boolean landedT = (Peek( p ) = Tko.TK_RPAREN)
            p.silent = savedSilentT
            p.errors = savedErrorsT
            if (inner <> Tko.NODE_NONE) andalso landedT then
                sp.b = inner
                Advance( p )                   '' past ')'
                tookName = true
                '' KEPT, so the '...' it refused is reported now -- 'typeof( sub( byval a
                '' as long, ... ) )' is fbc's 312 like any other procedure type.
                FlushVarargPending_( p, pendMark )
            else
                p.pos = saveT
                while p.varargPending.Count > pendMark
                    p.varargPending.Pop( )
                wend
            end if
        end if

        if tookName = false then
            dim as long saveE = p.pos
            dim as boolean savedSilent = p.silent
            dim as long savedErrors = p.errors
            p.silent = true
            Advance( p )                       '' past '('
            dim as Tko.NodeId opnd = Expression( p )
            dim as boolean landed = (Peek( p ) = Tko.TK_RPAREN)
            p.silent = savedSilent
            p.errors = savedErrors
            '' 'typeof( sub( ) )' AND 'typeof( function( ) as long )' ARE TYPES, and
            '' an expression parser reads them happily: 'sub' is a keyword usable as a
            '' name, so 'sub( )' comes out as a call with no arguments. Landing on the
            '' ')' therefore proves nothing on its own, and the operand has to be
            '' rejected by SHAPE. A procedure signature is the only type that survives
            '' the expression parse at all -- everything else, 'integer', 'const T',
            '' 'T ptr', stops short of the ')' and is rejected by the landing test.
            dim as boolean isSignature = false
            if (opnd <> Tko.NODE_NONE) andalso landed then
                if p.ast->Kind( opnd ) = Tko.N_CALL then
                    dim as Tko.ListPayload ptr olp = _
                        @p.ast->lists[cast( long, p.ast->nodes[cast( long, opnd )].data )]
                    if olp->target <> Tko.NODE_NONE then
                        if p.ast->Kind( olp->target ) = Tko.N_IDENT then
                            dim as Tko.IdentPayload ptr oip = _
                                @p.ast->idents[cast( long, _
                                    p.ast->nodes[cast( long, olp->target )].data )]
                            select case p.names->Spelling( oip->name )
                            case "sub", "function"
                                isSignature = true
                            end select
                        end if
                    end if
                end if
            end if
            if isSignature then landed = false

            if landed andalso (opnd <> Tko.NODE_NONE) then
                sp.b = opnd
                Advance( p )                   '' past ')'
                tookName = true                '' nothing left to skip
            else
                p.pos = saveE
            end if
        end if

        if tookName = false orelse (sp.b = Tko.NODE_NONE) then
            dim as long depth = 0
            do
                dim as Tko.TokenKind tk = Peek( p )
                if tk = Tko.TK_LPAREN then depth += 1
                if tk = Tko.TK_RPAREN then depth -= 1
                Advance( p )
                if depth <= 0 then exit do
                if AtEnd( p ) then exit do
            loop
        end if
    end if

    '' 'UNSIGNED <int type>' is a TWO-WORD type name, and it is the only one FreeBASIC
    '' has: measured, 'unsigned byte/short/long/integer/longint' give sizes 1/2/4/8/8,
    '' and 'SIGNED' is not a prefix at all -- fbc rejects 'as signed byte' outright.
    ''
    '' Without this the second word was simply left behind: 'dim as unsigned byte a'
    '' produced a TYPEREF of 'unsigned' and the declaration silently had the wrong type,
    '' which no diagnostic would ever mention.
    if k = Tko.KW_UNSIGNED then
        dim as Tko.TokenKind u = Peek( p )
        dim as Tko.TokenKind mapped = cast( Tko.TokenKind, 0 )
        select case u
        case Tko.KW_BYTE    : mapped = Tko.KW_UBYTE
        case Tko.KW_SHORT   : mapped = Tko.KW_USHORT
        case Tko.KW_LONG    : mapped = Tko.KW_ULONG
        case Tko.KW_INTEGER : mapped = Tko.KW_UINTEGER
        case Tko.KW_LONGINT : mapped = Tko.KW_ULONGINT
        end select
        if mapped <> cast( Tko.TokenKind, 0 ) then
            Advance( p )
            sp.op = cast( ushort, mapped )
            sp.name = p.names->GetString( _
                Tko.Text.LowerAscii( Tko.TokenKindText( mapped ) ) )
        elseif u = Tko.TK_IDENT then
            '' 'unsigned cxxlongint' -- UNSIGNED before a TYPEDEF rather than a builtin
            '' keyword. The name is carried here and 'op' is left as KW_UNSIGNED, which
            '' is what tells Resolve to take the unsigned counterpart of whatever the
            '' name turns out to be. No new node flag is needed: the two facts fit in
            '' the two fields already there.
            sp.name = cast( Tko.InternId, Cur( p ).literal )
            Advance( p )
        end if
    end if

    '' 'integer<N>' AND 'uinteger<N>' -- THE SIZED INTEGER SPELLINGS, which are
    '' ALIASES and not types of their own. Measured with '#print typeof':
    ''
    ''   integer<8>  BYTE     integer<16>  SHORT    integer<32>  LONG
    ''   integer<64> LONGINT  and the uinteger row is UBYTE/USHORT/ULONG/ULONGINT
    ''
    '' Nothing parsed them at all -- 'expected an identifier' at the '<' -- so
    '' numbers/integer_n.bas and fbc-int/array-size.bas, which are written entirely in
    '' terms of them, failed at their first declaration.
    dim as boolean sizedBase = (cast( Tko.TokenKind, sp.op ) = Tko.KW_INTEGER)
    sizedBase = sizedBase orelse (cast( Tko.TokenKind, sp.op ) = Tko.KW_UINTEGER)
    if sizedBase andalso (Peek( p ) = Tko.TK_LT) then
        dim as long saveW = p.pos
        Advance( p )
        dim as Tko.TokenKind wk = cast( Tko.TokenKind, 0 )
        if Peek( p ) = Tko.TK_INT_LIT then
            dim as boolean uns = (cast( Tko.TokenKind, sp.op ) = Tko.KW_UINTEGER)
            '' A TOKEN'S 'literal' IS A POOL INDEX, not the value.
            dim as longint wv = -1
            if cast( long, Cur( p ).literal ) < p.litPool->Count then
                wv = (*p.litPool)[cast( long, Cur( p ).literal )].intValue
            end if
            select case wv
            case 8  : wk = iif( uns, Tko.KW_UBYTE,    Tko.KW_BYTE )
            case 16 : wk = iif( uns, Tko.KW_USHORT,   Tko.KW_SHORT )
            case 32 : wk = iif( uns, Tko.KW_ULONG,    Tko.KW_LONG )
            case 64 : wk = iif( uns, Tko.KW_ULONGINT, Tko.KW_LONGINT )
            end select
        end if
        if wk <> cast( Tko.TokenKind, 0 ) then
            Advance( p )
            '' 'integer<8>=' LEXES THE CLOSING '>' AND THE '=' AS ONE '>=' TOKEN, and
            '' 'const MIN as integer<8>= 0' is how numbers/integer_n.bas writes every
            '' one of its constants -- no space before the '='. fbc reads it, so the
            '' token is SPLIT here: the '>' closes the width and what is left in the
            '' stream is the '=' the declaration still needs. Rejecting it left the
            '' whole sized type unparsed and its constant with no value, which
            '' declines at every use.
            dim as boolean closed = (Peek( p ) = Tko.TK_GT)
            if Peek( p ) = Tko.TK_GE then
                dim as Tko.Token ptr gt = @(*p.toks)[p.pos]
                gt->kind = cast( ushort, Tko.TK_EQ )
                gt->length = 1
                gt->loc += 1
                closed = true
            elseif closed then
                Advance( p )
            end if
            if closed then
                sp.op = cast( ushort, wk )
                sp.name = p.names->GetString( _
                    Tko.Text.LowerAscii( Tko.TokenKindText( wk ) ) )
            else
                p.pos = saveW
            end if
        else
            p.pos = saveW
        end if
    end if

    '' A LEADING '..' NAMES THE GLOBAL SCOPE. 'type<..a.b.T>( x )' is how the corpus's
    '' re-opened-namespace tests spell an unambiguous type, and the qualified-name loop
    '' below only ran AFTER a base identifier -- so the two dots were a syntax error and
    '' the whole statement went with them.
    ''
    '' Recorded as an EMPTY FIRST COMPONENT of the dotted path, which is the one spelling
    '' a real identifier can never produce; Resolve reads it as 'start at the file scope'
    '' rather than at the current one.
    if globalPrefix then
        if sp.ownerName = 0 then
            sp.ownerName = p.names->GetString( "" )
        end if
    end if

    '' Qualified names: 'ns.Type'. The QUALIFIER IS KEPT, in 'ownerName' -- the field
    '' N_PROC already uses for the 'Widget' of 'Widget.Method'. Overwriting 'name' per
    '' component and keeping only the last left 'nsab.T1' to resolve as a bare 'T1',
    '' looked up from the current scope, which never descends into a namespace: the
    '' type came out unknown and its variable's slot lowered to 'void'.
    ''
    '' A path DEEPER THAN ONE LEVEL keeps the whole thing, dotted, in that one field.
    '' Keeping only the last component made 'a.b.c.foo' resolve as if it were 'c.foo',
    '' and 'c' is not visible from the current scope -- it lives inside 'b' inside 'a'
    '' -- so the type came out unknown and its variable's slot lowered to VOID. Resolve
    '' splits the path back apart and walks it a component at a time.
    ''
    '' A dotted InternId rather than a list because the payload has one field for this
    '' and a name with a dot in it cannot collide with a real identifier.
    while Peek( p ) = Tko.TK_DOT
        Advance( p )
        if (Peek( p ) = Tko.TK_IDENT) orelse Tko.IsKeywordKind( Peek( p ) ) then
            if sp.ownerName = 0 then
                sp.ownerName = sp.name
            else
                sp.ownerName = p.names->GetString( _
                    p.names->Spelling( sp.ownerName ) & "." & _
                    p.names->Spelling( sp.name ) )
            end if
            '' A KEYWORD component takes its SPELLING, not its literal: a keyword
            '' token's 'literal' is not the name, so 'dim as ns_a.line l' over a type
            '' called 'line' produced a TYPEREF WITH NO NAME AT ALL and the variable's
            '' slot lowered to void. Unqualified 'dim as line m' worked, because the
            '' base-name path above already made this distinction.
            if Peek( p ) = Tko.TK_IDENT then
                sp.name = cast( Tko.InternId, Cur( p ).literal )
            else
                sp.name = p.names->GetString( _
                    Tko.Text.LowerAscii( Tko.TokenKindText( Peek( p ) ) ) )
            end if
            Advance( p )
        else
            exit while
        end if
    wend

    '' Generic arguments: 'Box( of long )'.
    if Peek( p ) = Tko.TK_LPAREN then
        dim as long save = p.pos
        Advance( p )
        dim as boolean isGeneric = false
        if Peek( p ) = Tko.TK_IDENT then
            isGeneric = (p.names->Spelling( cast( Tko.InternId, Cur( p ).literal ) ) = "of")
        end if
        if isGeneric then
            '' 'as Box( of long )' -- THE ARGUMENTS ARE KEPT, in first/count, as
            '' ordinary type references. They used to be skipped, so every
            '' instantiation of one generic named the same fieldless type.
            ''
            '' Nested arguments fall out for free: 'Box( of Box( of long ) )' recurses
            '' through TypeRef, which handles its own generic list the same way.
            Advance( p )
            dim as Tko.NodeIdVec gargs
            do
                dim as long beforeG = p.pos
                gargs.Push( cast( ulong, TypeRef( p ) ) )
                if p.pos = beforeG then exit do
                if Accept( p, Tko.TK_COMMA ) = false then exit do
            loop
            Expect( p, Tko.TK_RPAREN, ")" )
            sp.first = p.ast->children.Count
            sp.count = gargs.Count
            for i as long = 0 to gargs.Count - 1
                p.ast->children.Push( gargs[i] )
            next
        else
            p.pos = save
        end if
    end if

    '' A TYPE ALIAS: 'as byte alias "char"'.
    ''
    '' This is a C++ mangling control, not a rename. C++ has THREE distinct char types --
    '' char, signed char, unsigned char -- while FreeBASIC's BYTE and UBYTE map to the
    '' latter two, so there is no way to spell plain 'char' without it. The alias says
    '' which C++ type name to mangle against.
    ''
    '' Measured: fbc allows it on BYTE, UBYTE and UNSIGNED BYTE only, and rejects
    '' 'as long alias "int"' with a syntax error. That restriction is not applied here --
    '' the shape parses for any type and the diagnostic is owed from the checker, which
    '' does not emit it yet. Recorded rather than silently permitted.
    if Peek( p ) = Tko.KW_ALIAS then
        dim as long saveAlias = p.pos
        Advance( p )
        if Peek( p ) = Tko.TK_STRING_LIT then
            sp.b = Expression( p, Tko.PREC_POSTFIX )
        else
            p.pos = saveAlias
        end if
    end if

    '' 'zstring * 32' and friends: a fixed length.
    ''
    '' The length is a FULL CONSTANT EXPRESSION, not one token. Measured against fbc:
    '' 'zstring * (MAX+1)', 'zstring * ((MAX+1))' and 'zstring * iif( MAX>0, MAX+1, 1 )'
    '' are all accepted, and 'zstring * MAX+1' is FIVE bytes with MAX = 4 -- fbc keeps
    '' consuming past the first token rather than stopping at it. Accepting only an
    '' integer literal or a bare identifier, at multiplicative precedence, rejected the
    '' parenthesised spellings outright and silently mis-sized the unparenthesised one.
    ''
    '' It stops at PREC_CONCAT, and the boundary is measured, not chosen. '&' and 'shl'
    '' DO bind into the length -- 'zstring * MAX shl 1' is 4 bytes with MAX = 2 -- while
    '' '=' does NOT, because 'dim t as wstring * 50 = "x"' is a declaration with an
    '' INITIALISER and fbc accepts it. Parsing the length at full precedence ate the
    '' '= "x"' as a comparison: 5,089 corpus statements stopped lowering, every one of
    '' them in a wstring or zstring test, for a change that was meant to widen what
    '' parses.
    if Peek( p ) = Tko.TK_STAR then
        dim as long save = p.pos
        Advance( p )
    '' ...AND AN INTRINSIC MAY START IT. 'len', 'sizeof', 'cast' and 'cptr' are
    '' KEYWORDS, not identifiers, so the three-token test below turned them away and put
    '' the '*' back -- and the whole declaration then failed to parse, silently, with the
    '' field left untyped. Measured against fbc, all accepted:
    ''
    ''     string * len( K )              7      with K = "abcdefg"
    ''     zstring * len( K ) + 1         8
    ''     string * cast( integer, 6 )    6
    ''
    '' quirk/len-sizeof.bas writes the first of them.
    ''
    '' 'sizeof' IS LEFT OUT ON PURPOSE, though fbc takes it ('string * sizeof( integer )'
    '' is 8): ConstOf cannot fold a sizeof -- it is handed no type context -- so letting
    '' it through would turn a declaration that fails loudly into one that silently gets
    '' a 24-byte DESCRIPTOR. Wrong quietly is worse than refused.
        dim as Tko.TokenKind lk = Peek( p )
        dim as boolean startsLen = (lk = Tko.TK_INT_LIT) orelse (lk = Tko.TK_IDENT) orelse _
                                   (lk = Tko.TK_LPAREN)
        if startsLen = false then
            startsLen = (lk = Tko.KW_LEN) orelse (lk = Tko.KW_CAST) orelse _
                        (lk = Tko.KW_CPTR)
        end if
        if startsLen then
            sp.c = Expression( p, Tko.PREC_CONCAT )
        else
            p.pos = save
        end if
    end if

    dim as Tko.NodeId n = MakeStmt( p, Tko.N_TYPEREF, t.loc, sp )
    p.ast->nodes[cast( long, n )].flags or= flags

    '' 'ptr' may repeat, and 'const' may appear between the levels.
    ''
    '' A 'const' HERE QUALIFIES THE POINTER THAT FOLLOWS IT, NOT THE POINTEE BEFORE IT.
    '' 'integer const ptr' is a CONST POINTER to a writable integer; 'const integer ptr'
    '' -- the prefix form, read by the loop above this one -- is a writable pointer to a
    '' const integer. They are different types and fbc tells them apart:
    ''
    ''     dim r as ubyte const ptr : dim l as ubyte ptr = r      accepted
    ''     dim r as const ubyte ptr : dim l as ubyte ptr = r      error 181
    ''     dim r as ubyte const ptr : *r = 1                      accepted
    ''     dim r as const ubyte ptr : *r = 1                      error 119
    ''
    '' Folding the const onto the node ALREADY BUILT made both spellings one type -- a
    '' pointer to a const pointee -- so the whole 62-file 'const/assign-*-from-*' family
    '' could not be judged either way without refusing half of what fbc accepts.
    ''
    '' A TRAILING 'const' WITH NO 'ptr' AFTER IT is fbc's error 273 ('dim x as integer
    '' const'), and it keeps the old meaning here rather than gaining a diagnostic: that
    '' is a rule of its own and no corpus file asks for it yet.
    dim as boolean pendingConst = false
    do
        if Peek( p ) = Tko.KW_CONST then
            Advance( p )
            pendingConst = true
            continue do
        end if
        dim as boolean isPtr = (Peek( p ) = Tko.KW_PTR) orelse (Peek( p ) = Tko.KW_POINTER)
        if isPtr = false then exit do
        Advance( p )
        dim as Tko.StmtPayload up
        up.a = n
        n = MakeStmt( p, Tko.N_TYPEREF, t.loc, up )
        p.ast->nodes[cast( long, n )].flags or= Tko.NF_PTR
        if pendingConst then
            p.ast->nodes[cast( long, n )].flags or= Tko.NF_CONST
            pendingConst = false
        end if
    loop
    if pendingConst then p.ast->nodes[cast( long, n )].flags or= Tko.NF_CONST

    return n
end function
