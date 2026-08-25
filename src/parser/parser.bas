'' parser.bas -- see parser.bi
''
'' StmtPayload slot conventions, by node kind:
''
''   N_IF          b = branch list (N_IF_BRANCH each), c = else block
''   N_IF_BRANCH   a = condition, b = body block
''   N_SELECT      a = subject, b = case list, c = case else block
''   N_CASE        b = body block, first/count = pattern list
''   N_CASE_RANGE  a = low, b = high, op = relational token for 'IS <op>'
''   N_FOR         a = counter, b = body, c = 'as T' TypeRef or NONE,
''                 children = [from, to, step], any of which may be NONE
''   N_FOREACH     a = loop variable, b = body, c = 'as T' TypeRef or NONE,
''                 children = [sequence]
''   N_DO/N_WHILE  a = condition, b = body
''   N_WITH        a = subject, b = body
''   N_SCOPE       b = body
''   N_RETURN      a = value
''   N_EXIT/N_CONT extra = level count, op = target keyword
''   N_GOTO/N_LABEL name
''   N_AMBIGUOUS   a = target expression, b = rhs, op = assignment token (0 = call),
''                 first/count = paren-less argument list
''   N_INTRINSIC   op = keyword, first/count = arguments
''   N_VAR         first/count = N_VAR_ITEM list, op = the declaring keyword
''   N_VAR_ITEM    name, a = typeref, b = initialiser, c = array bounds list
''   N_CONST       name, a = typeref, b = value
''   N_TYPE        name, first/count = members
''   N_FIELD       name, a = typeref, b = bitfield width
''   N_ENUM        name, first/count = N_ENUM_ITEM
''   N_ENUM_ITEM   name, b = value
''   N_PROC        name, a = return typeref, b = body, first/count = params, op = kind
''   N_PARAM       name, a = typeref, b = default value
''   N_NAMESPACE   name, first/count = members
''   N_TYPEREF     name, a = element typeref, first/count = args or dims

#include once "parser/parser.bi"
#include once "parser/intrinsics.bi"
#include once "support/text.bi"

namespace Tko.Parse

declare function IsDeclarationStart( byval k as Tko.TokenKind ) as boolean
declare function Declaration( byref p as Tko.ParserState ) as Tko.NodeId
declare function Block( byref p as Tko.ParserState ) as Tko.NodeId
declare sub EndOfStatement( byref p as Tko.ParserState )
declare sub SkipEols( byref p as Tko.ParserState )
declare function AtEnd( byref p as Tko.ParserState ) as boolean
declare function ParseIntrinsic( byref p as Tko.ParserState ) as Tko.NodeId
declare sub ParseParamList( byref p as Tko.ParserState, byref sp as Tko.StmtPayload )

function AtEnd( byref p as Tko.ParserState ) as boolean
    return (Peek( p ) = Tko.TK_EOF)
end function

sub SkipEols( byref p as Tko.ParserState )
    while Peek( p ) = Tko.TK_EOL
        Advance( p )
    wend
end sub

sub EndOfStatement( byref p as Tko.ParserState )
    '' A statement never consumes more than its own terminator.
    while (Peek( p ) <> Tko.TK_EOL) andalso (AtEnd( p ) = false)
        Advance( p )
    wend
    if Peek( p ) = Tko.TK_EOL then Advance( p )
end sub

'' Recovery: consume to the next line, guaranteeing progress so no input can loop.
private sub Sync( byref p as Tko.ParserState )
    dim as long before = p.pos
    EndOfStatement( p )
    if p.pos = before then Advance( p )
end sub

''  Does an '=' follow the token at the cursor? Used to tell a statement intrinsic
'' from a variable or field of the same name. '==' is not an operator in FreeBASIC, so
'' a single TK_EQ is unambiguous.
private function FollowedByAssign( byref p as Tko.ParserState ) as boolean
    if HasTok( p, p.pos + 1 ) = false then return false
    return (cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind ) = Tko.TK_EQ)
end function

'' The keywords that may follow END to close a block. Taken from the ExpectEnd call
'' sites, so the two cannot drift: anything ExpectEnd is asked to close must appear here.
private function ClosesABlock( byval k as Tko.TokenKind ) as boolean
    select case k
    case Tko.KW_IF, Tko.KW_SELECT, Tko.KW_WHILE, Tko.KW_WITH, Tko.KW_SCOPE, _
         Tko.KW_ASM, Tko.KW_ENUM, Tko.KW_NAMESPACE, Tko.KW_EXTERN, Tko.KW_TYPE, _
         Tko.KW_UNION, Tko.KW_SUB, Tko.KW_FUNCTION, Tko.KW_CONSTRUCTOR, _
         Tko.KW_DESTRUCTOR, Tko.KW_PROPERTY, Tko.KW_OPERATOR
        return true
    end select
    return false
end function

'' Whether the statement list should stop here.
''
'' END IS NOT UNCONDITIONAL. 'END' also TERMINATES THE PROGRAM, with an optional exit
'' code -- 'end', 'end 3' -- so it closes a block only when a block keyword follows.
''
'' This predicate is where a mistake propagates furthest: the comment above the
'' single-line-IF handling records an 'end if' taken from an enclosing block, which then
'' swallowed an 'end function' and left a namespace unclosed hundreds of lines later. So
'' the test is a WHITELIST of what may follow, not a guess about what may not: an
'' unrecognised word after END leaves it a block ender, which is the old behaviour and
'' the safe direction to be wrong in.
'' Does the token at the cursor END a statement written on ONE line, rather than being
'' part of it? Inside 'if c then print i end if' the print item list runs to end of
'' line, so 'end' and 'if' were consumed as two more print items -- a plausible AST
'' with two bogus N_IDENTs in it, no diagnostic, and 47 corpus PRINT statements that
'' could not lower because those items have no type.
''
'' Measured both ways against fbc: 'if i then print i end if', '... endif' and
'' '... else print 2' are all accepted, and a bare 'print end' is error 3, "Expected
'' End-of-Line, found 'end'". So END, ENDIF, ELSE and ELSEIF can never be an item, and
'' stopping at them costs nothing that was legal.
function EndsSingleLineStmt( byref p as Tko.ParserState ) as boolean
    select case Peek( p )
    case Tko.KW_END, Tko.KW_ENDIF, Tko.KW_ELSE, Tko.KW_ELSEIF
        return true
    end select
    return false
end function

private function IsBlockEnderAt( byref p as Tko.ParserState ) as boolean
    dim as Tko.TokenKind k = Peek( p )
    select case k
    '' ENDIF is 'END IF' written as ONE WORD, and it closes a block exactly as the
    '' two-word form does. Measured: fbc accepts it, with and without ELSEIF/ELSE
    '' branches before it.
    case Tko.KW_ELSE, Tko.KW_ELSEIF, Tko.KW_NEXT, Tko.KW_LOOP, _
         Tko.KW_WEND, Tko.KW_CASE, Tko.KW_ENDIF, Tko.TK_EOF
        return true
    case Tko.KW_END
        if HasTok( p, p.pos + 1 ) = false then return true
        dim as Tko.TokenKind nk = cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind )
        '' 'end' alone on its line, or 'end <expr>', is the STATEMENT.
        if nk = Tko.TK_EOL then return false
        if ClosesABlock( nk ) then return true
        return false
    end select
    return false
end function

'' A statement list, stopping before whatever closes the enclosing construct.
function Block( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    dim as Tko.NodeIdVec items
    do
        SkipEols( p )
        if AtEnd( p ) then exit do
        if IsBlockEnderAt( p ) then exit do
        dim as Tko.NodeId s = Statement( p )
        if s <> Tko.NODE_NONE then items.Push( cast( ulong, s ) )
    loop
    return MakeList( p, Tko.N_BLOCK, t.loc, Tko.NODE_NONE, items )
end function

'' 'END IF', 'END SUB' ... -- accepted with or without the trailing keyword, because
'' fbc accepts both and a missing one is diagnosed by the caller, not here.
'' 'expected end X' WITHOUT saying where X opened is a poor diagnostic, and it cost a
'' long session: the parser runs to EOF, the error lands on the last line of the file,
'' and nothing points at the construct that was never closed. The opener's location is
'' in hand at every call site, so it is carried and reported as a note.
private sub ExpectEnd _
    ( byref p as Tko.ParserState, byval what as Tko.TokenKind, _
      byval openedAt as Tko.SourceLoc = 0 )

    '' 'endif' is one token and closes an IF on its own.
    if (what = Tko.KW_IF) andalso (Peek( p ) = Tko.KW_ENDIF) then
        Advance( p )
        return
    end if
    if Accept( p, Tko.KW_END ) then
        if Peek( p ) = what then Advance( p )
        return
    end if
    ErrorNode( p, Tko.TKO0405, Tko.TokenKindText( what ) )
    if openedAt <> 0 then
        p.diags->AddNote( Tko.TKO0905, Tko.PointRange( openedAt ), _
                          Tko.TokenKindText( what ) )
    end if
end sub

'' ---------------------------------------------------------------- type references

function TypeRef( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    dim as Tko.StmtPayload sp
    dim as ushort flags = 0

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
        dim as Tko.TokenKind lk = Peek( p )
        dim as boolean startsLen = (lk = Tko.TK_INT_LIT) orelse (lk = Tko.TK_IDENT) orelse _
                                   (lk = Tko.TK_LPAREN)
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

'' ------------------------------------------------------------------- statements

private function ParseIf( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    Advance( p )

    dim as Tko.StmtPayload sp
    dim as Tko.NodeIdVec branches

    dim as Tko.StmtPayload first_
    first_.a = Expression( p )
    if Peek( p ) = Tko.KW_THEN then Advance( p )

    '' 'if c then stmt' on one line is the same node with a flag, so semantics and
    '' lowering see one shape (docs/plan/04 section 4).
    dim as boolean singleLine = (Peek( p ) <> Tko.TK_EOL) andalso (AtEnd( p ) = false)
    if singleLine then
        dim as Tko.NodeIdVec one
        dim as Tko.NodeId s = Statement( p )
        if s <> Tko.NODE_NONE then one.Push( cast( ulong, s ) )
        first_.b = MakeList( p, Tko.N_BLOCK, t.loc, Tko.NODE_NONE, one )
        branches.Push( cast( ulong, MakeStmt( p, Tko.N_IF_BRANCH, t.loc, first_ ) ) )
        '' 'if c then s : end if' terminates explicitly. ':' and a newline both lex
        '' as an EOL, so the token kinds cannot tell them apart -- only the LINE can:
        ''
        ''     if ( a mod b ) <> 0 then        <- a block IF
        ''         if negA <> negB then q -= 1 <- a single-line IF
        ''     end if                          <- belongs to the BLOCK if
        ''
        '' Taking that 'end if' because it merely came next left the block IF open,
        '' which then consumed the enclosing 'end function', which left a namespace
        '' unclosed hundreds of lines later. The 'end' is this IF's only if it is on
        '' this IF's own line.
        if (Peek( p ) = Tko.KW_END) andalso HasTok( p, p.pos + 1 ) then
            if p.toks->At( p.pos + 1 ).kind = cast( ubyte, Tko.KW_IF ) then
                if p.src->Decode( Cur( p ).loc ).lineNo = _
                   p.src->Decode( t.loc ).lineNo then
                    Advance( p )
                    Advance( p )
                end if
            end if
        end if

        dim as Tko.NodeId n = MakeStmt( p, Tko.N_IF, t.loc, sp )
        p.ast->nodes[cast( long, n )].flags or= Tko.NF_SINGLE_LINE
        dim as Tko.StmtPayload done_
        done_.b = MakeList( p, Tko.N_BLOCK, t.loc, Tko.NODE_NONE, branches )
        p.ast->stmts[cast( long, p.ast->nodes[cast( long, n )].data )] = done_
        return n
    end if

    first_.b = Block( p )
    branches.Push( cast( ulong, MakeStmt( p, Tko.N_IF_BRANCH, t.loc, first_ ) ) )

    while Peek( p ) = Tko.KW_ELSEIF
        dim as Tko.Token et = Cur( p )
        Advance( p )
        dim as Tko.StmtPayload br
        br.a = Expression( p )
        if Peek( p ) = Tko.KW_THEN then Advance( p )
        br.b = Block( p )
        branches.Push( cast( ulong, MakeStmt( p, Tko.N_IF_BRANCH, et.loc, br ) ) )
    wend

    if Accept( p, Tko.KW_ELSE ) then sp.c = Block( p )

    sp.b = MakeList( p, Tko.N_BLOCK, t.loc, Tko.NODE_NONE, branches )
    ExpectEnd( p, Tko.KW_IF )
    return MakeStmt( p, Tko.N_IF, t.loc, sp )
end function

private function ParseSelect( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    Advance( p )
    if Peek( p ) = Tko.KW_CASE then Advance( p )
    if Peek( p ) = Tko.KW_AS then
        Advance( p )                          '' 'select case as const'
        if Peek( p ) = Tko.KW_CONST then Advance( p )
    end if

    dim as Tko.StmtPayload sp
    sp.a = Expression( p )

    dim as Tko.NodeIdVec cases
    do
        SkipEols( p )
        if Peek( p ) <> Tko.KW_CASE then exit do
        dim as Tko.Token ct = Cur( p )
        Advance( p )

        if Accept( p, Tko.KW_ELSE ) then
            sp.c = Block( p )
            continue do
        end if

        dim as Tko.StmtPayload cs
        dim as Tko.NodeIdVec patterns
        do
            dim as Tko.Token pt = Cur( p )
            dim as Tko.StmtPayload pat
            if Accept( p, Tko.KW_IS ) then
                pat.op = cast( ushort, Peek( p ) )
                Advance( p )
                pat.a = Expression( p )
                patterns.Push( cast( ulong, MakeStmt( p, Tko.N_CASE_RANGE, pt.loc, pat ) ) )
            else
                pat.a = Expression( p )
                if Accept( p, Tko.KW_TO ) then
                    pat.b = Expression( p )
                    patterns.Push( cast( ulong, MakeStmt( p, Tko.N_CASE_RANGE, pt.loc, pat ) ) )
                else
                    patterns.Push( cast( ulong, pat.a ) )
                end if
            end if
            if Accept( p, Tko.TK_COMMA ) = false then exit do
        loop

        cs.first = p.ast->children.Count
        cs.count = patterns.Count
        for i as long = 0 to patterns.Count - 1
            p.ast->children.Push( patterns[i] )
        next
        cs.b = Block( p )
        cases.Push( cast( ulong, MakeStmt( p, Tko.N_CASE, ct.loc, cs ) ) )
    loop

    sp.b = MakeList( p, Tko.N_BLOCK, t.loc, Tko.NODE_NONE, cases )
    ExpectEnd( p, Tko.KW_SELECT )
    return MakeStmt( p, Tko.N_SELECT, t.loc, sp )
end function

private function ParseFor( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    Advance( p )

    '' FOR EACH is FBC-Modern's; 'each' is CONTEXTUAL, so it arrives as an identifier
    '' and is recognised by spelling (probes V2).
    dim as boolean isEach = false
    if Peek( p ) = Tko.TK_IDENT then
        dim as Tko.InternId id = cast( Tko.InternId, Cur( p ).literal )
        if p.names->Spelling( id ) = "each" then
            isEach = true
            Advance( p )
        end if
    end if

    dim as Tko.StmtPayload sp
    if isEach then
        if Accept( p, Tko.KW_BYREF ) then
            sp.op = cast( ushort, Tko.KW_BYREF )
        end if
        sp.a = Expression( p, Tko.PREC_POSTFIX )
        if Accept( p, Tko.KW_AS ) then sp.c = TypeRef( p )
        '' 'in' is contextual too.
        if Peek( p ) = Tko.TK_IDENT then
            dim as Tko.InternId id = cast( Tko.InternId, Cur( p ).literal )
            if p.names->Spelling( id ) = "in" then Advance( p )
        end if
        dim as Tko.NodeId seq = Expression( p )
        sp.first = p.ast->children.Count
        sp.count = 1
        p.ast->children.Push( cast( ulong, seq ) )
        sp.b = Block( p )
        if Accept( p, Tko.KW_NEXT ) then
            while (Peek( p ) <> Tko.TK_EOL) andalso (AtEnd( p ) = false)
                Advance( p )
            wend
        end if
        return MakeStmt( p, Tko.N_FOREACH, t.loc, sp )
    end if

    sp.a = Expression( p, Tko.PREC_POSTFIX )
    if Accept( p, Tko.KW_AS ) then sp.c = TypeRef( p )

    '' children are ALWAYS the three slots [from, to, step], NODE_NONE where absent.
    '' They used to be a packed list with the step in 'c', which silently overwrote
    '' the 'as T' TypeRef parsed above -- 'for i as integer' lost its type.
    dim as Tko.NodeIdVec bounds
    dim as Tko.NodeId fromExpr = Tko.NODE_NONE
    dim as Tko.NodeId toExpr = Tko.NODE_NONE
    dim as Tko.NodeId stepExpr = Tko.NODE_NONE
    if Accept( p, Tko.TK_EQ ) then fromExpr = Expression( p )
    if Accept( p, Tko.KW_TO ) then toExpr = Expression( p )
    if Accept( p, Tko.KW_STEP ) then stepExpr = Expression( p )

    sp.first = p.ast->children.Count
    sp.count = 3
    p.ast->children.Push( cast( ulong, fromExpr ) )
    p.ast->children.Push( cast( ulong, toExpr ) )
    p.ast->children.Push( cast( ulong, stepExpr ) )

    sp.b = Block( p )
    if Accept( p, Tko.KW_NEXT ) then
        while (Peek( p ) <> Tko.TK_EOL) andalso (AtEnd( p ) = false)
            Advance( p )
        wend
    end if

    return MakeStmt( p, Tko.N_FOR, t.loc, sp )
end function

private function ParseDo( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    Advance( p )

    dim as Tko.StmtPayload sp
    dim as ushort flags = 0

    if Peek( p ) = Tko.KW_WHILE then
        Advance( p )
        sp.a = Expression( p )
    elseif Peek( p ) = Tko.KW_UNTIL then
        Advance( p )
        flags or= Tko.NF_UNTIL
        sp.a = Expression( p )
    end if

    sp.b = Block( p )

    if Accept( p, Tko.KW_LOOP ) then
        if Peek( p ) = Tko.KW_WHILE then
            Advance( p )
            flags or= Tko.NF_POST_COND
            sp.c = Expression( p )
        elseif Peek( p ) = Tko.KW_UNTIL then
            Advance( p )
            flags or= Tko.NF_POST_COND or Tko.NF_UNTIL
            sp.c = Expression( p )
        end if
    else
        ErrorNode( p, Tko.TKO0405, "loop" )
    end if

    dim as Tko.NodeId n = MakeStmt( p, Tko.N_DO, t.loc, sp )
    p.ast->nodes[cast( long, n )].flags or= flags
    return n
end function

private function ParseWhile( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    Advance( p )
    dim as Tko.StmtPayload sp
    sp.a = Expression( p )
    sp.b = Block( p )
    if Accept( p, Tko.KW_WEND ) = false then ExpectEnd( p, Tko.KW_WHILE )
    return MakeStmt( p, Tko.N_WHILE, t.loc, sp )
end function

private function ParseWith( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    Advance( p )
    dim as Tko.StmtPayload sp
    sp.a = Expression( p )
    sp.b = Block( p )
    ExpectEnd( p, Tko.KW_WITH )
    return MakeStmt( p, Tko.N_WITH, t.loc, sp )
end function

private function ParseScope( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    Advance( p )
    dim as Tko.StmtPayload sp
    sp.b = Block( p )
    ExpectEnd( p, Tko.KW_SCOPE )
    return MakeStmt( p, Tko.N_SCOPE, t.loc, sp )
end function

private function ParseExitLike _
    ( byref p as Tko.ParserState, byval kind as Tko.NodeKind ) as Tko.NodeId

    dim as Tko.Token t = Cur( p )
    Advance( p )
    dim as Tko.StmtPayload sp
    sp.extra = 0
    '' 'exit for, for' names the target repeatedly; count how deep it goes.
    do
        dim as Tko.TokenKind k = Peek( p )
        dim as boolean target = (k = Tko.KW_FOR) orelse (k = Tko.KW_DO) orelse _
                                (k = Tko.KW_WHILE) orelse (k = Tko.KW_SELECT) orelse _
                                (k = Tko.KW_SUB) orelse (k = Tko.KW_FUNCTION) orelse _
                                (k = Tko.KW_SCOPE) orelse (k = Tko.KW_PROPERTY) orelse _
                                (k = Tko.KW_CONSTRUCTOR) orelse (k = Tko.KW_DESTRUCTOR) orelse _
                                (k = Tko.KW_OPERATOR) orelse (k = Tko.KW_ANY)
        if target = false then exit do
        if sp.op = 0 then sp.op = cast( ushort, k )
        sp.extra += 1
        Advance( p )
        if Accept( p, Tko.TK_COMMA ) = false then exit do
    loop
    return MakeStmt( p, kind, t.loc, sp )
end function

'' A KEYWORD directly followed by '(' is an expression, not a statement -- 'cast(...)',
'' 'mid(...)', 'cuint(...)', 'strptr(...)'. It is safe to say so this late in the
'' dispatch: every keyword that BEGINS a statement has already been matched by the
'' cases above, by IsDeclarationStart, or by IsStatementIntrinsic, which deliberately
'' excludes the IFORM_EXPR family for exactly this reason -- 'x = len(s)' must not
'' parse as a LEN statement.
''
'' Testing the '(' rather than enumerating the keywords is what makes this cover the
'' whole conversion family without a list that would go stale.
private function KeywordLedExpression _
    ( byref p as Tko.ParserState, byval k as Tko.TokenKind ) as boolean

    if Tko.IsKeywordKind( k ) = false then return false
    if HasTok( p, p.pos + 1 ) = false then return false
    return (cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind ) = Tko.TK_LPAREN)
end function

'' Whether the parenthesised group starting at 'at' is a PARAMETER LIST rather than an
'' expression. Decided by AS, BYREF or BYVAL appearing at depth one -- a parameter
'' cannot be written without one of them, and an expression cannot contain one there.
private function LooksLikeParamList _
    ( byref p as Tko.ParserState, byval at as long ) as boolean

    dim as long depth = 0
    dim as long i = at
    '' Bounded: a runaway scan over a file with an unbalanced paren would otherwise
    '' walk the whole token stream on every 'operator ='.
    dim as long guard = 0
    while HasTok( p, i ) andalso (guard < 4096)
        dim as Tko.TokenKind k = cast( Tko.TokenKind, p.toks->At( i ).kind )
        select case k
        case Tko.TK_LPAREN
            depth += 1
        case Tko.TK_RPAREN
            depth -= 1
            if depth <= 0 then return false
        case Tko.KW_AS, Tko.KW_BYREF, Tko.KW_BYVAL
            if depth = 1 then return true
        case Tko.TK_EOL
            return false
        end select
        i += 1
        guard += 1
    wend
    return false
end function


'' 'function =' / 'operator =' / 'property =', and nothing else that starts with one
'' of those keywords. The cross-kind rules fbc enforces -- 'function =' is a syntax
'' error inside a SUB -- are deliberately NOT checked here: accepting a little more
'' than fbc never loses a file, and rejecting a little more would.
private function IsResultAssign _
    ( byref p as Tko.ParserState, byval k as Tko.TokenKind ) as boolean

    dim as boolean isResultKw = (k = Tko.KW_FUNCTION) orelse _
                                (k = Tko.KW_OPERATOR) orelse (k = Tko.KW_PROPERTY)
    if isResultKw = false then return false
    if HasTok( p, p.pos + 1 ) = false then return false
    if cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind ) <> Tko.TK_EQ then return false

    '' 'operator = ( a, b ) as string' IS A DEFINITION, not a result assignment, and
    '' the comment on the caller has always said the two are told apart by what
    '' follows the '='. But a '(' ALONE IS NOT ENOUGH: inside an operator body
    '' 'operator = ( v + 1 )' is a result assignment of a parenthesised expression,
    '' and treating that as a definition loses the whole body. That is a real
    '' regression this code made once -- 176,000 instructions stopped being emitted
    '' corpus-wide, while the DECLINE count went DOWN, because a statement inside a
    '' body that failed to parse is not a statement that declined.
    ''
    '' What actually separates them is a PARAMETER LIST: a definition's parentheses
    '' hold 'byref a as T', so an AS, BYREF or BYVAL appears at paren depth one. An
    '' expression can contain none of those at that depth -- 'cast( integer, x )'
    '' puts its type one level deeper.
    if k = Tko.KW_OPERATOR then
        if HasTok( p, p.pos + 2 ) then
            if cast( Tko.TokenKind, p.toks->At( p.pos + 2 ).kind ) = Tko.TK_LPAREN then
                if LooksLikeParamList( p, p.pos + 2 ) then return false
            end if
        end if
    end if
    return true
end function

'' The three-way ambiguity of docs/plan/04 section 6: a leading expression is a call,
'' an assignment, or a paren-less call with arguments. The parser does not decide.
private function ParseAmbiguous( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    dim as Tko.StmtPayload sp
    sp.a = Expression( p, Tko.PREC_POSTFIX )

    dim as Tko.TokenKind k = Peek( p )
    dim as boolean isAssign = (k = Tko.TK_EQ) orelse (k = Tko.TK_PLUSEQ) orelse _
                              (k = Tko.TK_MINUSEQ) orelse (k = Tko.TK_STAREQ) orelse _
                              (k = Tko.TK_SLASHEQ) orelse (k = Tko.TK_BSLASHEQ) orelse _
                              (k = Tko.TK_CARETEQ) orelse (k = Tko.TK_AMPEQ)
    if isAssign then
        sp.op = cast( ushort, k )
        Advance( p )
        '' 'i +=> 1' IS THE SAME STATEMENT AS 'i += 1'. FreeBASIC spells every
        '' compound assignment two ways, and the second lexes as the operator token
        '' followed by a bare '>' -- so the arrow is consumed here rather than given
        '' its own token, and nothing below this line can tell which was written.
        '' Without it 'i +=> 1' was 'expected an expression' at the '>'.
        Accept( p, Tko.TK_GT )
        sp.b = Expression( p )
        return MakeStmt( p, Tko.N_AMBIGUOUS, t.loc, sp )
    end if

    '' THE WORD-SPELLED COMPOUND ASSIGNMENTS: 'and=', 'or=', 'xor=', 'imp=', 'eqv=',
    '' 'mod=', 'shl=', 'shr=', 'andalso=' and 'orelse='. They are TWO TOKENS, because
    '' the operator is a keyword and the '=' is its own -- so nothing recognised them
    '' and 't1 and= t2' parsed as the expression 't1' followed by a paren-less call to
    '' something named 'and'. Measured: fbc emits 'T1 = T1 & T2' for the first of them.
    '' ...and the word-spelled ones take the arrow too -- 'i and=> 1' -- where it is
    '' ONE token, because '=>' after a keyword lexes as TK_FATARROW rather than as an
    '' '=' with a '>' behind it.
    if Tko.IsWordAssignOp( k ) andalso HasTok( p, p.pos + 1 ) then
        dim as Tko.TokenKind k2 = cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind )
        if (k2 = Tko.TK_EQ) orelse (k2 = Tko.TK_FATARROW) then
            sp.op = cast( ushort, k )
            Advance( p )
            Advance( p )
            sp.b = Expression( p )
            return MakeStmt( p, Tko.N_AMBIGUOUS, t.loc, sp )
        end if
    end if

    '' Anything else on the line is a paren-less argument list.
    dim as Tko.NodeIdVec args
    dim as boolean more = (Peek( p ) <> Tko.TK_EOL) andalso (AtEnd( p ) = false)
    if EndsSingleLineStmt( p ) then more = false
    if more then
        do
            '' Same rule as the PRINT list: 'if c then f 1, 2 end if' must not take
            '' 'end' and 'if' as two more arguments.
            if EndsSingleLineStmt( p ) then exit do
            '' 'locate ,,0' -- a PAREN-LESS call may elide arguments too, and the
            '' empty slots still count. LOCATE is not in the intrinsic registry, so
            '' this is the list it actually goes through.
            args.Push( cast( ulong, ArgOrElided( p, Tko.TK_EOL ) ) )
            if Accept( p, Tko.TK_COMMA ) = false then exit do
        loop
    end if
    sp.first = p.ast->children.Count
    sp.count = args.Count
    for i as long = 0 to args.Count - 1
        p.ast->children.Push( args[i] )
    next

    return MakeStmt( p, Tko.N_AMBIGUOUS, t.loc, sp )
end function

end namespace

#include once "parser/decl.bas"
#include once "parser/gfx.bas"
#include once "parser/intrinsics.bas"

namespace Tko.Parse

'' True when the identifier at the cursor is the given contextual word. FBC-Modern's
'' additions -- defer, each, in, of, spawn -- are NOT reserved, so they can only be
'' recognised by spelling and only where the grammar expects them.
private function IsContextual _
    ( byref p as Tko.ParserState, byref word as string ) as boolean

    if Peek( p ) <> Tko.TK_IDENT then return false
    dim as Tko.InternId nm = cast( Tko.InternId, Cur( p ).literal )
    return p.names->Spelling( nm ) = word
end function

function Statement( byref p as Tko.ParserState ) as Tko.NodeId
    SkipEols( p )
    if AtEnd( p ) then return Tko.NODE_NONE

    p.silent = false
    dim as Tko.Token t = Cur( p )
    dim as Tko.TokenKind k = Peek( p )
    dim as Tko.NodeId n = Tko.NODE_NONE
    dim as boolean consumesLine = true

    select case k
    case Tko.KW_IF
        n = ParseIf( p )
        '' A single-line IF's inner statement already ran EndOfStatement and so ate
        '' the line's EOL. Running it again here would skip forward to the NEXT EOL
        '' and swallow whatever followed -- an 'end sub' or a 'wend' -- whole. It
        '' only showed up when the IF was the LAST statement of a block, because
        '' otherwise the token it ate was an ordinary statement that reparsed fine.
        if (n <> Tko.NODE_NONE) andalso _
           ((p.ast->nodes[cast( long, n )].flags and Tko.NF_SINGLE_LINE) <> 0) then
            consumesLine = false
        end if
    case Tko.KW_SELECT    : n = ParseSelect( p )
    case Tko.KW_FOR       : n = ParseFor( p )
    case Tko.KW_DO        : n = ParseDo( p )
    case Tko.KW_WHILE     : n = ParseWhile( p )
    case Tko.KW_WITH      : n = ParseWith( p )
    case Tko.KW_SCOPE     : n = ParseScope( p )
    case Tko.KW_EXIT      : n = ParseExitLike( p, Tko.N_EXIT )
    case Tko.KW_CONTINUE  : n = ParseExitLike( p, Tko.N_CONTINUE )

    case Tko.KW_RETURN
        Advance( p )
        dim as Tko.StmtPayload sp
        dim as boolean hasValue = (Peek( p ) <> Tko.TK_EOL) andalso (AtEnd( p ) = false)
        if hasValue then sp.a = Expression( p )
        n = MakeStmt( p, Tko.N_RETURN, t.loc, sp )

    case Tko.KW_GOTO
        Advance( p )
        dim as Tko.StmtPayload sp
        if (Peek( p ) = Tko.TK_IDENT) orelse (Peek( p ) = Tko.TK_INT_LIT) then
            sp.name = cast( Tko.InternId, Cur( p ).literal )
            Advance( p )
        end if
        n = MakeStmt( p, Tko.N_GOTO, t.loc, sp )

    case Tko.KW_DELETE
        '' DELETE is classed as an OPERATOR in the keyword table, so it never reached
        '' the statement dispatch -- 54 corpus errors from one missing case.
        Advance( p )
        dim as Tko.StmtPayload sp
        if Accept( p, Tko.TK_LBRACKET ) then
            Expect( p, Tko.TK_RBRACKET, "]" )
            sp.extra = 1
        end if
        sp.a = Expression( p )
        n = MakeStmt( p, Tko.N_DELETE_STMT, t.loc, sp )

    case Tko.TK_HASH
        '' '#assert' is passed through by the preprocessor because its expression is a
        '' COMPILE-TIME one that can name types ('#assert typeof( a ) = typeof( b )'),
        '' so it belongs to the parser, not the PP. See probe P2.
        dim as long save = p.pos
        Advance( p )
        dim as boolean isAssert = false
        if Peek( p ) = Tko.TK_IDENT then
            isAssert = (p.names->Spelling( cast( Tko.InternId, Cur( p ).literal ) ) = "assert")
        end if
        if isAssert then
            Advance( p )
            dim as Tko.StmtPayload sp
            sp.a = Expression( p )
            n = MakeStmt( p, Tko.N_ASSERT, t.loc, sp )
        else
            p.pos = save
            n = ErrorNode( p, Tko.TKO0408 )
            Sync( p )
            return n
        end if

    case Tko.KW_ASM
        '' Parsed only so it can be rejected with a real diagnostic rather than
        '' miscompiled (docs/plan/01 section 5.6).
        Advance( p )
        dim as Tko.StmtPayload sp
        n = MakeStmt( p, Tko.N_ASM, t.loc, sp )
        ErrorNode( p, Tko.TKO0407 )
        while (Peek( p ) <> Tko.KW_END) andalso (AtEnd( p ) = false)
            Advance( p )
        wend
        ExpectEnd( p, Tko.KW_ASM )

    case else
        '' 'function = expr' -- BASIC's result assignment written with the KEYWORD
        '' rather than the procedure's name. It has to be tested before the
        '' declaration dispatch, which would otherwise read FUNCTION as the start of
        '' a nested procedure and consume the enclosing 'end function' looking for a
        '' body. That is why 158 corpus files reported 'expected end FUNCTION' at EOF.
        ''
        '' The '=' is the whole disambiguator, and it is enough: at module level
        '' 'operator = ( ... )' is a global operator DEFINITION, but that spelling has
        '' a '(' after the '=' rather than an expression -- and a definition cannot
        '' appear where a statement is being parsed inside a body.
        ''
        '' Measured against fbc: assignment only. 'function += 1' is error 61 and
        '' 'print function' is error 6, so the keyword is a WRITE-ONLY target.
        if IsResultAssign( p, k ) then
            dim as Tko.StmtPayload sp
            sp.a = NewNodeAt( p, Tko.N_FUNCRESULT, t.loc, 0 )
            Advance( p )                       '' the keyword
            sp.op = cast( ushort, Tko.TK_EQ )
            Advance( p )                       '' the '='
            sp.b = Expression( p )
            n = MakeStmt( p, Tko.N_AMBIGUOUS, t.loc, sp )
        elseif IsDeclarationStart( k ) then
            n = Declaration( p )
        elseif Tko.IsStatementIntrinsic( k ) andalso FollowedByAssign( p ) then
            '' A statement intrinsic whose name is being ASSIGNED to is not the
            '' statement -- it is a variable or a field that happens to share the
            '' spelling. fb/tuibuffer.bi has a field called 'width' and assigns it
            '' unqualified from inside a method:
            ''
            ''     width = cast( ubyte, TuiCharWidth( cp ) )
            ''
            '' which tiko-lang routed to the WIDTH statement and then failed on the '='.
            '' Measured: fbc accepts a FIELD named 'width' and rejects a VARIABLE of
            '' that name outright, so the field case is the one that matters.
            ''
            '' No statement intrinsic takes an '=' where its first argument goes, so
            '' the token settles it without the symbol table -- and what comes out is
            '' the ordinary call-or-assign ambiguity, which Resolve decides.
            n = ParseAmbiguous( p )
        elseif Tko.IsStatementIntrinsic( k ) then
            n = ParseIntrinsic( p )
        elseif (k = Tko.TK_IDENT) andalso IsContextual( p, "defer" ) then
            '' 'defer' is CONTEXTUAL in FBC-Modern -- not reserved, so it arrives as
            '' an identifier and is recognised by spelling, exactly as 'each' and
            '' 'in' are. Without this it parsed as a CALL to something named defer.
            dim as Tko.Token dt = Cur( p )
            Advance( p )
            dim as Tko.StmtPayload sp
            sp.b = Statement( p )
            n = MakeStmt( p, Tko.N_DEFER, dt.loc, sp )
            consumesLine = false
        elseif k = Tko.TK_IDENT then
            '' 'name:' is a label; anything else is the call-or-assign ambiguity.
            ''
            '' The test is the COLON FLAG, not the token's length. Both ':' and a
            '' newline are TK_EOL, and a length of 1 matches a bare LF as well as a
            '' colon -- so on an LF file every parenthesis-less zero-argument call,
            '' 'Bar' on a line of its own, was parsed as a LABEL named bar. It only
            '' looked correct on CRLF input, where the newline is two bytes.
            dim as boolean isLabel = false
            if HasTok( p, p.pos + 1 ) then
                isLabel = (cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind ) = Tko.TK_EOL) andalso _
                          ((p.toks->At( p.pos + 1 ).flags and Tko.TF_COLON) <> 0)
            end if
            if isLabel then
                dim as Tko.StmtPayload sp
                sp.name = cast( Tko.InternId, t.literal )
                Advance( p )
                Advance( p )
                n = MakeStmt( p, Tko.N_LABEL, t.loc, sp )
                consumesLine = false
            else
                n = ParseAmbiguous( p )
            end if
        elseif k = Tko.TK_DOT then
            '' '.field = 1' inside a WITH. It is the same call-or-assign ambiguity as
            '' a bare name, just with the base left to the enclosing WITH.
            n = ParseAmbiguous( p )
        elseif k = Tko.TK_LPAREN then
            '' A PARENTHESISED assignment target: '(a) = 5', '(*p) = 5', '(arr(1)) = 5'.
            '' The parentheses are permitted around an lvalue and change nothing, so the
            '' statement is the same call-or-assign ambiguity as a bare name.
            n = ParseAmbiguous( p )
        elseif k = Tko.KW_LET then
            '' 'let (a, b) = f( )' -- the multiple assignment. Measured: in the fb
            '' dialect ONLY the parenthesised form exists; plain 'let a = 5' is fbc
            '' error 146, valid in deprecated/fblite/qb alone. The keyword is consumed
            '' and what follows is the ordinary call-or-assign ambiguity, so the target
            '' being a tuple needs nothing special here.
            Advance( p )
            n = ParseAmbiguous( p )
        elseif KeywordLedExpression( p, k ) then
            '' A statement whose head is a KEYWORD-led expression rather than a name:
            ''
            ''     cast( U, x ).i = 5        mid( s, 1, 1 ) = "H"
            ''     cptr( short ptr, p ) += 1  cuint( g( ) )        strptr( s ) = 0
            ''
            '' fbc parses all of these; two of them it then REJECTS -- 'strptr(s) = 0'
            '' is error 119 and a literal on the left is error 24 -- but it rejects
            '' them in the semantic pass, having parsed the statement. tiko-lang died in the
            '' parser, so those files failed for the wrong reason and their goldens
            '' could never match.
            n = ParseAmbiguous( p )
        elseif (k = Tko.TK_INT_LIT) orelse (k = Tko.TK_FLOAT_LIT) orelse _
               (k = Tko.TK_STRING_LIT) then
            '' '0 = 1' and '"" = "a"'. fbc parses these and rejects them semantically,
            '' and the corpus tests exactly that. Accepting the parse is what lets the
            '' rejection happen in the right pass.
            n = ParseAmbiguous( p )
        elseif k = Tko.KW_END then
            '' 'END [exitcode]' TERMINATES THE PROGRAM. Reaching here at all means
            '' IsBlockEnderAt already decided this END does not close a block.
            Advance( p )
            dim as Tko.StmtPayload ep
            if (Peek( p ) <> Tko.TK_EOL) andalso (AtEnd( p ) = false) then
                ep.a = Expression( p )
            end if
            n = MakeStmt( p, Tko.N_END_STMT, t.loc, ep )
        elseif k = Tko.KW_BASE then
            '' 'base.vs( )' -- a call on the BASE-class receiver. Like '.field' inside a
            '' WITH, the base is implicit and what follows is an ordinary member
            '' expression, so it is the same call-or-assign ambiguity.
            n = ParseAmbiguous( p )
        elseif k = Tko.TK_STAR then
            '' Assignment THROUGH A POINTER: '*p = 5', '**pp = 5'. A statement may begin
            '' with the dereference operator, and the target is an ordinary lvalue
            '' expression from there -- the same call-or-assign ambiguity again.
            n = ParseAmbiguous( p )
        elseif k = Tko.TK_QUESTION then
            n = ParseIntrinsic( p )       '' '?' is PRINT
        else
            n = ErrorNode( p, Tko.TKO0408 )
            Sync( p )
            return n
        end if
    end select

    if consumesLine then EndOfStatement( p )
    return n
end function

#include once "parser/prelude.bas"

'' The prelude, parsed. Returns nothing when there is no keyword table to lex with,
'' which is the case for a ParserState built by a test harness rather than the driver.
private sub ParsePrelude( byref p as Tko.ParserState, byref items as Tko.NodeIdVec )
    if p.kw = 0 then return
    if p.src = 0 then return

    dim as Tko.FileId vf = p.src->AddVirtual( "<builtin>", PreludeText( ) )
    dim as Tko.Lex.Result r
    Tko.Lex.Run( *p.src, vf, *p.names, *cast( Tko.KeywordMap ptr, p.kw ), *p.diags, r )

    '' A SEPARATE ParserState over a FIXED token vector: no preprocessor, so 'stream'
    '' is zero and HasTok reads the vector directly. The AST, the interner and the
    '' diagnostics are shared, because the nodes it builds belong to this unit.
    dim as Tko.ParserState q
    q.toks = @r.tokens
    q.stream = 0
    q.litPool = @r.literals
    q.ast = p.ast
    q.src = p.src
    q.names = p.names
    q.diags = p.diags
    q.kw = 0
    q.pos = 0

    dim as long guard = 0
    do
        guard += 1
        if guard > 10000 then exit do
        SkipEols( q )
        if AtEnd( q ) then exit do
        dim as long before = q.pos
        dim as Tko.NodeId s = Statement( q )
        if s <> Tko.NODE_NONE then items.Push( cast( ulong, s ) )
        if q.pos = before then Advance( q )
    loop
end sub

function Unit( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    dim as Tko.NodeIdVec items
    do
        SkipEols( p )
        if AtEnd( p ) then exit do
        dim as long before = p.pos
        dim as Tko.NodeId s = Statement( p )
        if s <> Tko.NODE_NONE then items.Push( cast( ulong, s ) )
        if p.pos = before then Advance( p )        '' guaranteed progress
    loop
    '' LAST, not first. Collect is a whole pass before anything looks a name up, so
    '' declaring the prelude after the unit's own statements changes nothing -- and it
    '' keeps every NodeId in the file the number it already had, which is what the dumps
    '' and their goldens are written in.
    ParsePrelude( p, items )
    return MakeList( p, Tko.N_MODULE, t.loc, Tko.NODE_NONE, items )
end function

#include once "parser/parserdump.bas"
