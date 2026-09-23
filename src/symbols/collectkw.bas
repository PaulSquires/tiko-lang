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

'' A KEYWORD CANNOT NAME A TYPE, A TYPEDEF, AN ENUM OR A NAMESPACE, and here the class
'' decides it. Measured over all 247 keywords, each as 'type K', 'type K as long',
'' 'enum K' and 'namespace K':
''
''                     KEYWORD (120)   OPERATOR (13)   INTRINSIC (114)
''     type, typedef   refused, 14     refused, 14     accepted
''     enum            refused, 17     refused, 17     accepted
''     namespace       refused, 14     refused, 14     refused, 14 or 4
''
'' REM is the one exception in every column, and not by rule: it starts a comment, so
'' 'enum Rem' is an anonymous enum. 'type Base' is the case that was found -- BASE is a
'' keyword -- while 'type Print' is an intrinsic and fbc takes it. tiko took them all.
''
'' Returns nm unchanged, so the declaration still happens and nothing downstream sees a
'' hole; the report is the refusal. Only a KEYWORD TOKEN counts, as for
'' KeywordNameRejected_ above, and the prelude is not asked.
private function KwTypeName_ _
    ( byref w as Walker, byval nm as Tko.InternId, byval rawNm as Tko.InternId, _
      byval k as Tko.SymbolKind, byval loc as Tko.SourceLoc ) as Tko.InternId

    if (nm = Tko.INTERN_NONE) orelse (rawNm <> Tko.INTERN_NONE) then return nm
    if w.src <> 0 then
        if w.src->IsBuiltin( loc ) then return nm
    end if
    dim as long kid = cast( long, w.names->Fold( nm ) )
    if (kid <= 0) orelse (kid > TKO_KEYWORD_COUNT) then return nm
    dim as Tko.TokenKind kk = cast( Tko.TokenKind, cast( long, Tko.TK_KW_FIRST ) + kid )
    if Tko.Text.LowerAscii( Tko.TokenKindText( kk ) ) <> w.names->Spelling( kid ) then return nm
    if kk = Tko.KW_REM then return nm
    dim as boolean intrinsic = (Tko.KeywordClassOf( kk ) = Tko.KWCLASS_INTRINSIC)
    if intrinsic andalso (k <> Tko.SYM_NAMESPACE) then return nm
    dim as string what = "a type"
    if k = Tko.SYM_ENUM then what = "an enum"
    if k = Tko.SYM_NAMESPACE then what = "a namespace"
    w.diags->Report( Tko.TKO0807, Tko.PointRange( loc ), w.names->Spelling( nm ), what )
    return nm
end function
