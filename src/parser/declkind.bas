'' declkind.bas -- WHAT KIND OF NAME a module-level declaration makes, for the preprocessor.
'' Included by decl.bas, INSIDE namespace Tko.Parse, just above NoteDeclaredName_.
''
'' fbc's '#if' reads the symbol table, and what it finds decides the answer. Measured on
'' fbc-modern 1.20, 2026-09-28 (pp/if-nonconst-1..6 are six of the seven):
''
''     const K = 1            '#if K'  is 1            -- PpNoteConst
''     dim as long i          '#if i'  is error 11, "Expected constant"
''     dim shared as long g   '#if g'  is error 11
''     sub S( )               '#if S'  is error 17
''     type T                 '#if T'  is false, quietly -- as an undefined name is
''
'' tiko read every declared name that was not a const as 0, so each of those errors was a
'' silently false '#if'. The kind comes from the statement's first word; the name has just
'' been read, so the walk back stops at the line (or ':') it is on.
''
''     1   anything else -- a TYPE, an ENUM, a NAMESPACE, a typedef
''     2   a variable: DIM, VAR, REDIM, COMMON, EXTERN, SHARED, and STATIC before a name
''     3   a procedure: SUB, FUNCTION, DECLARE, PROPERTY, OPERATOR, and STATIC before one
''
'' DECLARING A FUNCTION-LIKE MACRO'S NAME -- TF_BARE_FNMACRO on the name being read. fbc's
'' '#define' sits in its global symbol table, so a declaration that enters that table or a
'' procedure's is error 4, "Duplicated definition": a DIM, SHARED or local, a CONST, a TYPE,
'' a NAMESPACE, a FOR variable, a parameter of a procedure BODY. One that enters a table of
'' its own does not collide: a TYPE's field, an ENUM's member (named or not), a namespace's
'' member, a DECLARE's parameter (read with 'record' false) -- and anything in a MEMBER's
'' body, 'sub T.m' or 'sub N.s', parameters included: fbc looks there before the global
'' table. Measured, fbc-modern 1.20, 2026-10-03; tiko took every one of them.
private sub BareMacroDecl_( byref p as Tko.ParserState )
    if (p.aggDepth <> 0) orelse (p.nsDepth <> 0) orelse (p.bareNameOk <> 0) orelse p.silent then return
    if p.memberDepth <> 0 then return
    dim as Tko.InternId id = cast( Tko.InternId, Cur( p ).literal )
    p.diags->Report( Tko.TKO0600, Tko.PointRange( Cur( p ).loc ), p.names->Spelling( id ) )
end sub

'' The FIRST word, not any word: 'dim as sub( ) pf' is a variable.
private function DeclKindHere_( byref p as Tko.ParserState ) as long
    dim as long i = p.pos - 1
    dim as long first_ = -1
    while i >= 0
        if cast( Tko.TokenKind, p.toks->At( i ).kind ) = Tko.TK_EOL then exit while
        first_ = i
        i -= 1
    wend
    if first_ < 0 then return 1
    dim as Tko.TokenKind k = cast( Tko.TokenKind, p.toks->At( first_ ).kind )
    if (k = Tko.KW_PRIVATE) orelse (k = Tko.KW_PUBLIC) then
        if first_ + 1 >= p.pos then return 1
        first_ += 1
        k = cast( Tko.TokenKind, p.toks->At( first_ ).kind )
    end if
    select case k
    case Tko.KW_DIM, Tko.KW_VAR, Tko.KW_REDIM, Tko.KW_COMMON, Tko.KW_EXTERN, Tko.KW_SHARED
        return 2
    case Tko.KW_SUB, Tko.KW_FUNCTION, Tko.KW_DECLARE, Tko.KW_PROPERTY, Tko.KW_OPERATOR
        return 3
    case Tko.KW_STATIC
        if first_ + 1 < p.pos then
            dim as Tko.TokenKind k2 = cast( Tko.TokenKind, p.toks->At( first_ + 1 ).kind )
            if (k2 = Tko.KW_SUB) orelse (k2 = Tko.KW_FUNCTION) then return 3
        end if
        return 2
    end select
    return 1
end function
