'' arrayelem.bas -- AN ARRAY'S ELEMENT TYPE AGAINST A BYDESC PARAMETER'S, for the builtin side.
''
'' Split out of visibility.bas at the 1500-line lint cap and included from it, inside its
'' namespace, just above CheckBydescArgs_, which calls it after its own UDT-against-UDT test.
''
'' TWO BUILTINS DO NOT CONVERT: an integer array to 'a() as double' and a long array to
'' 'a() as integer' are both fbc's error 58. Measured. EXCEPT 'a( ) as any', which takes any
'' element at all -- this suite's own any-array-param test passes three through one.
''
'' NOR A UDT AND A BUILTIN, either way round (T83): a Decimal array to 'weights( ) as longint'
'' compiled, and DecimalApportion read each 16-byte element as an 8-byte integer. fbc-modern
'' 1.20, 2026-10-03: error 58 for a UDT array to 'a( ) as longint', and for a longint or a
'' string array to 'a( ) as UDT'. 'skipMixed' is set over a real overload SET: there the
'' scoring already refuses the mismatch as TKO0632, fbc's single 99, and a second report
'' would double it. One procedure written 'overload' is not a set.
private function ArrayElemBad_ _
    ( byref c as Ctx, byval ael as TypeId, byval pel as TypeId, _
      byval skipMixed as boolean ) as boolean

    if ael = pel then return false
    dim as TypeKind ak = c.types->Kind( ael ), pk = c.types->Kind( pel )
    if pk = TK_BUILTIN then
        if c.types->BuiltinOf( pel ) = TY_ANY then return false
    end if
    if (ak = TK_BUILTIN) andalso (pk = TK_BUILTIN) then return true
    if skipMixed then return false
    if (ak = TK_UDT) andalso (pk = TK_BUILTIN) then return true
    if (ak = TK_BUILTIN) andalso (pk = TK_UDT) then return true
    return false
end function
