'' undef.bas -- '#undef name' and '#undef ns.name', for the parser.
''
'' Included from parser.bas, which is at the 1500-line cap, as spawn.bas and selchan.bas
'' are.
''
'' An '#undef' of a name that is not a macro is passed through by the preprocessor
'' (pp/directive.bas), because it removes a DECLARED symbol and only Collect can see
'' those -- see SymbolTable.UndefSym. A DOTTED name is passed whole: 'ns.name' is fbc's
'' error 123, and Collect refuses it (TKO0779). Only its first component used to reach
'' here, which turned '#undef ns.name' into '#undef ns' and removed the namespace.
''
'' The owner path goes where a qualified declaration's does, in 'ownerName'.

namespace Tko.Parse

private function UndefStmt_ _
    ( byref p as Tko.ParserState, byref t as Tko.Token ) as Tko.NodeId

    dim as Tko.StmtPayload sp
    Advance( p )
    sp.name = cast( Tko.InternId, Cur( p ).literal )
    Advance( p )
    dim as string ownerPath = ""
    do
        if Peek( p ) <> Tko.TK_DOT then exit do
        if NextTokIs_( p, Tko.TK_IDENT ) = false then exit do
        if len( ownerPath ) > 0 then ownerPath += "."
        ownerPath += p.names->Spelling( sp.name )
        Advance( p )
        sp.name = cast( Tko.InternId, Cur( p ).literal )
        Advance( p )
    loop
    if len( ownerPath ) > 0 then sp.ownerName = p.names->GetString( ownerPath )
    return MakeStmt( p, Tko.N_UNDEF, t.loc, sp )
end function

end namespace
