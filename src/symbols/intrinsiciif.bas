'' intrinsiciif.bas -- the two type questions IIF's result rule asks.
''
'' Split out of intrinsics.bas at the 1500-line cap and INCLUDED by it, inside the
'' same namespace, exactly as intrinsicname.bas is. Nothing moved changed in the
'' move.

'' A BOOLEAN, through a typedef or a qualifier. IIF's arms are compared by type id
'' and a boolean can arrive as either.
private function IsBooleanType_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    if t = Tko.TYPE_NONE then return false
    dim as Tko.TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) <> Tko.TK_BUILTIN then return false
    return (c.types->BuiltinOf( u ) = Tko.TY_BOOLEAN)
end function

'' A number this table may answer with -- an integer or a floating point builtin,
'' and nothing else. A string arm against a boolean is not measured and keeps the
'' old answer rather than a guessed one.
private function NumericBuiltin_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    if t = Tko.TYPE_NONE then return false
    dim as Tko.TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) = Tko.TK_ENUM then return true
    if c.types->Kind( u ) <> Tko.TK_BUILTIN then return false
    dim as Tko.BuiltinType bt = c.types->BuiltinOf( u )
    if bt = Tko.TY_BOOLEAN then return false
    return IsInt_( bt ) orelse IsFloat_( bt )
end function

