'' typeref.bas -- PARSING A TYPE REFERENCE.
''
'' Split out of parser.bas at the 1500-line cap and included from it in the same
'' place, so nothing about the compile order changes. Nothing in it changed in the
'' move.

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
            if cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind ) = Tko.TK_DOT then
                Advance( p )
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

    '' A procedure type: 'sub|function [cdecl|stdcall|pascal] ( params ) [as T]'.
    '' This is what 'as function cdecl ( ) as long = NULL' needs, and it appears
    '' throughout real headers as a callback parameter.
    dim as Tko.TokenKind pk = Peek( p )
    if (pk = Tko.KW_SUB) orelse (pk = Tko.KW_FUNCTION) then
        Advance( p )
        sp.op = cast( ushort, pk )
        while Tko.IsCallConvKind( Peek( p ) )
            Advance( p )
        wend
        ParseParamList( p, sp )
        '' 'function( ) BYREF as zstring' -- a byref-returning procedure TYPE. The
        '' modifier sits before the AS, so 'Accept( KW_AS )' failed and the return type
        '' was left for the caller to trip over: 'expected )'. The same shape as the
        '' byref-returning procedure DECLARATION, which cost a run of its own.
        dim as boolean byrefRet = Accept( p, Tko.KW_BYREF )
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
    if k = Tko.TK_LPAREN then
        Advance( p )
        dim as Tko.NodeIdVec elems
        if Peek( p ) <> Tko.TK_RPAREN then
            do
                '' 'name as T' -- the name is read and discarded, which is what makes
                '' it documentation rather than a field name.
                '' A KEYWORD is a legal element name too -- '(count as long, name as
                '' string)' is in the corpus, and NAME is the NAME statement. The
                '' following AS is what tells a name from a type: an element that IS a
                '' type is followed by ',' or ')'.
                dim as Tko.TokenKind ek = Peek( p )
                if (ek = Tko.TK_IDENT) orelse Tko.IsKeywordKind( ek ) then
                    if HasTok( p, p.pos + 1 ) then
                        if cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind ) = Tko.KW_AS then
                            Advance( p )
                            Advance( p )
                        end if
                    end if
                end if
                dim as long before = p.pos
                elems.Push( cast( ulong, TypeRef( p ) ) )
                if p.pos = before then exit do
                if Accept( p, Tko.TK_COMMA ) = false then exit do
            loop
        end if
        Expect( p, Tko.TK_RPAREN, ")" )
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
            else
                p.pos = saveT
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

    '' 'ptr' may repeat, and 'const' may appear between levels: 'const zstring ptr'.
    do
        if Peek( p ) = Tko.KW_CONST then
            Advance( p )
            p.ast->nodes[cast( long, n )].flags or= Tko.NF_CONST
            continue do
        end if
        dim as boolean isPtr = (Peek( p ) = Tko.KW_PTR) orelse (Peek( p ) = Tko.KW_POINTER)
        if isPtr = false then exit do
        Advance( p )
        dim as Tko.StmtPayload up
        up.a = n
        n = MakeStmt( p, Tko.N_TYPEREF, t.loc, up )
        p.ast->nodes[cast( long, n )].flags or= Tko.NF_PTR
    loop

    return n
end function
