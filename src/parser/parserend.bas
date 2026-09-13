'' parserend.bas -- what closes a block, and what closes a SINGLE-LINE statement.
''
'' Split out of parser.bas at the 1500-line lint cap. Three predicates asking one
'' question from three sides; nothing here parses anything.

#include once "parser/parser.bi"

namespace Tko.Parse


'' The token AFTER the one at the cursor, for the two-token decisions the statement
'' dispatch has to make.
function NextTokIs_ _
    ( byref p as ParserState, byval want as Tko.TokenKind ) as boolean

    if HasTok( p, p.pos + 1 ) = false then return false
    return (cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind ) = want)
end function

'' The keywords that may follow END to close a block. Taken from the ExpectEnd call
'' sites, so the two cannot drift: anything ExpectEnd is asked to close must appear here.
function ClosesABlock( byval k as Tko.TokenKind ) as boolean
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

function IsBlockEnderAt( byref p as Tko.ParserState ) as boolean
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

'' Is the cursor on an END that closes a DIFFERENT block from 'what'? Measured: 'end sub'
'' inside an unclosed IF is fbc's error 32, "Expected 'END IF', found 'end'" -- the
'' IF's error, and the SUB's close.
function EndClosesOther_ _
    ( byref p as Tko.ParserState, byval what as Tko.TokenKind ) as boolean

    if Peek( p ) <> Tko.KW_END then return false
    if HasTok( p, p.pos + 1 ) = false then return false
    dim as Tko.TokenKind nk = cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind )
    if nk = what then return false
    return ClosesABlock( nk )
end function

'' TOKENS LEFT ON THE LINE AFTER A WHOLE STATEMENT are fbc's error 3, "Expected
'' End-of-Line". EndOfStatement discards whatever it walks past, so 'foo 1 2' compiled
'' as 'foo 1' and 'x = 1 2' as 'x = 1', in silence.
''
'' NOT after an earlier error in the same statement, which has already said what went
'' wrong; and NOT at the ELSE, ENDIF or END IF that a single-line IF's then-branch
'' stops at, because those belong to the IF -- see EndOfStatement.
sub CheckEndOfStatement_( byref p as Tko.ParserState )
    if p.silent then return
    dim as boolean atEol = (Peek( p ) = Tko.TK_EOL) orelse (Peek( p ) = Tko.TK_EOF)
    if atEol then return
    if p.stopAtElse then
        select case Peek( p )
        case Tko.KW_ELSE, Tko.KW_ENDIF
            return
        case Tko.KW_END
            if NextTokIs_( p, Tko.KW_IF ) then return
        end select
    end if
    ErrorNode( p, Tko.TKO0420 )
end sub

end namespace
