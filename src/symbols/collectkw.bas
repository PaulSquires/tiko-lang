'' collectkw.bas -- a keyword spelling used as a declaration name.
''
'' Split out of collect.bas at the 1500-line cap and INCLUDED by it, inside the same
'' namespace, so it sees the Walker. Nothing moved changed.

'' A KEYWORD SPELLING IS NOT A NAME TO DECLARE. Measured over all 247 keywords of
'' lexer/keywords.bi, each declared seven ways -- fbc error 4, or accepted:
''
''                         GLOBAL          NAMESPACE             TYPE
''     procedure           every keyword   OPERATOR and KEYWORD  OPERATOR and KEYWORD
''     const               every keyword   OPERATOR and KEYWORD  (not measured)
''     variable (dim)      every keyword   every keyword         a FIELD: accepted
''
'' An INTRINSIC name below the global scope is fine -- fbc-modern's own headers declare
'' methods called Draw, Open and Append -- and so is 'redim field( ... )' inside a type.
'' tiko accepted every refused shape. Operators, structors and properties are not asked,
'' nor is the prelude ('err'). A LOCAL named 'line' (error 4) and a PARAMETER named 'str'
'' (error 59) are in bodies Collect does not walk.
''
'' ONLY A NAME SPELLED WITH A KEYWORD TOKEN. '#undef mod' makes 'dim mod as integer'
'' legal, and the preprocessor does it by retagging the token as an identifier -- which is
'' what gives the declaration a raw spelling. A keyword token gives it none.
''
'' The class needs no table: keywords are interned FIRST and in table order, so folded id
'' N is TK_KW_FIRST + N. The spelling is checked before that is believed.
private function KeywordNameRejected_ _
    ( byref w as Walker, byval scope_ as Tko.ScopeId, byval nm as Tko.InternId, _
      byval rawNm as Tko.InternId, byval isVariable as boolean, _
      byval loc as Tko.SourceLoc ) as boolean

    if (nm = Tko.INTERN_NONE) orelse (rawNm <> Tko.INTERN_NONE) then return false
    if w.src <> 0 then
        if w.src->IsBuiltin( loc ) then return false
    end if
    dim as long kid = cast( long, w.names->Fold( nm ) )
    if (kid <= 0) orelse (kid > TKO_KEYWORD_COUNT) then return false
    dim as Tko.TokenKind kk = cast( Tko.TokenKind, cast( long, Tko.TK_KW_FIRST ) + kid )
    if Tko.Text.LowerAscii( Tko.TokenKindText( kk ) ) <> w.names->Spelling( kid ) then return false
    dim as Tko.SymScope ptr sc = w.syms->ScopeAt( scope_ )
    if sc = 0 then return false
    dim as boolean intrinsic = (Tko.KeywordClassOf( kk ) = Tko.KWCLASS_INTRINSIC)
    select case cast( Tko.ScopeKind, sc->kind )
    case Tko.SCOPEK_GLOBAL, Tko.SCOPEK_MODULE
        return true
    case Tko.SCOPEK_NAMESPACE
        return isVariable orelse (intrinsic = false)
    case Tko.SCOPEK_TYPE
        return (isVariable = false) andalso (intrinsic = false)
    '' A LOCAL, in a procedure or in a block inside one: every keyword. Measured over all
    '' 247 as 'sub S( ) : dim as long <kw>' -- 247 fbc errors, where tiko accepted 242.
    '' A local CONST was not measured and is not asked.
    case Tko.SCOPEK_PROC, Tko.SCOPEK_BLOCK
        return isVariable
    end select
    return false
end function
